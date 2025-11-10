package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dto.DailyStatsDTO;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.Reservation;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAOImpl implements ReservationDAO {

  @Override
  public List<Reservation> findAllWithDetails() {
    List<Reservation> reservations = new ArrayList<>();
    String sql = "SELECT " +
        "r.*, " +
        "c.id as client_id_alias, c.username as client_username, c.email as client_email, c.first_name as client_first_name, c.last_name as client_last_name, c.avatar_url as client_avatar_url, "
        +
        "p.id as partner_id_alias, p.username as partner_username, p.email as partner_email, p.first_name as partner_first_name, p.last_name as partner_last_name, p.avatar_url as partner_avatar_url, "
        +
        "l.id as listing_id_alias, " +
        "i.id as item_id, i.title as item_title, i.price_per_day as item_price, i.description as item_description " +
        "FROM reservations r " +
        "LEFT JOIN users c ON r.client_id = c.id " +
        "LEFT JOIN users p ON r.partner_id = p.id " +
        "LEFT JOIN listings l ON r.listing_id = l.id " +
        "LEFT JOIN items i ON l.item_id = i.id " +
        "ORDER BY r.created_at DESC";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      while (rs.next()) {
        Reservation r = mapResultSetToReservationWithDetails(rs);
        reservations.add(r);
      }
    } catch (SQLException e) {
      System.err.println("Erreur SQL critique dans findAllWithDetails: " + e.getMessage());
      e.printStackTrace();
    }
    return reservations;
  }

  private Reservation mapResultSetToReservationBasic(ResultSet rs) throws SQLException {
    Reservation reservation = new Reservation();
    reservation.setId(rs.getLong("id"));
    reservation.setListingId(rs.getLong("listing_id"));
    reservation.setClientId(rs.getLong("client_id"));
    reservation.setPartnerId(rs.getLong("partner_id"));
    reservation.setStartDate(rs.getTimestamp("start_date"));
    reservation.setEndDate(rs.getTimestamp("end_date"));
    reservation.setStatus(rs.getString("status"));
    reservation.setDeliveryOption(rs.getBoolean("delivery_option"));
    reservation.setCreatedAt(rs.getTimestamp("created_at"));

    return reservation;
  }

  private Reservation mapResultSetToReservationWithDetails(ResultSet rs) throws SQLException {
    Reservation reservation = mapResultSetToReservationBasic(rs);

    Item item = null;

    if (rs.getLong("client_id_alias") != 0) {
      User client = new User();
      client.setId(rs.getLong("client_id_alias"));
      client.setUsername(rs.getString("client_username"));
      client.setFirstName(rs.getString("client_first_name"));
      client.setLastName(rs.getString("client_last_name"));
      client.setAvatarUrl(rs.getString("client_avatar_url"));
      reservation.setClient(client);
    }

    if (rs.getLong("partner_id_alias") != 0) {
      User partner = new User();
      partner.setId(rs.getLong("partner_id_alias"));
      partner.setUsername(rs.getString("partner_username"));
      partner.setFirstName(rs.getString("partner_first_name"));
      partner.setLastName(rs.getString("partner_last_name"));
      partner.setAvatarUrl(rs.getString("partner_avatar_url"));
      reservation.setPartner(partner);
    }

    if (rs.getLong("listing_id_alias") != 0) {
      Listing listing = new Listing();
      listing.setId(rs.getLong("listing_id_alias"));

      if (rs.getLong("item_id") != 0) {
        item = new Item();
        item.setId(rs.getLong("item_id"));
        item.setTitle(rs.getString("item_title"));
        item.setPricePerDay(rs.getDouble("item_price"));
        item.setDescription(rs.getString("item_description"));
        listing.setItem(item);
      }
      reservation.setListing(listing);
    }

    if (reservation.getStartDate() != null && reservation.getEndDate() != null && item != null) {
      long numberOfDays = reservation.getDays();
      double pricePerDay = item.getPricePerDay();
      double total = numberOfDays * pricePerDay;
      reservation.setMontantTotal(total);
    } else {
      reservation.setMontantTotal(0.0);
    }

    return reservation;
  }

  private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
    try {
      rs.findColumn(columnName);
      return true;
    } catch (SQLException e) {
      return false;
    }
  }

  public List<DailyStatsDTO> getDailyBookingCountStats(int days) {
    List<DailyStatsDTO> stats = new ArrayList<>();
    String sql = "SELECT DATE(created_at) AS reservation_date, COUNT(*) AS daily_count " +
        "FROM reservations " +
        "WHERE status = 'confirmed' AND created_at >= CURDATE() - INTERVAL ? DAY " +
        "GROUP BY reservation_date " +
        "ORDER BY reservation_date ASC";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setInt(1, days - 1);

      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          DailyStatsDTO dto = new DailyStatsDTO();
          dto.setDate(rs.getDate("reservation_date").toLocalDate());
          dto.setCount(rs.getLong("daily_count"));
          stats.add(dto);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return stats;
  }

  @Override
  public long countAllConfirmed() {
    String sql = "SELECT COUNT(*) FROM reservations";
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
  public double getTotalRevenueAllTime() {
    String sql = "SELECT SUM(i.price_per_day * DATEDIFF(r.end_date, r.start_date)) " +
        "FROM reservations r " +
        "JOIN listings l ON r.listing_id = l.id " +
        "JOIN items i ON l.item_id = i.id " +
        "WHERE r.status = 'confirmed'";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      if (rs.next()) {
        return rs.getDouble(1);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  @Override
  public List<Reservation> findReservationsEndedOn(Date date) {
    List<Reservation> reservations = new ArrayList<>();
    String sql = "SELECT * FROM reservations WHERE end_date = ? AND status = 'completed'";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setDate(1, new java.sql.Date(date.getTime()));
      ResultSet rs = pstmt.executeQuery();

      while (rs.next()) {
        Reservation r = mapResultSetToReservation(rs);
        reservations.add(r);
      }
    } catch (SQLException e) {
      System.err.println("Erreur lors de la recherche des réservations terminées : " + e.getMessage());
      e.printStackTrace();
    }
    return reservations;
  }

  private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
    Reservation reservation = new Reservation();
    reservation.setId(rs.getLong("id"));
    reservation.setListingId(rs.getLong("listing_id"));
    reservation.setClientId(rs.getLong("client_id"));
    reservation.setStartDate(rs.getDate("start_date"));
    reservation.setEndDate(rs.getDate("end_date"));
    reservation.setStatus(rs.getString("status"));
    return reservation;
  }

  @Override
  public Map<String, Long> countByStatus() {
    Map<String, Long> counts = new HashMap<>();
    String sql = "SELECT status, COUNT(*) as count FROM reservations GROUP BY status";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      while (rs.next()) {
        counts.put(rs.getString("status"), rs.getLong("count"));
      }
    } catch (SQLException e) {
      System.err.println("Erreur SQL (countByStatus): " + e.getMessage());
      e.printStackTrace();
    }
    return counts;
  }

  @Override
  public Reservation findById(long reservationId) {
    Reservation reservation = null;
    String sql = "SELECT * FROM reservations WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, reservationId);
      try (ResultSet rs = pstmt.executeQuery()) {
        if (rs.next()) {
          reservation = mapResultSetToReservationBasic(rs);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return reservation;
  }
}