package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {
    
    @Override
    public List<Review> findAll() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
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
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis.", e);
        }
        return reviews;
    }

    @Override
    public Review findById(long id) {
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
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
                    return review;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de l'avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de l'avis.", e);
        }
        return null;
    }

    @Override
    public List<Review> findByItemId(long itemId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE item_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis par article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis par article.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findByItemIdAndType(long itemId, String type) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE item_id = ? AND type = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            pstmt.setString(2, type);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis par article et type: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis par article et type.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findByReviewerId(long reviewerId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE reviewer_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, reviewerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis par examinateur: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis par examinateur.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findByRevieweeId(long revieweeId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE reviewee_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, revieweeId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis par évalué: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis par évalué.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findByReservationId(long reservationId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE reservation_id = ? ORDER BY created_at DESC";

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
                    review.setVisible(rs.getBoolean("is_visible"));
                    review.setType(rs.getString("type"));
                    review.setReviewerId(rs.getLong("reviewer_id"));
                    review.setRevieweeId(rs.getLong("reviewee_id"));
                    review.setItemId(rs.getLong("item_id"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis par réservation: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis par réservation.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findVisibleReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE is_visible = 1 ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
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
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis visibles: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis visibles.", e);
        }
        return reviews;
    }

    @Override
    public List<Review> findVisibleReviewsByItemId(long itemId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at FROM reviews WHERE item_id = ? AND is_visible = 1 ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
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
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis visibles par article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des avis visibles par article.", e);
        }
        return reviews;
    }

    @Override
    public double getAverageRatingByItemId(long itemId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE item_id = ? AND is_visible = 1";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors du calcul de la note moyenne: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors du calcul de la note moyenne.", e);
        }
        return 0.0;
    }

    @Override
    public long getReviewCountByItemId(long itemId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE item_id = ? AND is_visible = 1";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors du comptage des avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors du comptage des avis.", e);
        }
        return 0;
    }

    @Override
    public boolean create(Review review) {
        String sql = "INSERT INTO reviews (reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setLong(1, review.getReservationId());
            pstmt.setInt(2, review.getRating());
            pstmt.setString(3, review.getComment());
            pstmt.setBoolean(4, review.isVisible());
            pstmt.setString(5, review.getType());
            pstmt.setLong(6, review.getReviewerId());
            pstmt.setLong(7, review.getRevieweeId());
            pstmt.setLong(8, review.getItemId());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        review.setId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la création de l'avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la création de l'avis.", e);
        }
        return false;
    }

    @Override
    public boolean update(Review review) {
        String sql = "UPDATE reviews SET reservation_id = ?, rating = ?, comment = ?, is_visible = ?, type = ?, reviewer_id = ?, reviewee_id = ?, item_id = ? WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, review.getReservationId());
            pstmt.setInt(2, review.getRating());
            pstmt.setString(3, review.getComment());
            pstmt.setBoolean(4, review.isVisible());
            pstmt.setString(5, review.getType());
            pstmt.setLong(6, review.getReviewerId());
            pstmt.setLong(7, review.getRevieweeId());
            pstmt.setLong(8, review.getItemId());
            pstmt.setLong(9, review.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la mise à jour de l'avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la mise à jour de l'avis.", e);
        }
    }

    @Override
    public boolean delete(long id) {
        String sql = "DELETE FROM reviews WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la suppression de l'avis: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la suppression de l'avis.", e);
        }
    }
}
