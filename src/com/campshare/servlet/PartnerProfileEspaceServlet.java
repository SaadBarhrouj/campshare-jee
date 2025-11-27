package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.service.ClientService;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/partner/profile")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 20
)
public class PartnerProfileEspaceServlet extends HttpServlet {

       @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ClientService clientService = new ClientService();
        PartnerService partnerService = new PartnerService();

                
        User user1 = (User) request.getSession().getAttribute("authenticatedUser");
        if (user1 == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = partnerService.getPartnerByEmail(user1.getEmail());
        request.setAttribute("user", user);

        ReservationService reservationService = new ReservationService();
        User userProfile = reservationService.getPartnerProfile(user.getEmail());
        request.setAttribute("userProfile", userProfile);
        int totalReservations = reservationService.getTotalReservationsByEmailPartner(user.getEmail());
        request.setAttribute("totalReservations", totalReservations);

        double totalDepense = reservationService.getTotalDepenseByEmailPartner(user1.getEmail());
        request.setAttribute("totalDepense", totalDepense);

                // Calculate stars
      

        double noteMoyenne = userProfile.getAvgRating();
        request.setAttribute("noteMoyenne", noteMoyenne);
        int fullStars = (int) Math.floor(userProfile.getAvgRating());
        boolean hasHalfStar = (noteMoyenne - fullStars) >= 0.5;
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        // Set attributes for JSP
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("emptyStars", emptyStars);
        request.getRequestDispatcher("/jsp/partner/profile.jsp").forward(request, response);

    }

     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== doPost method called ===");
        User user1 = (User) request.getSession().getAttribute("authenticatedUser");
        if (user1 == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Handle profile update
        String action = request.getParameter("action");
        System.out.println("Action: " + action);
        
        if ("update".equals(action)) {
            String emailParam = request.getParameter("email");
            String email = (emailParam != null && !emailParam.isBlank()) ? emailParam : user1.getEmail();

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
            
            ReservationService reservationService = new ReservationService();
            User existingUser = reservationService.getPartnerProfile(email);
            String avatarFileName = existingUser != null ? existingUser.getAvatarUrl() : null;

            try {
                Part filePart = request.getPart("avatar");
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (!submittedFileName.isBlank()) {
                        String uploadsDirPath = getServletContext().getRealPath("/assets/images/users");
                        File uploadsDir = new File(uploadsDirPath);
                        if (!uploadsDir.exists()) {
                            uploadsDir.mkdirs();
                        }
                        avatarFileName = System.currentTimeMillis() + "_" + submittedFileName;
                        File destination = new File(uploadsDir, avatarFileName);
                        filePart.write(destination.getAbsolutePath());
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
                if(updateSuccess) {
                    user1.setFirstName(firstName);
                    user1.setLastName(lastName);
                    user1.setUsername(username);
                    user1.setPhoneNumber(phoneNumber);
                    user1.setAvatarUrl(avatarFileName);
                    request.getSession().setAttribute("authenticatedUser", user1);
                } 
                
               
                
            } catch (Exception e) {
                System.out.println("❌ Error updating user: " + e.getMessage());
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            }
            
            response.sendRedirect(request.getContextPath() + "/partner/profile");
        } else {
            System.out.println("Action is not 'update'");
            response.sendRedirect(request.getContextPath() + "/partner/profile");
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

