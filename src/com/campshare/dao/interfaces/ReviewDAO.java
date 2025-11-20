package com.campshare.dao.interfaces;

import java.util.List;
import com.campshare.model.Review;

public interface ReviewDAO {
    List<Review> findByReservationId(long reservationId);
    List<Review> findByReservationIdWithUser(long reservationId);
}