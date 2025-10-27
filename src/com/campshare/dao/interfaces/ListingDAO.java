package com.campshare.dao.interfaces;

import java.util.List;

import com.campshare.model.Listing;

public interface ListingDAO {

    List<Listing> findAll();
    Listing findById(long id);
    List<Listing> findByPartnerId(long partnerId);

    long countAll();


    List<Listing> findByCityId(long cityId);
    List<Listing> findByStatus(String status);
    List<Listing> findByItemId(long itemId);
    List<Listing> findActiveListings();
    List<Listing> findByCategoryId(long categoryId);
    List<Listing> findByPriceRange(double minPrice, double maxPrice);
    List<Listing> searchByTitle(String searchTerm);
    List<Listing> findByCityAndCategory(long cityId, long categoryId);


  long countAllActive();

  long countAllArchived();


  List<Listing> findRecent(int limit);

  Listing findInfoById(long listingId);

  boolean updateStatus(long listingId, String newStatus);

  boolean delete(long listingId);


}