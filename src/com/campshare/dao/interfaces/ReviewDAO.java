package com.campshare.dao.interfaces;

import com.campshare.model.Review;
import java.util.List;
import java.util.Map;

public interface ReviewDAO {
    
    List<Review> findByRevieweeId(long revieweeId);
    List<Review> findByItemId(long itemId);

    long countByItemId(long itemId);
    double getAverageRatingByItemId(long itemId);
    List<Review> getPartnerAvisRecu(String email);
    
    // Partner review methods
    long countByRevieweeId(long revieweeId);
    double getAverageRatingByRevieweeId(long revieweeId);
    Map<Integer, Integer> getRatingPercentagesByRevieweeId(long revieweeId);


    long countByRevieweeCId(long revieweeId);
    double getAverageRatingByRevieweeCId(long revieweeId);
    Map<Integer, Integer> getRatingPercentagesByRevieweeCId(long revieweeId);
    List<Review> findByRevieweeCId(long revieweeId);

    List<Review> findByReservationId(long reservationId);
    List<Review> findByReservationIdWithUser(long reservationId);

}
