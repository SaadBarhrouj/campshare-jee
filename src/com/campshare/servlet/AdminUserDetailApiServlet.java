package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.service.UserService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class AdminUserDetailApiServlet extends HttpServlet {

  private UserService userService = new UserService();
  private Gson gson = new Gson();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
      long userId = Long.parseLong(request.getParameter("id"));
      User user = userService.getUserById(userId);

      if (user != null) {
        Map<String, Object> data = new HashMap<>();
        data.put("user", user);

        String jsonResponse = gson.toJson(data);
        response.getWriter().write(jsonResponse);
      } else {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.getWriter().write("{\"error\": \"Utilisateur non trouvé\"}");
      }
    } catch (NumberFormatException e) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().write("{\"error\": \"ID utilisateur invalide\"}");
    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"error\": \"Erreur interne du serveur\"}");
      e.printStackTrace();
    }
  }
}