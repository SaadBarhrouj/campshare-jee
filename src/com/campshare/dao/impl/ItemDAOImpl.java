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
}