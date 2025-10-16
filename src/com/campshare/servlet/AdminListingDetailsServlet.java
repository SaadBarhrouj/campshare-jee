package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.service.AdminDashboardService;
import com.campshare.dto.ListingInfoDTO;
import com.campshare.service.ListingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminListingDetailsServlet extends HttpServlet {

  private ListingService listingService = new ListingService();
  private AdminDashboardService dashboardService = new AdminDashboardService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      long listingId = Long.parseLong(request.getParameter("id"));

      ListingInfoDTO listingDetails = listingService.getListingDetailsById(listingId);
      AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();

      if (listingDetails != null) {
        request.setAttribute("listingDetails", listingDetails);

        request.setAttribute("dashboardStats", stats);
        request.getRequestDispatcher("/jsp/admin/listing_details.jsp").forward(request, response);
      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Annonce non trouvée.");
      }

    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de l'annonce invalide.");
    }
  }
}