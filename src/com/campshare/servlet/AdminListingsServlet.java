package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.dto.ListingsPageStatsDTO;
import com.campshare.model.Listing;
import com.campshare.service.AdminDashboardService;
import com.campshare.service.ListingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminListingsServlet extends HttpServlet {

    private ListingService listingService = new ListingService();
    private AdminDashboardService dashboardService = new AdminDashboardService();

    private static final int LISTINGS_PER_PAGE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchQuery = request.getParameter("search");
        String status = request.getParameter("status") != null ? request.getParameter("status") : "all";
        String sortBy = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";

        int currentPage = 1;
        if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int offset = (currentPage - 1) * LISTINGS_PER_PAGE;

        List<Listing> listings = listingService.getPaginatedListings(searchQuery, status, sortBy, LISTINGS_PER_PAGE, offset);
        int totalListings = listingService.countTotalListings(searchQuery, status);

        int totalPages = (int) Math.ceil((double) totalListings / LISTINGS_PER_PAGE);
        if (totalPages == 0) totalPages = 1;

        ListingsPageStatsDTO pageStats = listingService.getListingPageStats();
        request.setAttribute("pageStats", pageStats);
        
        AdminDashboardStatsDTO dashboardStats = dashboardService.getDashboardStats();
        request.setAttribute("dashboardStats", dashboardStats);

        request.setAttribute("listings", listings);         
        request.setAttribute("totalPages", totalPages);  
        request.setAttribute("currentPage", currentPage);
        
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("statusFilter", status);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("/jsp/admin/listings.jsp").forward(request, response);
    }
}