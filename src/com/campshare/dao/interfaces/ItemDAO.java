package com.campshare.dao.interfaces;

import com.campshare.model.Item;
import java.util.List;

public interface ItemDAO {
  List<Item> findAll();

  boolean updateItem(Item item);
}