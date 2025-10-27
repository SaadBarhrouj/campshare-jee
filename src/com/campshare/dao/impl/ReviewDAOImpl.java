package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {
    
    @Override
    public List<Review> findByRevieweeId(long revieweeId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.username as reviewer_username, u.avatar_url as reviewer_avatar " +
                    "FROM reviews r " +
                    "LEFT JOIN users u ON r.reviewer_id = u.id " +
                    "WHERE r.reviewee_id = ? AND r.is_visible = true " +
                    "ORDER BY r.created_at DESC";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, revieweeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = mapResultSetToReview(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des avis pour l'utilisateur " + revieweeId, e);
        }
        return reviews;
    }

    @Override
    public List<Review> findByItemId(long itemId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.username as reviewer_username, u.avatar_url as reviewer_avatar " +
                    "FROM reviews r " +
                    "LEFT JOIN users u ON r.reviewer_id = u.id " +
                    "WHERE r.item_id = ? AND r.is_visible = true AND r.type = 'forObject' " +
                    "ORDER BY r.created_at DESC";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = mapResultSetToReview(rs);
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des avis pour l'item " + itemId, e);
        }
        return reviews;
    }

    @Override
    public long countByItemId(long itemId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE item_id = ? AND is_visible = true AND type = 'forObject'";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des avis pour l'item " + itemId, e);
        }
        return 0;
    }

    @Override
    public double getAverageRatingByItemId(long itemId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE item_id = ? AND is_visible = true AND type = 'forObject'";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    return rs.wasNull() ? 0.0 : avg;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du calcul de la note moyenne pour l'item " + itemId, e);
        }
        return 0.0;
    }

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getLong("id"));
        review.setReservationId(rs.getLong("reservation_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setVisible(rs.getBoolean("is_visible"));
        review.setType(rs.getString("type"));
        review.setReviewerId(rs.getLong("reviewer_id"));
        review.setRevieweeId(rs.getLong("reviewee_id"));
        review.setItemId(rs.getLong("item_id"));
        review.setCreatedAt(rs.getTimestamp("created_at"));

        // Set reviewer information
        User reviewer = new User();
        reviewer.setId(rs.getLong("reviewer_id"));
        reviewer.setUsername(rs.getString("reviewer_username"));
        reviewer.setAvatarUrl(rs.getString("reviewer_avatar"));
        review.setReviewer(reviewer);

        return review;
    }
}
