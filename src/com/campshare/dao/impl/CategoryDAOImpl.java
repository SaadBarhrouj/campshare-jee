package com.campshare.dao.impl;

import com.campshare.dao.interfaces.CategoryDAO;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {
  @Override
  public List<Category> findAll() {
    List<Category> categories = new ArrayList<>();
    String sql = "SELECT id, name FROM categories ORDER BY name ASC";
    try (Connection conn = DatabaseManager.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql)) {
      while (rs.next()) {
        Category cat = new Category();
        cat.setId(rs.getLong("id"));
        cat.setName(rs.getString("name"));
        categories.add(cat);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return categories;
  }
}