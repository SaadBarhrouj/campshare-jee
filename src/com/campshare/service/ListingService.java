package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.model.Listing;
import java.util.List;

public class ListingService {
    private ListingDAO listingDAO = new ListingDAOImpl();

    public List<Listing> getAllListings() {
        return listingDAO.findAll();
    }

    public Listing getListingById(long id) {
        return listingDAO.findById(id);
    }

    public long getListingsCount() {
        return listingDAO.countAll();
    }

    public List<Listing> getListingsByCityId(long cityId) {
        return listingDAO.findByCityId(cityId);
    }

    public List<Listing> getListingsByStatus(String status) {
        return listingDAO.findByStatus(status);
    }

    public List<Listing> getListingsByItemId(long itemId) {
        return listingDAO.findByItemId(itemId);
    }

    public List<Listing> getActiveListings() {
        return listingDAO.findActiveListings();
    }

    public List<Listing> getListingsByCategoryId(long categoryId) {
        return listingDAO.findByCategoryId(categoryId);
    }

    public List<Listing> getListingsByPriceRange(double minPrice, double maxPrice) {
        return listingDAO.findByPriceRange(minPrice, maxPrice);
    }

    public List<Listing> searchListingsByTitle(String searchTerm) {
        return listingDAO.searchByTitle(searchTerm);
    }

    public List<Listing> getListingsByCityAndCategory(long cityId, long categoryId) {
        return listingDAO.findByCityAndCategory(cityId, categoryId);
    }
}