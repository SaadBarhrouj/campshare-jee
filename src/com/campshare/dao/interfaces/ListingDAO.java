package com.campshare.dao.interfaces;

import com.campshare.model.Listing;
import java.util.List;

public interface ListingDAO {

    List<Listing> findAll();
    Listing findById(long id);
    List<Listing> findByPartnerId(long partnerId);

    long countAll();

}