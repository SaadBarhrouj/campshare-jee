package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ClientService;

import java.io.IOException;

@WebServlet("/client/dashboard")

public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        String email = "maronakram@gmail.com";
        User user = clientService.getClientByEmail(email);
        request.setAttribute("user", user);


        request.getRequestDispatcher("/jsp/client/dashboard.jsp").forward(request, response);
              
    }
    
}
