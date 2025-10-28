package com.campshare.dao.interfaces;

import com.campshare.model.Notification;


public interface NotificationDAO {
  boolean notificationExists(long userId, long reservationId, String type);

  boolean createNotification(Notification notification);
  
}
