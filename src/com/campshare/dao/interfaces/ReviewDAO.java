package com.campshare.dao.interfaces;

import com.campshare.model.Review;
import java.util.List;

public interface ReviewDAO {
    
    List<Review> findByRevieweeId(long revieweeId);
    List<Review> findByItemId(long itemId);

    long countByItemId(long itemId);
    double getAverageRatingByItemId(long itemId);
    List<Review> getPartnerAvisRecu(String email) ;

    

    
}
