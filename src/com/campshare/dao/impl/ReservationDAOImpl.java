package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dto.DailyStatsDTO;
import com.campshare.model.Reservation;
import com.campshare.util.DatabaseManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ReservationDAOImpl implements ReservationDAO {

  @Override
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
    String sql = "SELECT COUNT(*) FROM reservations WHERE status = 'confirmed'";
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
}