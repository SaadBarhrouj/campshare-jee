package com.campshare.dao.interfaces;

import com.campshare.model.Reservation;
import com.campshare.model.Review;
import java.util.List;




public interface ReservationDAO {
    int countCompletedReservationsByPartnerId(long partnerId);
    int countActiveListeningByPartnerId(long partnerId);
    int countListeningByPartnerId(long partnerId);
    double sumPaymentThisMonth(long partnerId);
    List<Review> getLastAvisPartnerForObject(String email);
    List<Reservation> getPendingReservationsWithMontantTotal(String email);
    
}
