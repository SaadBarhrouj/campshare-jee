package com.campshare.service;

import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.dto.ListingsPageStatsDTO;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import java.util.List;

public class ListingService {
  private ListingDAO listingDAO = new ListingDAOImpl();
  private ItemDAO itemDAO = new ItemDAOImpl();

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

  public boolean updateListingContent(long itemId, String title, String description, long categoryId) {
    return listingDAO.updateListingContent(itemId, title, description, categoryId);
  }

  public boolean updateListing(Listing listing, Item item) {

    boolean itemUpdated = itemDAO.updateItem(item);
    boolean listingUpdated = listingDAO.updateListing(listing);

    return itemUpdated && listingUpdated;
  }

  public List<Listing> getPaginatedListings(String searchQuery, String status, String sortBy, int limit, int offset) {
    return listingDAO.findAndPaginateListings(searchQuery, status, sortBy, limit, offset);
  }

  public int countTotalListings(String searchQuery, String status) {
    return listingDAO.countListings(searchQuery, status);
  }
}