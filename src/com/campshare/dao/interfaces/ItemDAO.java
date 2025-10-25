package com.campshare.dao.interfaces;

import com.campshare.model.Image;
import com.campshare.model.Item;
import java.util.List;

import javax.servlet.ServletContext;

public interface  ItemDAO {

    List<Item> getPartnerEquipement(String email) ;
    int createItem(Item item );
    boolean deleteItem(int itemId);

}
