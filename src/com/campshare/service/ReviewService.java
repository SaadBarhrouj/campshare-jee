package com.campshare.service;

import java.util.List;
import java.util.Map;

import com.campshare.dao.impl.ReviewDAOImpl;
import com.campshare.model.Review;



public class ReviewService {

    private ReviewDAOImpl reviewDAO = new ReviewDAOImpl();

    public List<Review> getReviewsByRevieweeId(long revieweeId) {
        return reviewDAO.findByRevieweeId(revieweeId);
    }

    public long getReviewCountByRevieweeId(long revieweeId) {
        return reviewDAO.countByRevieweeId(revieweeId);
    }

    public double getAverageRatingByRevieweeId(long revieweeId) {
        return reviewDAO.getAverageRatingByRevieweeId(revieweeId);
    }

    public Map<Integer, Integer> getRatingPercentagesByRevieweeId(long revieweeId) {
        return reviewDAO.getRatingPercentagesByRevieweeId(revieweeId);
    }


    public List<Review> getReviewsByRevieweeCId(long revieweeId) {
        return reviewDAO.findByRevieweeCId(revieweeId);
    }

    public long getReviewCountByRevieweeCId(long revieweeId) {
        return reviewDAO.countByRevieweeCId(revieweeId);
    }

    public double getAverageRatingByRevieweeCId(long revieweeId) {
        return reviewDAO.getAverageRatingByRevieweeCId(revieweeId);
    }

    public Map<Integer, Integer> getRatingPercentagesByRevieweeCId(long revieweeId) {
        return reviewDAO.getRatingPercentagesByRevieweeCId(revieweeId);
    }

}

