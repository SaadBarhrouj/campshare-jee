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
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getLong("id"));
                    image.setItemId(rs.getLong("item_id"));
                    image.setUrl(rs.getString("url"));
                    images.add(image);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des images pour l'item " + itemId, e);
        }
        return images;
    }

    @Override
    public Image findFirstByItemId(long itemId) {
        String sql = "SELECT id, item_id, url FROM images WHERE item_id = ? ORDER BY id ASC LIMIT 1";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getLong("id"));
                    image.setItemId(rs.getLong("item_id"));
                    image.setUrl(rs.getString("url"));
                    return image;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération de la première image pour l'item " + itemId, e);
        }
        return null;
    }
}
