package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dto.ListingInfoDTO;
import java.util.List;

public class ListingService {
  private ListingDAO listingDAO = new ListingDAOImpl();

  public List<ListingInfoDTO> getRecentListingsWithDetails(int limit) {
    return listingDAO.findRecentWithDetails(limit);
  }

  public List<ListingInfoDTO> getAllListingsWithDetails() {
    return listingDAO.findAllWithDetails();
  }

  public ListingInfoDTO getListingDetailsById(long listingId) {
    return listingDAO.findInfoById(listingId);
  }

  public boolean updateListingStatus(long listingId, String newStatus) {
    return listingDAO.updateStatus(listingId, newStatus);
  }

  public boolean deleteListing(long listingId) {
    return listingDAO.delete(listingId);
  }
}