package com.campshare.dao.interfaces;

import com.campshare.model.Reservation;
import com.campshare.model.Review;

import java.util.List;

public interface ReservationDAO {

    int getTotalReservationsByEmail(String email);
    double getTotalDepenseByEmail(String email);
    double getNoteMoyenneByEmail(String email);
    List<Reservation> getReservationDetailsByEmail(String email);
    List<Reservation> getAllReservationDetailsByEmail(String email);
    List<Reservation> getAllReservationDetailsByEmailAndStatus(String email, String status);
    List<Reservation> getSimilarListingsByCategory(String email);
    List<Reservation> getAllSimilarListingsByCategory(String email);
    List<Review> getReviewsAboutMe(String email);

    int countCompletedReservationsByPartnerId(long partnerId);
    int countActiveListeningByPartnerId(long partnerId);
    int countListeningByPartnerId(long partnerId);
    double sumPaymentThisMonth(long partnerId);
    List<Review> getLastAvisPartnerForObject(String email);
    List<Reservation> getPendingReservationsWithMontantTotal(String email);
    List<Reservation> getReservationsWithMontantTotal(String email);
}


