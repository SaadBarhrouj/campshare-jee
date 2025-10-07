package com.campshare.servlet;

import com.campshare.model.AdminDashboardStatsDTO;
import com.campshare.service.AdminDashboardService;
import com.mysql.cj.log.Log;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

public class AdminDashboardServlet extends HttpServlet {

  private AdminDashboardService dashboardService = new AdminDashboardService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();
    // debug with logger
    Logger logger = Logger.getLogger(AdminDashboardServlet.class.getName());
    logger.info("Admin Dashboard Stats: " + stats);

    request.setAttribute("dashboardStats", stats);

    request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
  }
}