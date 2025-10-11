package com.campshare.service;

import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.Item;
import com.campshare.model.User;
import java.util.List;

public class PartnerService {

    private UserDAO userDAO = new UserDAOImpl();
    private ItemDAO itemDAO = new ItemDAOImpl();

    
    public User getClientByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    public double getAverageRating(long id) {
        return userDAO.getAverageRatingForPartner(id);
    }
    public List<Item> getPartnerEquipment(String email) {
        return itemDAO.getPartnerEquipement(email);
    }


}
