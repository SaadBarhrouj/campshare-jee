package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.model.User;
import com.campshare.service.AdminDashboardService;
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

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    List<User> partners = userService.getUsersByRole("partner");
    request.setAttribute("partners", partners);

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();
    request.setAttribute("dashboardStats", stats);

    request.getRequestDispatcher("/jsp/admin/partners.jsp").forward(request, response);
  }
}