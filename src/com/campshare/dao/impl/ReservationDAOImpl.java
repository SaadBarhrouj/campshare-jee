package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Category;
import com.campshare.model.City;
import com.campshare.model.Image;
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
import com.campshare.dto.DailyStatsDTO;

public class ReservationDAOImpl implements ReservationDAO{

    @Override
    public int getTotalReservationsByEmail(String email) {
    String sql = """
        SELECT COUNT(r.id) AS total_reservations
        FROM users u
        LEFT JOIN reservations r ON u.id = r.client_id
        WHERE u.email = ?
        GROUP BY u.id, u.username
        LIMIT 1
    """;

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total_reservations");
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération du nombre de réservations : " + e.getMessage());
        }

        return 0; 
    }

        @Override
    public double getTotalDepenseByEmail(String email) {
        String sql = """
            SELECT COALESCE(SUM(ABS(DATEDIFF(r.end_date, r.start_date) + 1) * i.price_per_day), 0) AS total_depense
            FROM users u
            LEFT JOIN reservations r ON u.id = r.client_id
            LEFT JOIN listings l ON r.listing_id = l.id
            LEFT JOIN items i ON l.item_id = i.id
            WHERE u.email = ? AND r.status = 'completed'
        """;

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total_depense");
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors du calcul de la dépense totale : " + e.getMessage());
            throw new RuntimeException("Erreur lors du calcul de la dépense totale.", e);
        }

        return 0;
    }

        @Override
    public double getNoteMoyenneByEmail(String email) {
        String sql = """
            SELECT ROUND(AVG(r.rating), 2) AS note_moyenne
            FROM users u
            LEFT JOIN reviews r ON r.reviewee_id = u.id
            WHERE u.email = ? AND r.type = 'forClient'
        """;

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("note_moyenne");
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors du calcul de la note moyenne : " + e.getMessage());
            throw new RuntimeException("Erreur lors du calcul de la note moyenne.", e);
        }

        return 0;
    }

      public List<Reservation> getReservationDetailsByEmail(String email) {
        List<Reservation> reservations = new ArrayList<>();

        String sql = """
            SELECT 
                r.id AS reservation_id,
                l.id AS listing_id,
                p.id AS partner_id,
                p.username AS partner_username,
                p.avatar_url AS partner_img,
                ROUND(AVG(pr.rating), 1) AS partner_avg_rating,
                MIN(i.url) AS image_url,
                r.start_date,
                r.end_date,
                r.status,
                it.price_per_day,
                it.title AS listing_title,
                ABS((DATEDIFF(r.end_date, r.start_date) + 1) * it.price_per_day)
                    + CASE WHEN r.delivery_option = 1 THEN 50 ELSE 0 END AS montant_paye,
                it.description
            FROM users u
            JOIN reservations r ON u.id = r.client_id
            LEFT JOIN listings l ON r.listing_id = l.id
            LEFT JOIN items it ON l.item_id = it.id
            LEFT JOIN users p ON it.partner_id = p.id
            LEFT JOIN images i ON it.id = i.item_id
            LEFT JOIN reviews pr ON pr.reviewee_id = p.id AND pr.type = 'forPartner'
            WHERE u.email = ?
            GROUP BY l.id, it.price_per_day, r.id, p.username, p.id, p.avatar_url,
                    r.start_date, r.end_date, r.status, it.title, it.description, r.delivery_option
            ORDER BY r.created_at DESC
            LIMIT 2
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                Listing listing = new Listing();
                reservation.setId(rs.getInt("reservation_id"));
                listing.setId(rs.getInt("listing_id"));

                // Partner info
                User partner = new User();
                partner.setId(rs.getInt("partner_id"));
                partner.setUsername(rs.getString("partner_username"));
                partner.setAvatarUrl(rs.getString("partner_img"));
                partner.setAvgRating(rs.getDouble("partner_avg_rating"));
                reservation.setPartner(partner);

                // Item info
                Item item = new Item();
                item.setId(rs.getInt("listing_id"));
                item.setTitle(rs.getString("listing_title"));
                item.setDescription(rs.getString("description"));
                item.setPricePerDay(rs.getDouble("price_per_day"));
                Image image = new Image();
                image.setUrl(rs.getString("image_url"));

                List<Image> images = new ArrayList<>();
                images.add(image);

                
                item.setImages(images);
                listing.setItem(item);


                

                reservation.setStartDate(rs.getDate("start_date"));
                reservation.setEndDate(rs.getDate("end_date"));
                reservation.setStatus(rs.getString("status"));



                reservation.setListing(listing);

                reservations.add(reservation);
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des détails de réservation : " + e.getMessage());
        }

        return reservations;
    }

    public List<Reservation> getAllReservationDetailsByEmail(String email) {
        List<Reservation> reservations = new ArrayList<>();

        String sql = """
            SELECT 
                r.id AS reservation_id,
                l.id AS listing_id,
                p.id AS partner_id,
                p.username AS partner_username,
                p.avatar_url AS partner_img,
                ROUND(AVG(pr.rating), 1) AS partner_avg_rating,
                MIN(i.url) AS image_url,
                r.start_date,
                r.end_date,
                r.status,
                it.title AS listing_title,
                it.price_per_day,
                ABS((DATEDIFF(r.end_date, r.start_date) + 1) * it.price_per_day)
                    + CASE WHEN r.delivery_option = 1 THEN 50 ELSE 0 END AS montant_paye,
                it.description
            FROM users u
            JOIN reservations r ON u.id = r.client_id
            LEFT JOIN listings l ON r.listing_id = l.id
            LEFT JOIN items it ON l.item_id = it.id
            LEFT JOIN users p ON it.partner_id = p.id
            LEFT JOIN images i ON it.id = i.item_id
            LEFT JOIN reviews pr ON pr.reviewee_id = p.id AND pr.type = 'forPartner'
            WHERE u.email = ?
            GROUP BY l.id, it.price_per_day, r.id, p.username, p.id, p.avatar_url,
                    r.start_date, r.end_date, r.status, it.title, it.description, r.delivery_option
            ORDER BY r.created_at DESC
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("reservation_id"));

                //listing info
                Listing listing = new Listing();
                listing.setId(rs.getInt("listing_id"));

                // Partner info
                User partner = new User();
                partner.setId(rs.getInt("partner_id"));
                partner.setUsername(rs.getString("partner_username"));
                partner.setAvatarUrl(rs.getString("partner_img"));
                partner.setAvgRating(rs.getDouble("partner_avg_rating"));
                reservation.setPartner(partner);

                // Item info
                Item item = new Item();
                item.setId(rs.getInt("listing_id"));
                item.setTitle(rs.getString("listing_title"));
                item.setDescription(rs.getString("description"));
                item.setPricePerDay(rs.getDouble("price_per_day"));


  

                // Image
                Image image = new Image();
                image.setUrl(rs.getString("image_url"));
                List<Image> images = new ArrayList<>();
                images.add(image);
                item.setImages(images);

                reservation.setStartDate(rs.getDate("start_date"));
                reservation.setEndDate(rs.getDate("end_date"));
                reservation.setStatus(rs.getString("status"));

                listing.setItem(item);
                reservation.setListing(listing);


                reservations.add(reservation);
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de toutes les réservations : " + e.getMessage());
        }

        return reservations;
    }

    public List<Reservation> getAllReservationDetailsByEmailAndStatus(String email, String status) {
        List<Reservation> reservations = new ArrayList<>();

        String sql = """
            SELECT 
                r.id AS reservation_id,
                l.id AS listing_id,
                p.id AS partner_id,
                p.username AS partner_username,
                p.avatar_url AS partner_img,
                ROUND(AVG(pr.rating), 1) AS partner_avg_rating,
                MIN(i.url) AS image_url,
                r.start_date,
                r.end_date,
                r.status,
                it.title AS listing_title,
                ABS((DATEDIFF(r.end_date, r.start_date) + 1) * it.price_per_day)
                    + CASE WHEN r.delivery_option = 1 THEN 50 ELSE 0 END AS montant_paye,
                it.description
            FROM users u
            JOIN reservations r ON u.id = r.client_id
            LEFT JOIN listings l ON r.listing_id = l.id
            LEFT JOIN items it ON l.item_id = it.id
            LEFT JOIN users p ON it.partner_id = p.id
            LEFT JOIN images i ON it.id = i.item_id
            LEFT JOIN reviews pr ON pr.reviewee_id = p.id AND pr.type = 'forPartner'
            WHERE u.email = ? AND r.status = ?
            GROUP BY l.id, it.price_per_day, r.id, p.username, p.id, p.avatar_url,
                    r.start_date, r.end_date, r.status, it.title, it.description, r.delivery_option
            ORDER BY r.created_at DESC
        """;

        System.out.println("Filtering reservations for email: " + email + " with status: " + status);

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, status);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("reservation_id"));

                Listing listing = new Listing();
                listing.setId(rs.getInt("listing_id"));

                // Partner info
                User partner = new User();
                partner.setId(rs.getInt("partner_id"));
                partner.setUsername(rs.getString("partner_username"));
                partner.setAvatarUrl(rs.getString("partner_img"));
                reservation.setPartner(partner);

                // Item info
                Item item = new Item();
                item.setId(rs.getInt("listing_id"));
                item.setTitle(rs.getString("listing_title"));
                item.setDescription(rs.getString("description"));
                

                // Image
                Image image = new Image();
                image.setUrl(rs.getString("image_url"));
                List<Image> images = new ArrayList<>();
                images.add(image);
                item.setImages(images);

                reservation.setStartDate(rs.getDate("start_date"));
                reservation.setEndDate(rs.getDate("end_date"));
                String dbStatus = rs.getString("status");
                partner.setAvgRating(rs.getDouble("partner_avg_rating"));
                reservation.setStatus(dbStatus);
                
                // Debug: Print the actual status from database
                System.out.println("Found reservation with status: '" + dbStatus + "' for reservation ID: " + reservation.getId());

                



                listing.setItem(item);
                reservation.setListing(listing);

                reservations.add(reservation);
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des réservations filtrées : " + e.getMessage());
        }

        return reservations;
    }

    public List<Reservation> getSimilarListingsByCategory(String email) {
        List<Reservation> similarListings = new ArrayList<>();

        String sql = """
            SELECT 
                images.url AS image_url,
                items.price_per_day,
                c.name AS category_name,
                items.title AS listing_title,
                ci.name AS city_name,
                ls.start_date,
                ls.id AS lis_id,
                ls.end_date,
                ROUND(AVG(r.rating), 1) AS avg_rating,
                COUNT(r.id) AS review_count
            FROM listings ls
            JOIN items ON ls.item_id = items.id
            JOIN categories c ON items.category_id = c.id
            JOIN cities ci ON ls.city_id = ci.id
            LEFT JOIN (
                SELECT item_id, url 
                FROM images 
                WHERE id IN (
                    SELECT MIN(id) 
                    FROM images 
                    GROUP BY item_id
                )
            ) AS images ON items.id = images.item_id
            LEFT JOIN reviews r ON r.item_id = items.id AND r.type = 'forObject'
            WHERE ls.status = 'active'
            AND ls.id != (  -- Exclut le listing actuellement réservé
                SELECT r.listing_id 
                FROM reservations r 
                JOIN users u ON u.id = r.client_id 
                WHERE u.email = ? 
                LIMIT 1
            )
            GROUP BY ls.id, items.price_per_day, c.name, items.title, ci.name, ls.start_date, ls.end_date
            ORDER BY avg_rating DESC, ls.start_date ASC
            LIMIT 3
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation res = new Reservation();

                // Item info
                Item item = new Item();
                item.setTitle(rs.getString("listing_title"));
                item.setPricePerDay(rs.getDouble("price_per_day"));
                item.setDescription(""); 
                
                // optional
                Listing listing = new Listing();

            

                // Category
                Category category = new Category();
                category.setName(rs.getString("category_name"));
                item.setCategory(category);

                // City
                City city = new City();
                city.setName(rs.getString("city_name"));
                listing.setCity(city);

                // Listing info
                listing.setId(rs.getInt("lis_id"));
                listing.setStartDate(rs.getDate("start_date"));
                listing.setEndDate(rs.getDate("end_date"));
                res.setListing(listing);

                // Image
                Image image = new Image();
                image.setUrl(rs.getString("image_url"));
                List<Image> images = new ArrayList<>();
                images.add(image);

                // Ratings - Note: partner_id et partner_username ne sont plus dans le SELECT
                // Si vous en avez besoin, vous devrez les ajouter à la requête SQL
                User partner = new User();
                partner.setAvgRating(rs.getDouble("avg_rating"));
                partner.setReviewCount(rs.getInt("review_count"));
                res.setPartner(partner);
                item.setImages(images);
                listing.setItem(item);
                res.setListing(listing);

                similarListings.add(res);
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des listings similaires : " + e.getMessage());
        }

        return similarListings;
    }

     public List<Reservation> getAllSimilarListingsByCategory(String email) {
        List<Reservation> similarListings = new ArrayList<>();

        String sql = """
            SELECT 
                images.url AS image_url,
                items.price_per_day,
                c.name AS category_name,
                items.title AS listing_title,
                ci.name AS city_name,
                ls.start_date,
                ls.id AS lis_id,
                ls.end_date,
                ROUND(AVG(r.rating), 1) AS avg_rating,
                COUNT(r.id) AS review_count
            FROM listings ls
            JOIN items ON ls.item_id = items.id
            JOIN categories c ON items.category_id = c.id
            JOIN cities ci ON ls.city_id = ci.id
            LEFT JOIN (
                SELECT item_id, url 
                FROM images 
                WHERE id IN (
                    SELECT MIN(id) 
                    FROM images 
                    GROUP BY item_id
                )
            ) AS images ON items.id = images.item_id
            LEFT JOIN reviews r ON r.item_id = items.id AND r.type = 'forObject'
            WHERE ls.status = 'active'
            AND ls.id != (  -- Exclut le listing actuellement réservé
                SELECT r.listing_id 
                FROM reservations r 
                JOIN users u ON u.id = r.client_id 
                WHERE u.email = ? 
                LIMIT 1
            )
            GROUP BY ls.id, items.price_per_day, c.name, items.title, ci.name, ls.start_date, ls.end_date
            ORDER BY avg_rating DESC, ls.start_date ASC
            LIMIT 3
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Reservation res = new Reservation();

                // Item info
                Item item = new Item();
                item.setTitle(rs.getString("listing_title"));
                item.setPricePerDay(rs.getDouble("price_per_day"));
                item.setDescription(""); 
                
                Listing listing =new Listing();

                // Category
                Category category = new Category();
                category.setName(rs.getString("category_name"));

                // City
                City city = new City();
                city.setName(rs.getString("city_name"));

                // Listing info
                listing.setId(rs.getInt("lis_id"));
                listing.setStartDate(rs.getDate("start_date"));
                listing.setEndDate(rs.getDate("end_date"));
                res.setListing(listing);

                // Image
                Image image = new Image();
                image.setUrl(rs.getString("image_url"));
                List<Image> images = new ArrayList<>();
                images.add(image);

                
                User partner = new User();
                partner.setAvgRating(rs.getDouble("avg_rating"));
                partner.setReviewCount(rs.getInt("review_count"));
                res.setPartner(partner);
                item.setCategory(category);
                item.setImages(images);
                listing.setCity(city);
                listing.setItem(item);
                res.setListing(listing);

                similarListings.add(res);
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des listings similaires : " + e.getMessage());
        }

        return similarListings;
    }

    public List<Review> getReviewsAboutMe(String email) {
        List<Review> reviews = new ArrayList<>();

        String sql = """
            SELECT 
                rv.comment,
                rv.rating,
                rv.created_at,
                rv.type,
                reviewer.username AS reviewer_name,
                reviewer.id AS reviewer_id,
                reviewer.avatar_url AS reviewer_avatar,
                reviewee.username AS reviewee_name,
                CASE 
                    WHEN rv.type = 'forClient' THEN i.title 
                    ELSE NULL 
                END AS item_title,
                CASE 
                    WHEN rv.type = 'forClient' THEN img.image_url 
                    ELSE NULL 
                END AS item_image
            FROM users AS reviewee
            JOIN reviews AS rv ON reviewee.id = rv.reviewee_id
            JOIN reservations AS r ON rv.reservation_id = r.id
            JOIN users AS reviewer ON rv.reviewer_id = reviewer.id
            LEFT JOIN listings AS l ON r.listing_id = l.id
            LEFT JOIN items AS i ON l.item_id = i.id
            LEFT JOIN (
                SELECT item_id, MIN(url) AS image_url
                FROM images
                GROUP BY item_id
            ) AS img ON i.id = img.item_id
            WHERE reviewee.email = ?
            AND rv.type = 'forClient'
            ORDER BY rv.created_at DESC
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();

                    review.setComment(rs.getString("comment"));
                    review.setRating(rs.getInt("rating"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setType(rs.getString("type"));

                    // Reviewer info
                    User reviewer = new User();
                    reviewer.setId(rs.getLong("reviewer_id"));
                    reviewer.setUsername(rs.getString("reviewer_name"));
                    reviewer.setAvatarUrl(rs.getString("reviewer_avatar"));
                    review.setReviewer(reviewer);

                    // Reviewee info
                    User reviewee = new User();
                    reviewee.setUsername(rs.getString("reviewee_name"));
                    review.setReviewee(reviewee);

                    // Item info
                    Item item = new Item();
                    item.setTitle(rs.getString("item_title"));

                    // Image info
                    Image image = new Image();
                    image.setUrl(rs.getString("item_image"));
                    List<Image> images = new ArrayList<>();
                    images.add(image);
                    item.setImages(images);
                    review.setItem(item);



                    System.out.println("Loaded review: " + review.getComment() + " by " + reviewer.getUsername());

                    reviews.add(review);
                }
            }

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des avis sur l'utilisateur : " + e.getMessage());
        }

        return reviews;
    }

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

     public List<Reservation> getOngoingReservationsWithMontantTotal(String email) {
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
            AND r.status = 'ongoing'
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
    public List<Item> getPartnerEquipment(String email) throws SQLException {
        List<Item> items = new ArrayList<>();

        String sql = """
            SELECT 
                i.id,
                i.title,
                i.description,
                i.price_per_day,
                i.category_id,
                C.name AS category_name,
                GROUP_CONCAT(DISTINCT img.url) AS image_urls,
                AVG(R.rating) AS avg_rating,
                COUNT(DISTINCT R.id) AS review_count
            FROM users U
            JOIN items i ON i.partner_id = U.id
            JOIN categories C ON C.id = i.category_id
            LEFT JOIN images img ON img.item_id = i.id
            LEFT JOIN reviews R ON R.reviewee_id = i.id AND R.type = 'forObject' AND R.is_visible = TRUE
            WHERE U.email = ?
            GROUP BY i.id, i.title, i.description, i.price_per_day, i.category_id, C.name
        """;
        Connection connection = DatabaseManager.getConnection();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getInt("id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    Category category = new Category();
                    category.setId(rs.getInt("category_id"));
                    category.setName(rs.getString("category_name"));
                    item.setCategory(category);
                    

                    String urls = rs.getString("image_urls");
                    if (urls != null && !urls.isEmpty()) {
                        String[] urlArray = urls.split(",");
                        List<Image> images = new ArrayList<>();
                        for (String url : urlArray) {
                            Image image = new Image();
                            image.setUrl(url);
                            images.add(image);
                        }
                        item.setImages(images);
                    } else {
                        item.setImages(new ArrayList<>());
                    }

                    //item.setAvgRating(rs.getDouble("avg_rating"));
                    //item.setReviewCount(rs.getInt("review_count"));

                    items.add(item);
                }
            }
        }

        return items;
    }


    public List<Reservation> getReservationsWithMontantTotal(String email) {
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
                i.price_per_day AS itempricePerDay,
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
                item.setPricePerDay(rs.getDouble("itempricePerDay"));
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

    //profile client


    public User getClientProfile(String email) {
        User user = null;

        String sql = """
            SELECT 
                u.id,
                u.first_name,
                u.last_name,
                u.username,
                u.email,
                u.phone_number,
                u.password,
                u.address,
                u.avatar_url,
                u.is_subscriber,
                u.is_active,
                u.city_id,
                c.name AS city_name,
                AVG(r.rating) AS avg_rating,
                COUNT(r.id) AS review_count,
                u.created_at
            FROM users u
            LEFT JOIN reviews r 
                ON r.reviewee_id = u.id 
                AND r.type = 'forClient'
            JOIN cities c 
                ON c.id = u.city_id
            WHERE u.email = ?
            GROUP BY 
                u.id, u.first_name, u.last_name, u.username, u.email, 
                u.phone_number, u.password, u.address, u.avatar_url, 
                u.is_subscriber, u.is_active, u.city_id, c.name, u.created_at
            LIMIT 1
        """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getLong("id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setPassword(rs.getString("password"));
                user.setAddress(rs.getString("address"));
                user.setAvatarUrl(rs.getString("avatar_url"));
                user.setSubscriber(rs.getBoolean("is_subscriber"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCityId(rs.getLong("city_id"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setAvgRating(rs.getDouble("avg_rating"));
                user.setReviewCount(rs.getInt("review_count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }


    /////////////////////////////////////
    @Override
    public List<DailyStatsDTO> getDailyBookingCountStats(int days) {
        List<DailyStatsDTO> stats = new ArrayList<>();
        String sql = "SELECT DATE(created_at) AS reservation_date, COUNT(*) AS daily_count " +
            "FROM reservations " +
            "WHERE status = 'confirmed' AND created_at >= CURDATE() - INTERVAL ? DAY " +
            "GROUP BY reservation_date " +
            "ORDER BY reservation_date ASC";

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, days - 1);

        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
            DailyStatsDTO dto = new DailyStatsDTO();
            dto.setDate(rs.getDate("reservation_date").toLocalDate());
            dto.setCount(rs.getLong("daily_count"));
            stats.add(dto);
            }
        }
        } catch (SQLException e) {
        e.printStackTrace();
        }
        return stats;
    }

    @Override
    public long countAllConfirmed() {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'confirmed'";
        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()) {

        if (rs.next()) {
            return rs.getLong(1);
        }
        } catch (SQLException e) {
        e.printStackTrace();
        }
        return 0;
    }

    @Override
    public double getTotalRevenueAllTime() {
        String sql = "SELECT SUM(i.price_per_day * DATEDIFF(r.end_date, r.start_date)) " +
            "FROM reservations r " +
            "JOIN listings l ON r.listing_id = l.id " +
            "JOIN items i ON l.item_id = i.id " +
            "WHERE r.status = 'confirmed'";
        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()) {

        if (rs.next()) {
            return rs.getDouble(1);
        }
        } catch (SQLException e) {
        e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public boolean cancelReservation(int reservationId) {
        String sql = "UPDATE reservations SET status = 'canceled' WHERE id = ? AND status = 'pending'";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            int rowsAffected = stmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



   public boolean updateUserProfile(String email, String firstName, String lastName, String username,
                                 String phoneNumber, String password, String avatarFileName) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseManager.getConnection();

            // ✅ Keep old avatar if null/empty
            if (avatarFileName == null || avatarFileName.trim().isEmpty()) {
                String query = "SELECT avatar_url FROM users WHERE email = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    avatarFileName = rs.getString("avatar_url");
                }
                pstmt.close();
            }

            String sql;
            if (password != null && !password.trim().isEmpty()) {
                sql = "UPDATE users SET first_name=?, last_name=?, username=?, phone_number=?, avatar_url=?, password=? WHERE email=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, username);
                pstmt.setString(4, phoneNumber);
                pstmt.setString(5, avatarFileName);
                pstmt.setString(6, password); // hash later
                pstmt.setString(7, email);
            } else {
                sql = "UPDATE users SET first_name=?, last_name=?, username=?, phone_number=?, avatar_url=? WHERE email=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, username);
                pstmt.setString(4, phoneNumber);
                pstmt.setString(5, avatarFileName);
                pstmt.setString(6, email);
            }

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
    public List<Reservation> getLocationsEncours(String email)  {
    List<Reservation> locations = new ArrayList<>();

    String sql = "SELECT C.username, i.title, R.start_date, R.end_date, C.avatar_url, R.created_at, " +
                 "i.price_per_day, " +
                 "((DATEDIFF(R.end_date, R.start_date) + 1) * i.price_per_day + " +
                 "CASE WHEN R.delivery_option = 1 THEN 50 ELSE 0 END) AS montant_total, " +
                 "(DATEDIFF(R.end_date, R.start_date) + 1) AS number_days " +
                 "FROM users U " +
                 "JOIN reservations R ON R.partner_id = U.id " +
                 "JOIN listings L ON L.id = R.listing_id " +
                 "JOIN items i ON i.id = L.item_id " +
                 "JOIN users C ON C.id = R.client_id " +
                 "WHERE U.email = ? AND R.status = 'ongoing' " +
                 "LIMIT 5";

    try (Connection conn = DatabaseManager.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Reservation reservation = new Reservation();
            User client = new User();
            Item item = new Item();
            client.setUsername(rs.getString("username"));
            item.setTitle(rs.getString("title"));
            reservation.setStartDate(rs.getDate("start_date"));
            reservation.setEndDate(rs.getDate("end_date"));
            client.setAvatarUrl(rs.getString("avatar_url"));
            reservation.setCreatedAt(rs.getTimestamp("created_at"));
            item.setPricePerDay(rs.getDouble("price_per_day"));
            //loc.setMontantTotal(rs.getDouble("montant_total"));
            //loc.setNumberDays(rs.getInt("number_days"));
            reservation.setClient(client);
            Listing listing = new Listing();
            listing.setItem(item);
            reservation.setListing(listing);

            locations.add(reservation);
        }
    } catch (SQLException e) {
            e.printStackTrace();
    }

    return locations;
}


}
