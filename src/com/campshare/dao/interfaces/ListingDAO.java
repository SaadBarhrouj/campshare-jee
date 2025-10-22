package com.campshare.dao.interfaces;

import com.campshare.model.Listing;
import java.util.List;

public interface ListingDAO {
  List<Listing> findAll();

  long countAll();
  List<Listing> getPartnerListings(String email);
}