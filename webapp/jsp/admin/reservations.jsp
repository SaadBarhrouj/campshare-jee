<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <title>Gestion des reservations - Admin</title>
    <link
      rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              forest: "#2D5F2B",
              meadow: "#4F7942",
              earth: "#8B7355",
              wood: "#D2B48C",
              sky: "#5D9ECE",
              water: "#1E7FCB",
              sunlight: "#FFAA33",
              admin: {
                primary: "#1E40AF",
                secondary: "#3B82F6",
                accent: "#60A5FA",
                light: "#DBEAFE",
                dark: "#1E3A8A",
              },
            },
          },
        },
        darkMode: "class",
      };

      if (
        window.matchMedia &&
        window.matchMedia("(prefers-color-scheme: dark)").matches
      ) {
        document.documentElement.classList.add("dark");
      }
      window
        .matchMedia("(prefers-color-scheme: dark)")
        .addEventListener("change", (event) => {
          if (event.matches) {
            document.documentElement.classList.add("dark");
          } else {
            document.documentElement.classList.remove("dark");
          }
        });
    </script>
  </head>

  <body
    class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col"
  >
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
                    <img
                      src=""
                      alt="Admin User"
                      class="h-8 w-8 rounded-full object-cover"
                    />
                    <div class="flex flex-col items-start">
                      <span
                        class="font-medium text-gray-800 dark:text-gray-200 text-sm"
                      >
                      </span>
                      <span
                        class="text-xs text-admin-primary dark:text-admin-secondary font-medium"
                      >
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
                      <i class="fas fa-user-circle mr-2 opacity-70"></i> Mon
                      profil
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
          <div class="mt-3 space-y-1 px-2">
            <a
              href="#profile"
              class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              <i class="fas fa-user-circle mr-2 opacity-70"></i> Mon profil
            </a>
            <a
              href="#account-settings"
              class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              <i class="fas fa-cog mr-2 opacity-70"></i> Paramètres
            </a>
            <a
              href="#admin-logs"
              class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              <i class="fas fa-history mr-2 opacity-70"></i> Historique
              d'actions
            </a>
            <a
              href="#logout"
              class="block px-3 py-2 rounded-md text-base font-medium text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se déconnecter
            </a>
          </div>
        </div>
      </div>
    </nav>

      <jsp:include page="includes/admin_sidebar.jsp">
        <jsp:param name="activePage" value="reservations" />
      </jsp:include>

      <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
          <div class="py-8 px-4 md:px-8 pb-0">

            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                    <div>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Gestion des reservations</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Liste de toutes les reservations de la plateforme.</p>
                    </div>
                </div>

                 
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8 justify-center">                   

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 ">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                                <i class="fas fa-user text-admin-primary dark:text-admin-secondary"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Total reservations</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${pageStats.total}"/>
                                    </h3>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 dark:bg-green-900/30 mr-4">
                                <i class="fas fa-check-circle text-green-600 dark:text-green-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">reservations Actives</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white"><c:out value="${pageStats.active}"/></h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    (<fmt:formatNumber value="${pageStats.activePercentage}" maxFractionDigits="0"/>% du total)
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-red-100 dark:bg-red-900/30 mr-4">
                                <i class="fas fa-x text-red-600 dark:text-red-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">reservations Inactifs</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white"><c:out value="${pageStats.inactive}"/></h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    (<fmt:formatNumber value="${pageStats.inactivePercentage}" maxFractionDigits="0"/>% du total)
                                </p>
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm mb-8 p-5">
                    <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                        <div class="flex-1">
                        <form action="" method="GET">
                            <div class="relative">
                                <input 
                                    type="text" 
                                    name="search" 
                                    placeholder="Rechercher par nom, email ou ville..." 
                                    class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-sm"
                                    value=""
                                >
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                                    </div>
                                    </div>
                        </form>
                            </div>
                        
                        <div class="relative inline-block text-left" id="status-filter-container">
                            <button id="status-filter-button" class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                                <span>Statut: Tous</span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                            <div id="status-filter-dropdown" class="filter-dropdown right-0 hidden">
                                <div class="option active" data-value="all">Tous les statuts</div>
                                <div class="option" data-value="active">Actifs</div>
                                <div class="option" data-value="inactive">Inactifs</div>
                         
                            </div>
                        </div>
                        

                        <div class="relative inline-block text-left" id="sort-filter-container">
                            <button id="sort-filter-button" class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                                <span>Trier par 
                                    
                                </span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                            <div id="sort-filter-dropdown" class="filter-dropdown right-0 hidden w-full">
                                <div class="flex flex-col">
                                    <a href="" 
                                    class="option block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Plus récents
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Plus anciens
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nom (A-Z)
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nom (Z-A)
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nombre de réservations
                                    </a>
                                </div>
                            </div>
                        </div>
                          
                    </div>
                </div>
      </main>
    </div>
  </body>
</html>
