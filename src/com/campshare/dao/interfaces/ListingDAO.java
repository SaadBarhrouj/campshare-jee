package com.campshare.dao.interfaces;

import com.campshare.model.Listing;
import java.util.List;

public interface ListingDAO {
    List<Listing> findAll();
    Listing findById(long id);
    long countAll();
    List<Listing> findByCityId(long cityId);
    List<Listing> findByStatus(String status);
    List<Listing> findByItemId(long itemId);
    List<Listing> findActiveListings();
    List<Listing> findByCategoryId(long categoryId);
    List<Listing> findByPriceRange(double minPrice, double maxPrice);
    List<Listing> searchByTitle(String searchTerm);
    List<Listing> findByCityAndCategory(long cityId, long categoryId);
}