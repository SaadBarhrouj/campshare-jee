package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;
import com.campshare.util.FileUploadUtil;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

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


        User user1 = (User) request.getSession().getAttribute("authenticatedUser");
        if (user1 == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = user1.getEmail();

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
            String emailParam = request.getParameter("email");
            String email = (emailParam != null && !emailParam.isBlank()) ? emailParam : "maronakram@gmail.com";

            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");
            
            System.out.println("First Name: " + firstName);
            System.out.println("Last Name: " + lastName);
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phoneNumber);
            
            // Handle file upload
            ReservationService reservationService = new ReservationService();
            User existingUser = reservationService.getClientProfile(email);
            String avatarFileName = existingUser != null ? existingUser.getAvatarUrl() : null;

            try {
                //Part filePart = request.getPart("avatar");
                //if (filePart != null && filePart.getSize() > 0) {
                //    String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                //    if (!submittedFileName.isBlank()) {
                //        String uploadsDirPath = getServletContext().getRealPath("/images/avatars");
                //        File uploadsDir = new File(uploadsDirPath);
                //        if (!uploadsDir.exists()) {
                //            uploadsDir.mkdirs();
                //        }
                //        avatarFileName = System.currentTimeMillis() + "_" + submittedFileName;
                //        File destination = new File(uploadsDir, avatarFileName);
                //         filePart.write(destination.getAbsolutePath());
                //    }
                //} 

                
                // 222
                Part avatarPart = request.getPart("avatar");

                if (avatarPart != null && avatarPart.getSize() > 0) {
                    String userHome = System.getProperty("user.home");
                    String uploadDirectory = userHome + File.separator + "campshare_uploads";
                    
                    String newAvatarPath = FileUploadUtil.uploadFile(avatarPart, uploadDirectory, "avatars");
                    
                    if (newAvatarPath != null) {
                        avatarFileName = newAvatarPath; 
                    }
                }


            } catch (Exception e) {
                System.out.println("Error handling file upload: " + e.getMessage());
            }
            
            try {
                boolean updateSuccess = reservationService.updateUserProfile(
                    email, // use email to identify the user
                    firstName,
                    lastName,
                    username,
                    phoneNumber,
                    password, // can be null if not changing password
                    avatarFileName // can be null if not changing avatar
                );

                // Update the authenticatedUser in session with the latest user data
                /*HttpSession session = request.getSession(false);
                User updatedUser = reservationService.getClientProfile(email);
                session.setAttribute("authenticatedUser", updatedUser);

                System.out.println("Updated User: " + updatedUser);
                System.out.println("Authenticated User: " + session.getAttribute("authenticatedUser"));*/
                
             
                
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