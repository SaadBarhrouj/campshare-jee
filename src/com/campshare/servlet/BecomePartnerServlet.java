package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class BecomePartnerServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            User authenticatedUser = (User) req.getSession().getAttribute("authenticatedUser");

            if (authenticatedUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            long userId = authenticatedUser.getId();
            userService.updateRole(userId, "partner");

            // Update the session to reflect new role
            authenticatedUser.setRole("partner");
            req.getSession().setAttribute("authenticatedUser", authenticatedUser);

            // Redirect to partner dashboard or show confirmation
            resp.sendRedirect(req.getContextPath() + "/jsp/partner/home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Erreur lors du changement de rôle : " + e.getMessage());
            req.getRequestDispatcher("/jsp/error.jsp").forward(req, resp);
        }
    }
}
