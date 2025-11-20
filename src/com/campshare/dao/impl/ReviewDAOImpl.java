package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public List<Review> findByReservationIdWithUser(long reservationId) {
        List<Review> reviews = new ArrayList<>();
        
        String sql = "SELECT r.*, " +
                     "u.id as u_id, u.username, u.first_name, u.last_name, u.avatar_url " +
                     "FROM reviews r " +
                     "LEFT JOIN users u ON r.reviewer_id = u.id " +
                     "WHERE r.reservation_id = ?";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, reservationId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getLong("id"));
                    review.setReservationId(rs.getLong("reservation_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setType(rs.getString("type")); 
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    if (rs.getLong("u_id") != 0) {
                        User reviewer = new User();
                        reviewer.setId(rs.getLong("u_id"));
                        reviewer.setUsername(rs.getString("username"));
                        reviewer.setFirstName(rs.getString("first_name"));
                        reviewer.setLastName(rs.getString("last_name"));
                        reviewer.setAvatarUrl(rs.getString("avatar_url"));
                        
                        review.setReviewer(reviewer);
                    }
                    
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans findByReservationIdWithUser: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }

    @Override
    public List<Review> findByReservationId(long reservationId) {
        return findByReservationIdWithUser(reservationId);
    }
}