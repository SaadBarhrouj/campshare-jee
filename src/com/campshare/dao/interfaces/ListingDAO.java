package com.campshare.dao.interfaces;

import java.util.List;

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

}