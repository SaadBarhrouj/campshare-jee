package com.campshare.service;

import com.campshare.dao.impl.CityDAOImpl;
import com.campshare.dao.interfaces.CityDAO;
import com.campshare.model.City;
import java.util.List;

public class CityService {

  private CityDAO cityDAO = new CityDAOImpl();

  public List<City> getAllCities() {
    return cityDAO.findAll();
  }
}