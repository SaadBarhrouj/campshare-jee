package com.campshare.service;

import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dao.impl.ReservationDAOImpl;
import com.campshare.dao.interfaces.ReservationDAO;
import com.campshare.model.Item;
import com.campshare.model.User;
import com.campshare.model.Reservation;

import java.util.List;

public class PartnerService {

    private UserDAO userDAO = new UserDAOImpl();
    private ItemDAO itemDAO = new ItemDAOImpl();
    private ReservationDAO reservationDAO = new ReservationDAOImpl();

    
    public User getClientByEmail(String email) {
        return userDAO.findByEmail(email);
    }
    public List<Item> getPartnerEquipment(String email) {
        return itemDAO.getPartnerEquipement(email);
    }

    public List<Reservation> getLocationsEnCours(String email) {
        return reservationDAO.getLocationsEncours(email);
    }

}
