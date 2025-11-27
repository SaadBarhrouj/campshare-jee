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
import com.campshare.util.FileUploadUtil;


@WebServlet("/partner/AddItem")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024) // 2MB
public class PartnerAddItemServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PartnerService partnerService = new PartnerService();

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        double pricePerDay = Double.parseDouble(request.getParameter("price_per_day"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        List<Image> images = new ArrayList<>();
        String uploadPath = getServletContext().getRealPath("/assets/images/items");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();


        for (Part part : request.getParts()) {
            System.out.println("Part name: " + part.getName());
            System.out.println("File name: " + part.getSubmittedFileName());
            System.out.println("Size: " + part.getSize());
        }


        for (Part part : request.getParts()) {
            // String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            // part.write(uploadPath + File.separator + fileName);

            // Image img = new Image();
            // img.setUrl(fileName); 
            // images.add(img);

            if ("images[]".equals(part.getName()) && part.getSize() > 0) {
                String userHome = System.getProperty("user.home");
                String uploadDirectory = userHome + File.separator + "campshare_uploads";
                String newAvatarPath = FileUploadUtil.uploadFile(part, uploadDirectory, "items");
                System.out.println("the new avatar path" + newAvatarPath);
                Image img = new Image();
                img.setUrl(newAvatarPath);
                images.add(img);
                
                // if (newAvatarPath != null) {
                //     avatarUrl = newAvatarPath; 
                // }
            }
        }



        // Assuming you have the logged-in partner user
        //User partner = (User) request.getSession().getAttribute("user");

        Item item = new Item();
        item.setTitle(title);
        item.setDescription(description);
        item.setPricePerDay(pricePerDay);
        Category category = new Category();
        category.setId(categoryId);
        item.setCategory(category);
        User partner = new User(); // Placeholder for the actual partner user retrieval

        User user = (User) request.getSession().getAttribute("authenticatedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        long partnerId = user.getId();

        partner.setId(partnerId); // Set the actual partner ID
        item.setPartner(partner);
        item.setImages(images);
        partnerService.createItemWithImages(item,  getServletContext());

        

        response.sendRedirect(request.getContextPath() + "/partner/MesEquipements");
    }
    
}