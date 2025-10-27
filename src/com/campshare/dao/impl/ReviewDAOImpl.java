package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Item;
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
    public List<Review> getPartnerAvisRecu(String email)  {
        List<Review> avisList = new ArrayList<>();

        String sql = "SELECT r.rating, r.comment, c.username, c.avatar_url, " +
                    "DATE(r.created_at) AS created_at, " +
                    "CASE WHEN r.type = 'forObject' THEN i.title ELSE NULL END AS object_title " +
                    "FROM reviews r " +
                    "JOIN users u ON u.id = r.reviewee_id " +
                    "JOIN users c ON c.id = r.reviewer_id " +
                    "LEFT JOIN items i ON i.id = r.item_id AND r.type = 'forObject' " +
                    "WHERE u.email = ? " +
                    "AND r.type IN ('forObject', 'forPartner')";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Review avis = new Review();
                avis.setRating(rs.getInt("rating"));
                avis.setComment(rs.getString("comment"));
                User reviewer = new User();
                reviewer.setUsername(rs.getString("username"));
                reviewer.setAvatarUrl(rs.getString("avatar_url"));
                avis.setCreatedAt(rs.getDate("created_at"));
                Item item = new Item();
                item.setTitle(rs.getString("object_title"));
                //avis.setObjectTitle(rs.getString("object_title"));
                avis.setReviewer(reviewer);
                avis.setItem(item);
                
                avisList.add(avis);
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }

        return avisList;
    }


}
