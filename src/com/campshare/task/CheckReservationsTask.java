package com.campshare.task;

import com.campshare.dao.impl.*;
import com.campshare.dao.interfaces.*;
import com.campshare.model.*;
import com.campshare.service.NotificationService;
import com.campshare.util.EmailUtil;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class CheckReservationsTask implements Runnable {

  private ReservationDAO reservationDAO = new ReservationDAOImpl();
  private UserDAO userDAO = new UserDAOImpl();
  private ListingDAO listingDAO = new ListingDAOImpl();
  private NotificationService notificationService = new NotificationService();

  private static final String BASE_URL = "http://localhost:8080/webapp";

  @Override
  public void run() {
    System.out.println("[TASK] Vérification des réservations terminées...");

    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -1);
    Date yesterday = cal.getTime();

    List<Reservation> reservations = reservationDAO.findReservationsEndedOn(yesterday);
    if (reservations.isEmpty())
      return;

    System.out.println("[TASK] Réservations à traiter : " + reservations.size());

    for (Reservation res : reservations) {
      try {
        User client = userDAO.findById(res.getClientId());
        Listing listing = listingDAO.findInfoById(res.getListingId());
        if (client == null || listing == null || listing.getItem() == null || listing.getItem().getPartner() == null)
          continue;

        User partner = listing.getItem().getPartner();
        Item item = listing.getItem();
        Timestamp now = new Timestamp(System.currentTimeMillis());

        // --- Notifications client ---
        Notification notifObject = new Notification();
        notifObject.setUserId(client.getId());
        notifObject.setType("review_object");
        notifObject.setMessage("Évaluer l’équipement.");
        notifObject.setRead(false);
        notifObject.setReservationId(res.getId());
        notifObject.setListingId(listing.getId());
        notifObject.setCreatedAt(now);
        notificationService.createReviewRequestNotification(notifObject);

        Notification notifPartner = new Notification();
        notifPartner.setUserId(client.getId());
        notifPartner.setType("review_partner");
        notifPartner.setMessage("Évaluer le partenaire.");
        notifPartner.setRead(false);
        notifPartner.setReservationId(res.getId());
        notifPartner.setListingId(listing.getId());
        notifPartner.setCreatedAt(now);
        notificationService.createReviewRequestNotification(notifPartner);

        // --- Notification partenaire ---
        Notification notifClient = new Notification();
        notifClient.setUserId(partner.getId());
        notifClient.setType("review_client");
        notifClient.setMessage("Évaluer le client.");
        notifClient.setRead(false);
        notifClient.setReservationId(res.getId());
        notifClient.setListingId(listing.getId());
        notifClient.setCreatedAt(now);
        notificationService.createReviewRequestNotification(notifClient);

        // --- Envoi emails ---
        String reviewObjectUrl = BASE_URL + "/review-form?resa=" + res.getId() + "&type=review_object";
        String reviewPartnerUrl = BASE_URL + "/review-form?resa=" + res.getId() + "&type=review_partner";
        String reviewClientUrl = BASE_URL + "/review-form?resa=" + res.getId() + "&type=review_client";

        System.out.println("[EMAIL] Envoi email client...");
        EmailUtil.sendEmail(
            client.getEmail(),
            "Évaluez votre expérience CampShare",
            EmailUtil.formatClientReviewRequestEmail(
                client.getFirstName(), res.getId(), item.getTitle(),
                partner.getFirstName(), reviewObjectUrl, reviewPartnerUrl));

        System.out.println("[EMAIL] Envoi email partenaire...");
        EmailUtil.sendEmail(
            partner.getEmail(),
            "Évaluez votre client CampShare",
            EmailUtil.formatPartnerReviewRequestEmail(
                partner.getFirstName(), res.getId(), item.getTitle(),
                client.getFirstName(), reviewClientUrl));

      } catch (Exception e) {
        System.err.println("[TASK] Erreur traitement Réservation ID " + res.getId() + ": " + e.getMessage());
      }
    }
    System.out.println("[TASK] Fin vérification des réservations.");
  }

  private static String escapeHtml(String input) {
    if (input == null)
      return "";
    return input.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
  }
}
