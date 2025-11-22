package com.campshare.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.ReservationService;

import java.io.File;
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
        
        User user = (User) request.getSession().getAttribute("authenticatedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = user.getEmail();

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("update".equals(action)) {

            // Read input fields
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String password = request.getParameter("password");

            String avatarFileName = null;

            // ✅ Handle avatar upload
            try {
                Part filePart = request.getPart("avatar");
                if (filePart != null && filePart.getSize() > 0) {
                    avatarFileName = getFileName(filePart);

                    String uploadPath = getServletContext().getRealPath("/images/avatars/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + avatarFileName);

                    System.out.println("✅ Avatar uploaded: " + avatarFileName);
                }
            } catch (Exception e) {
                System.out.println("⚠ Avatar upload error: " + e.getMessage());
            }

            ReservationService reservationService = new ReservationService();
            boolean updateSuccess = reservationService.updateUserProfile(
                    email, firstName, lastName, username, phoneNumber,
                    password, avatarFileName
            );

            if (updateSuccess) {
                System.out.println("✅ Profile updated!");

                // ✅ Update session user manually (no DB fetch)
                User user = (User) request.getSession().getAttribute("user");
                if (user != null) {
                    user.setFirstName(firstName);
                    user.setLastName(lastName);
                    user.setUsername(username);
                    user.setEmail(email);
                    user.setPhoneNumber(phoneNumber);

                    if (avatarFileName != null && !avatarFileName.trim().isEmpty()) {
                        user.setAvatarUrl(avatarFileName);
                    }
                    if (password != null && !password.trim().isEmpty()) {
                        user.setPassword(password); // (recommended: hash)
                    }

                    request.getSession().setAttribute("user", user);
                }

                request.getSession().setAttribute("successMessage", "Profil mis à jour avec succès!");

            } else {
                System.out.println("❌ Failed to update profile!");
                request.getSession().setAttribute("errorMessage", "Erreur lors de la mise à jour!");
            }

            response.sendRedirect(request.getContextPath() + "/client/profile");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }



}