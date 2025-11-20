package com.campshare.servlet;

import com.campshare.dao.impl.ReviewDAOImpl;
import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ReservationReviewsServlet extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAOImpl();
    private Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss").create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                response.getWriter().write("{}");
                return;
            }

            long reservationId = Long.parseLong(idParam);
            
            List<Review> reviews = reviewDAO.findByReservationIdWithUser(reservationId);

            JsonObject reviewsJson = new JsonObject();

            for (Review review : reviews) {
                if ("forPartner".equalsIgnoreCase(review.getType())) {
                    reviewsJson.add("reviewFromClient", gson.toJsonTree(review));
                } 
                else if ("forClient".equalsIgnoreCase(review.getType())) {
                    reviewsJson.add("reviewFromPartner", gson.toJsonTree(review));
                }
            }

            response.getWriter().write(gson.toJson(reviewsJson));

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID invalide");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur serveur");
        }
    }
}