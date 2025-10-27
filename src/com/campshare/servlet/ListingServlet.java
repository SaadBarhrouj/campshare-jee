package com.campshare.servlet;

import com.campshare.model.Reservation;
import com.campshare.service.ListingService;
import com.campshare.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

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
    
    // Get unavailable dates from confirmed reservations
    ReservationService reservationService = new ReservationService();
    List<Reservation> reservations = reservationService.getConfirmedReservationsByListingId(listingId);
    
    // Generate list of individual dates that are unavailable
    List<String> unavailableDatesList = new ArrayList<>();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    Calendar cal = Calendar.getInstance();
    
    for (Reservation reservation : reservations) {
      if (reservation.getStartDate() != null && reservation.getEndDate() != null) {
        cal.setTime(reservation.getStartDate());
        Date currentDate = cal.getTime();
        Date endDate = reservation.getEndDate();
        
        // Add all dates in the range
        while (!currentDate.after(endDate)) {
          unavailableDatesList.add(sdf.format(currentDate));
          cal.add(Calendar.DAY_OF_MONTH, 1);
          currentDate = cal.getTime();
        }
      }
    }
    
    // Convert list to JSON array string
    StringBuilder jsonArray = new StringBuilder("[");
    for (int i = 0; i < unavailableDatesList.size(); i++) {
      if (i > 0) jsonArray.append(",");
      jsonArray.append("\"").append(unavailableDatesList.get(i)).append("\"");
    }
    jsonArray.append("]");
    
    req.setAttribute("unavailableDates", jsonArray.toString());

    req.getRequestDispatcher("/jsp/listing/listing.jsp").forward(req, resp);
  }
}