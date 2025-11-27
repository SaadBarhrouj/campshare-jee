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

import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.model.Item;
import com.campshare.model.Reservation;
import com.campshare.model.Category;
import com.campshare.model.Image;


import com.campshare.service.ItemService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;


@WebServlet("/partner/DeleteItem/*")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 2MB
public class PartnerDeleteItemServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PartnerService partnerService = new PartnerService();

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing item ID");
            return;
        }
        int itemId = Integer.parseInt(pathInfo.substring(1));
        boolean deleted = partnerService.deleteItem(itemId);

        response.sendRedirect(request.getContextPath() + "/partner/MesEquipements");
    }
    
}