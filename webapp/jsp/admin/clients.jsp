<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Clients - CampShare Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'forest': '#2D5F2B',
                        'meadow': '#4F7942',
                        'earth': '#8B7355',
                        'wood': '#D2B48C',
                        'sky': '#5D9ECE',
                        'water': '#1E7FCB',
                        'sunlight': '#FFAA33',
                        'admin': {
                            'primary': '#1E40AF',
                            'secondary': '#3B82F6',
                            'accent': '#60A5FA',
                            'light': '#DBEAFE',
                            'dark': '#1E3A8A'
                        }
                    }
                }
            },
            darkMode: 'class',
        }

        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.documentElement.classList.add('dark');
        }
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
            if (event.matches) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        });
    </script>
 
</head>

<body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col">

        <jsp:include page="includes/admin_header.jsp"></jsp:include>


        <jsp:include page="includes/admin_sidebar.jsp">
            <jsp:param name="activePage" value="clients"/>
        </jsp:include>
    <!-- Dashboard container -->

        
        <!-- Main content -->
        <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
            <div class="py-8 px-4 md:px-8 pb-0">
                <!-- Dashboard header -->
                <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                    <div>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Gestion des Clients</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Liste de tous les clients de la plateforme.</p>
                    </div>
                </div>
                
                <!-- Stats cards -->
                 
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8 justify-center">                    <!-- Stats card 1 - Total Clients --> 

                    <!-- Stats card 1 - Total Clients -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 ">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                                <i class="fas fa-user text-admin-primary dark:text-admin-secondary"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Clients</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${pageStats.total}"/>
                                    </h3>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Stats card 2 - Active Clients -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 dark:bg-green-900/30 mr-4">
                                <i class="fas fa-check-circle text-green-600 dark:text-green-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Clients Actifs</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white"><c:out value="${pageStats.active}"/></h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    (<fmt:formatNumber value="${pageStats.activePercentage}" maxFractionDigits="0"/>% du total)
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Stats card 2 - Active Clients -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-red-100 dark:bg-red-900/30 mr-4">
                                <i class="fas fa-x text-red-600 dark:text-red-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Clients Inactifs</p>
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
                
                <!-- Filters and search -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm mb-8 p-5">
                    <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                        <!-- Search bar -->
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
                        
                        <!-- Status filter -->
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
                        
                        <!-- Sort filter -->
                       

                        <!-- Sort filter -->
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
              
                    

                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm my-8 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm admin-table">
                            <thead>
                                <tr>
                                    <th>Client</th>
                                    <th>Contact</th>
                                    <th>Inscrit le</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="client" items="${clients}">
                                    <tr>
                                       <td>
                                            <div class="flex items-center">
                                                <c:choose>
                                                    <c:when test="${not empty client.avatarUrl}">
                                                        <img class="h-10 w-10 rounded-full object-cover mr-4"
                                                            src="${pageContext.request.contextPath}/uploads/${client.avatarUrl}"
                                                            alt="Avatar">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img class="h-10 w-10 rounded-full object-cover mr-4"
                                                            src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                                                            alt="Avatar">
                                                    </c:otherwise>
                                                </c:choose>

                                                <div>
                                                    <p class="font-semibold"><c:out value="${client.firstName} ${client.lastName}"/></p>
                                                    <p class="text-xs text-gray-500">@<c:out value="${client.username}"/></p>
                                                </div>
                                            </div>
                                        </td>

                                        <td>
                                            <p><c:out value="${client.email}"/></p>
                                            <p class="text-xs text-gray-500"><c:out value="${client.phoneNumber}"/></p>
                                        </td>
                                        <td><fmt:formatDate value="${client.createdAt}" pattern="dd MMM yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${client.active}">
                                                    <span class="badge badge-success">Actif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>                                        <td>
                                            <button onclick="showUserDetails(${client.id})" 
                                                    class="p-2 text-xs rounded-md bg-blue-100 hover:bg-blue-200" title="Voir les détails">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
          </div>
    </div>

        <div id="user-detail-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] flex flex-col">

                <div class="p-5 border-b flex items-center justify-between">
                    <div class="flex items-center">
                        <img id="modal-user-avatar" src="" alt="Avatar" class="w-12 h-12 rounded-full object-cover mr-4" />
                        <div>
                            <h3 id="modal-user-fullname" class="text-xl font-bold"></h3>
                            <span id="modal-user-role-badge" class="badge"></span>
                            
                            <span id="modal-user-id-hidden" class="hidden"></span>
                        </div>
                    </div>
                    <button id="close-user-modal" class="text-gray-500 hover:text-gray-700"><i class="fas fa-times"></i></button>
                </div>

                <div class="p-5 overflow-y-auto">
                    <h4 class="font-semibold text-lg mb-3">Informations personnelles</h4>
                    <div class="space-y-2 text-sm">
                        <div class="flex justify-between"><span class="text-gray-600">Email:</span> <span id="modal-user-email" class="font-medium"></span></div>
                        <div class="flex justify-between"><span class="text-gray-600">Téléphone:</span> <span id="modal-user-phone" class="font-medium"></span></div>
                        <div class="flex justify-between"><span class="text-gray-600">Inscrit le:</span> <span id="modal-user-created-at" class="font-medium"></span></div>
                        <div class="flex justify-between"><span class="text-gray-600">Statut:</span> <span id="modal-user-status-badge" class="badge"></span></div>
                    </div>
                </div>

                <div class="p-5 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50 rounded-b-lg">
                    <h4 class="font-semibold text-gray-900 dark:text-white text-lg mb-3">Actions Administratives</h4>
                    <div class="flex items-center justify-between">
                        <label class="flex items-center cursor-pointer">
                            <span class="text-gray-700 dark:text-gray-300 mr-3">Compte Actif</span>
                            <div class="relative">
                                <input type="checkbox" id="modal-user-active-toggle" class="sr-only peer">
                                <div class="block bg-gray-200 dark:bg-gray-600 w-14 h-8 rounded-full peer-checked:bg-admin-primary"></div>
                                <div class="dot absolute left-1 top-1 bg-white dark:bg-gray-200 w-6 h-6 rounded-full transition-transform peer-checked:translate-x-full"></div>
                            </div>
                        </label>
                        <button id="modal-save-changes" class="px-4 py-2 bg-admin-primary hover:bg-admin-dark text-white rounded-md text-sm shadow-sm">
                            Sauvegarder
                        </button>
                    </div>
                </div>
                </div>
        </div>
            
    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>

</body>
</html>