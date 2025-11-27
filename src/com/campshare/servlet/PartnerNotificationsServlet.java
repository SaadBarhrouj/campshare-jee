package com.campshare.servlet;

import com.campshare.model.User;
import com.campshare.service.NotificationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/partner/notifications")
public class PartnerNotificationsServlet extends HttpServlet {

  private NotificationService notificationService = new NotificationService();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    User authUser = (User) req.getSession().getAttribute("authenticatedUser");
    if (authUser == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }

    long userId = authUser.getId();
    req.setAttribute("notifications", notificationService.getPartnerNotifications(userId));

    req.getRequestDispatcher("/jsp/notifications/notifications-partner.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    User authUser = (User) req.getSession().getAttribute("authenticatedUser");
    if (authUser == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }

    long userId = authUser.getId();
    String action = req.getParameter("action");

    if (action != null) {
      switch (action) {
        case "markAllRead":
          notificationService.markAllNotificationsAsRead(userId);
          break;
        case "markRead": {
          String idParam = req.getParameter("singleId");
          if (idParam != null && !idParam.isEmpty()) {
            try {
              long notificationId = Long.parseLong(idParam);
              notificationService.markNotificationAsRead(userId, notificationId);
            } catch (NumberFormatException ignored) {
            }
          }
          break;
        }
        case "deleteOne": {
          String idParam = req.getParameter("singleId");
          if (idParam != null && !idParam.isEmpty()) {
            try {
              long notificationId = Long.parseLong(idParam);
              notificationService.deleteNotification(userId, notificationId);
            } catch (NumberFormatException ignored) {
            }
          }
          break;
        }
        case "deleteSelected": {
          String[] idParams = req.getParameterValues("selectedIds");
          if (idParams != null && idParams.length > 0) {
            List<Long> ids = new ArrayList<>();
            for (String idStr : idParams) {
              try {
                ids.add(Long.parseLong(idStr));
              } catch (NumberFormatException ignored) {
              }
            }
            if (!ids.isEmpty()) {
              notificationService.deleteNotifications(userId, ids);
            }
          }
          break;
        }
        default:
          break;
      }
    }

    resp.sendRedirect(req.getContextPath() + "/partner/notifications");
  }
}

