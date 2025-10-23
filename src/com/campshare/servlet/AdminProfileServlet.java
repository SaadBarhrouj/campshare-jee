package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.model.Listing;
import com.campshare.model.User;
import com.campshare.service.AdminDashboardService;
import com.campshare.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AdminProfileServlet extends HttpServlet {

  private UserService userService = new UserService();
  private AdminDashboardService dashboardService = new AdminDashboardService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    User currentUser = (session != null) ? (User) session.getAttribute("authenticatedUser") : null;

    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    User adminProfile = userService.getUserById(currentUser.getId());

    request.setAttribute("adminProfile", adminProfile);

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();

    request.setAttribute("dashboardStats", stats);

    request.getRequestDispatcher("/jsp/admin/admin_profile.jsp").forward(request, response);
  }



  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    User currentUser = (session != null) ? (User) session.getAttribute("authenticatedUser") : null;

    if (currentUser == null || !"admin".equals(currentUser.getRole())) {
      response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé.");
      return;
    }

    String action = request.getParameter("action");
    boolean success = false;
    String successMsg = "";
    String errorMsg = "";

    if ("changePassword".equals(action)) {
      try {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");


        success = userService.changeAdminPassword(currentUser.getId(), currentPassword, newPassword, confirmPassword);

        if (success) {
          successMsg = "Mot de passe modifié avec succès.";
        } else {
          errorMsg = "Échec du changement de mot de passe. Vérifiez votre mot de passe actuel et assurez-vous que les nouveaux mots de passe correspondent (minimum 8 caractères).";
        }
      } catch (Exception e) {
        e.printStackTrace(); 
        errorMsg = "Une erreur serveur s'est produite lors de la tentative de changement de mot de passe.";
        success = false;
      }
    } else {
      errorMsg = "Action non valide demandée.";
      success = false;
    }


    User adminProfile = userService.getUserById(currentUser.getId());
    request.setAttribute("adminProfile", adminProfile);

    if (success) {
      request.setAttribute("successMessage", successMsg);
    } else {
      request.setAttribute("errorMessage", errorMsg);
    }

    request.getRequestDispatcher("/jsp/admin/admin_profile.jsp").forward(request, response);
  }
}