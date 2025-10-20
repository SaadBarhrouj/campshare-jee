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
    
    return listings;
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
      e.printStackTrace();
    }
    return 0;
  }
}