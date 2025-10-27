package com.campshare.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.model.Item;
import com.campshare.model.Listing;


import com.campshare.service.ItemService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;


@WebServlet("/partner/MesAnnonces")
public class PartnerMesAnnonceServlet extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();

        ItemService itemService = new ItemService();


        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);

        List<Listing> PartenerListings = partnerService.getPartnerListings(email);
        request.setAttribute("PartenerListings", PartenerListings);



        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/MesAnnonces.jsp").forward(request, response);
    }
    
}