package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.service.UserService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String registrationSuccess = request.getParameter("registrationSuccess");
        String logoutSuccess = request.getParameter("logoutSuccess");

        if ("true".equals(registrationSuccess)) {
            request.setAttribute("successMessage", "Votre compte a été créé avec succès! Veuillez vous connecter.");
        } else if ("true".equals(logoutSuccess)) {
            request.setAttribute("successMessage", "Vous avez été déconnecté avec succès.");
        }

        request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userService.loginUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("authenticatedUser", user);
                session.setMaxInactiveInterval(30 * 60);

                String userRole = user.getRole();
                String redirectURL = request.getContextPath();

                if ("admin".equals(userRole)) {
                    redirectURL += "/admin/dashboard";
                } else if ("partner".equals(userRole)) {
                    redirectURL += "/jsp/partner/dashboard.jsp";
                } else {
                    redirectURL += "/jsp/client/dashboard.jsp";
                }

                response.sendRedirect(redirectURL);

            } else {
                request.setAttribute("errorMessage", "Email ou mot de passe incorrect, ou compte inactif.");
                request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Une erreur technique est survenue. Veuillez réessayer plus tard.");
            request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
        }
    }
}