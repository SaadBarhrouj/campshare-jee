package com.campshare.service;

import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.model.Reservation;

import java.util.List;
import java.util.Map;

public class ReservationService {

  private ReservationDAO reservationDAO = new ReservationDAOImpl();

  public List<Reservation> getAllReservationsWithDetails() {
    return reservationDAO.findAllWithDetails();
  }

  public Map<String, Long> countReservationsByStatus() {
    return reservationDAO.countByStatus();
  }

  public Reservation findReservationById(long reservationId) {
    return reservationDAO.findById(reservationId);
  }

}