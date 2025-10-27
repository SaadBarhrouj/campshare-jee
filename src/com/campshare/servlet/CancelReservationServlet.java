package com.campshare.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.campshare.service.ReservationService;
import java.io.IOException;

@WebServlet("/client/reservations/cancel")
public class CancelReservationServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Récupérer l'ID de la réservation
            String reservationIdStr = request.getParameter("reservationId");
            
            if (reservationIdStr == null || reservationIdStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de réservation manquant");
                return;
            }
            
            int reservationId = Integer.parseInt(reservationIdStr);
            
            // Utiliser le service pour annuler la réservation
            ReservationService reservationService = new ReservationService();
            boolean success = reservationService.cancelReservation(reservationId);
            
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Réservation annulée avec succès");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de l'annulation");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de réservation invalide");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur serveur");
        }
    }
}

