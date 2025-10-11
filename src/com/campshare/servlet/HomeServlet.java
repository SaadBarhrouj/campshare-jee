package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

import com.campshare.model.Reservation;
import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;

import java.io.IOException;

@WebServlet("/client/dashboard")

public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        String email = "maronakram@gmail.com";
        User user = clientService.getClientByEmail(email);
        request.setAttribute("user", user);

        ReservationService reservationService = new ReservationService();
        int totalReservations = reservationService.getTotalReservationsByEmail(email);
        request.setAttribute("totalReservations", totalReservations);

        double totalDepense = reservationService.getTotalDepenseByEmail(email);
        request.setAttribute("totalDepense", totalDepense);

        double noteMoyenne = reservationService.getNoteMoyenneByEmail(email);
        request.setAttribute("noteMoyenne", noteMoyenne);


        // Calculate stars
        int fullStars = (int) Math.floor(noteMoyenne);
        boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        // Set attributes for JSP
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("emptyStars", emptyStars);

        List<Reservation> reservations = reservationService.getReservationDetailsByEmail(email);
        request.setAttribute("reservations", reservations);
        
        List<Reservation> similarListings = reservationService.getSimilarListingsByCategory(email);
        request.setAttribute("similarListings", similarListings);


        request.getRequestDispatcher("/jsp/client/dashboard.jsp").forward(request, response);
              
    }
    
}
