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
    String sql = "SELECT id, title, description, price, image_url FROM listings ORDER BY created_at DESC";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      while (rs.next()) {
        Listing listing = new Listing();
        listing.setId(rs.getLong("id"));
        listing.setTitle(rs.getString("title"));
        listing.setDescription(rs.getString("description"));
        listing.setPrice(rs.getDouble("price"));
        listing.setImageUrl(rs.getString("image_url"));
        listings.add(listing);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
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