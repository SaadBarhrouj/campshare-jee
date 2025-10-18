package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
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
  private AdminDashboardService dashboardService = new AdminDashboardService();
  private ListingService listingService = new ListingService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();
    request.setAttribute("dashboardStats", stats);

    List<Listing> listings = listingService.getAllListings();
    request.setAttribute("listings", listings);
    request.getRequestDispatcher("/jsp/admin/listings.jsp").forward(request, response);
  }
}