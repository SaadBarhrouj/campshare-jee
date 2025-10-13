package com.campshare.dao.interfaces;

import com.campshare.model.Review;
import java.util.List;

public interface ReviewDAO {
    List<Review> findAll();
    Review findById(long id);
    List<Review> findByItemId(long itemId);
    List<Review> findByItemIdAndType(long itemId, String type);
    List<Review> findByReviewerId(long reviewerId);
    List<Review> findByRevieweeId(long revieweeId);
    List<Review> findByReservationId(long reservationId);
    List<Review> findVisibleReviews();
    List<Review> findVisibleReviewsByItemId(long itemId);
    double getAverageRatingByItemId(long itemId);
    long getReviewCountByItemId(long itemId);
    boolean create(Review review);
    boolean update(Review review);
    boolean delete(long id);
}
