package com.campshare.servlet;

import com.campshare.model.City;
import com.campshare.model.User;
import com.campshare.service.CityService;
import com.campshare.service.UserService;
import com.campshare.util.FileUploadUtil;
import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CityService cityService = new CityService();
        List<City> cities = cityService.getAllCities();
        request.setAttribute("cities", cities);
        request.getRequestDispatcher("/jsp/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String address = request.getParameter("address");
        String cityIdParam = request.getParameter("city_id");
        String password = request.getParameter("password");
        String passwordConfirmation = request.getParameter("password_confirmation");
        String role = request.getParameter("role");
        boolean isSubscriber = request.getParameter("is_subscribed") != null;

        long cityId = 0;
        if (cityIdParam != null && !cityIdParam.isEmpty()) {
            try {
                cityId = Long.parseLong(cityIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("serverErrors", List.of("ID de ville invalide."));
                request.getRequestDispatcher("/jsp/auth/register.jsp").forward(request, response);
                return;
            }
        }

        String userHome = System.getProperty("user.home");
        String permanentStoragePath = userHome + File.separator + "campshare_uploads";

        File uploadDir = new File(permanentStoragePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String avatarUrl = null;
        String cinRectoUrl = null;
        String cinVersoUrl = null;

        try {
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                avatarUrl = FileUploadUtil.uploadFile(imagePart, permanentStoragePath, "avatars");
            }

            Part cinFrontPart = request.getPart("cin_recto");
            if (cinFrontPart != null && cinFrontPart.getSize() > 0) {
                cinRectoUrl = FileUploadUtil.uploadFile(cinFrontPart, permanentStoragePath, "cin");
            }

            Part cinBackPart = request.getPart("cin_verso");
            if (cinBackPart != null && cinBackPart.getSize() > 0) {
                cinVersoUrl = FileUploadUtil.uploadFile(cinBackPart, permanentStoragePath, "cin");
            }
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            request.setAttribute("serverErrors",
                    List.of("Erreur lors du téléchargement des fichiers: " + e.getMessage()));
            request.getRequestDispatcher("/jsp/auth/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phoneNumber);
        newUser.setAddress(address);
        newUser.setCityId(cityId);
        newUser.setRole(role != null ? role : "client");
        newUser.setSubscriber(isSubscriber);
        newUser.setAvatarUrl(avatarUrl);
        newUser.setCinRecto(cinRectoUrl);
        newUser.setCinVerso(cinVersoUrl);
        newUser.setActive(true);

        List<String> errors = userService.registerUser(newUser, password, passwordConfirmation);

        if (errors.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login?registrationSuccess=true");
        } else {
            request.setAttribute("serverErrors", errors);
            request.setAttribute("user", newUser);
            request.getRequestDispatcher("/jsp/auth/register.jsp").forward(request, response);
        }
    }
}