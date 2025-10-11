package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.model.Item;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ItemDAOImpl implements ItemDAO {

    @Override
    public List<Item> findAll() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getLong("id"));
                item.setPartnerId(rs.getLong("partner_id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setPricePerDay(rs.getDouble("price_per_day"));
                item.setCategoryId(rs.getLong("category_id"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles.", e);
        }
        return items;
    }

    @Override
    public Item findById(long id) {
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de l'article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de l'article.", e);
        }
        return null;
    }

    @Override
    public List<Item> findByPartnerId(long partnerId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE partner_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, partnerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles du partenaire: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles du partenaire.", e);
        }
        return items;
    }

    @Override
    public List<Item> findByCategoryId(long categoryId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE category_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles par catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles par catégorie.", e);
        }
        return items;
    }

    @Override
    public List<Item> findByPriceRange(double minPrice, double maxPrice) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE price_per_day BETWEEN ? AND ? ORDER BY price_per_day ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, minPrice);
            pstmt.setDouble(2, maxPrice);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles par prix: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles par prix.", e);
        }
        return items;
    }

    @Override
    public List<Item> searchByTitle(String searchTerm) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE title LIKE ? OR description LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche d'articles: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche d'articles.", e);
        }
        return items;
    }
}
