package com.campshare.service;

import com.campshare.dao.interfaces.NotificationDAO;
import com.campshare.dao.impl.NotificationDAOImpl;
import com.campshare.model.Notification;

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

}