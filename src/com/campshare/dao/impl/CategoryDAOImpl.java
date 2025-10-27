package com.campshare.dao.impl;
import com.campshare.dao.interfaces.CategoryDAO;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name FROM categories ORDER BY name ASC";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getLong("id"));
                c.setName(rs.getString("name"));
                categories.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des catégories", e);
        }
        return categories;
    }

    public Category findById(long id) {
        String sql = "SELECT id, name FROM categories WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getLong("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération de la catégorie par ID", e);
        }
        return null;
    }

    public Category findByName(String name) {
        String sql = "SELECT id, name FROM categories WHERE name = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getLong("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération de la catégorie par nom", e);
        }
        return null;
    }
}


