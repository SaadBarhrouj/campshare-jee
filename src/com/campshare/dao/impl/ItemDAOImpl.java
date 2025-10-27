package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.campshare.dao.interfaces.ItemDAO;


import com.campshare.model.Image;
import com.campshare.model.Item;
import com.campshare.model.Review;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;
import java.sql.Statement;



public class ItemDAOImpl implements ItemDAO {

    @Override
  public List<Item> findAll() {
    List<Item> items = new ArrayList<>();
    String sql = "SELECT * FROM items ORDER BY created_at DESC";
    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {
      while (rs.next()) {
        Item item = new Item();
        item.setId(rs.getLong("id"));
        item.setPartnerId(rs.getLong("partner_id"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setPricePerDay(rs.getDouble("price_per_day"));
        item.setCategoryId(rs.getLong("category_id"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        items.add(item);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return items;
  }

    public List<Item> getPartnerEquipement(String email) {
        List<Item> items = new ArrayList<>();



        String sql ="""
                SELECT 
                    i.id AS item_id,
                    i.partner_id,
                    i.title AS item_title,
                    i.description,
                    i.price_per_day,
                    i.category_id,
                    i.created_at,
                    C.id AS category_id,
                    C.name AS category_name,
                    GROUP_CONCAT(DISTINCT img.url) AS image_urls,
                    AVG(R.rating) AS avg_rating,
                    COUNT(DISTINCT R.id) AS review_count
                FROM users U
                JOIN items i ON i.partner_id = U.id
                JOIN categories C ON C.id = i.category_id
                LEFT JOIN images img ON img.item_id = i.id
                LEFT JOIN reviews R ON R.reviewee_id = i.id 
                    AND R.type = 'forObject'
                    AND R.is_visible = true
                WHERE U.email = ?
                GROUP BY i.id, i.partner_id, i.title, i.description, i.price_per_day, i.category_id, i.created_at, C.id, C.name
            """;

        try (Connection conn = DatabaseManager.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getLong("item_id"));
                item.setPartnerId(rs.getLong("partner_id"));
                item.setTitle(rs.getString("item_title"));
                item.setDescription(rs.getString("description"));
                item.setPricePerDay(rs.getDouble("price_per_day"));
                item.setCategoryId(rs.getLong("category_id"));
                item.setCreatedAt(rs.getTimestamp("created_at"));

                // Set Category
                Category category = new Category();
                category.setId(rs.getLong("category_id"));
                category.setName(rs.getString("category_name"));
                item.setCategory(category);

                // Parse image URLs
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

                // Fetch reviews for this item
                List<Review> reviews = getItemReviews(item.getId(), conn);
                item.setReviews(reviews);

                // Optional: print avg rating or review count
                

                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    // Helper method to fetch reviews for an item





    

    @Override
    public Item findById(long id) {
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE id = ?";
        
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    return item;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération de l'article: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération de l'article.", e);
        }
        return null;
    }

    @Override
    public List<Item> findByPartnerId(long partnerId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE partner_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, partnerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles du partenaire: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles du partenaire.", e);
        }
        return items;
    }

    @Override
    public List<Item> findByCategoryId(long categoryId) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE category_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles par catégorie: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles par catégorie.", e);
        }
        return items;
    }

    @Override
    public List<Item> findByPriceRange(double minPrice, double maxPrice) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE price_per_day BETWEEN ? AND ? ORDER BY price_per_day ASC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, minPrice);
            pstmt.setDouble(2, maxPrice);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la récupération des articles par prix: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la récupération des articles par prix.", e);
        }
        return items;
    }

    @Override
    public List<Item> searchByTitle(String searchTerm) {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT id, partner_id, title, description, price_per_day, category_id, created_at FROM items WHERE title LIKE ? OR description LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getLong("id"));
                    item.setPartnerId(rs.getLong("partner_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setCategoryId(rs.getLong("category_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche d'articles: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche d'articles.", e);
        }
        return items;
    }
        private List<Review> getItemReviews(long itemId, Connection conn) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT id, rating, comment, created_at
            FROM reviews
            WHERE item_id = ? AND type = 'forObject' AND is_visible = true
        """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, itemId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getLong("id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                reviews.add(review);
            }
        }

        return reviews;
    }
    public int createItem(Item equipment) {
        String itemSql = "INSERT INTO items (partner_id, title, description, price_per_day, category_id) VALUES (?, ?, ?, ?, ?)";
        String imageSql = "INSERT INTO images (item_id, url) VALUES (?, ?)";

        int itemId = -1;

        try (Connection conn = DatabaseManager.getConnection()) {
            conn.setAutoCommit(false);

            // Insert item
            try (PreparedStatement stmt = conn.prepareStatement(itemSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setDouble(1, equipment.getPartner().getId());
                stmt.setString(2, equipment.getTitle());
                stmt.setString(3, equipment.getDescription());
                stmt.setDouble(4, equipment.getPricePerDay());
                stmt.setDouble(5, equipment.getCategory().getId());
                stmt.executeUpdate();

                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    itemId = rs.getInt(1);
                } else {
                    conn.rollback();
                    return -1;
                }
            }

            // Insert images (the servlet already created Image objects with url)
            if (equipment.getImages() != null) {
                try (PreparedStatement imgStmt = conn.prepareStatement(imageSql)) {
                    for (Image img : equipment.getImages()) {
                        imgStmt.setInt(1, itemId);
                        imgStmt.setString(2, img.getUrl()); // just the file name
                        imgStmt.addBatch();
                    }
                    imgStmt.executeBatch();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return itemId;
    }

    public boolean deleteItem(int itemId) {
        String deleteImagesSql = "DELETE FROM images WHERE item_id = ?";
        String deleteItemSql = "DELETE FROM items WHERE id = ?";
        String deleteListingsSql = "DELETE FROM listings WHERE item_id = ?";

        try (Connection conn = DatabaseManager.getConnection()) {
            // Start a transaction
            conn.setAutoCommit(false);

            try (PreparedStatement stmtImages = conn.prepareStatement(deleteImagesSql)) {
                stmtImages.setInt(1, itemId);
                stmtImages.executeUpdate();
            }
            try (PreparedStatement stmtListings = conn.prepareStatement(deleteListingsSql)) {
                stmtListings.setInt(1, itemId);
                stmtListings.executeUpdate();
            }

            int affectedRows;
            try (PreparedStatement stmtItem = conn.prepareStatement(deleteItemSql)) {
                stmtItem.setInt(1, itemId);
                affectedRows = stmtItem.executeUpdate();
            }



            // Commit the transaction
            conn.commit();

            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Optional<Item> findItemWithImages(int equipmentId) {
        String sql = "SELECT i.*, img.id AS img_id, img.url AS img_url " +
                     "FROM items i LEFT JOIN images img ON img.item_id = i.id " +
                     "WHERE i.id = ?";

        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, equipmentId);
            ResultSet rs = stmt.executeQuery();

            Item item = null;

            while (rs.next()) {
                if (item == null) {
                    item = new Item();
                    item.setId(rs.getInt("id"));
                    item.setDescription(rs.getString("description"));
                    item.setPricePerDay(rs.getDouble("price_per_day"));
                    item.setTitle(rs.getString("title"));
                    item.setPartnerId(rs.getInt("partner_id"));
                }
                List<Image> images = new ArrayList<>();
                int imgId = rs.getInt("img_id");
                if (imgId > 0) {
                    Image img = new Image();
                    img.setId(imgId);
                    img.setUrl(rs.getString("img_url"));
                    images.add(img);
                }
                item.setImages(images);
            }

            if (item != null) {
                
                return Optional.of(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }



}