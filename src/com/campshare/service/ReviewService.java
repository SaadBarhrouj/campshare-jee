package com.campshare.service;

import com.campshare.dao.impl.ReviewDAOImpl;
import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ReviewService {
    private ReviewDAO reviewDAO = new ReviewDAOImpl();

    public List<Review> getAllReviews() {
        return reviewDAO.findAll();
    }

    public Review getReviewById(long id) {
        return reviewDAO.findById(id);
    }

    public List<Review> getReviewsByItemId(long itemId) {
        return reviewDAO.findByItemId(itemId);
    }

    public List<Review> getVisibleReviewsByItemId(long itemId) {
        return reviewDAO.findVisibleReviewsByItemId(itemId);
    }

    public List<Review> getReviewsByItemIdAndType(long itemId, String type) {
        return reviewDAO.findByItemIdAndType(itemId, type);
    }

    public List<Review> getReviewsByReviewerId(long reviewerId) {
        return reviewDAO.findByReviewerId(reviewerId);
    }

    public List<Review> getReviewsByRevieweeId(long revieweeId) {
        return reviewDAO.findByRevieweeId(revieweeId);
    }

    public List<Review> getReviewsByReservationId(long reservationId) {
        return reviewDAO.findByReservationId(reservationId);
    }

    public List<Review> getVisibleReviews() {
        return reviewDAO.findVisibleReviews();
    }

    public double getAverageRatingByItemId(long itemId) {
        return reviewDAO.getAverageRatingByItemId(itemId);
    }

    public long getReviewCountByItemId(long itemId) {
        return reviewDAO.getReviewCountByItemId(itemId);
    }

    public Map<Integer, Double> getRatingPercentagesByItemId(long itemId) {
        List<Review> reviews = getVisibleReviewsByItemId(itemId);
        Map<Integer, Integer> ratingCounts = new HashMap<>();
        
        // Initialize counts for all possible ratings (1-5)
        for (int i = 1; i <= 5; i++) {
            ratingCounts.put(i, 0);
        }
        
        // Count ratings
        for (Review review : reviews) {
            int rating = review.getRating();
            ratingCounts.put(rating, ratingCounts.get(rating) + 1);
        }
        
        // Calculate percentages
        Map<Integer, Double> percentages = new HashMap<>();
        int totalReviews = reviews.size();
        
        if (totalReviews > 0) {
            for (int i = 1; i <= 5; i++) {
                double percentage = (ratingCounts.get(i) * 100.0) / totalReviews;
                percentages.put(i, percentage);
            }
        } else {
            // If no reviews, set all percentages to 0
            for (int i = 1; i <= 5; i++) {
                percentages.put(i, 0.0);
            }
        }
        
        return percentages;
    }

    public boolean createReview(Review review) {
        return reviewDAO.create(review);
    }

    public boolean updateReview(Review review) {
        return reviewDAO.update(review);
    }

    public boolean deleteReview(long id) {
        return reviewDAO.delete(id);
    }
}
