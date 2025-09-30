package com.campshare.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AuthenticationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");// apres je doit mettre /home
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String path = request.getServletPath();
        String action = request.getParameter("action"); 

        switch (path) {
            case "/login":
                if ("login".equals(action)) {
                    System.out.println("Tentative de connexion...");
                }
                break;
            case "/register":
                if ("register".equals(action)) {
                    System.out.println("Tentative d'inscription...");
                }
                break;
        }
    }
}