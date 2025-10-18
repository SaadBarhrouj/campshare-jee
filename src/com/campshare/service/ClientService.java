package com.campshare.service;

import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.model.User;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class ClientService {

    private UserDAO userDAO = new UserDAOImpl();

    
    public User getClientByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    
    
}
