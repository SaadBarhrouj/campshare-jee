package com.campshare.service;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Reservation;
import com.campshare.model.Review;

import java.util.List;

import com.campshare.dao.impl.ReservationDAOImpl;



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

}

