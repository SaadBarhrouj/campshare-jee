package com.campshare.dao.interfaces;

import com.campshare.model.Image;
import java.util.List;

public interface ImageDAO {
    
    List<Image> findByItemId(long itemId);
    Image findFirstByItemId(long itemId);
    
}
