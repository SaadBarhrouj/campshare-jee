package com.campshare.dao.interfaces;

import com.campshare.model.Reservation;
import com.campshare.model.Review;
import com.campshare.model.User;
import java.util.List;
import com.campshare.dto.DailyStatsDTO;

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
    double getAverageRatingForPartner(long partnerId);
    double getTotalRevenueByPartner(long partnerId);
    List<Review> getLastAvisPartnerForObject(String email);
    List<Reservation> getPendingReservationsWithMontantTotal(String email);
    List<Reservation> getReservationsWithMontantTotal(String email);
    User getClientProfile(String email);
    User getPartnerProfile(String email);
    boolean cancelReservation(int reservationId);


    List<DailyStatsDTO> getDailyBookingCountStats(int days);
    long countAllConfirmed();
    double getTotalRevenueAllTime();
    boolean updateUserProfile(String email, String firstName, String lastName, String username, String phoneNumber, String password, String avatarFileName) ;


    List<Reservation> getLocationsEncours(String email);


}

