package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.Reservation;
import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

    public int countCompletedReservationsByPartnerId(long partnerId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM reservations WHERE partner_id = ? AND status = 'completed'";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, partnerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    public int countActiveListeningByPartnerId(long partnerId) {
        int count = 0;
        String sql = "SELECT COUNT(L.id) " +
                    "FROM items i " +
                    "JOIN listings L ON L.item_id = i.id " +
                    "WHERE i.partner_id = ? AND L.status = 'active'";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, partnerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

    return count;
    }
    public int countListeningByPartnerId(long partnerId) {
        int count = 0;
        String sql = "SELECT COUNT(L.id) " +
                    "FROM items i " +
                    "JOIN listings L ON L.item_id = i.id " +
                    "WHERE i.partner_id = ?";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, partnerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

    return count;
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

    public double sumPaymentThisMonth(long partnerId) {
        double total = 0.0;

        String sql = "SELECT COALESCE(SUM((DATEDIFF(r.end_date, r.start_date) + 1) * i.price_per_day), 0) AS total " +
                    "FROM reservations r " +
                    "JOIN listings l ON l.id = r.listing_id " +
                    "JOIN items i ON i.id = l.item_id " +
                    "WHERE r.partner_id = ? " +
                    "AND MONTH(r.created_at) = MONTH(CURRENT_DATE()) " +
                    "AND YEAR(r.created_at) = YEAR(CURRENT_DATE())";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, partnerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return total;
    }
   public List<Review> getLastAvisPartnerForObject(String email) {
        List<Review> reviews = new ArrayList<>();

        String sql = """
            SELECT 
                r.id,
                r.reservation_id,
                r.rating,
                r.comment,
                r.is_visible,
                r.type,
                r.reviewer_id,
                r.reviewee_id,
                r.item_id,
                c.username AS reviewer_name,
                c.avatar_url AS reviewer_avatar,
                DATE(r.created_at) AS created_at,
                i.title AS object_title
            FROM reviews r
            JOIN users u ON u.id = r.reviewee_id
            JOIN users c ON c.id = r.reviewer_id
            LEFT JOIN items i ON i.id = r.item_id AND r.type = 'forObject'
            WHERE u.email = ?
            AND r.type = 'forObject'
            ORDER BY r.created_at DESC
            LIMIT 3        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();

                // Basic Review fields
                review.setId(rs.getLong("id"));
                review.setReservationId(rs.getLong("reservation_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setType(rs.getString("type"));
                review.setReviewerId(rs.getLong("reviewer_id"));
                review.setRevieweeId(rs.getLong("reviewee_id"));
                review.setItemId(rs.getLong("item_id"));
                review.setCreatedAt(rs.getTimestamp("created_at"));

                // Reviewer object
                User reviewer = new User();
                reviewer.setUsername(rs.getString("reviewer_name"));
                reviewer.setAvatarUrl(rs.getString("reviewer_avatar"));
                review.setReviewer(reviewer);

                // Reviewee object
                User reviewee = new User();
                reviewee.setId(rs.getLong("reviewee_id"));
                review.setReviewee(reviewee);

                // Item object
                Item item = new Item();
                item.setId(rs.getLong("item_id"));
                item.setTitle(rs.getString("object_title"));
                review.setItem(item);

                reviews.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }
    public List<Reservation> getPendingReservationsWithMontantTotal(String email) {
        List<Reservation> reservations = new ArrayList<>();

        String sql = """
            SELECT 
                r.id AS reservation_id,
                r.start_date,
                r.end_date,
                r.created_at,
                r.status,
                r.delivery_option,
                l.id AS listing_id,
                i.id AS item_id,
                i.title AS item_title,
                c.id AS client_id,
                c.username AS client_username,
                c.avatar_url AS client_avatar,
                (ABS(DATEDIFF(r.end_date, r.start_date) + 1) * i.price_per_day
                + CASE WHEN r.delivery_option = 1 THEN 50 ELSE 0 END) AS montant_total,
                (ABS(DATEDIFF(r.end_date, r.start_date) + 1)) AS number_days
            FROM users u
            JOIN reservations r ON r.partner_id = u.id
            JOIN listings l ON l.id = r.listing_id
            JOIN items i ON i.id = l.item_id
            JOIN users c ON c.id = r.client_id
            WHERE u.email = ?
            AND r.status = 'pending'
            ORDER BY r.created_at DESC
            LIMIT 2
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation res = new Reservation();
                res.setId(rs.getLong("reservation_id"));
                res.setStartDate(rs.getDate("start_date"));
                res.setEndDate(rs.getDate("end_date"));
                res.setStatus(rs.getString("status"));
                res.setCreatedAt(rs.getDate("created_at"));

                // Client
                User client = new User();
                client.setId(rs.getLong("client_id"));
                client.setUsername(rs.getString("client_username"));
                client.setAvatarUrl(rs.getString("client_avatar"));
                res.setClient(client);

                // Partner
                User partner = new User();
                partner.setUsername(email);  // or fetch more fields if needed
                res.setPartner(partner);

                // Listing
                Listing listing = new Listing();
                Item item = new Item();
                item.setId(rs.getLong("item_id"));
                item.setTitle(rs.getString("item_title"));
                listing.setId(rs.getLong("listing_id"));
                listing.setItem(item);
                res.setListing(listing);

                reservations.add(res);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reservations;
    }

    
}
