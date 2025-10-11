package com.campshare.servlet;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Reservation;
import com.campshare.model.User;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;

@WebServlet("/partner/DemandeLocation")

public class PartnerDemandeLocationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        PartnerService partnerService = new PartnerService();
        ReservationService reservationService = new ReservationService();


        
        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);
        long partnerId = user.getId(); 

        List<Reservation> ReservationsWithMontantTotal = reservationService.getReservationsWithMontantTotal(email);
        request.setAttribute("ReservationsWithMontantTotal", ReservationsWithMontantTotal);

        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/DemandeLocation.jsp").forward(request, response);
    }
    
}
