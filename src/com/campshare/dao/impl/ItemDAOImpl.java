package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.model.Item;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAOImpl implements ItemDAO {
  @Override
  public List<Item> findAll() {
    List<Item> items = new ArrayList<>();
    String sql = "SELECT * FROM items ORDER BY created_at DESC";
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
      e.printStackTrace();
    }
    return items;
  }

  @Override
  public boolean updateItem(Item item) {
    String sql = "UPDATE items SET title = ?, description = ?, price_per_day = ?, category_id = ? WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setString(1, item.getTitle());
      pstmt.setString(2, item.getDescription());
      pstmt.setDouble(3, item.getPricePerDay());
      pstmt.setLong(4, item.getCategoryId());
      pstmt.setLong(5, item.getId()); // Le 'id' va dans la clause WHERE

      return pstmt.executeUpdate() > 0; // Retourne true si une ligne a été modifiée
    } catch (SQLException e) {
      System.err.println("Erreur lors de la mise à jour de l'item: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }
}