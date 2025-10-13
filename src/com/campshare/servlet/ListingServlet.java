package com.campshare.servlet;

import com.campshare.model.*;
import com.campshare.service.*;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ListingServlet extends HttpServlet {

    private ListingService listingService = new ListingService();
    private ItemService itemService = new ItemService();
    private UserService userService = new UserService();
    private CategoryService categoryService = new CategoryService();
    private CityService cityService = new CityService();
    private ImageService imageService = new ImageService();
    private ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get listing ID from request parameter
            String listingIdParam = request.getParameter("id");
            if (listingIdParam == null || listingIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Listing ID is required");
                return;
            }

            long listingId = Long.parseLong(listingIdParam);
            
            // Get the listing
            Listing listing = listingService.getListingById(listingId);
            if (listing == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Listing not found");
                return;
            }

            // Get the item
            Item item = itemService.getItemById(listing.getItemId());
            if (item == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Item not found");
                return;
            }

            // Get the partner (user who owns the item)
            User partner = userService.getUserById(item.getPartnerId());
            
            // Get the category
            Category category = categoryService.getCategoryById(item.getCategoryId());
            
            // Get the city
            City city = cityService.getCityById(listing.getCityId());
            
            // Get images for the item
            List<Image> images = imageService.getImagesByItemId(item.getId());
            
            // Get reviews for the item (only visible ones)
            List<Review> reviews = reviewService.getVisibleReviewsByItemId(item.getId());
            
            // Get review statistics
            double averageRating = reviewService.getAverageRatingByItemId(item.getId());
            long reviewCount = reviewService.getReviewCountByItemId(item.getId());
            Map<Integer, Double> ratingPercentages = reviewService.getRatingPercentagesByItemId(item.getId());
            
            // Get unavailable dates (this would need to be implemented based on reservations)
            List<String> unavailableDates = getUnavailableDates(listingId);

            // Set attributes for JSP
            request.setAttribute("listing", listing);
            request.setAttribute("item", item);
            request.setAttribute("partner", partner);
            request.setAttribute("category", category);
            request.setAttribute("city", city);
            request.setAttribute("images", images);
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("reviewCount", reviewCount);
            request.setAttribute("ratingPercentages", ratingPercentages);
            request.setAttribute("unavailableDates", unavailableDates);

            // Forward to JSP
            request.getRequestDispatcher("/jsp/listing/listing.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid listing ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while loading the listing");
        }
    }

    private List<String> getUnavailableDates(long listingId) {
        // This method should query the reservations table to get unavailable dates
        // For now, return an empty list - this would need to be implemented
        // based on your reservation system
        return new ArrayList<>();
    }
}
