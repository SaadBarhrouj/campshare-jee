package com.campshare.dao.interfaces;

import com.campshare.model.Category;
import java.util.List;

public interface CategoryDAO {
    List<Category> findAll();
    Category findById(long id);
}
