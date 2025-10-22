package com.campshare.dao.impl;

import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.model.City;
import com.campshare.model.Image;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.util.DatabaseManager;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ListingDAOImpl implements ListingDAO {
  @Override
  public List<Listing> findAll() {
    List<Listing> listings = new ArrayList<>();
    
    return listings;
  }

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
      e.printStackTrace();
    }
    return 0;
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

}

