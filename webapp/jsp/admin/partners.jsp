<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 


<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Partenaires - CampShare Admin</title>
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
            <jsp:param name="activePage" value="partners"/>
        </jsp:include>

        <!-- Main content -->
        <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
            <div class="py-8 px-4 md:px-8 pb-0">
                <!-- Dashboard header -->
                <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                    <div>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Gestion des Partenaires</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Liste de tous les partenaires de la plateforme</p>
                    </div>
                </div>
                
                <!-- Stats cards -->
                 
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8 justify-center">               
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 ">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                                <i class="fas fa-user text-admin-primary dark:text-admin-secondary"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Partenaires</p>
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
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Partenaires Actifs</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${pageStats.active}"/>
                                    </h3>
                                    
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
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Partenaires Inactifs</p>
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
                    <form action="${pageContext.request.contextPath}/admin/partners" method="GET">
                        <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                            
                            <div class="flex-1">
                                <div class="relative">
                                    <input 
                                        type="text" 
                                        name="search" 
                                        placeholder="Rechercher par nom, email..." 
                                        class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-sm"
                                        value="<c:out value='${searchQuery}'/>"
                                    >
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <select name="status" class="w-full md:w-auto px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-admin-primary">
                                <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Statut: Tous</option>
                                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Statut: Actifs</option>
                                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Statut: Inactifs</option>
                            </select>
                            
                            <select name="sort" class="w-full md:w-auto px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-admin-primary">
                                <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Trier par: Plus récents</option>
                                <option value="oldest" ${sortBy == 'oldest' ? 'selected' : ''}>Trier par: Plus anciens</option>
                                <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Trier par: Nom (A-Z)</option>
                                <option value="name_desc" ${sortBy == 'name_desc' ? 'selected' : ''}>Trier par: Nom (Z-A)</option>
                            </select>
                            
                            <button type="submit" class="w-full md:w-auto px-4 py-2 bg-admin-primary text-white rounded-md text-sm font-medium hover:bg-admin-dark">
                                Filtrer
                            </button>
                        </div>
                    </form>
                </div>
              
                    

                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm my-8 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm admin-table">
                            <thead>
                                <tr>
                                    <th>Partenaire</th>
                                    <th>Contact</th>
                                    <th>Inscrit le</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="partner" items="${partners}">
                                    <tr>
                                        <td>
                                            <div class="flex items-center">
                                               <c:choose>
                                                    <c:when test="${not empty partner.avatarUrl}">
                                                        <img class="h-10 w-10 rounded-full object-cover mr-4"
                                                            src="${pageContext.request.contextPath}/uploads/${partner.avatarUrl}"
                                                            alt="Avatar">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img class="h-10 w-10 rounded-full object-cover mr-4"
                                                            src="${pageContext.request.contextPath}/assets/images/default-avatar.png"
                                                            alt="Avatar">
                                                    </c:otherwise>
                                                </c:choose>

                                                <div>
                                                    <p class="font-semibold"><c:out value="${partner.firstName} ${partner.lastName}"/></p>
                                                    <p class="text-xs text-gray-500">@<c:out value="${partner.username}"/></p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <p><c:out value="${partner.email}"/></p>
                                            <p class="text-xs text-gray-500"><c:out value="${partner.phoneNumber}"/></p>
                                        </td>
                                        <td><fmt:formatDate value="${partner.createdAt}" pattern="dd MMM yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${partner.active}">
                                                    <span class="badge badge-success">Actif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>                                        <td>
                                            <button onclick="showUserDetails(${partner.id})" 
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

        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm my-8 p-4 flex items-center justify-between">
            
            <div>
                <p class="text-sm text-gray-700 dark:text-gray-400">
                    Page <span class="font-medium">${currentPage}</span> sur <span class="font-medium">${totalPages}</span>
                </p>
            </div>

            <c:if test="${totalPages > 1}">
                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                    
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/admin/partners?page=${currentPage - 1}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                        class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700">
                            <i class="fas fa-chevron-left h-5 w-5"></i>
                        </a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/partners?page=${i}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                        class="relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium 
                                ${i == currentPage ? 'z-10 bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-accent' : 'bg-white dark:bg-gray-800 text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/partners?page=${currentPage + 1}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                        class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700">
                            <i class="fas fa-chevron-right h-5 w-5"></i>
                        </a>
                    </c:if>
                    
                </nav>
            </c:if>
        </div>

    <jsp:include page="includes/admin_user_details_modal.jsp" />
            
    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
</body>
</html>