package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Review;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

public class ReviewDAOImpl implements ReviewDAO {

  @Override
  public List<Review> findByReservationId(long reservationId) {
    List<Review> reviews = new ArrayList<>();
    String sql = "SELECT * FROM reviews WHERE reservation_id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {

      pstmt.setLong(1, reservationId);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          Review review = mapResultSetToReview(rs);

          User reviewer = new UserDAOImpl().findById(review.getReviewerId());
          review.setReviewer(reviewer);

          reviews.add(review);
        }
      }
    } catch (SQLException e) {
      System.err.println(
          "Erreur lors de la recherche des avis pour la réservation ID " + reservationId + ": " + e.getMessage());
      e.printStackTrace();
    }
    return reviews;
  }

  private Review mapResultSetToReview(ResultSet rs) throws SQLException {
    Review review = new Review();
    review.setId(rs.getLong("id"));
    review.setReservationId(rs.getLong("reservation_id"));
    review.setRating(rs.getInt("rating"));
    review.setComment(rs.getString("comment"));
    review.setReviewerId(rs.getLong("reviewer_id"));
    review.setRevieweeId(rs.getLong("reviewee_id"));
    review.setCreatedAt(rs.getTimestamp("created_at"));
    return review;
  }
}
