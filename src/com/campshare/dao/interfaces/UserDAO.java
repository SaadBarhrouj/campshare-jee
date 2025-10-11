package com.campshare.dao.interfaces;

import java.util.List;

import com.campshare.dto.DailyRegistrationStatsDTO;
import com.campshare.model.User;

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

    List<DailyRegistrationStatsDTO> getDailyRegistrationStats(int days);
}