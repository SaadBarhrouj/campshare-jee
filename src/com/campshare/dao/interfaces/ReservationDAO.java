package com.campshare.dao.interfaces;

import com.campshare.dto.DailyStatsDTO;
import java.util.List;

public interface ReservationDAO {
  List<DailyStatsDTO> getDailyBookingCountStats(int days);

  long countAllConfirmed();

  double getTotalRevenueAllTime();
}