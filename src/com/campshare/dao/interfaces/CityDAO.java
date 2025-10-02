package com.campshare.dao.interfaces;

import com.campshare.model.City;
import java.util.List;

public interface CityDAO {
  List<City> findAll();
}