package com.campshare.servlet;

import com.campshare.dao.impl.ReviewDAOImpl;
import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.dto.ReviewsDTO;
import com.campshare.model.Reservation;
import com.campshare.model.Review;
import com.campshare.service.ReservationService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ReservationReviewsServlet extends HttpServlet {

  private ReviewDAO reviewDAO = new ReviewDAOImpl();
  private ReservationService reservationService = new ReservationService();
  private Gson gson = new GsonBuilder().setPrettyPrinting().create();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      long reservationId = Long.parseLong(request.getParameter("id"));


      Reservation reservation = reservationService.findReservationById(reservationId);
      if (reservation == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Réservation non trouvée");
        return;
      }

      List<Review> reviews = reviewDAO.findByReservationId(reservationId);

      ReviewsDTO reviewsDTO = new ReviewsDTO();
      for (Review review : reviews) {
        if (review.getReviewerId() == reservation.getClientId()) {
          reviewsDTO.setReviewFromClient(review);
        }
        else if (review.getReviewerId() == reservation.getPartnerId()) {
          reviewsDTO.setReviewFromPartner(review);
        }
      }

      String jsonResponse = this.gson.toJson(reviewsDTO);
      response.setContentType("application/json");
      response.setCharacterEncoding("UTF-8");
      response.getWriter().write(jsonResponse);

    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de réservation invalide.");
    } catch (Exception e) {
      e.printStackTrace();
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur interne du serveur.");
    }
  }
}