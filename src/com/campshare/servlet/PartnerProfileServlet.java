package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.model.City;
import com.campshare.model.Review;
import com.campshare.service.UserService;
import com.campshare.service.CityService;
import com.campshare.service.ReviewService;
import com.campshare.service.ListingService;
import com.campshare.service.ListingService.ListingViewModel;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class PartnerProfileServlet extends HttpServlet {

    private UserService userService = new UserService();
    private CityService cityService = new CityService();
    private ReviewService reviewService = new ReviewService();
    private ListingService listingService = new ListingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get partner ID from request parameter
            String partnerIdParam = req.getParameter("id");
            if (partnerIdParam == null || partnerIdParam.trim().isEmpty()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Partner ID is required");
                return;
            }

            long partnerId;
            try {
                partnerId = Long.parseLong(partnerIdParam);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid partner ID format");
                return;
            }

            // Get partner information
            User partner = userService.getUserById(partnerId);
            if (partner == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Partner not found");
                return;
            }

            // Get partner's city
            City city = null;
            if (partner.getCityId() > 0) {
                city = cityService.getCityById(partner.getCityId());
            }

            // Get partner reviews
            List<Review> partnerReviews = reviewService.getReviewsByRevieweeId(partnerId);
            long partnerReviewCount = reviewService.getReviewCountByRevieweeId(partnerId);
            double partnerAvgRating = reviewService.getAverageRatingByRevieweeId(partnerId);
            Map<Integer, Integer> partnerRatingPercentages = reviewService.getRatingPercentagesByRevieweeId(partnerId);

            // Get partner's active listings
            List<ListingViewModel> listings = listingService.getPartnerListingsWithRelations(partnerId);
            long listingsCount = listings.size();


            System.out.println("partner = " + partner);
            System.out.println("city = " + city);
            System.out.println("partnerReviews = " + partnerReviews);
            System.out.println("partnerReviewCount = " + partnerReviewCount);
            System.out.println("partnerAvgRating = " + partnerAvgRating);
            System.out.println("partnerRatingPercentages = " + partnerRatingPercentages);
            System.out.println("listings = " + listings);
            System.out.println("listingsCount = " + listingsCount);

            
            // Set attributes for JSP
            req.setAttribute("partner", partner);
            req.setAttribute("city", city);
            req.setAttribute("partnerReviews", partnerReviews);
            req.setAttribute("partnerReviewCount", partnerReviewCount);
            req.setAttribute("partnerAvgRating", partnerAvgRating);
            req.setAttribute("partnerRatingPercentages", partnerRatingPercentages);
            req.setAttribute("listings", listings);
            req.setAttribute("listingsCount", listingsCount);

            // Forward to JSP
            req.getRequestDispatcher("/jsp/profiles/partner-profile.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while loading partner profile");
        }
    }
}
