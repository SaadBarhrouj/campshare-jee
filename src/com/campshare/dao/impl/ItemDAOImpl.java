package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campshare.dao.interfaces.ItemDAO;


import com.campshare.model.Image;
import com.campshare.model.Item;
import com.campshare.model.Review;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;



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


}