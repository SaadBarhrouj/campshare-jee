<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="">
    <title>Tableau de bord Administrateur - CampShare </title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard.css">   
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'forest': '#2D5F2B', 'meadow': '#4F7942', 'earth': '#8B7355',
                        'wood': '#D2B48C', 'sky': '#5D9ECE', 'water': '#1E7FCB',
                        'sunlight': '#FFAA33',
                        'admin': {
                            'primary': '#1E40AF', 'secondary': '#3B82F6', 'accent': '#60A5FA',
                            'light': '#DBEAFE', 'dark': '#1E3A8A'
                        }
                    }
                }
            },
            darkMode: 'class',
        };

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
            <jsp:param name="activePage" value="dashboard"/>
        </jsp:include>
        <!-- Main content -->
    <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
            <div class="py-8 px-4 md:px-8">
                <!-- Dashboard header -->
                <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                    <div>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Bienvenue, <c:out value="${authenticatedUser.username}"/>! Voici une vue d'ensemble de
                            la plateforme.</p>
                    </div>
                </div>

                <!-- Stats cards -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <!-- Stats card 1 - Utilisateurs -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                                <i class="fas fa-users text-admin-primary dark:text-admin-secondary"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Utilisateurs</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${dashboardStats.totalUsers}"/>
                                    </h3>
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    <c:out value="${dashboardStats.totalClients}"/> clients, <c:out value="${dashboardStats.totalPartners}"/> partenaires
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Stats card 2 - Équipements -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-indigo-100 dark:bg-indigo-900/30 mr-4">
                                <i class="fas fa-campground text-indigo-600 dark:text-indigo-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Annonces</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${dashboardStats.totalListings}"/>
                                    </h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Stats card 3 - Réservations -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 dark:bg-green-900/30 mr-4">
                                <i class="fas fa-calendar-check text-green-600 dark:text-green-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Réservations</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${dashboardStats.totalReservations}"/>
                                    </h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Stats card 4 - Revenu -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-amber-100 dark:bg-amber-900/30 mr-4">
                                <i class="fas fa-money-bill-wave text-amber-600 dark:text-amber-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Revenu </p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                       <c:out value="${dashboardStats.totalRevenue}"/>
                                    </h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    &nbsp;
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent activity and issues -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                        <div class="p-4">
                            <div class="chart-container">
                                <div
                                    class="w-full h-full flex items-center justify-center bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                    <div class="chart-container bg-white dark:bg-gray-800 p-4 rounded-lg flex justify-center items-center">
                                        <canvas id="registrationBarChart"></canvas>
                                    </div>
                                </div>     
                                
                            </div>
                        </div>
                    </div>
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">

                                                <div class="p-4">
                            <div class="chart-container">
                                <div
                                    class="w-full h-full flex items-center justify-center bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                    <div class="chart-container bg-white dark:bg-gray-800 p-4 rounded-lg flex justify-center items-center">
                                        <canvas id="bookingCountChart"></canvas>
                                    </div>
                                </div>     
                                
                            </div>
                        </div>
                    </div>
                </div>

               
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm">
            <div class="border-b border-gray-200 dark:border-gray-700">
                <div class="flex overflow-x-auto px-4">
                    <button data-tab="users" class="admin-tab active">Utilisateurs récents</button>
                    <button data-tab="partners" class="admin-tab">Partenaires récents</button>
                    <button data-tab="listings" class="admin-tab">Annonces récentes</button>
                </div>
            </div>

    
            <div class="p-4">
                <div id="users-content" class="tab-content">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm admin-table">
                            <thead>
                                <tr>
                                    <th>Nom</th>
                                    <th>Nom d'utilisateur</th>
                                    <th>Email</th>
                                    <th>Rôle</th>
                                    <th>Inscrit le</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="client" items="${recentClients}">
                                    <tr>
                                        <td>
                                            <div class="flex items-center">
                                                <c:choose>
                                                    <c:when test="${not empty fn:trim(client.avatarUrl)}">
                                                        <img class="h-8 w-8 rounded-full object-cover mr-3" src="${pageContext.request.contextPath}/uploads/${client.avatarUrl}" alt="Avatar">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img class="h-8 w-8 rounded-full object-cover mr-3" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                                    </c:otherwise>
                                                </c:choose>
                                                <span><c:out value="${client.firstName} ${client.lastName}"/></span>
                                            </div>
                                        </td>
                                        <td><c:out value="${client.username}"/></td>
                                        <td><c:out value="${client.email}"/></td>
                                        <td><span class="badge badge-info">Client</span></td>
                                        <td><fmt:formatDate value="${client.createdAt}" pattern="dd MMM, yyyy"/></td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty recentClients}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-gray-500">Aucun client récent à afficher.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>


                <div id="partners-content" class="tab-content hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm admin-table">
                            <thead>
                                <tr>
                                    <th>Nom du Partenaire</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Devenu partenaire le</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="partner" items="${recentPartners}">
                                    <tr>
                                        <td>
                                            <div class="flex items-center">
                                                <c:choose>
                                                    <c:when test="${not empty fn:trim(partner.avatarUrl)}">
                                                        <img class="h-8 w-8 rounded-full object-cover mr-3" src="${pageContext.request.contextPath}/uploads/${partner.avatarUrl}" alt="Avatar">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img class="h-8 w-8 rounded-full object-cover mr-3" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                                    </c:otherwise>
                                                </c:choose>
                                                <span><c:out value="${partner.firstName} ${partner.lastName}"/></span>
                                            </div>
                                        </td>
                                        <td><c:out value="${partner.email}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${partner.active}">
                                                    <span class="badge badge-success">Actif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${partner.createdAt}" pattern="dd MMM, yyyy"/></td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty recentPartners}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-gray-500">Aucun partenaire récent à afficher.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="listings-content" class="tab-content hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm admin-table">
                            <thead>
                                <tr>
                                    <th>Titre de l'annonce</th>
                                    <th>Partenaire</th>
                                    <th>Prix / jour</th>
                                    <th>Créée le</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="listing" items="${recentListings}">
                                    <tr>
                                        <td><c:out value="${listing.item.title}"/></td>
                                        <td>
                                        <c:if test="${not empty listing.item && not empty listing.item.partner}">
                                            <c:out value="${listing.item.partner.firstName} ${listing.item.partner.lastName}"/>
                                        </c:if>
                                        </td>                                        
                                        <td><fmt:formatNumber value="${listing.item.pricePerDay}" type="currency" currencySymbol="MAD"/></td>
                                        <td><fmt:formatDate value="${listing.createdAt}" pattern="dd MMM, yyyy"/></td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty recentListings}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-gray-500">Aucune annonce récente à afficher.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</body>

</html>