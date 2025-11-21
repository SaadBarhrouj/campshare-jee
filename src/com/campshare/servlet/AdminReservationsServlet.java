package com.campshare.servlet;

import com.campshare.model.Reservation;
import com.campshare.service.ReservationService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import com.campshare.service.AdminDashboardService;
import com.campshare.dto.AdminDashboardStatsDTO;

public class AdminReservationsServlet extends HttpServlet {

  private final ReservationService reservationService = new ReservationService();
  private final AdminDashboardService dashboardService = new AdminDashboardService();
  private static final int RESERVATIONS_PER_PAGE = 6;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      Map<String, Long> statusCounts = reservationService.countReservationsByStatus();
      long totalReservations = statusCounts.values().stream().mapToLong(Long::longValue).sum();
      long confirmedCount = statusCounts.getOrDefault("confirmed", 0L);
      long pendingCount = statusCounts.getOrDefault("pending", 0L);
      long completedCount = statusCounts.getOrDefault("completed", 0L);
      long cancelledCount = statusCounts.getOrDefault("cancelled", 0L);
      long rejectedCount = statusCounts.getOrDefault("rejected", 0L);

      request.setAttribute("totalReservations", totalReservations);
      request.setAttribute("confirmedCount", confirmedCount);
      request.setAttribute("pendingCount", pendingCount);
      request.setAttribute("completedCount", completedCount);
      request.setAttribute("cancelledCount", cancelledCount);
      request.setAttribute("rejectedCount", rejectedCount);

      if (totalReservations > 0) {
        request.setAttribute("confirmedPercentage", (double) confirmedCount / totalReservations * 100);
        request.setAttribute("pendingPercentage", (double) pendingCount / totalReservations * 100);
        request.setAttribute("completedPercentage", (double) completedCount / totalReservations * 100);
        request.setAttribute("cancelledPercentage", (double) cancelledCount / totalReservations * 100);
        request.setAttribute("rejectedPercentage", (double) rejectedCount / totalReservations * 100);
      } else {
        request.setAttribute("confirmedPercentage", 0.0);
        request.setAttribute("pendingPercentage", 0.0);
        request.setAttribute("completedPercentage", 0.0);
        request.setAttribute("cancelledPercentage", 0.0);
        request.setAttribute("rejectedPercentage", 0.0);
      }

      String searchQuery = request.getParameter("search");
      String status = request.getParameter("status") != null ? request.getParameter("status") : "all";
      String sortBy = request.getParameter("sort") != null ? request.getParameter("sort") : "date_desc";
      int currentPage = 1;

      if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
        try {
          currentPage = Integer.parseInt(request.getParameter("page"));
          if (currentPage < 1)
            currentPage = 1;
        } catch (NumberFormatException e) {
          currentPage = 1;
        }
      }

      int offset = (currentPage - 1) * RESERVATIONS_PER_PAGE;

      List<Reservation> reservations = reservationService.getFilteredAndPaginatedReservations(searchQuery, status,
          sortBy, RESERVATIONS_PER_PAGE, offset);
      int totalFilteredReservations = reservationService.countFilteredReservations(searchQuery, status);

      int totalPages = (int) Math.ceil((double) totalFilteredReservations / RESERVATIONS_PER_PAGE);
      if (totalPages == 0)
        totalPages = 1;

      request.setAttribute("reservations", reservations);
      request.setAttribute("totalPages", totalPages);
      request.setAttribute("currentPage", currentPage);
      request.setAttribute("searchQuery", searchQuery);
      request.setAttribute("statusFilter", status);
      request.setAttribute("sortBy", sortBy);

      AdminDashboardStatsDTO dashboardStats = dashboardService.getDashboardStats();
      request.setAttribute("dashboardStats", dashboardStats);

      RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/admin/reservations.jsp");
      dispatcher.forward(request, response);

    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("errorMessage", "Erreur critique lors du chargement des réservations: " + e.getMessage());
      RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/admin/reservations.jsp");
      dispatcher.forward(request, response);
    }
  }
}
