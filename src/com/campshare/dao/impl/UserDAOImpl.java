package com.campshare.dao.impl;

import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Implémentation minimale de UserDAO pour le test de connexion.
 */
public class UserDAOImpl implements UserDAO {

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        User user = null;

        // Le try-with-resources ferme automatiquement la connexion
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    // Assurez-vous que les noms de colonnes ("user_id", "username", etc.)
                    // correspondent exactement à votre table `users`.
                }
            }
        } catch (SQLException e) {
            System.err.println("ERREUR JDBC: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
}