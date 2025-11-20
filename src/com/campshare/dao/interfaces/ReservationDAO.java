package com.campshare.dao.interfaces;

import com.campshare.dto.DailyStatsDTO;
import com.campshare.model.Reservation;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ReservationDAO {
  List<DailyStatsDTO> getDailyBookingCountStats(int days);

  long countAllConfirmed();

  double getTotalRevenueAllTime();

  List<Reservation> findReservationsEndedOn(Date date);

  List<Reservation> findAllWithDetails();

  Map<String, Long> countByStatus();

  Reservation findById(long id);

  List<Reservation> findAndFilter(String searchQuery, String status, String sortBy, int limit, int offset);

  int countFiltered(String searchQuery, String status);

  List<Reservation> findReservationsWithPassedEndDate(String status);

  boolean updateStatus(long reservationId, String newStatus);
  List<Reservation> findExpiredConfirmedReservations();
}