package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.model.Listing;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingDAOImpl implements ListingDAO {
    
    @Override
    public List<Listing> findAll() {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Listing listing = new Listing();
                listing.setId(rs.getLong("id"));
                listing.setItemId(rs.getLong("item_id"));
                listing.setStatus(rs.getString("status"));
                listing.setStartDate(rs.getDate("start_date"));
                listing.setEndDate(rs.getDate("end_date"));
                listing.setCityId(rs.getLong("city_id"));
                listing.setLongitude(rs.getDouble("longitude"));
                listing.setLatitude(rs.getDouble("latitude"));
                listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                listing.setCreatedAt(rs.getTimestamp("created_at"));
                listings.add(listing);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces.", e);
        }
        return listings;
    }

    @Override
    public Listing findById(long id) {
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    return listing;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de l'annonce: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de l'annonce.", e);
        }
        return null;
    }

    @Override
    public long countAll() {
        String sql = "SELECT COUNT(*) FROM listings";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors du comptage des annonces: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors du comptage des annonces.", e);
        }
        return 0;
    }

    @Override
    public List<Listing> findByCityId(long cityId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE city_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, cityId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par ville: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par ville.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByStatus(String status) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par statut: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par statut.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByItemId(long itemId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE item_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par article.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findActiveListings() {
        return findByStatus("active");
    }

    @Override
    public List<Listing> findByCategoryId(long categoryId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.category_id = ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par catégorie.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByPriceRange(double minPrice, double maxPrice) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.price_per_day BETWEEN ? AND ? ORDER BY i.price_per_day ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, minPrice);
            pstmt.setDouble(2, maxPrice);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par prix: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par prix.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> searchByTitle(String searchTerm) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.title LIKE ? OR i.description LIKE ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche d'annonces: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche d'annonces.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByCityAndCategory(long cityId, long categoryId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE l.city_id = ? AND i.category_id = ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, cityId);
            pstmt.setLong(2, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par ville et catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par ville et catégorie.", e);
        }
        return listings;
    }
}