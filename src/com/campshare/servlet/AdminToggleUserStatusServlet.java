package com.campshare.servlet;

import com.campshare.service.UserService;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

public class AdminToggleUserStatusServlet extends HttpServlet {
  private UserService userService = new UserService();
  private Gson gson = new Gson();

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    try {
      long userId = Long.parseLong(request.getParameter("id"));

      Map<String, Boolean> requestBody = gson.fromJson(request.getReader(), Map.class);
      boolean newStatus = requestBody.get("isActive");

      userService.updateUserStatus(userId, newStatus);

      response.getWriter().write("{\"message\": \"Statut mis à jour avec succès\"}");

    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"error\": \"Erreur lors de la mise à jour du statut.\"}");
      e.printStackTrace();
    }
  }
}