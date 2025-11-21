package com.campshare.task;

import com.campshare.dao.impl.*;
import com.campshare.dao.interfaces.*;
import com.campshare.model.*;
import com.campshare.service.NotificationService;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class CheckReservationsTask implements Runnable {

    private ReservationDAO reservationDAO = new ReservationDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();
    private ListingDAO listingDAO = new ListingDAOImpl();
    private NotificationService notificationService = new NotificationService();

    @Override
    public void run() {
        System.out.println("[TASK] Lancement de la tache planifiee...");

        System.out.println("[TASK] 1. Recherche des reservations expirees a cloturer...");
        List<Reservation> expiredReservations = reservationDAO.findReservationsWithPassedEndDate("confirmed");        
        if (!expiredReservations.isEmpty()) {
            System.out.println("[TASK] -> " + expiredReservations.size() + " reservations trouvees a passer en 'completed'.");
            for (Reservation res : expiredReservations) {
                boolean updated = reservationDAO.updateStatus(res.getId(), "completed");
                if (updated) {
                    System.out.println("[TASK] Reservation #" + res.getId() + " cloturee avec succes.");
                } else {
                    System.err.println("[TASK] Echec cloture Reservation #" + res.getId());
                }
            }
        } else {
            System.out.println("[TASK] -> Aucune reservation a cloturer.");
        }

        System.out.println("[TASK] 2. Verification pour envoi des demandes d'avis...");
        
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        Date yesterday = cal.getTime();

        List<Reservation> reservationsEndedYesterday = reservationDAO.findReservationsEndedOn(yesterday);
        
        if (reservationsEndedYesterday.isEmpty()) {
            System.out.println("[TASK] -> Aucune reservation terminee hier. Fin de la tache.");
            return;
        }

        System.out.println("[TASK] -> " + reservationsEndedYesterday.size() + " reservations necessitent des avis.");

        for (Reservation res : reservationsEndedYesterday) {
            try {
                User client = userDAO.findById(res.getClientId());
                Listing listing = listingDAO.findInfoById(res.getListingId());
                
                if (client == null || listing == null || listing.getItem() == null || listing.getItem().getPartner() == null) {
                    continue;
                }

                User partner = listing.getItem().getPartner();
                Timestamp now = new Timestamp(System.currentTimeMillis());

                createNotif(client.getId(), "review_object", "\u00C9valuer l\u2019\u00E9quipement lou\u00E9.", res.getId(), listing.getId(), now);
                createNotif(client.getId(), "review_partner", "\u00C9valuer le partenaire " + partner.getFirstName(), res.getId(), listing.getId(), now);

                createNotif(partner.getId(), "review_client", "\u00C9valuer le client " + client.getFirstName(), res.getId(), listing.getId(), now);

                System.out.println("[TASK] Notifications creees pour Reservation #" + res.getId());

            } catch (Exception e) {
                System.err.println("[TASK] Erreur traitement Reservation ID " + res.getId() + ": " + e.getMessage());
            }
        }
        System.out.println("[TASK] Cycle de maintenance termine.");
    }

    private void createNotif(long userId, String type, String message, long resId, long listId, Timestamp now) {
        Notification notif = new Notification();
        notif.setUserId(userId);
        notif.setType(type);
        notif.setMessage(message);
        notif.setRead(false);
        notif.setReservationId(resId);
        notif.setListingId(listId);
        notif.setCreatedAt(now);
        notificationService.createReviewRequestNotification(notif);
    }
}