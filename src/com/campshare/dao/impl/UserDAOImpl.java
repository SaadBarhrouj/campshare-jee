package com.campshare.dao.impl;

import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDAOImpl implements UserDAO {

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche de l'utilisateur par email: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par email.", e);
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche de l'utilisateur par username: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par username.", e);
        }
        return null;
    }

    @Override
    public void save(User user) {
        String sql = "INSERT INTO users (first_name, last_name, username, email, password, phone_number, address, role, avatar_url, cin_recto, cin_verso, is_subscriber, is_active, city_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getUsername());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPassword());
            pstmt.setString(6, user.getPhoneNumber());
            pstmt.setString(7, user.getAddress());
            pstmt.setString(8, user.getRole());
            pstmt.setString(9, user.getAvatarUrl());
            pstmt.setString(10, user.getCinRecto());
            pstmt.setString(11, user.getCinVerso());
            pstmt.setBoolean(12, user.isSubscriber());
            pstmt.setBoolean(13, user.isActive());
            pstmt.setLong(14, user.getCityId());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("La création de l'utilisateur a échoué, aucune ligne affectée.");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("La création de l'utilisateur a échoué, aucun ID généré.");
                }
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'enregistrement de l'utilisateur: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de l'enregistrement de l'utilisateur.", e);
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        user.setCinRecto(rs.getString("cin_recto"));
        user.setCinVerso(rs.getString("cin_verso"));
        user.setSubscriber(rs.getBoolean("is_subscriber"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCityId(rs.getLong("city_id"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
    public double getAverageRatingForPartner(long partnerId) {
        double avgRating = 0.0;
        String sql = "SELECT AVG(R.rating) AS avg_rating " +
                    "FROM reviews R " +
                    "WHERE R.reviewee_id = ? AND R.type = 'forPartner'";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, partnerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating"); // returns 0.0 if null
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return avgRating;
    }
}