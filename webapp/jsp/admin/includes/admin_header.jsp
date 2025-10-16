<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- Navigation -->
<nav
  class="bg-white bg-opacity-95 dark:bg-gray-800 dark:bg-opacity-95 shadow-md fixed w-full z-50 transition-all duration-300"
>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between h-16">
      <div class="flex-shrink-0 flex items-center">
        <!-- Logo -->
        <a href="" class="flex items-center">
          <span
            class="text-admin-primary dark:text-admin-secondary text-3xl font-extrabold"
            >Camp<span class="text-sunlight">Share</span></span
          >
          <span
            class="text-xs ml-2 text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded"
            >ADMIN</span
          >
        </a>
      </div>

      <!-- Desktop Navigation -->
      <div class="hidden md:flex items-center space-x-8">
        <!-- User menu -->
        <div class="relative ml-4">
          <div class="flex items-center space-x-4">
            <!-- User profile menu -->
            <div class="relative">
              <button
                id="user-menu-button"
                class="flex items-center space-x-2 focus:outline-none"
              >
                <c:choose>
                  <c:when test="${not empty authenticatedUser.avatarUrl}">
                    <img
                      src="${pageContext.request.contextPath}/uploads/${authenticatedUser.avatarUrl}"
                      alt="Admin User"
                      class="h-8 w-8 rounded-full object-cover"
                    />
                  </c:when>

                  <c:otherwise>
                    <img
                      src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                      alt="Admin User"
                      class="h-8 w-8 rounded-full object-cover"
                    />
                  </c:otherwise>
                </c:choose>

                <div class="flex flex-col items-start">
                  <span
                    class="font-medium text-gray-800 dark:text-gray-200 text-sm"
                  >
                    <c:out
                      value="${authenticatedUser.firstName} ${authenticatedUser.lastName}"
                  /></span>
                  <span
                    class="text-xs text-admin-primary dark:text-admin-secondary font-medium"
                  >
                    <c:out value="${authenticatedUser.username}" />
                  </span>
                </div>
                <i class="fas fa-chevron-down text-sm text-gray-500"></i>
              </button>

              <!-- User dropdown menu -->
              <div
                id="user-dropdown"
                class="hidden absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-md shadow-lg z-50 border border-gray-200 dark:border-gray-600 py-1"
              >
                <a
                  href=""
                  class="block px-4 py-2 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700"
                >
                  <i class="fas fa-user-circle mr-2 opacity-70"></i> Mon profil
                </a>
                <div
                  class="border-t border-gray-200 dark:border-gray-700"
                ></div>

                <a
                  href="${pageContext.request.contextPath}/logout"
                  class="block px-4 py-2 text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700"
                  onclick="event.preventDefault(); document.getElementById('admin-logout-form').submit();"
                >
                  <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se
                  déconnecter
                </a>

                <form
                  id="admin-logout-form"
                  action="${pageContext.request.contextPath}/logout"
                  method="POST"
                  class="hidden"
                ></form>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Mobile menu button -->
      <div class="md:hidden flex items-center">
        <button
          id="mobile-menu-button"
          class="text-gray-600 dark:text-gray-300 hover:text-admin-primary dark:hover:text-admin-secondary focus:outline-none"
        >
          <svg
            class="h-6 w-6"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
        </button>
      </div>
    </div>
  </div>

  <!-- Mobile menu -->
  <div
    id="mobile-menu"
    class="hidden md:hidden bg-white dark:bg-gray-800 pb-4 shadow-lg"
  >
    <div class="pt-2 pb-3 px-3">
      <!-- Mobile search -->
      <div class="relative mb-3">
        <input
          type="text"
          placeholder="Recherche rapide..."
          class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-sm"
        />
        <div
          class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none"
        >
          <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
        </div>
      </div>
    </div>

    <!-- Mobile profile menu -->
    <div class="border-t border-gray-200 dark:border-gray-700 pt-4 pb-3">
      <div class="flex items-center px-4">
        <div class="flex-shrink-0">
          <img
            src="https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80"
            alt="Admin User"
            class="h-10 w-10 rounded-full"
          />
        </div>
        <div class="ml-3">
          <div class="text-base font-medium text-gray-800 dark:text-white">
            Saad Barhrouj
          </div>
          <div
            class="text-sm font-medium text-admin-primary dark:text-admin-secondary"
          >
            Admin
          </div>
        </div>
        <div class="ml-auto flex items-center space-x-4">
          <button
            class="flex-shrink-0 p-1 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
          >
            <i class="fas fa-bell text-lg"></i>
            <span
              class="absolute -mt-1 -mr-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center"
              >5</span
            >
          </button>
          <button
            class="flex-shrink-0 p-1 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300"
          >
            <i class="fas fa-cog text-lg"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</nav>
