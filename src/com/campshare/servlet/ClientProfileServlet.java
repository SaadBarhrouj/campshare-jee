package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.model.City;
import com.campshare.model.Review;
import com.campshare.service.UserService;
import com.campshare.service.CityService;
import com.campshare.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class ClientProfileServlet extends HttpServlet {

    private UserService userService = new UserService();
    private CityService cityService = new CityService();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get client ID from request parameter
            String clientIdParam = req.getParameter("id");
            if (clientIdParam == null || clientIdParam.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Client ID is required");
                return;
            }

            long clientId;
            try {
                clientId = Long.parseLong(clientIdParam);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid client ID format");
                return;
            }

            // Get client information
            User client = userService.getUserById(clientId);
            if (client == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Client not found");
                return;
            }

            // Get client's city
            City city = null;
            if (client.getCityId() > 0) {
                city = cityService.getCityById(client.getCityId());
            }

            // Get client reviews
            List<Review> clientReviews = reviewService.getReviewsByRevieweeCId(clientId);
            long clientReviewCount = reviewService.getReviewCountByRevieweeCId(clientId);
            double clientAvgRating = reviewService.getAverageRatingByRevieweeCId(clientId);
            Map<Integer, Integer> clientRatingPercentages = reviewService.getRatingPercentagesByRevieweeCId(clientId);


            System.out.println("client = " + client);
            System.out.println("city = " + city);
            System.out.println("clientReviews = " + clientReviews);
            System.out.println("clientReviewCount = " + clientReviewCount);
            System.out.println("clientAvgRating = " + clientAvgRating);
            System.out.println("clientRatingPercentages = " + clientRatingPercentages);

            
            // Set attributes for JSP
            req.setAttribute("client", client);
            req.setAttribute("city", city);
            req.setAttribute("clientReviews", clientReviews);
            req.setAttribute("clientReviewCount", clientReviewCount);
            req.setAttribute("clientAvgRating", clientAvgRating);
            req.setAttribute("clientRatingPercentages", clientRatingPercentages);

            // Forward to JSP
            req.getRequestDispatcher("/jsp/profiles/client-profile.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while loading client profile");
        }
    }
}
