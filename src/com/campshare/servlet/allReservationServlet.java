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

@WebServlet("/client/allReservation")

public class allReservationServlet extends HttpServlet {
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

        ReservationService reservationService = new ReservationService();
        double noteMoyenne = reservationService.getNoteMoyenneByEmail(email);
        request.setAttribute("noteMoyenne", noteMoyenne);

        // Get status filter parameter
        String statusFilter = request.getParameter("status");
        
        // Debug logging
        System.out.println("Status filter parameter: " + statusFilter);
        
        // Get reservations based on filter
        List<Reservation> reservations;
        if (statusFilter != null && !statusFilter.equals("all") && !statusFilter.trim().isEmpty()) {
            System.out.println("Filtering by status: " + statusFilter);
            reservations = reservationService.getAllReservationDetailsByEmailAndStatus(email, statusFilter);
            System.out.println("Filtered reservations count: " + reservations.size());
        } else {
            System.out.println("Getting all reservations");
            reservations = reservationService.getAllReservationDetailsByEmail(email);
            System.out.println("All reservations count: " + reservations.size());
        }
        request.setAttribute("reservations", reservations);

        // Calculate stars
        int fullStars = (int) Math.floor(noteMoyenne);
        boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        // Set attributes for JSP
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("emptyStars", emptyStars);
        request.setAttribute("selectedStatus", statusFilter);

        // Check if it's an AJAX request
        String requestedWith = request.getHeader("X-Requested-With");
        System.out.println("X-Requested-With header: " + requestedWith);
        
        if ("XMLHttpRequest".equals(requestedWith)) {
            System.out.println("Processing AJAX request - returning reservations grid only");
            // Set content type for AJAX response
            response.setContentType("text/html; charset=UTF-8");
            // For AJAX requests, only include the reservations grid
            request.getRequestDispatcher("/jsp/client/components/reservations-grid.jsp").forward(request, response);
        } else {
            System.out.println("Processing regular request - returning full page");
            // For regular requests, include the full page
            request.getRequestDispatcher("/jsp/client/allReservation.jsp").forward(request, response);
        }
              
    }
    
}