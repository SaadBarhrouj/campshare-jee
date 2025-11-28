package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.campshare.model.Reservation;
import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;
import java.util.List;

@WebServlet("/client/equipement")

public class equipementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        
        User user = (User) request.getSession().getAttribute("authenticatedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = user.getEmail();

        request.setAttribute("user", user);

        try {
            ReservationService reservationService = new ReservationService();
            double noteMoyenne = reservationService.getNoteMoyenneByEmail(email);
            request.setAttribute("noteMoyenne", noteMoyenne);

            // Get ALL similar listings (without LIMIT 3)
            List<Reservation> similarListings = reservationService.getAllSimilarListingsByCategory(email);
            request.setAttribute("similarListings", similarListings);

            // Calculate stars
            int fullStars = (int) Math.floor(noteMoyenne);
            boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
            int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

            // Set attributes for JSP
            request.setAttribute("fullStars", fullStars);
            request.setAttribute("hasHalfStar", hasHalfStar);
            request.setAttribute("emptyStars", emptyStars);
            
            request.getRequestDispatcher("/jsp/client/equipementRecommende.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Erreur dans equipementServlet : " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue lors du chargement des équipements recommandés.");
            request.setAttribute("similarListings", new java.util.ArrayList<Reservation>());
            try {
                request.getRequestDispatcher("/jsp/client/equipementRecommende.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors du chargement de la page");
            }
        }
              
    }
    
}
