package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.service.AdminDashboardService;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminListingsServlet extends HttpServlet {
  private AdminDashboardService dashboardService = new AdminDashboardService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();
    request.setAttribute("dashboardStats", stats);

    request.getRequestDispatcher("/jsp/admin/listings.jsp").forward(request, response);
  }
}