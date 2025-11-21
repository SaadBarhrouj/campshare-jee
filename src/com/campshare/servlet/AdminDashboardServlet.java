package com.campshare.servlet;

import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.model.Listing;
import com.campshare.model.User;
import com.campshare.service.AdminDashboardService;
import com.campshare.service.ListingService;
import com.campshare.service.UserService;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminDashboardServlet extends HttpServlet {

  private AdminDashboardService dashboardService = new AdminDashboardService();
  private UserService userService = new UserService();
  private ListingService listingService = new ListingService();
  final int RECENT_ITEMS_LIMIT = 5;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    List<User> recentClients = userService.getRecentClients(RECENT_ITEMS_LIMIT);
    List<User> recentPartners = userService.getRecentPartners(RECENT_ITEMS_LIMIT);
    List<Listing> recentListings = listingService.getRecentListings(RECENT_ITEMS_LIMIT);

    AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();

    request.setAttribute("dashboardStats", stats);
    request.setAttribute("recentClients", recentClients);
    request.setAttribute("recentPartners", recentPartners);
    request.setAttribute("recentListings", recentListings);

    request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
  }
}
