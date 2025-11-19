package com.campshare.dao.interfaces;

import java.util.List;

import com.campshare.model.Item;
import com.campshare.model.Listing;

public interface ListingDAO {

  long countAll();

  long countAllActive();

  long countAllArchived();

  List<Listing> findAll();

  List<Listing> findRecent(int limit);

  Listing findInfoById(long listingId);

  boolean updateStatus(long listingId, String newStatus);

  boolean delete(long listingId);

  boolean updateListingContent(long itemId, String title, String description, long categoryId);

  boolean updateListing(Listing listing);

  List<Listing> findAndPaginateListings(String searchQuery, String status, String sortBy, int limit, int offset);

  int countListings(String searchQuery, String status);

}