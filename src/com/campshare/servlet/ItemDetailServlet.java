package com.campshare.servlet;

import com.campshare.service.ItemService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.Map;


import com.campshare.model.Item;
import com.campshare.service.ListingService;
import com.google.gson.Gson;

@WebServlet("/partner/equipment/details")
public class ItemDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    ListingService listingService = new ListingService();
        

    String idParam = request.getParameter("id");
    System.out.println("ItemDetailServlet: id=" + idParam);
    if (idParam == null) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing Item id");
      return;
    }
    long itemId;
    try {
      itemId = Long.parseLong(idParam);
    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid item id");
      return;
    }

    Item item = listingService.getItemDetails(itemId);
    int nbrListing = listingService.getCountListingsByItem(itemId);
    int nbrReservation = listingService.getCountReservationByItem(itemId);
    System.out.println("ItemDetailServlet: item=" + item);


    if (item == null) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "Listing not found");
      return;
    }
    Map<String, Object> jsonMap = new HashMap<>();
    jsonMap.put("item", item);
    jsonMap.put("nbrListing", nbrListing);
    jsonMap.put("nbrReservation", nbrReservation);

    // Configurer la réponse JSON
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    // Convertir en JSON
    String json = new Gson().toJson(jsonMap);
    response.getWriter().write(json);

    }
}

