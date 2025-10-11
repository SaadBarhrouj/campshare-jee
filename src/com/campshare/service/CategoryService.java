package com.campshare.service;

import com.campshare.dao.impl.CategoryDAOImpl;
import com.campshare.dao.interfaces.CategoryDAO;
import com.campshare.model.Category;
import java.util.List;

public class CategoryService {
    
    private CategoryDAO categoryDAO = new CategoryDAOImpl();

    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    public Category getCategoryById(long id) {
        return categoryDAO.findById(id);
    }
}
