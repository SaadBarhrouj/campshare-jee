package com.campshare.dao.interfaces;

import com.campshare.model.User;

public interface UserDAO {
    User findByEmail(String email);
    User findByUsername(String username);
    void save(User user);
}