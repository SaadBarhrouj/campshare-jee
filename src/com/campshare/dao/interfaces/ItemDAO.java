package com.campshare.dao.interfaces;

import com.campshare.model.Item;
import java.util.List;
import java.util.Optional;

public interface  ItemDAO {

    List<Item> getPartnerEquipement(String email) ;

    List<Item> findAll();
    

    Item findById(long id);
    List<Item> findByPartnerId(long partnerId);
    List<Item> findByCategoryId(long categoryId);
    List<Item> findByPriceRange(double minPrice, double maxPrice);
    List<Item> searchByTitle(String searchTerm);


    int createItem(Item item );
    boolean deleteItem(int itemId);
    
    Optional<Item> findItemWithImages(int equipmentId);

    Item findByListingId(long id);

    
}
