package com.campshare.dao.interfaces;

import com.campshare.model.Notification;

import java.util.List;

public interface NotificationDAO {

    boolean notificationExists(long userId, long reservationId, String type);

    boolean createNotification(Notification notification);

    /**
     * Get all notifications for a client space (all types except 'review_client').
     */
    List<Notification> findClientNotifications(long userId);

    boolean markAsRead(long userId, long notificationId);

    int markAllAsRead(long userId);

    boolean deleteById(long userId, long notificationId);

    int deleteByIds(long userId, List<Long> notificationIds);
}
