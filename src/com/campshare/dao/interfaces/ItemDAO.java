package com.campshare.dao.interfaces;

import com.campshare.model.Item;
import java.util.List;

public interface  ItemDAO {

    List<Item> getPartnerEquipement(String email) ;

    List<Item> findAll();
    

    
}
