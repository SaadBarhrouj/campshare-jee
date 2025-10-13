package com.campshare.filter;

import com.campshare.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class SecurityFilter implements Filter {

  private static final List<String> PUBLIC_PATHS = Arrays.asList("", "/", "/login", "/register", "/logout",
      "/listings", "/listing");

  private static final String ADMIN_PREFIX = "/jsp/admin/";
  private static final String PARTNER_PREFIX = "/jsp/partner/";
  private static final String CLIENT_PREFIX = "/jsp/client/";
  private static final String ASSETS_PREFIX = "/assets/";
  private static final String UPLOADS_PREFIX = "/uploads/";

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    HttpSession session = httpRequest.getSession(false);

    String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

    if (isPublic(path)) {
      chain.doFilter(request, response);
      return;
    }

    if (session == null || session.getAttribute("authenticatedUser") == null) {
      httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
      return;
    }

    User user = (User) session.getAttribute("authenticatedUser");

    if (hasPermission(path, user)) {
      chain.doFilter(request, response);
    } else {
      httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès Refusé");
    }
  }

  private boolean isPublic(String path) {
    if (path.startsWith(ASSETS_PREFIX) || path.startsWith(UPLOADS_PREFIX)) {
      return true;
    }
    return PUBLIC_PATHS.contains(path);
  }

  private boolean hasPermission(String path, User user) {

    String role = user.getRole();

    switch (role) {
      case "admin":
        return path.startsWith(ADMIN_PREFIX) || path.startsWith("/admin/") || path.startsWith("/api/admin/");
        
      case "partner":
        return path.startsWith(PARTNER_PREFIX) || path.startsWith(CLIENT_PREFIX);
      case "client":
        return path.startsWith(CLIENT_PREFIX);
      default:
        return false;
    }
  }

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
  }

  @Override
  public void destroy() {
  }
}