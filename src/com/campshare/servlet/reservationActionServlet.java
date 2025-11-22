package com.campshare.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Category;
import com.campshare.model.User;
import com.campshare.model.City;

import com.campshare.model.Item;

import com.campshare.service.CityService;
import com.campshare.service.PartnerService;
import com.campshare.service.ListingService;
import com.campshare.service.CategoryService;



@WebServlet("/partner/reservationAction")
public class reservationActionServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long reservationId = Long.parseLong(request.getParameter("reservation_id"));
        String action = request.getParameter("action");

        ListingService listingService = new ListingService();

        try {
            if ("accept".equals(action)) {
                listingService.acceptReservation(reservationId);
            } else if ("refuse".equals(action)) {
                listingService.refuseReservation(reservationId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de l'action sur la réservation");
            return;
        }

        // Redirection après traitement
        String referer = request.getHeader("referer");
        if (referer != null) {
            response.sendRedirect(referer);  // retourne à la page précédente
        } else {
            response.sendRedirect(request.getContextPath() + "/partner/dashboard"); // fallback
        }
    }
    
}