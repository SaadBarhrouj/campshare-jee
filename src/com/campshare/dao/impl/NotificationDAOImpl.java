package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Timestamp;
import java.sql.Types;

import com.campshare.util.DatabaseManager;
import com.campshare.dao.interfaces.NotificationDAO;
import com.campshare.model.Notification;

public class NotificationDAOImpl implements NotificationDAO {

    @Override
    public boolean notificationExists(long userId, long reservationId, String type) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND reservation_id = ? AND type = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            pstmt.setLong(2, reservationId);
            pstmt.setString(3, type);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL (notificationExists): " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean createNotification(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, reservation_id, type, message, is_read, listing_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, notification.getUserId());

            if (notification.getReservationId() != null) {
                pstmt.setLong(2, notification.getReservationId());
            } else {
                pstmt.setNull(2, Types.BIGINT);
            }
            pstmt.setString(3, notification.getType());
            pstmt.setString(4, notification.getMessage());
            pstmt.setBoolean(5, notification.isRead());

            if (notification.getListingId() != null) {
                pstmt.setLong(6, notification.getListingId());
            } else {
                pstmt.setNull(6, Types.BIGINT);
            }

            pstmt.setTimestamp(7, notification.getCreatedAt() != null ? notification.getCreatedAt()
                    : new Timestamp(System.currentTimeMillis()));

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("Notification déjà existante (contrainte unique) pour user " + notification.getUserId()
                    + ", resa " + notification.getReservationId() + ", type " + notification.getType());
            return false;
        } catch (SQLException e) {
            System.err.println("Erreur SQL (createNotification): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}