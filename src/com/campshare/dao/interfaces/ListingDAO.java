package com.campshare.dao.interfaces;

import com.campshare.model.Listing;
import java.sql.SQLException;
import java.util.List;

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
  List<Listing> getPartnerListings(String email);
  boolean deleteAnnonce(long id);
  boolean updateListing(long listingId, long cityId, String startDate, String endDate,
                                 String deliveryOption, Double latitude, Double longitude
                                );

  boolean insertAnnonce(Listing listing);
  


  boolean updateListingContent(long itemId, String title, String description, long categoryId);

  boolean updateListing(Listing listing);

  List<Listing> findAndPaginateListings(String searchQuery, String status, String sortBy, int limit, int offset);

  int countListings(String searchQuery, String status);

    void updateReservationStatus(long reservationId, String status) throws SQLException;

    


}