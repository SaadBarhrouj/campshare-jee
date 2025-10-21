package com.campshare.dao.interfaces;

import com.campshare.model.City;
import java.util.List;

public interface CityDAO {

    List<City> findAll();
    City findById(long id);
    City findByName(String name);

}