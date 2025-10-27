package com.campshare.service;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.Reservation;
import com.campshare.model.Review;
import com.campshare.model.User;
import java.util.List;

import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;



public class ReservationService {

    private ReservationDAO reservationDAO = new ReservationDAOImpl();

    public int getTotalReservationsByEmail(String email) {
        return reservationDAO.getTotalReservationsByEmail(email);
    }

    public double getTotalDepenseByEmail(String email) {
        return reservationDAO.getTotalDepenseByEmail(email);
    }

    public double getNoteMoyenneByEmail(String email) {
        return reservationDAO.getNoteMoyenneByEmail(email);
    }

    public List<Reservation> getReservationDetailsByEmail(String email) {
        return reservationDAO.getReservationDetailsByEmail(email);
    }

    public List<Reservation> getAllReservationDetailsByEmail(String email) {
        return reservationDAO.getAllReservationDetailsByEmail(email);
    }

    public List<Reservation> getAllReservationDetailsByEmailAndStatus(String email, String status) {
        return reservationDAO.getAllReservationDetailsByEmailAndStatus(email, status);
    }

    public List<Reservation> getSimilarListingsByCategory(String email) {
        return reservationDAO.getSimilarListingsByCategory(email);
    }

    public List<Reservation> getAllSimilarListingsByCategory(String email) {
        return reservationDAO.getAllSimilarListingsByCategory(email);
    }
    public List<Review> getReviewsAboutMe(String email) {
        return reservationDAO.getReviewsAboutMe(email);
    }

    public User getClientProfile(String email) {
        return reservationDAO.getClientProfile(email);
    }

    private UserDAO userDAO = new UserDAOImpl();

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

    public boolean cancelReservation(int reservationId) {
        return reservationDAO.cancelReservation(reservationId);
    }

    public boolean updateUserProfile(String email, String firstName, String lastName, String username, String phoneNumber, String password, String avatarFileName) {
        return reservationDAO.updateUserProfile(email, firstName, lastName, username, phoneNumber, password, avatarFileName);
    }

    public List<Reservation> getConfirmedReservationsByListingId(long listingId) {
        return reservationDAO.getConfirmedReservationsByListingId(listingId);
    }

    public boolean store(Reservation reservation) {
        return reservationDAO.store(reservation);
    }
}

