package com.campshare.service;

import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.model.User;

public class PartnerService {

    private UserDAO userDAO = new UserDAOImpl();

    
    public User getClientByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    public double getAverageRating(long id) {
        return userDAO.getAverageRatingForPartner(id);
    }


}
