package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.dto.UserPageStatsDTO;
import com.campshare.model.User;
import com.campshare.service.AdminDashboardService;
import com.campshare.service.AdminUserService;
import com.campshare.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminPartnersServlet extends HttpServlet {

  private UserService userService = new UserService();
  private AdminDashboardService dashboardService = new AdminDashboardService();
  private AdminUserService adminUserService = new AdminUserService();

  private static final int USERS_PER_PAGE = 7;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String searchQuery = request.getParameter("search");
    String status = request.getParameter("status") != null ? request.getParameter("status") : "all";
    String sortBy = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";

    int currentPage = 1;
    if (request.getParameter("page") != null) {
      try {
        currentPage = Integer.parseInt(request.getParameter("page"));
      } catch (NumberFormatException e) {
        currentPage = 1;
      }
    }

    int offset = (currentPage - 1) * USERS_PER_PAGE;

    List<User> partners = userService.getPaginatedUsers("partner", searchQuery, status, sortBy, USERS_PER_PAGE, offset);
    int totalPartners = userService.countTotalUsers("partner", searchQuery, status);

    int totalPages = (int) Math.ceil((double) totalPartners / USERS_PER_PAGE);
    if (totalPages == 0) {
      totalPages = 1;
    }

    UserPageStatsDTO pageStats = adminUserService.getUserStats("partner");
    request.setAttribute("pageStats", pageStats);

    request.setAttribute("partners", partners);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPage", currentPage);

    request.setAttribute("searchQuery", searchQuery);
    request.setAttribute("statusFilter", status);
    request.setAttribute("sortBy", sortBy);

    AdminDashboardStatsDTO dashboardStats = dashboardService.getDashboardStats();
    request.setAttribute("dashboardStats", dashboardStats);

    request.getRequestDispatcher("/jsp/admin/partners.jsp").forward(request, response);
  }
}