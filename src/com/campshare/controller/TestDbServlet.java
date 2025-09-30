package com.campshare.controller;

import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class TestDbServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        System.out.println("--- DÉBUT TEST CONNEXION BDD ---");
        
        UserDAO userDAO = new UserDAOImpl();
        
        String testEmail = "VOTRE_EMAIL_DE_TEST_ICI@example.com";
        
        // 3. Appeler la méthode du DAO
        User foundUser = userDAO.findByEmail(testEmail);
        
        // 4. Afficher le résultat dans la console ET sur la page web
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Test de Connexion Base de Données</h1>");
        out.println("<p>Vérifiez la console de VS Code pour les logs détaillés.</p>");

        if (foundUser != null) {
            String message = "CONNEXION RÉUSSIE ! Utilisateur trouvé : " + foundUser.getUsername();
            System.out.println(message);
            out.println("<p style='color:green;'>" + message + "</p>");
        } else {
            String message = "CONNEXION RÉUSSIE, mais l'utilisateur avec l'email '" + testEmail + "' n'a pas été trouvé.";
            System.out.println(message);
            out.println("<p style='color:orange;'>" + message + "</p>");
        }

        System.out.println("--- FIN TEST CONNEXION BDD ---");
        out.println("</body></html>");
    }
}