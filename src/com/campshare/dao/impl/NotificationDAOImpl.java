package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

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

    @Override
    public List<Notification> findClientNotifications(long userId) {
        String sql = "SELECT id, user_id, type, message, is_read, listing_id, reservation_id, created_at " +
                "FROM notifications " +
                "WHERE user_id = ? AND type <> 'review_client' " +
                "ORDER BY created_at DESC";

        List<Notification> notifications = new ArrayList<>();

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getLong("id"));
                    n.setUserId(rs.getLong("user_id"));
                    n.setType(rs.getString("type"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));

                    long listingId = rs.getLong("listing_id");
                    if (rs.wasNull()) {
                        n.setListingId(null);
                    } else {
                        n.setListingId(listingId);
                    }

                    long reservationId = rs.getLong("reservation_id");
                    if (rs.wasNull()) {
                        n.setReservationId(null);
                    } else {
                        n.setReservationId(reservationId);
                    }

                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(n);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL (findClientNotifications): " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    @Override
    public List<Notification> findPartnerNotifications(long userId) {
        String sql = "SELECT id, user_id, type, message, is_read, listing_id, reservation_id, created_at " +
                "FROM notifications " +
                "WHERE user_id = ? AND type = 'review_client' " +
                "ORDER BY created_at DESC";

        List<Notification> notifications = new ArrayList<>();

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getLong("id"));
                    n.setUserId(rs.getLong("user_id"));
                    n.setType(rs.getString("type"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));

                    long listingId = rs.getLong("listing_id");
                    if (rs.wasNull()) {
                        n.setListingId(null);
                    } else {
                        n.setListingId(listingId);
                    }

                    long reservationId = rs.getLong("reservation_id");
                    if (rs.wasNull()) {
                        n.setReservationId(null);
                    } else {
                        n.setReservationId(reservationId);
                    }

                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(n);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL (findPartnerNotifications): " + e.getMessage());
            e.printStackTrace();
        }

        return notifications;
    }

    @Override
    public int getUnreadClientNotificationCount(long userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0 AND type <> 'review_client'";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL (getUnreadClientNotificationCount): " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int getUnreadPartnerNotificationCount(long userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0 AND type = 'review_client'";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL (getUnreadPartnerNotificationCount): " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean markAsRead(long userId, long notificationId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE id = ? AND user_id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, notificationId);
            pstmt.setLong(2, userId);
            int updated = pstmt.executeUpdate();
            return updated > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL (markAsRead): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int markAllAsRead(long userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur SQL (markAllAsRead): " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public boolean deleteById(long userId, long notificationId) {
        String sql = "DELETE FROM notifications WHERE id = ? AND user_id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, notificationId);
            pstmt.setLong(2, userId);
            int deleted = pstmt.executeUpdate();
            return deleted > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL (deleteById): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int deleteByIds(long userId, List<Long> notificationIds) {
        if (notificationIds == null || notificationIds.isEmpty()) {
            return 0;
        }

        StringBuilder sql = new StringBuilder("DELETE FROM notifications WHERE user_id = ? AND id IN (");
        for (int i = 0; i < notificationIds.size(); i++) {
            if (i > 0) {
                sql.append(",");
            }
            sql.append("?");
        }
        sql.append(")");

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            pstmt.setLong(1, userId);
            for (int i = 0; i < notificationIds.size(); i++) {
                pstmt.setLong(i + 2, notificationIds.get(i));
            }
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Erreur SQL (deleteByIds): " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }
}