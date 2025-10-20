package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dto.ListingsPageStatsDTO;
import com.campshare.model.Listing;
import java.util.List;

public class ListingService {
  private ListingDAO listingDAO = new ListingDAOImpl();

  public List<Listing> getRecentListings(int limit) {
    return listingDAO.findRecent(limit);
  }

  public List<Listing> getAllListings() {
    return listingDAO.findAll();
  }

  public Listing getListingDetailsById(long listingId) {
    return listingDAO.findInfoById(listingId);
  }

  public boolean updateListingStatus(long listingId, String newStatus) {
    return listingDAO.updateStatus(listingId, newStatus);
  }

  public boolean deleteListing(long listingId) {
    return listingDAO.delete(listingId);
  }

  public ListingsPageStatsDTO getListingPageStats() {
    ListingsPageStatsDTO stats = new ListingsPageStatsDTO();

    long total = listingDAO.countAll();
    long active = listingDAO.countAllActive();
    long archived = listingDAO.countAllArchived();

    stats.setTotal(total);
    stats.setActive(active);
    stats.setArchived(archived);

    if (total > 0) {
      stats.setActivePercentage(((double) active / total) * 100.0);
      stats.setArchivedPercentage(((double) archived / total) * 100.0);
    } else {
      stats.setActivePercentage(0.0);
      stats.setArchivedPercentage(0.0);
    }

    return stats;
  }
}