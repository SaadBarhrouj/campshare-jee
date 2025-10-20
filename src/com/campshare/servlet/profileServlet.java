package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;

import java.io.IOException;

@WebServlet("/client/profile")

public class profileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        String email = "maronakram@gmail.com";
        User user = clientService.getClientByEmail(email);
        request.setAttribute("user", user);

        ReservationService reservationService = new ReservationService();
        User userProfile = reservationService.getClientProfile(email);
        request.setAttribute("userProfile", userProfile);
        int totalReservations = reservationService.getTotalReservationsByEmail(email);
        request.setAttribute("totalReservations", totalReservations);

        double totalDepense = reservationService.getTotalDepenseByEmail(email);
        request.setAttribute("totalDepense", totalDepense);

                // Calculate stars
      

        double noteMoyenne = reservationService.getNoteMoyenneByEmail(email);
        request.setAttribute("noteMoyenne", noteMoyenne);
        int fullStars = (int) Math.floor(noteMoyenne);
        boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        // Set attributes for JSP
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("emptyStars", emptyStars);
        request.getRequestDispatcher("/jsp/client/profile.jsp").forward(request, response);

    }
    
}
