package com.campshare.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dto.AdminDashboardStatsDTO;
import com.campshare.dto.DailyRegistrationStatsDTO;
import com.campshare.dto.DailyStatsDTO;
import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.interfaces.ItemDAO;

public class AdminDashboardService {

  private UserDAO userDAO = new UserDAOImpl();
  private ListingDAO listingDAO = new ListingDAOImpl();
  private ReservationDAO reservationDAO = new ReservationDAOImpl();
  private ItemDAO itemDAO = new ItemDAOImpl();
  private static final double COMMISSION_RATE = 0.10;

  public AdminDashboardStatsDTO getDashboardStats() {
    AdminDashboardStatsDTO stats = new AdminDashboardStatsDTO();

    long clientCount = userDAO.countByRole("client");
    long partnerCount = userDAO.countByRole("partner");

    stats.setTotalClients(clientCount);
    stats.setTotalPartners(partnerCount);

    stats.setTotalUsers(clientCount + partnerCount);

    stats.setTotalListings(listingDAO.countAll());
    stats.setTotalReservations(reservationDAO.countAllConfirmed());
    double totalBookingValue = reservationDAO.getTotalRevenueAllTime();
    stats.setTotalRevenue(totalBookingValue * COMMISSION_RATE);
    return stats;
  }

  public Map<String, Object> getRegistrationChartData(int days) {
    List<DailyRegistrationStatsDTO> rawData = userDAO.getDailyRegistrationStats(days);

    List<String> labels = new ArrayList<>();
    List<Long> clientData = new ArrayList<>();
    List<Long> partnerData = new ArrayList<>();

    for (int i = 0; i < days; i++) {
      LocalDate date = LocalDate.now().minusDays(i);
      labels.add(0, date.format(DateTimeFormatter.ofPattern("MMM dd")));
      clientData.add(0, 0L);
      partnerData.add(0, 0L);
    }

    for (DailyRegistrationStatsDTO stat : rawData) {
      String label = stat.getDate().format(DateTimeFormatter.ofPattern("MMM dd"));
      int index = labels.indexOf(label);
      if (index != -1) {
        if ("client".equals(stat.getRole())) {
          clientData.set(index, (long) stat.getCount());
        } else if ("partner".equals(stat.getRole())) {
          partnerData.set(index, (long) stat.getCount());
        }
      }
    }

    Map<String, Object> clientDataset = new HashMap<>();
    clientDataset.put("label", "Clients");
    clientDataset.put("data", clientData);
    clientDataset.put("backgroundColor", "rgba(59, 130, 246, 0.8)");

    Map<String, Object> partnerDataset = new HashMap<>();
    partnerDataset.put("label", "Partenaires");
    partnerDataset.put("data", partnerData);
    partnerDataset.put("backgroundColor", "rgba(16, 185, 129, 0.8)");

    Map<String, Object> finalChartData = new HashMap<>();
    finalChartData.put("labels", labels);
    finalChartData.put("datasets", List.of(clientDataset, partnerDataset));

    return finalChartData;
  }

  public Map<String, Object> getBookingCountChartData(int days) {
    List<DailyStatsDTO> rawData = reservationDAO.getDailyBookingCountStats(days);

    List<String> labels = new ArrayList<>();
    List<Long> bookingData = new ArrayList<>();
    for (int i = 0; i < days; i++) {
      LocalDate date = LocalDate.now().minusDays(i);
      labels.add(0, date.format(DateTimeFormatter.ofPattern("MMM dd")));
      bookingData.add(0, 0L);
    }

    for (DailyStatsDTO stat : rawData) {
      String label = stat.getDate().format(DateTimeFormatter.ofPattern("MMM dd"));
      int index = labels.indexOf(label);
      if (index != -1) {
        bookingData.set(index, stat.getCount());
      }
    }

    Map<String, Object> bookingDataset = new HashMap<>();
    bookingDataset.put("label", "Nombre de Réservations");
    bookingDataset.put("data", bookingData);
    bookingDataset.put("backgroundColor", "rgba(75, 192, 192, 0.8)");
    bookingDataset.put("borderColor", "rgb(75, 192, 192)");
    bookingDataset.put("tension", 0.1);
    Map<String, Object> finalChartData = new HashMap<>();
    finalChartData.put("labels", labels);
    finalChartData.put("datasets", List.of(bookingDataset));

    return finalChartData;
  }

}