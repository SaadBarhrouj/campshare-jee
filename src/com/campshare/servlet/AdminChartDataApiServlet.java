package com.campshare.servlet;

import com.campshare.service.AdminDashboardService;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class AdminChartDataApiServlet extends HttpServlet {

  private AdminDashboardService dashboardService = new AdminDashboardService();
  private Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
      Map<String, Object> registrationChartData = dashboardService.getRegistrationChartData(14);
      Map<String, Object> bookingCountChartData = dashboardService.getBookingCountChartData(14);

      Map<String, Object> responseData = new HashMap<>();
      responseData.put("registrationStats", registrationChartData);
      responseData.put("bookingCountStats", bookingCountChartData);

      response.getWriter().write(gson.toJson(responseData));

    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter()
          .write("{\"error\": \"Erreur lors de la récupération des données pour les graphiques.\"}");
      e.printStackTrace();
    }
  }
}