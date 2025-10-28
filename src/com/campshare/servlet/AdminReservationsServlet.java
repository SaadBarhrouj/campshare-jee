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

  private ReservationService reservationService = new ReservationService();
  private AdminDashboardService dashboardService = new AdminDashboardService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    System.out
        .println("\n--- [SERVLET DEBUG] Début du traitement de la requête doGet pour AdminReservationsServlet ---");

    try {
      System.out.println("[SERVLET DEBUG] Appel de reservationService.countReservationsByStatus()...");
      Map<String, Long> statusCounts = reservationService.countReservationsByStatus();
      System.out.println("[SERVLET DEBUG] Résultat de countReservationsByStatus : " + statusCounts.toString());

      System.out.println("[SERVLET DEBUG] Appel de reservationService.getAllReservationsWithDetails()...");
      List<Reservation> reservations = reservationService.getAllReservationsWithDetails();

      if (reservations == null) {
        System.err.println("[SERVLET DEBUG] ERREUR FATALE : Le service a retourné une liste NULL !");
      } else {
        System.out
            .println("[SERVLET DEBUG] Le service a retourné une liste avec " + reservations.size() + " élément(s).");
      }

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

      request.setAttribute("reservations", reservations);
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

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.sendRedirect(request.getContextPath() + "/admin/reservations");
  }
}
