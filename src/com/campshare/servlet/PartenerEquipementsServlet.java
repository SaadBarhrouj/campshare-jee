package com.campshare.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Category;
import com.campshare.model.User;
import com.campshare.model.Item;

import com.campshare.service.ItemService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;
import com.campshare.service.CategoryService;



@WebServlet("/partner/MesEquipements")
public class PartenerEquipementsServlet extends HttpServlet {

    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();
        CategoryService categoryService = new CategoryService();

        ItemService itemService = new ItemService();


        String email = "maronakram@gmail.com";
        User user = partnerService.getClientByEmail(email);
        request.setAttribute("user", user);

        List<Item> PartenerEquipment = itemService.getPartnerEquipment(email);
        request.setAttribute("PartenerEquipment", PartenerEquipment);

        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);



        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/MesEquipements.jsp").forward(request, response);
    }
    
}