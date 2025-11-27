package com.campshare.service;

import com.campshare.dao.interfaces.NotificationDAO;
import com.campshare.dao.impl.NotificationDAOImpl;
import com.campshare.model.Notification;

import java.util.ArrayList;
import java.util.List;

public class NotificationService {

  private NotificationDAO notificationDAO = new NotificationDAOImpl();

  public boolean createReviewRequestNotification(Notification notification) {
    try {
      System.out.println("[Service] Vérification notif existante pour User ID: " + notification.getUserId()
          + ", Resa ID: " + notification.getReservationId() + ", Type: " + notification.getType());

      if (notification.getUserId() == 0 || notification.getReservationId() == null || notification.getType() == null) {
        System.err.println("[Service] Données manquantes pour vérifier/créer la notification.");
        return false;
      }

      boolean exists = notificationDAO.notificationExists(
          notification.getUserId(),
          notification.getReservationId(),
          notification.getType());

      if (exists) {
        System.out.println("[Service] Notification déjà existante.");
        return true;
      } else {
        System.out.println("[Service] Notification non trouvée, tentative de création...");
        boolean created = notificationDAO.createNotification(notification);
        System.out.println("[Service] Résultat création notification: " + created);
        return created;
      }
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la création/vérification de la notification: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  /**
   * Get all notifications for the client space (all types except 'review_client').
   */
  public List<Notification> getClientNotifications(long userId) {
    try {
      return notificationDAO.findClientNotifications(userId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la récupération des notifications client: " + e.getMessage());
      e.printStackTrace();
      return new ArrayList<>();
    }
  }

  /**
   * Get all notifications for the partner space (only 'review_client' type).
   */
  public List<Notification> getPartnerNotifications(long userId) {
    try {
      return notificationDAO.findPartnerNotifications(userId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la récupération des notifications partenaire: " + e.getMessage());
      e.printStackTrace();
      return new ArrayList<>();
    }
  }

  /**
   * Get count of unread client notifications (all types except 'review_client').
   */
  public int getUnreadClientNotificationCount(long userId) {
    try {
      return notificationDAO.getUnreadClientNotificationCount(userId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la récupération du nombre de notifications client non lues: " + e.getMessage());
      e.printStackTrace();
      return 0;
    }
  }

  /**
   * Get count of unread partner notifications (only 'review_client' type).
   */
  public int getUnreadPartnerNotificationCount(long userId) {
    try {
      return notificationDAO.getUnreadPartnerNotificationCount(userId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la récupération du nombre de notifications partenaire non lues: " + e.getMessage());
      e.printStackTrace();
      return 0;
    }
  }

  public boolean markNotificationAsRead(long userId, long notificationId) {
    try {
      return notificationDAO.markAsRead(userId, notificationId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors du marquage comme lu de la notification: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  public int markAllNotificationsAsRead(long userId) {
    try {
      return notificationDAO.markAllAsRead(userId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors du marquage comme lu de toutes les notifications: " + e.getMessage());
      e.printStackTrace();
      return 0;
    }
  }

  public boolean deleteNotification(long userId, long notificationId) {
    try {
      return notificationDAO.deleteById(userId, notificationId);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la suppression de la notification: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  public int deleteNotifications(long userId, List<Long> notificationIds) {
    try {
      return notificationDAO.deleteByIds(userId, notificationIds);
    } catch (Exception e) {
      System.err.println("[Service] Erreur lors de la suppression des notifications: " + e.getMessage());
      e.printStackTrace();
      return 0;
    }
  }
}