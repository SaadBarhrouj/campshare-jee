package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.Category;
import com.campshare.model.City;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.User;
import com.campshare.model.Image;
import com.campshare.model.Review;
import com.campshare.util.DatabaseManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingDAOImpl implements ListingDAO {
  private UserDAO userDAO = new UserDAOImpl();
  private final String BASE_SELECT_SQL = "SELECT " +
      "l.id as listing_id, l.status, l.start_date, l.end_date, l.created_at as listing_created_at, " +
      "l.longitude, l.latitude, l.delivery_option, " +
      "i.id as item_id, i.title, i.description, i.price_per_day, i.category_id, " +
      "u.id as partner_id, u.username, u.first_name, u.last_name, u.avatar_url as partner_avatar, " +
      "c.id as city_id, c.name as city_name, " +
      "cat.id as category_id_ref, cat.name as category_name " +
      "FROM listings l " +
      "JOIN items i ON l.item_id = i.id " +
      "JOIN users u ON i.partner_id = u.id " +
      "JOIN cities c ON l.city_id = c.id " +
      "JOIN categories cat ON i.category_id = cat.id ";

  @Override
  public long countAll() {
    String sql = "SELECT COUNT(*) FROM listings";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      if (rs.next()) {
        return rs.getLong(1);
      }
    } catch (SQLException e) {
      System.err.println("Erreur countAll: " + e.getMessage());
      e.printStackTrace();
    }
    return 0;
  }

  @Override
  public long countAllActive() {
    String sql = "SELECT COUNT(*) FROM listings WHERE status = 'active' AND end_date >= CURDATE()";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      if (rs.next()) {
        return rs.getLong(1);
      }
    } catch (SQLException e) {
      System.err.println("Erreur countAllActive: " + e.getMessage());
      e.printStackTrace();
    }
    return 0;
  }

  @Override
  public long countAllArchived() {
    String sql = "SELECT COUNT(*) FROM listings WHERE status = 'archived'";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      if (rs.next()) {
        return rs.getLong(1);
      }
    } catch (SQLException e) {
      System.err.println("Erreur countAllArchived: " + e.getMessage());
      e.printStackTrace();
    }
    return 0;
  }

  @Override
  public List<Listing> findAll() {
    List<Listing> listings = new ArrayList<>();
    String sql = BASE_SELECT_SQL + "ORDER BY l.created_at DESC";
    try (Connection conn = DatabaseManager.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql)) {
      while (rs.next()) {
        listings.add(mapResultSetToListingBasic(rs));
      }
    } catch (SQLException e) {
      System.err.println("Erreur findAllWithDetails: " + e.getMessage());
      e.printStackTrace();
    }
    return listings;
  }

  @Override
  public List<Listing> findRecent(int limit) {
    List<Listing> listings = new ArrayList<>();
    String sql = BASE_SELECT_SQL + "ORDER BY l.created_at DESC LIMIT ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setInt(1, limit);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          listings.add(mapResultSetToListingBasic(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Erreur findRecentWithDetails: " + e.getMessage());
      e.printStackTrace();
    }
    return listings;
  }

  @Override
  public Listing findInfoById(long listingId) {
    String sql = BASE_SELECT_SQL + "WHERE l.id = ?";
    Listing listing = null;
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, listingId);
      try (ResultSet rs = pstmt.executeQuery()) {
        if (rs.next()) {
          listing = mapResultSetToListingComplete(rs);
        }
      }
    } catch (SQLException e) {
      System.err.println("Erreur findInfoById pour ID " + listingId + ": " + e.getMessage());
      e.printStackTrace();
    }
    return listing;
  }

  @Override
  public boolean updateStatus(long listingId, String newStatus) {
    String sql = "UPDATE listings SET status = ? WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setString(1, newStatus);
      pstmt.setLong(2, listingId);
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      System.err.println("Erreur updateStatus pour ID " + listingId + ": " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  @Override
  public boolean delete(long listingId) {
    String sql = "DELETE FROM listings WHERE id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, listingId);
      return pstmt.executeUpdate() > 0;
    } catch (SQLException e) {
      System.err.println("Erreur delete pour ID " + listingId + ": " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  private Listing mapResultSetToListingBasic(ResultSet rs) throws SQLException {
    try {
      User partner = new User();
      partner.setId(rs.getLong("partner_id"));
      partner.setUsername(rs.getString("username"));
      partner.setFirstName(rs.getString("first_name"));
      partner.setLastName(rs.getString("last_name"));
      partner.setAvatarUrl(rs.getString("partner_avatar"));

      Category category = new Category();
      category.setId(rs.getLong("category_id_ref"));
      category.setName(rs.getString("category_name"));

      Item item = new Item();
      item.setId(rs.getLong("item_id"));
      item.setTitle(rs.getString("title"));
      item.setDescription(rs.getString("description"));
      item.setPricePerDay(rs.getDouble("price_per_day"));
      item.setPartnerId(partner.getId());
      item.setCategoryId(category.getId());
      item.setPartner(partner);
      item.setCategory(category);
      item.setImages(new ArrayList<>());
      item.setReviews(new ArrayList<>());

      City city = new City();
      city.setId(rs.getLong("city_id"));
      city.setName(rs.getString("city_name"));

      Listing listing = new Listing();
      listing.setId(rs.getLong("listing_id"));
      listing.setItemId(item.getId());
      listing.setStatus(rs.getString("status"));
      listing.setStartDate(rs.getDate("start_date"));
      listing.setEndDate(rs.getDate("end_date"));
      listing.setCityId(city.getId());
      listing.setLongitude(rs.getObject("longitude", Double.class));
      listing.setLatitude(rs.getObject("latitude", Double.class));
      listing.setDeliveryOption(rs.getBoolean("delivery_option"));
      listing.setCreatedAt(rs.getTimestamp("listing_created_at"));
      listing.setItem(item);
      listing.setCity(city);

      return listing;
    } catch (SQLException e) {
      System.err.println("Erreur dans mapResultSetToListingBasic: " + e.getMessage());
      e.printStackTrace();
      throw e;
    }
  }

  private Listing mapResultSetToListingComplete(ResultSet rs) throws SQLException {
    Listing listing = mapResultSetToListingBasic(rs);

    if (listing != null && listing.getItem() != null) {
      try {
        long currentItemId = listing.getItem().getId();
        listing.getItem().setImages(findImagesForItem(currentItemId));
        listing.getItem().setReviews(findReviewsForItem(currentItemId));
      } catch (Exception e) {
        System.err.println("Erreur lors du chargement des images/reviews pour item ID " + listing.getItem().getId()
            + ": " + e.getMessage());
        e.printStackTrace();
      }
    }
    return listing;
  }

  private List<Image> findImagesForItem(long itemId) {
    List<Image> images = new ArrayList<>();
    String sql = "SELECT id, item_id, url FROM images WHERE item_id = ?";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, itemId);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          Image img = new Image();
          img.setId(rs.getLong("id"));
          img.setItemId(rs.getLong("item_id"));
          img.setUrl(rs.getString("url"));
          images.add(img);
        }
      }
    } catch (SQLException e) {
      System.err.println("Erreur findImagesForItem pour ID " + itemId + ": " + e.getMessage());
      e.printStackTrace();
    }
    return images;
  }

  private List<Review> findReviewsForItem(long itemId) {
    List<Review> reviews = new ArrayList<>();
    String sql = "SELECT id, reservation_id, rating, comment, is_visible, type, reviewer_id, reviewee_id, item_id, created_at "
        +
        "FROM reviews WHERE item_id = ? AND is_visible = true AND type = 'forObject' ORDER BY created_at DESC";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
      pstmt.setLong(1, itemId);
      try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
          Review review = new Review();
          review.setId(rs.getLong("id"));
          review.setReservationId(rs.getLong("reservation_id"));
          review.setRating(rs.getInt("rating"));
          review.setComment(rs.getString("comment"));
          review.setVisible(rs.getBoolean("is_visible"));
          review.setType(rs.getString("type"));
          review.setReviewerId(rs.getLong("reviewer_id"));
          review.setRevieweeId(rs.getLong("reviewee_id"));
          User reviewer = userDAO.findById(review.getReviewerId());
          review.setReviewer(reviewer);
          review.setItemId(rs.getLong("item_id"));
          review.setCreatedAt(rs.getTimestamp("created_at"));
          reviews.add(review);
        }
      }
    } catch (SQLException e) {
      System.err.println("Erreur findReviewsForItem pour ID " + itemId + ": " + e.getMessage());
      e.printStackTrace();
    }
    return reviews;
  }
}