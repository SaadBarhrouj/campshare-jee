package com.campshare.service;

import java.util.List;
import java.util.Map;

import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Reservation;

public class ReservationService {

    private final ReservationDAO reservationDAO;

    public ReservationService() {
        this.reservationDAO = new ReservationDAOImpl();
    }

    public List<Reservation> getAllReservationsWithDetails() {
        return reservationDAO.findAllWithDetails();
    }

    public Map<String, Long> countReservationsByStatus() {
        return reservationDAO.countByStatus();
    }

    public List<Reservation> getFilteredAndPaginatedReservations(String searchQuery, String status, String sortBy,
            int pageSize, int offset) {
        return reservationDAO.findAndFilter(searchQuery, status, sortBy, pageSize, offset);
    }

    public int countFilteredReservations(String searchQuery, String status) {
        return reservationDAO.countFiltered(searchQuery, status);
    }

    public Reservation findReservationById(long reservationId) {
        return reservationDAO.findById(reservationId);
    }
}
