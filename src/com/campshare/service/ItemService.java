package com.campshare.service;

import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.model.Item;
import java.util.List;

public class ItemService {

    private ItemDAO itemDAO = new ItemDAOImpl();


    public List<Item> getPartnerEquipment(String email) {
        return itemDAO.getPartnerEquipement(email);
    }

    public Item getItemById(long id) {
        return itemDAO.findById(id);
    }
    


}
