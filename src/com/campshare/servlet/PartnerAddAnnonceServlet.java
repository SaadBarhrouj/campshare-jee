package com.campshare.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Category;
import com.campshare.model.User;
import com.campshare.model.City;

import com.campshare.model.Item;

import com.campshare.service.CityService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;
import com.campshare.service.CategoryService;



@WebServlet("/partner/AddAnnonce")
public class PartnerAddAnnonceServlet extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();
        CityService cityService = new CityService();
        int equipmentId = Integer.parseInt(request.getParameter("equipment_id"));

        List<City> cities = cityService.getAllCities();
        request.setAttribute("cities", cities);



        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);
        Optional<Item> opitem = partnerService.findItemWithImages(equipmentId);
        Item item = opitem.get();
        request.setAttribute("item", item);
        System.out.println("aaaaaaaaaaaaaaaa");
        System.out.println(item);
        




        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/annonce-form.jsp").forward(request, response);
    }
    
}