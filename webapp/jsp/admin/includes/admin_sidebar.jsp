<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!-- Dashboard container -->
<div class="flex flex-col md:flex-row pt-16">
  <!-- Sidebar (hidden on mobile) -->
  <aside
    class="hidden md:block w-64 bg-white dark:bg-gray-800 shadow-md h-screen fixed overflow-y-auto"
  >
    <div class="p-5">
      <div class="mb-6 px-3">
        <h5
          class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2"
        >
          Menu Principal
        </h5>
        <nav class="space-y-1">
          <a
            href="${pageContext.request.contextPath}/admin/dashboard"
            class="sidebar-link ${param.activePage == 'dashboard' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-tachometer-alt w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Tableau de bord
          </a>
        </nav>
      </div>

      <div class="mb-6 px-3">
        <h5
          class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2"
        >
          Utilisateurs
        </h5>
        <nav class="space-y-1">
          <a
            href="${pageContext.request.contextPath}/admin/partners"
            class="sidebar-link ${param.activePage == 'partners' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Partenaires
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
            >
              <c:out value="${dashboardStats.totalPartners}"
            /></span>
          </a>
          <a
            href="${pageContext.request.contextPath}/admin/clients"
            class="sidebar-link ${param.activePage == 'clients' ? 'active' : ''} sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-users w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Clients
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
              ><c:out value="${dashboardStats.totalClients}"
            /></span>
          </a>
        </nav>
      </div>

      <div class="mb-6 px-3">
        <h5
          class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2"
        >
          Equi. Réserv. & Avis
        </h5>
        <nav class="space-y-1">
          <a
            href="${pageContext.request.contextPath}/admin/listings"
            class="sidebar-link ${param.activePage == 'listings' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-campground w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Annonces
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
            >
              <c:out value="${dashboardStats.totalListings}" />
            </span>
          </a>

          <a
            href="${pageContext.request.contextPath}/admin/reservations"
            class="sidebar-link ${param.activePage == 'reservations' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-calendar-alt w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Réservations
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
              ><c:out value="${dashboardStats.totalReservations}" />
            </span>
          </a>

        </nav>
      </div>
    </div>
  </aside>

  <!-- Mobile sidebar toggle -->
  <div
    id="mobile-sidebar-overlay"
    class="md:hidden fixed inset-0 bg-gray-800 bg-opacity-50 z-40 hidden"
  ></div>

  <div class="md:hidden fixed bottom-4 right-4 z-50">
    <button
      id="mobile-sidebar-toggle"
      class="w-14 h-14 rounded-full bg-admin-primary dark:bg-admin-secondary text-white shadow-lg flex items-center justify-center"
    >
      <i class="fas fa-bars text-xl"></i>
    </button>
  </div>

  <div
    id="mobile-sidebar"
    class="md:hidden fixed inset-y-0 left-0 transform -translate-x-full w-64 bg-white dark:bg-gray-800 shadow-xl z-50 transition-transform duration-300"
  >
    <div class="p-5">
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-xl font-bold text-gray-900 dark:text-white">
          Menu Admin
        </h2>
        <button
          id="close-mobile-sidebar"
          class="text-gray-600 dark:text-gray-400 focus:outline-none"
        >
          <i class="fas fa-times text-xl"></i>
        </button>
      </div>

      <div class="mb-6">
        <h5
          class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2"
        >
          Menu Principal
        </h5>
        <nav class="space-y-1">
          <a
            href="#dashboard"
            class="sidebar-link ${param.activePage == 'dashboards' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium rounded-md transition-colors"
          >
            <i
              class="fas fa-tachometer-alt w-5 mr-3 text-admin-primary dark:text-admin-secondary"
            ></i>
            Tableau de bord
          </a>
          <!-- Dans la section MENU PRINCIPAL -->
          <div
            class="sidebar-link flex items-center px-3 py-2.5"
            id="clients-link"
          >
            <i class="fas fa-users w-5 mr-3"></i>
            <span>Clients</span>
            <span class="ml-auto bg-blue-100 text-blue-800 rounded-full px-2"
              >33
            </span>
          </div>
          <a
            href="${pageContext.request.contextPath}/admin/partners "
            id="partners-link"
            class="sidebar-link ${param.activePage == 'partners' ? 'active' : ''} flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            id="partners-link"
          >
            <i
              class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Partenaires
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
            >
              33
            </span>
          </a>
          <a
            href=""
            id="partners-link"
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            id="partners-link"
          >
            <i
              class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>

            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
              >33</span
            >
          </a>
          <a
            href="#reservations"
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-calendar-alt w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Réservations
            <span
              class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
              >278</span
            >
          </a>
          <a
            href=""
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-star w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Avis
            <span
              class="ml-auto bg-red-100 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-xs rounded-full h-5 px-1.5 flex items-center justify-center"
            >
            </span>
          </a>
        </nav>
      </div>

      <div class="mb-6">
        <h5
          class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2"
        >
          Utilisateurs
        </h5>
        <nav class="space-y-1">
          <a
            href="#analytics"
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-chart-line w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Statistiques
          </a>
          <a
            href="#financial"
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-money-bill-wave w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Finances
          </a>
          <a
            href="#reports-gen"
            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <i
              class="fas fa-file-alt w-5 mr-3 text-gray-500 dark:text-gray-400"
            ></i>
            Rapports
          </a>
        </nav>
      </div>
    </div>
  </div>
</div>
