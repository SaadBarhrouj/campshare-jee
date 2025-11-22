package com.campshare.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.City;
import com.campshare.model.User;
import com.campshare.service.CityService;
import com.campshare.service.ListingService;
import com.campshare.service.PartnerService;

@WebServlet("/partner/AnnonceEdit")
public class partnerEditAnnonceServle extends HttpServlet {
    private CityService cityService = new CityService();
    private ListingService listingService = new ListingService();

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
    List<City> cities = cityService.getAllCities();
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
    request.setAttribute("cities", cities);
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


        request.getRequestDispatcher("/jsp/partner/Edit-annonce.jsp").forward(request, response);

    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8"); // handle accents

        // Get form parameters
        long listingId = Long.parseLong(request.getParameter("listing_id"));
        long cityId = Long.parseLong(request.getParameter("city_id"));
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");
        String deliveryOption = request.getParameter("delivery_option");
        
        String latitudeStr = request.getParameter("latitude");
        String longitudeStr = request.getParameter("longitude");
        Double latitude = (latitudeStr != null && !latitudeStr.isEmpty()) ? Double.parseDouble(latitudeStr) : null;
        Double longitude = (longitudeStr != null && !longitudeStr.isEmpty()) ? Double.parseDouble(longitudeStr) : null;



        // Update listing
        boolean updated = listingService.updateListing(listingId, cityId, startDate, endDate, deliveryOption,
                                            latitude, longitude);

        if (updated) {
            request.getSession().setAttribute("successMessage", "Annonce mise à jour avec succès ✅");
        } else {
            request.getSession().setAttribute("errorMessage", "Impossible de mettre à jour l'annonce ❌");
        }

        // Redirect back to listing page or dashboard
        response.sendRedirect(request.getContextPath() + "/partner/MesAnnonces");
    }
}