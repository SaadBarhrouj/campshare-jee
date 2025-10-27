package com.campshare.servlet;

import com.campshare.service.ListingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ListingServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String idParam = req.getParameter("id");
    if (idParam == null) {
      resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing listing id");
      return;
    }
    long listingId;
    try {
      listingId = Long.parseLong(idParam);
    } catch (NumberFormatException e) {
      resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid listing id");
      return;
    }

    ListingService service = new ListingService();
    ListingService.ListingViewModel vm = service.getListingDetails(listingId);
    if (vm == null) {
      resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Listing not found");
      return;
    }

    req.setAttribute("listing", vm.listing);
    req.setAttribute("item", vm.item);
    req.setAttribute("category", vm.category);
    req.setAttribute("city", vm.city);
    req.setAttribute("partner", vm.partner);
    
    // Get images for the item
    if (vm.item != null) {
      com.campshare.dao.impl.ImageDAOImpl imageDAO = new com.campshare.dao.impl.ImageDAOImpl();
      req.setAttribute("images", imageDAO.findByItemId(vm.item.getId()));
    } else {
      req.setAttribute("images", new java.util.ArrayList<>());
    }

    // Review data from the service
    req.setAttribute("reviews", vm.reviews != null ? vm.reviews : new java.util.ArrayList<>());
    req.setAttribute("reviewCount", vm.reviewCount);
    req.setAttribute("averageRating", vm.averageRating);
    req.setAttribute("ratingPercentages", vm.ratingPercentages != null ? vm.ratingPercentages : new java.util.LinkedHashMap<Integer, Integer>());
    req.setAttribute("unavailableDates", "[]");

    req.getRequestDispatcher("/jsp/listing/listing.jsp").forward(req, resp);
  }
}