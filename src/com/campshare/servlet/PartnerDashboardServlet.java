package com.campshare.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.PartnerService;


@WebServlet("/partner/dashboard")
public class PartnerDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();
        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);

        request.getRequestDispatcher("/jsp/partner/home.jsp").forward(request, response);
    }
    
}
