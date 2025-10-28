package com.campshare.dao.interfaces;

import com.campshare.model.User;
import java.util.List;

import com.campshare.dto.DailyRegistrationStatsDTO;

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

    List<User> findRecentByRole(String role, int limit);

    void updateRole(long userId, String newRole);
}