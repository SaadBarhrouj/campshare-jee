package com.campshare.dao.interfaces;

import com.campshare.model.Item;
import java.util.List;

public interface  ItemDAO {

    List<Item> getPartnerEquipement(String email) ;

    List<Item> findAll();
    

    Item findById(long id);
    List<Item> findByPartnerId(long partnerId);
    List<Item> findByCategoryId(long categoryId);
    List<Item> findByPriceRange(double minPrice, double maxPrice);
    List<Item> searchByTitle(String searchTerm);
    
}
