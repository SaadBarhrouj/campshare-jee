package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dto.ListingInfoDTO;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingDAOImpl implements ListingDAO {

  private final String BASE_SELECT_SQL = "SELECT " +
      "l.id as listing_id, l.status, l.start_date, l.end_date, l.created_at as listing_created_at, " +
      "i.id as item_id, i.title, i.description, i.price_per_day, " +
      "u.id as partner_id, u.username, u.first_name, u.last_name, u.avatar_url as partner_avatar " +
      "FROM listings l " +
      "JOIN items i ON l.item_id = i.id " +
      "JOIN users u ON i.partner_id = u.id ";

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

  @Override
  public List<ListingInfoDTO> findAllWithDetails() {
    List<ListingInfoDTO> listings = new ArrayList<>();
    String sql = BASE_SELECT_SQL + "ORDER BY l.created_at DESC";

    try (Connection conn = DatabaseManager.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql)) {

      while (rs.next()) {
        listings.add(mapResultSetToListingInfo(rs));
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return listings;
  }

  @Override
  public List<ListingInfoDTO> findRecentWithDetails(int limit) {
    List<ListingInfoDTO> listings = new ArrayList<>();
    String sql = BASE_SELECT_SQL + "ORDER BY l.created_at DESC LIMIT ?";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setInt(1, limit);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          listings.add(mapResultSetToListingInfo(rs));
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return listings;
  }

  @Override
  public boolean updateStatus(long listingId, String newStatus) {
    String sql = "UPDATE listings SET status = ? WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setString(1, newStatus);
      pstmt.setLong(2, listingId);
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }

  private ListingInfoDTO mapResultSetToListingInfo(ResultSet rs) throws SQLException {

    try {
      User partner = new User();
      partner.setId(rs.getLong("partner_id"));
      partner.setUsername(rs.getString("username"));
      partner.setFirstName(rs.getString("first_name"));
      partner.setLastName(rs.getString("last_name"));
      partner.setAvatarUrl(rs.getString("partner_avatar"));

      Item item = new Item();
      item.setId(rs.getLong("item_id"));
      item.setTitle(rs.getString("title"));
      item.setDescription(rs.getString("description"));
      item.setPricePerDay(rs.getDouble("price_per_day"));

      Listing listing = new Listing();
      listing.setId(rs.getLong("listing_id"));
      listing.setStatus(rs.getString("status"));
      listing.setCreatedAt(rs.getTimestamp("listing_created_at"));

      Date startDateSql = rs.getDate("start_date");
      if (startDateSql != null) {
        listing.setStartDate(startDateSql.toLocalDate());
      }

      Date endDateSql = rs.getDate("end_date");
      if (endDateSql != null) {
        listing.setEndDate(endDateSql.toLocalDate());
      }

      ListingInfoDTO dto = new ListingInfoDTO();
      dto.setListing(listing);
      dto.setItem(item);
      dto.setPartner(partner);

      return dto;

    } catch (Exception e) {
      System.out.println("!!!!!!!!!!!!!! ERREUR DANS mapResultSetToListingInfo !!!!!!!!!!!!!!");
      e.printStackTrace();
      throw e;
    }
  }

  @Override
  public ListingInfoDTO findInfoById(long listingId) {
    String sql = BASE_SELECT_SQL + "WHERE l.id = ?";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setLong(1, listingId);

      try (ResultSet rs = pstmt.executeQuery()) {
        if (rs.next()) {
          return mapResultSetToListingInfo(rs);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;
  }

  @Override
  public boolean delete(long listingId) {
    String sql = "DELETE FROM listings WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, listingId);
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      e.printStackTrace();
      return false;
    }
  }
}