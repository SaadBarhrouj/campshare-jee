package com.campshare.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ListingService;
import com.campshare.service.PartnerService;

@WebServlet("/partner/AnnonceDetails")
public class AnnonceDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

      PartnerService partnerService = new PartnerService();

      String email = "maronakram@gmail.com";
      User user = partnerService.getPartnerByEmail(email);
      request.setAttribute("user", user);
        

    String idParam = request.getParameter("listing_id");
    if (idParam == null) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing listing id");
      return;
    }
    long listingId;
    try {
      listingId = Long.parseLong(idParam);
    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid listing id");
      return;
    }

    ListingService service = new ListingService();
    ListingService.ListingViewModel vm = service.getListingDetails(listingId);
    if (vm == null) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "Listing not found");
      return;
    }

    request.setAttribute("listing", vm.listing);
    request.setAttribute("item", vm.item);
    request.setAttribute("category", vm.category);
    request.setAttribute("city", vm.city);
    request.setAttribute("partner", vm.partner);
    
    // Get images for the item
    if (vm.item != null) {
      com.campshare.dao.impl.ImageDAOImpl imageDAO = new com.campshare.dao.impl.ImageDAOImpl();
      request.setAttribute("images", imageDAO.findByItemId(vm.item.getId()));
    } else {
      request.setAttribute("images", new java.util.ArrayList<>());
    }

    // Review data from the service
    request.setAttribute("reviews", vm.reviews != null ? vm.reviews : new java.util.ArrayList<>());
    request.setAttribute("reviewCount", vm.reviewCount);
    request.setAttribute("averageRating", vm.averageRating);
    request.setAttribute("ratingPercentages", vm.ratingPercentages != null ? vm.ratingPercentages : new java.util.LinkedHashMap<Integer, Integer>());

        

        request.getRequestDispatcher("/jsp/partner/details-anoonce.jsp").forward(request, response);

    }
}

