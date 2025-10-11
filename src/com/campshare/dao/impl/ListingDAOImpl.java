package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.model.Listing;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingDAOImpl implements ListingDAO {

  public List<Listing> findAll() {
    List<Listing> listings = new ArrayList<>();

    String sql = "SELECT id, item_id, status, start_date, end_date, city_id, delivery_option, created_at FROM listings ORDER BY created_at DESC";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      while (rs.next()) {
        Listing listing = new Listing();

        listing.setId(rs.getLong("id"));
        listing.setItemId(rs.getLong("item_id"));
        listing.setStatus(rs.getString("status"));
        listing.setStartDate(rs.getDate("start_date").toLocalDate());
        listing.setEndDate(rs.getDate("end_date").toLocalDate());
        listing.setCityId(rs.getLong("city_id"));
        listing.setDeliveryOption(rs.getBoolean("delivery_option"));
        listing.setCreatedAt(rs.getTimestamp("created_at"));

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

  @Override
  public long countAllActive() {
    String sql = "SELECT COUNT(*) FROM listings WHERE status = 'active' AND end_date >= CURDATE()";
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