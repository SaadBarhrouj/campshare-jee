package com.campshare.dao.interfaces;

import com.campshare.dto.DailyRegistrationStatsDTO;
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

    List<DailyRegistrationStatsDTO> getDailyRegistrationStats(int days);

    List<User> findRecentByRole(String role, int limit);

    void updateRole(long userId, String newRole);
    boolean updateUserProfile(User user);

    boolean updateUserPassword(long userId, String newHashedPassword);

    boolean updateUserAvatar(long userId, String avatarUrl);

    List<User> findAndPaginateUsers(String role, String searchQuery, String status, String sortBy, int limit,
            int offset);

    int countUsers(String role, String searchQuery, String status);

    double getPartnerAverageRating(long userId);
    int getPartnerCountRating(long userId);


    
}