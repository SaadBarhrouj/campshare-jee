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


  private Listing mapRow(ResultSet rs) throws SQLException {
        Listing listing = new Listing();
        listing.setId(rs.getLong("id"));
        listing.setItemId(rs.getLong("item_id"));
        listing.setStatus(rs.getString("status"));
        listing.setStartDate(rs.getDate("start_date"));
        listing.setEndDate(rs.getDate("end_date"));
        listing.setCityId(rs.getLong("city_id"));
        listing.setLongitude(rs.getObject("longitude") == null ? null : rs.getDouble("longitude"));
        listing.setLatitude(rs.getObject("latitude") == null ? null : rs.getDouble("latitude"));
        listing.setDeliveryOption(rs.getBoolean("delivery_option"));
        listing.setCreatedAt(rs.getTimestamp("created_at"));
        return listing;
    }

    @Override
    public Listing findById(long id) {
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération du listing par ID", e);
        }
        return null;
    }

    @Override
    public List<Listing> findByPartnerId(long partnerId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l JOIN items i ON l.item_id = i.id WHERE i.partner_id = ? ORDER BY l.created_at DESC";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, partnerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listings.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la récupération des listings par partenaire", e);
        }
        return listings;
    }












    @Override
    public List<Listing> findByCityId(long cityId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE city_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, cityId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par ville: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par ville.", e);
        }
        return listings;
    }


    @Override
    public List<Listing> findByStatus(String status) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par statut: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par statut.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByItemId(long itemId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT id, item_id, status, start_date, end_date, city_id, longitude, latitude, delivery_option, created_at FROM listings WHERE item_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, itemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par article.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findActiveListings() {
        return findByStatus("active");
    }

    @Override
    public List<Listing> findByCategoryId(long categoryId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.category_id = ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par catégorie.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByPriceRange(double minPrice, double maxPrice) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.price_per_day BETWEEN ? AND ? ORDER BY i.price_per_day ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, minPrice);
            pstmt.setDouble(2, maxPrice);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par prix: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par prix.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> searchByTitle(String searchTerm) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE i.title LIKE ? OR i.description LIKE ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche d'annonces: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche d'annonces.", e);
        }
        return listings;
    }

    @Override
    public List<Listing> findByCityAndCategory(long cityId, long categoryId) {
        List<Listing> listings = new ArrayList<>();
        String sql = "SELECT l.id, l.item_id, l.status, l.start_date, l.end_date, l.city_id, l.longitude, l.latitude, l.delivery_option, l.created_at " +
                     "FROM listings l " +
                     "INNER JOIN items i ON l.item_id = i.id " +
                     "WHERE l.city_id = ? AND i.category_id = ? ORDER BY l.created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, cityId);
            pstmt.setLong(2, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Listing listing = new Listing();
                    listing.setId(rs.getLong("id"));
                    listing.setItemId(rs.getLong("item_id"));
                    listing.setStatus(rs.getString("status"));
                    listing.setStartDate(rs.getDate("start_date"));
                    listing.setEndDate(rs.getDate("end_date"));
                    listing.setCityId(rs.getLong("city_id"));
                    listing.setLongitude(rs.getDouble("longitude"));
                    listing.setLatitude(rs.getDouble("latitude"));
                    listing.setDeliveryOption(rs.getBoolean("delivery_option"));
                    listing.setCreatedAt(rs.getTimestamp("created_at"));
                    listings.add(listing);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des annonces par ville et catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des annonces par ville et catégorie.", e);
        }
        return listings;
    }
      public List<Listing> getPartnerListings(String email) {
    List<Listing> listings = new ArrayList<>();

    String sql = """
        SELECT 
            L.id AS listing_id,
            L.status,
            L.created_at,
            L.city_id,
            I.title,
            I.description,
            I.price_per_day,
            C.name AS city_name,
            GROUP_CONCAT(IMG.url) AS image_urls
        FROM users U
        JOIN items I ON I.partner_id = U.id
        JOIN listings L ON L.item_id = I.id
        JOIN cities C ON L.city_id = C.id
        LEFT JOIN images IMG ON IMG.item_id = I.id
        WHERE U.email = ?
        GROUP BY L.id, I.title, I.description, I.price_per_day, C.name
        ORDER BY L.created_at DESC
    """;

    try (Connection conn = DatabaseManager.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Listing listing = new Listing();
            listing.setId(rs.getInt("listing_id"));
            listing.setStatus(rs.getString("status"));
            listing.setCreatedAt(rs.getTimestamp("created_at"));
            listing.setCityId(rs.getInt("city_id"));

            City city = new City();
            city.setName(rs.getString("city_name"));
            listing.setCity(city);

            Item item = new Item();
            item.setTitle(rs.getString("title"));
            item.setDescription(rs.getString("description"));
            item.setPricePerDay(rs.getDouble("price_per_day"));

            String imageUrlsString = rs.getString("image_urls");
            List<Image> images = new ArrayList<>();
            if (imageUrlsString != null && !imageUrlsString.isEmpty()) {
                for (String url : imageUrlsString.split(",")) {
                    Image img = new Image();
                    img.setUrl(url.trim());
                    images.add(img);
                }
            }
            item.setImages(images);
            listing.setItem(item);

            listings.add(listing);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return listings;
}

  @Override
  public boolean deleteAnnonce(long id) {
      String sql = "DELETE FROM listings WHERE id = ?";
      
      try (Connection conn = DatabaseManager.getConnection();
          PreparedStatement stmt = conn.prepareStatement(sql)) {

          stmt.setLong(1, id);
          return stmt.executeUpdate() > 0;
          
      } catch (SQLException e) {
          System.out.println("Error deleting annonce: " + e.getMessage());
          return false;
      }
  }

      public boolean updateListing(long listingId, long cityId, String startDate, String endDate,
                                 String deliveryOption, Double latitude, Double longitude) {
        String sql = "UPDATE listings SET city_id = ?, start_date = ?, end_date = ?, delivery_option = ?, " +
                     "latitude = ?, longitude = ? WHERE id = ?";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
              deliveryOption = deliveryOption.equals("true") ? "1" : "0";

            stmt.setLong(1, cityId);
            stmt.setString(2, startDate);
            stmt.setString(3, endDate);
            stmt.setString(4, deliveryOption);
            stmt.setObject(5, latitude); // use setObject to allow null
            stmt.setObject(6, longitude);
           
            stmt.setLong(7, listingId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updating listing: " + e.getMessage());
            return false;
        }
    }


}