package com.campshare.servlet;

import com.campshare.model.Listing;
import com.campshare.service.ListingService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ListingsServlet extends HttpServlet {

  private ListingService listingService = new ListingService();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    List<Listing> listings = listingService.getAllListings();

    request.setAttribute("listings", listings);

    request.getRequestDispatcher("/jsp/listing/listings.jsp").forward(request, response);
  }
}