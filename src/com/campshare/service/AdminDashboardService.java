package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dto.AdminDashboardStatsDTO;

public class AdminDashboardService {

  private UserDAO userDAO = new UserDAOImpl();
  private ListingDAO listingDAO = new ListingDAOImpl();

  public AdminDashboardStatsDTO getDashboardStats() {
    AdminDashboardStatsDTO stats = new AdminDashboardStatsDTO();

    long clientCount = userDAO.countByRole("client");
    long partnerCount = userDAO.countByRole("partner");

    stats.setTotalClients(clientCount);
    stats.setTotalPartners(partnerCount);

    stats.setTotalUsers(clientCount + partnerCount);

    stats.setTotalListings(listingDAO.countAll());
    stats.setTotalReservations(40);

    return stats;

  }
}