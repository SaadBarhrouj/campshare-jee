package com.campshare.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.Reservation;
import com.campshare.model.Category;
import com.campshare.model.Image;


import com.campshare.service.ItemService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;
import com.campshare.service.ListingService;



@WebServlet("/partner/AddAnnonceForm")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024) // 2MB
public class PartnerAddAnnonceFormServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PartnerService partnerService = new PartnerService();
        ListingService listingService = new ListingService();

        try {
            // Retrieve parameters from form
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String startDateStr  = request.getParameter("start_date");
            String endDateStr = request.getParameter("end_date");
            boolean deliveryOption = "on".equals(request.getParameter("delivery_option"));
            int cityId = Integer.parseInt(request.getParameter("city_id"));
            double latitude = Double.parseDouble(request.getParameter("latitude"));
            double longitude = Double.parseDouble(request.getParameter("longitude"));

            // Get the partner (you can replace this with actual logged user)
            int partnerId =1;


            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date utilStartDate = formatter.parse(startDateStr);
            Date utilEndDate = formatter.parse(endDateStr);

            // Convert to java.sql.Date
            java.sql.Date sqlStartDate = new java.sql.Date(utilStartDate.getTime());
            java.sql.Date sqlEndDate = new java.sql.Date(utilEndDate.getTime());
            // Create listing object
            Listing listing = new Listing();
            listing.setItemId(itemId);
            listing.setStartDate(sqlStartDate);
            listing.setEndDate(sqlEndDate);
            listing.setDeliveryOption(deliveryOption);
            //listing.setPremium(isPremium != null && isPremium.equals("on"));
            //listing.setPremiumType(premiumType);
            listing.setCityId(cityId);
            listing.setLatitude(latitude);
            listing.setLongitude(longitude);
            listing.setStatus("active");

            // Insert into database
            boolean success = partnerService.addListing(listing);
            System.out.println("bbbbbbbbbbbbbb");

            System.out.println(listing);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/partner/annonce-form.jsp").forward(request, response);
        }

        

        response.sendRedirect(request.getContextPath() + "/partner/MesEquipements");
    }
    
}