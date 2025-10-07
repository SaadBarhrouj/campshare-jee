package com.campshare.servlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/partner/DemandeLocation")

public class PartnerDemandeLocationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Exemple : on peut envoyer des données dynamiques à la JSP
        request.setAttribute("partnerName", "John Doe");  // tu peux remplacer par la vraie info
        request.setAttribute("totalProjects", 5);

        // On redirige vers la JSP du dashboard
        request.getRequestDispatcher("/jsp/partner/DemandeLocation.jsp").forward(request, response);
    }
    
}
