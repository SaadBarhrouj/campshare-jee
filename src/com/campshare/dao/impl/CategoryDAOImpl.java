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

    @Override
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name FROM categories ORDER BY name ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getLong("id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des catégories: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des catégories.", e);
        }
        return categories;
    }

    @Override
    public Category findById(long id) {
        String sql = "SELECT id, name FROM categories WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getLong("id"));
                    category.setName(rs.getString("name"));
                    return category;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de la catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de la catégorie.", e);
        }
        return null;
    }
}
