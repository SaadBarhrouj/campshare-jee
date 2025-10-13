package com.campshare.dao.impl;

import com.campshare.dao.interfaces.CityDAO;
import com.campshare.model.City;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CityDAOImpl implements CityDAO {

  @Override
  public List<City> findAll() {
    List<City> cities = new ArrayList<>();
    String sql = "SELECT id, name FROM cities ORDER BY name ASC";

    try (Connection conn = DatabaseManager.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()) {

      while (rs.next()) {
        City city = new City();
        city.setId(rs.getLong("id"));
        city.setName(rs.getString("name"));
        cities.add(city);
      }
    } catch (SQLException e) {
      System.err.println("Erreur SQL lors de la récupération des villes: " + e.getMessage());
      throw new RuntimeException("Erreur de base de données lors de la récupération des villes.", e);
    }
    return cities;
  }

  @Override
  public City findById(long id) {
    String sql = "SELECT id, name FROM cities WHERE id = ?";
    
    try (Connection conn = DatabaseManager.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
      
      pstmt.setLong(1, id);
      
      try (ResultSet rs = pstmt.executeQuery()) {
        if (rs.next()) {
          City city = new City();
          city.setId(rs.getLong("id"));
          city.setName(rs.getString("name"));
          return city;
        }
      }
    } catch (SQLException e) {
      System.err.println("Erreur SQL lors de la récupération de la ville: " + e.getMessage());
      throw new RuntimeException("Erreur de base de données lors de la récupération de la ville.", e);
    }
    return null;
  }
}