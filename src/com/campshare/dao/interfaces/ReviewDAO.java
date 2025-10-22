package com.campshare.dao.interfaces;

import com.campshare.model.Item;
import com.campshare.model.Review;
import java.util.List;

public interface  ReviewDAO {


    List<Review> getPartnerAvisRecu(String email) ;
    

    
}
