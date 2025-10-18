package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
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
}