package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.dto.ListingInfoDTO;
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
    System.out.println("\n[DEBUG SERVLET 1] Entrée dans AdminListingsServlet.doGet().");
    ;

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();
    request.setAttribute("dashboardStats", stats);

    // ...
    List<ListingInfoDTO> listings = listingService.getAllListingsWithDetails();
    System.out.println("[DEBUG SERVLET 2] " + listings.size() + " annonce(s) récupérée(s) du service.");

    request.setAttribute("listings", listings);
    System.out.println("[DEBUG SERVLET 3] La liste a été mise dans la requête.");

    request.getRequestDispatcher("/jsp/admin/listings.jsp").forward(request, response);
    System.out.println("[DEBUG SERVLET 4] Forward vers le JSP effectué. Sortie du servlet.");
  }
}