package com.campshare.servlet;

import com.campshare.service.AdminDashboardService;
import com.campshare.service.CategoryService;
import com.campshare.service.CityService;
import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.model.Category;
import com.campshare.model.City;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.service.ListingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class AdminEditListingServlet extends HttpServlet {

  private AdminDashboardService dashboardService = new AdminDashboardService();
  private ListingService listingService = new ListingService();
  private CategoryService categoryService = new CategoryService();
  private CityService cityService = new CityService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      long listingId = Long.parseLong(request.getParameter("id"));

      AdminDashboardStatsDTO stats = dashboardService.getDashboardStats();

      Listing listingToEdit = listingService.getListingDetailsById(listingId);

      List<Category> allCategories = categoryService.getAllCategories();
      List<City> allCities = cityService.getAllCities();

      request.setAttribute("listing", listingToEdit);
      request.setAttribute("allCategories", allCategories);
      request.setAttribute("allCities", allCities);
      request.setAttribute("dashboardStats", stats);

      request.getRequestDispatcher("/jsp/admin/edit_listing.jsp").forward(request, response);

    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID d'annonce invalide.");
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
      request.setCharacterEncoding("UTF-8");

      long listingId = Long.parseLong(request.getParameter("listingId"));
      long itemId = Long.parseLong(request.getParameter("itemId"));

      Listing listing = new Listing();
      listing.setId(listingId);
      listing.setStartDate(Date.valueOf(request.getParameter("startDate")));
      listing.setEndDate(Date.valueOf(request.getParameter("endDate")));
      listing.setCityId(Long.parseLong(request.getParameter("cityId")));
      listing.setDeliveryOption(request.getParameter("deliveryOption") != null);

      Item item = new Item();
      item.setId(itemId);
      item.setTitle(request.getParameter("title"));
      item.setDescription(request.getParameter("description"));
      item.setPricePerDay(Double.parseDouble(request.getParameter("pricePerDay")));
      item.setCategoryId(Long.parseLong(request.getParameter("categoryId")));

      boolean success = listingService.updateListing(listing, item);

      if (success) {
        response
            .sendRedirect(request.getContextPath() + "/admin/listings/details?id=" + listingId + "&updateSuccess=true");
      } else {
        response.sendRedirect(request.getContextPath() + "/admin/listings/edit?id=" + listingId + "&updateFailed=true");
      }

    } catch (Exception e) {
      e.printStackTrace();
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la mise à jour.");
    }
  }
}