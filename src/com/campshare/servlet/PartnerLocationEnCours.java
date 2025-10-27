package com.campshare.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.model.Item;
import com.campshare.model.Reservation;


import com.campshare.service.ItemService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;


@WebServlet("/partner/LocationEnCours")
public class PartnerLocationEnCours extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();



        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);

        List<Reservation> PartenerReservavtion = partnerService.getLocationsEnCours(email);
        request.setAttribute("PartenerReservavtion", PartenerReservavtion);



        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/LocationEnCours.jsp").forward(request, response);
    }
    
}