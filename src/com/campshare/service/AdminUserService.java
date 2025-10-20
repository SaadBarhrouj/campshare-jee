package com.campshare.service;

import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dto.UserPageStatsDTO;

public class AdminUserService {

  private UserDAO userDAO = new UserDAOImpl();

  public UserPageStatsDTO getUserStats(String role) {
    UserPageStatsDTO statsDTO = new UserPageStatsDTO();

    long total = userDAO.countByRole(role);
    long active = userDAO.countByRoleAndStatus(role, true);
    long inactive = total - active; 

    double activePercentage = (total > 0) ? ((double) active / total) * 100 : 0;
    double inactivePercentage = (total > 0) ? ((double) inactive / total) * 100 : 0;

    statsDTO.setTotal(total);
    statsDTO.setActive(active);
    statsDTO.setInactive(inactive);
    statsDTO.setActivePercentage(activePercentage);
    statsDTO.setInactivePercentage(inactivePercentage);

    return statsDTO;
  }
}