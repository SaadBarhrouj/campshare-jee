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
            // Ensure UTF-8 for request/response
            req.setCharacterEncoding("UTF-8");
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("text/html; charset=UTF-8");
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


            System.out.println("listings = " + listings);
            System.out.println("listingsCount = " + listingsCount);

            System.out.println("================= DEBUG: ListingViewModels =================");
            if (listings != null && !listings.isEmpty()) {
                for (var vm : listings) {
                    System.out.println("---- ListingViewModel ----");

                    // Listing info
                    if (vm.listing != null) {
                        System.out.println("Listing ID: " + vm.listing.getId());
                        System.out.println("Listing Start Date: " + vm.listing.getStartDate());
                        System.out.println("Listing End Date: " + vm.listing.getEndDate());
                    } else {
                        System.out.println("Listing is NULL!");
                    }

                    // Item info
                    if (vm.item != null) {
                        System.out.println("Item ID: " + vm.item.getId());
                        System.out.println("Item Title: " + vm.item.getTitle());
                        System.out.println("Item Price/Day: " + vm.item.getPricePerDay());
                    } else {
                        System.out.println("Item is NULL!");
                    }

                    // Category info
                    if (vm.category != null) {
                        System.out.println("Category ID: " + vm.category.getId());
                        System.out.println("Category Name: " + vm.category.getName());
                    } else {
                        System.out.println("Category is NULL!");
                    }

                    // Partner info
                    if (vm.partner != null) {
                        System.out.println("Partner ID: " + vm.partner.getId());
                        System.out.println("Partner Username: " + vm.partner.getUsername());
                    } else {
                        System.out.println("Partner is NULL!");
                    }

                    // City info
                    if (vm.city != null) {
                        System.out.println("City ID: " + vm.city.getId());
                        System.out.println("City Name: " + vm.city.getName());
                    } else {
                        System.out.println("City is NULL!");
                    }

                    System.out.println("----------------------------------------------");
                }
            } else {
                System.out.println("No listings found (listings is null or empty)");
            }
            System.out.println("=============================================================");


            
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
