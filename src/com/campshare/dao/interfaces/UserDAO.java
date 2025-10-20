package com.campshare.dao.interfaces;

import com.campshare.model.User;
import java.util.List;

public interface UserDAO {
    User findByEmail(String email);

    User findByUsername(String username);

    void save(User user);

    long countAll();

    long countByRole(String role);

    List<User> findByRole(String role);

    User findById(long id);

    void updateStatus(long userId, boolean isActive);

    long countByRoleAndStatus(String role, boolean isActive);
}