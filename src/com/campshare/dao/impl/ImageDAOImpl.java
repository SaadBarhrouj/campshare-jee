package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ImageDAO;
import com.campshare.model.Image;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImageDAOImpl implements ImageDAO {

    @Override
    public List<Image> findByItemId(long itemId) {
        List<Image> images = new ArrayList<>();
        String sql = "SELECT id, item_id, url FROM images WHERE item_id = ? ORDER BY id ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getLong("id"));
                    image.setItemId(rs.getLong("item_id"));
                    image.setUrl(rs.getString("url"));
                    images.add(image);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des images de l'article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des images de l'article.", e);
        }
        return images;
    }

    @Override
    public Image findFirstByItemId(long itemId) {
        String sql = "SELECT id, item_id, url FROM images WHERE item_id = ? ORDER BY id ASC LIMIT 1";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getLong("id"));
                    image.setItemId(rs.getLong("item_id"));
                    image.setUrl(rs.getString("url"));
                    return image;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de la première image: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de la première image.", e);
        }
        return null;
    }
}
