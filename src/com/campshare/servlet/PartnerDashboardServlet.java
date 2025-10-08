package com.campshare.servlet;

import com.campshare.model.Reservation;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Review;
import com.campshare.model.Reservation;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;

import com.campshare.service.PartnerService;


@WebServlet("/partner/dashboard")
public class PartnerDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();
        ReservationService reservationService = new ReservationService();

        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);
        long partnerId = user.getId(); 

        int completedReservations = reservationService.getNumberCompletedReservation(partnerId);

        request.setAttribute("completedReservations", completedReservations);

        int countActiveListening =  reservationService.getNumberActiveListenings(partnerId);
        request.setAttribute("countActiveListening", countActiveListening);

        int countListening = reservationService.getNumberListenings(partnerId);
        request.setAttribute("countListening", countListening);

        double monthPayment = reservationService.getSumPaymentThisMonth(partnerId);
        request.setAttribute("monthPayment", monthPayment);

        List<Review> LastAvisPartnerForObjectList = reservationService.getLastAvisPartnerForObject(email);
        request.setAttribute("LastAvisPartnerForObjectList", LastAvisPartnerForObjectList);

        List<Reservation> PendingReservationsWithMontantTotal = reservationService.getPendingReservationsWithMontantTotal(email);
        request.setAttribute("PendingReservationsWithMontantTotal", PendingReservationsWithMontantTotal);

        request.getRequestDispatcher("/jsp/partner/home.jsp").forward(request, response);
    }
    
}
