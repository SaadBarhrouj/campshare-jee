package com.campshare.servlet;

import com.campshare.service.ListingService;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminDeleteListingServlet extends HttpServlet {
  private ListingService listingService = new ListingService();

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    long listingId = Long.parseLong(request.getParameter("listingId"));
    listingService.deleteListing(listingId);

    response.sendRedirect(request.getContextPath() + "/admin/listings?deleteSuccess=true");
  }
}