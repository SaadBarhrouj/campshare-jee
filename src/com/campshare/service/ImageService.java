package com.campshare.service;

import com.campshare.dao.impl.ImageDAOImpl;
import com.campshare.dao.interfaces.ImageDAO;
import com.campshare.model.Image;
import java.util.List;

public class ImageService {
    
    private ImageDAO imageDAO = new ImageDAOImpl();

    public List<Image> getImagesByItemId(long itemId) {
        return imageDAO.findByItemId(itemId);
    }

    public Image getFirstImageByItemId(long itemId) {
        return imageDAO.findFirstByItemId(itemId);
    }
}
