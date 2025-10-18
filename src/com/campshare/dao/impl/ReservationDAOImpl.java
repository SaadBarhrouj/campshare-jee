package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Listing;
import com.campshare.model.Reservation;
import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;
import com.campshare.model.City;
import com.campshare.model.Image;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

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



}
