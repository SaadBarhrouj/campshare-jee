package com.campshare.service;

import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.Reservation;
import com.campshare.model.Review;
import java.util.List;

public class ReservationService {
    
    private UserDAO userDAO = new UserDAOImpl();
    private ReservationDAO reservationDAO = new ReservationDAOImpl();

    public int getNumberCompletedReservation(long partnerId) {
        return reservationDAO.countCompletedReservationsByPartnerId(partnerId);
    }
    public int getNumberActiveListenings(long partnerId) {
        return reservationDAO.countActiveListeningByPartnerId(partnerId);
    }
    public int getNumberListenings(long partnerId) {
        return reservationDAO.countListeningByPartnerId(partnerId);
    }
    public double getSumPaymentThisMonth(long partnerId) {
        return reservationDAO.sumPaymentThisMonth(partnerId);
    }
    public List<Review> getLastAvisPartnerForObject(String email) {
        return reservationDAO.getLastAvisPartnerForObject(email);
    }
    public List<Reservation> getPendingReservationsWithMontantTotal(String email) {
        return reservationDAO.getPendingReservationsWithMontantTotal(email);
    }
    public List<Reservation> getReservationsWithMontantTotal(String email) {
        return reservationDAO.getReservationsWithMontantTotal(email);
    }


}
