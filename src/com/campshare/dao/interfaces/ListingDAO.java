package com.campshare.dao.interfaces;

import com.campshare.dto.ListingInfoDTO;
import java.util.List;

public interface ListingDAO {

  long countAll();

  long countAllActive();

  List<ListingInfoDTO> findAllWithDetails();

  List<ListingInfoDTO> findRecentWithDetails(int limit);

  ListingInfoDTO findInfoById(long listingId);

  boolean updateStatus(long listingId, String newStatus);

  boolean delete(long listingId);

}