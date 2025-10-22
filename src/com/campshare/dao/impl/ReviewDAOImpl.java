package com.campshare.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.model.Image;
import com.campshare.model.Item;
import com.campshare.model.User;

import com.campshare.model.Review;
import com.campshare.model.Category;
import com.campshare.util.DatabaseManager;



public class ReviewDAOImpl implements ReviewDAO {

    public List<Review> getPartnerAvisRecu(String email)  {
    List<Review> avisList = new ArrayList<>();

    String sql = "SELECT r.rating, r.comment, c.username, c.avatar_url, " +
                 "DATE(r.created_at) AS created_at, " +
                 "CASE WHEN r.type = 'forObject' THEN i.title ELSE NULL END AS object_title " +
                 "FROM reviews r " +
                 "JOIN users u ON u.id = r.reviewee_id " +
                 "JOIN users c ON c.id = r.reviewer_id " +
                 "LEFT JOIN items i ON i.id = r.item_id AND r.type = 'forObject' " +
                 "WHERE u.email = ? " +
                 "AND r.type IN ('forObject', 'forPartner')";

    try (Connection conn = DatabaseManager.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Review avis = new Review();
            avis.setRating(rs.getInt("rating"));
            avis.setComment(rs.getString("comment"));
            User reviewer = new User();
            reviewer.setUsername(rs.getString("username"));
            reviewer.setAvatarUrl(rs.getString("avatar_url"));
            avis.setCreatedAt(rs.getDate("created_at"));
            Item item = new Item();
            item.setTitle(rs.getString("object_title"));
            //avis.setObjectTitle(rs.getString("object_title"));
            avis.setReviewer(reviewer);
            avis.setItem(item);
            
            avisList.add(avis);
        }
    }catch (SQLException e) {
        e.printStackTrace();
    }

    return avisList;
}

}