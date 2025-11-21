package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.model.Listing;
import com.campshare.model.User;
import com.campshare.service.AdminDashboardService;
import com.campshare.service.UserService;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import com.campshare.util.FileUploadUtil;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)

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
    }

    else if ("updateInfo".equals(action)) {
      try {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");

        Part avatarPart = request.getPart("avatar");
                String avatarUrl = currentUser.getAvatarUrl(); 

                if (avatarPart != null && avatarPart.getSize() > 0) {
                    String userHome = System.getProperty("user.home");
                    String uploadDirectory = userHome + File.separator + "campshare_uploads";
                    
                    String newAvatarPath = FileUploadUtil.uploadFile(avatarPart, uploadDirectory, "avatars");
                    
                    if (newAvatarPath != null) {
                        avatarUrl = newAvatarPath; 
                    }
                }

                success = userService.updateAdminInfo(currentUser.getId(), firstName, lastName, email, avatarUrl);

                if (success) {
                  successMsg = "Informations du profil mises à jour avec succès.";
                  currentUser.setFirstName(firstName);
                  currentUser.setLastName(lastName);
                  currentUser.setEmail(email);
                  currentUser.setAvatarUrl(avatarUrl);
                  session.setAttribute("authenticatedUser", currentUser);

                } else {

          errorMsg = "Échec de la mise à jour des informations. Un autre utilisateur utilise peut-être déjà cet email.";
        }
      } catch (Exception e) {
        e.printStackTrace();
        errorMsg = "Une erreur serveur s'est produite lors de la mise à jour des informations.";
        success = false;
      }
    } else {
      errorMsg = "Action non valide demandée: [" + action + "]";
      success = false;
    }

    User adminProfile = userService.getUserById(currentUser.getId());
    request.setAttribute("adminProfile", adminProfile);

    if (success) {
      session.setAttribute("successMessage", successMsg);
      response.sendRedirect(request.getContextPath() + "/admin/profile");
      return;
    } else {
      request.setAttribute("errorMessage", errorMsg);
      request.getRequestDispatcher("/jsp/admin/admin_profile.jsp").forward(request, response);
    }
  }

}