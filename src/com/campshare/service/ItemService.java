package com.campshare.service;

import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.model.Item;
import java.util.List;

public class ItemService {
    
    private ItemDAO itemDAO = new ItemDAOImpl();

    public List<Item> getAllItems() {
        return itemDAO.findAll();
    }

    public Item getItemById(long id) {
        return itemDAO.findById(id);
    }

    public List<Item> getItemsByPartnerId(long partnerId) {
        return itemDAO.findByPartnerId(partnerId);
    }

    public List<Item> getItemsByCategoryId(long categoryId) {
        return itemDAO.findByCategoryId(categoryId);
    }

    public List<Item> getItemsByPriceRange(double minPrice, double maxPrice) {
        return itemDAO.findByPriceRange(minPrice, maxPrice);
    }

    public List<Item> searchItemsByTitle(String searchTerm) {
        return itemDAO.searchByTitle(searchTerm);
    }
}
