package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;

import java.io.IOException;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5, 
    maxRequestSize = 1024 * 1024 * 10 
)
@WebServlet("/client/profile")

public class profileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        String email = "maronakram@gmail.com";
        User user = clientService.getClientByEmail(email);
        request.setAttribute("user", user);

        ReservationService reservationService = new ReservationService();
        User userProfile = reservationService.getClientProfile(email);
        request.setAttribute("userProfile", userProfile);
        int totalReservations = reservationService.getTotalReservationsByEmail(email);
        request.setAttribute("totalReservations", totalReservations);

        double totalDepense = reservationService.getTotalDepenseByEmail(email);
        request.setAttribute("totalDepense", totalDepense);

                // Calculate stars
      

        double noteMoyenne = reservationService.getNoteMoyenneByEmail(email);
        request.setAttribute("noteMoyenne", noteMoyenne);
        int fullStars = (int) Math.floor(noteMoyenne);
        boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        // Set attributes for JSP
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("emptyStars", emptyStars);
        request.getRequestDispatcher("/jsp/client/profile.jsp").forward(request, response);

    }


        @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== doPost method called ===");
        
        // Handle profile update
        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        if ("update".equals(action)) {
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            
            System.out.println("First Name: " + firstName);
            System.out.println("Last Name: " + lastName);
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phoneNumber);
            
            // Handle file upload
            String avatarFileName = null;
            try {
                Part filePart = request.getPart("avatar");
                if (filePart != null && filePart.getSize() > 0) {
                    avatarFileName = getFileName(filePart);
                    System.out.println("Uploaded file: " + avatarFileName);
                    // Save the file to your server
                    // String uploadPath = getServletContext().getRealPath("") + "images/avatars";
                    // filePart.write(uploadPath + File.separator + fileName);
                }
            } catch (Exception e) {
                System.out.println("Error handling file upload: " + e.getMessage());
            }
            
            // ✅ ACTUALLY UPDATE THE USER IN DATABASE
            try {
                ReservationService reservationService = new ReservationService();
                boolean updateSuccess = reservationService.updateUserProfile(
                    email, // use email to identify the user
                    firstName,
                    lastName,
                    username,
                    phoneNumber,
                    password, // can be null if not changing password
                    avatarFileName // can be null if not changing avatar
                );
                
                if (updateSuccess) {
                    System.out.println("✅ User profile updated successfully!");
                    // Set success message
                    request.getSession().setAttribute("successMessage", "Profil mis à jour avec succès!");
                } else {
                    System.out.println("❌ Failed to update user profile!");
                    request.getSession().setAttribute("errorMessage", "Erreur lors de la mise à jour du profil!");
                }
                
            } catch (Exception e) {
                System.out.println("❌ Error updating user: " + e.getMessage());
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            }
            
            // Redirect back to profile
            response.sendRedirect(request.getContextPath() + "/client/profile");
        } else {
            System.out.println("Action is not 'update'");
            response.sendRedirect(request.getContextPath() + "/client/profile");
        }
    }
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

}