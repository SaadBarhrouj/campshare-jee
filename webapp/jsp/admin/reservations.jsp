<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Réservations - Admin</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css" rel="stylesheet" />

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
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 bg-gray-50 dark:bg-gray-900 min-h-screen flex flex-col">

<jsp:include page="includes/admin_header.jsp"></jsp:include>
<jsp:include page="includes/admin_sidebar.jsp">
    <jsp:param name="activePage" value="reservations"/>
</jsp:include>

<main class="flex-1 md:ml-64 min-h-screen">
    <div class="py-8 px-4 md:px-8">

        <!-- Success Alert -->
        <c:if test="${param.updated == 'true'}">
            <div id="alert-success" class="flex items-center p-4 mb-6 text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400" role="alert">
                <i class="fas fa-check-circle"></i>
                <span class="sr-only">Success</span>
                <div class="ms-3 text-sm font-medium">
                    La réservation a été mise à jour avec succès !
                </div>
                <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-green-50 text-green-500 rounded-lg focus:ring-2 focus:ring-green-400 p-1.5 hover:bg-green-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-success" aria-label="Close">
                    <span class="sr-only">Close</span>
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </c:if>
        
        <!-- Breadcrumb -->
        <nav class="flex mb-6" aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-admin-secondary dark:text-gray-400 dark:hover:text-white">
                        <i class="fas fa-home mr-2"></i> Accueil
                    </a>
                </li>
                <li aria-current="page">
                    <div class="flex items-center">
                        <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2 dark:text-gray-400">Réservations</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Gestion des Réservations</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Liste de toutes les réservations de la plateforme.</p>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 mb-8">
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                        <i class="fas fa-calendar-check text-admin-primary dark:text-admin-secondary"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Total</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <c:out value="${totalReservations}"/>
                        </h3>
                    </div>
                </div>
            </div>
            
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-green-100 dark:bg-green-900/30 mr-4">
                        <i class="fas fa-check-circle text-green-600 dark:text-green-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Confirmées</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <c:out value="${confirmedCount}"/>
                        </h3>
                        <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                            (<fmt:formatNumber value="${confirmedPercentage}" maxFractionDigits="0"/>%)
                        </p>
                    </div>
                </div>
            </div>

            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-yellow-100 dark:bg-yellow-900/30 mr-4">
                        <i class="fas fa-clock text-yellow-600 dark:text-yellow-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">En attente</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <c:out value="${pendingCount}"/>
                        </h3>
                        <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                            (<fmt:formatNumber value="${pendingPercentage}" maxFractionDigits="0"/>%)
                        </p>
                    </div>
                </div>
            </div>

            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-blue-100 dark:bg-blue-900/30 mr-4">
                        <i class="fas fa-flag-checkered text-blue-600 dark:text-blue-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Terminées</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <c:out value="${completedCount}"/>
                        </h3>
                        <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                            (<fmt:formatNumber value="${completedPercentage}" maxFractionDigits="0"/>%)
                        </p>
                    </div>
                </div>
            </div>

            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-red-100 dark:bg-red-900/30 mr-4">
                        <i class="fas fa-times-circle text-red-600 dark:text-red-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Annulées</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                            <c:out value="${cancelledCount + rejectedCount}"/>
                        </h3>
                        <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                            (<fmt:formatNumber value="${cancelledPercentage + rejectedPercentage}" maxFractionDigits="0"/>%)
                        </p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filters -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm mb-8 p-5">
            <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                <div class="flex-1">
                    <form action="${pageContext.request.contextPath}/admin/reservations" method="GET" id="searchForm">
                        <div class="relative">
                            <input 
                                type="text" 
                                name="search" 
                                placeholder="Rechercher par client, partenaire ou équipement..." 
                                class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-base"
                                value="${param.search}"
                            >
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                            </div>
                        </div>
                    </form>
                </div>
                
                <div class="relative inline-block text-left">
                    <select name="status" onchange="filterByStatus(this.value)" 
                            class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                        <option value="all" ${param.status == 'all' || empty param.status ? 'selected' : ''}>Tous les statuts</option>
                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>En attente</option>
                        <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Confirmées</option>
                        <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Terminées</option>
                        <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Annulées</option>
                        <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejetées</option>
                    </select>
                </div>

                <div class="relative inline-block text-left">
                    <select name="sort" onchange="sortReservations(this.value)"
                            class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-base font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                        <option value="date_desc" ${param.sort == 'date_desc' || empty param.sort ? 'selected' : ''}>Plus récentes</option>
                        <option value="date_asc" ${param.sort == 'date_asc' ? 'selected' : ''}>Plus anciennes</option>
                        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Prix décroissant</option>
                        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Prix croissant</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Reservations Cards -->
        <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="reservation" items="${reservations}">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-300 p-6">
                            <!-- Header with status -->
                            <div class="flex items-center justify-between mb-4">
                                <div class="flex items-center">
                                    <i class="fas fa-calendar-check text-admin-primary dark:text-admin-secondary mr-2"></i>
                                    <span class="text-sm text-gray-500 dark:text-gray-400">Réservation #${reservation.id}</span>
                                </div>
                                <c:set var="status" value="${reservation.status}"/>
                                <span class="px-2 py-1 text-xs font-medium rounded-full
                                    ${status == 'confirmed' ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : ''}
                                    ${status == 'pending' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400' : ''}
                                    ${status == 'completed' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : ''}
                                    ${status == 'cancelled' ? 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400' : ''}
                                    ${status == 'rejected' ? 'bg-gray-100 text-gray-800 dark:bg-gray-900/30 dark:text-gray-400' : ''}">
                                    <c:choose>
                                        <c:when test="${status == 'pending'}">En attente</c:when>
                                        <c:when test="${status == 'confirmed'}">Confirmée</c:when>
                                        <c:when test="${status == 'completed'}">Terminée</c:when>
                                        <c:when test="${status == 'cancelled'}">Annulée</c:when>
                                        <c:when test="${status == 'rejected'}">Rejetée</c:when>
                                        <c:otherwise><c:out value="${status}"/></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <!-- Equipment info -->
                            <div class="mb-4">
                                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2 line-clamp-2">
                                    <c:out value="${reservation.listing.item.title}"/>
                                </h3>
                                <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
                                    <c:out value="${reservation.listing.item.description}"/>
                                </p>
                            </div>

                            <!-- Client and Partner info -->
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Client</p>
                                    <div class="flex items-center">
                                        <c:choose>
                                            <c:when test="${not empty fn:trim(reservation.client.avatarUrl)}">
                                                <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/uploads/${reservation.client.avatarUrl}" alt="Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                            </c:otherwise>
                                        </c:choose>
                                        <button 
                                            onclick="showUserDetails(${reservation.client.id})" 
                                            class="text-sm font-medium text-gray-900 dark:text-white hover:text-admin-secondary dark:hover:text-admin-accent transition-colors truncate">
                                            <c:out value="${reservation.client.firstName} ${reservation.client.lastName}"/>
                                        </button>
                                    </div>
                                </div>
                                

                                <div>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 mb-1">Partenaire</p>
                                    <div class="flex items-center">
                                        <c:choose>
                                            <c:when test="${not empty fn:trim(reservation.partner.avatarUrl)}">
                                                <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/uploads/${reservation.partner.avatarUrl}" alt="Avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                            </c:otherwise>
                                        </c:choose>
                                        <button 
                                            onclick="showUserDetails(${reservation.partner.id})" 
                                            class="text-sm font-medium text-gray-900 dark:text-white hover:text-admin-secondary dark:hover:text-admin-accent transition-colors truncate">
                                            <c:out value="${reservation.partner.firstName} ${reservation.partner.lastName}"/>
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <!-- Dates and price -->
                            <div class="space-y-2 mb-4">
                                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                    <i class="fas fa-calendar mr-2"></i>
                                    <c:out value="${reservation.startDate}" /> - 
                                    <c:out value="${reservation.endDate}" />
                                </div>
                                <div class="flex items-center text-sm text-gray-600 dark:text-gray-400">
                                    <i class="fas fa-calendar-days mr-2"></i>
                                    ${reservation.days} jour(s)
                                </div>
                                <div class="flex items-center justify-between">
                                    <span class="text-xs text-gray-500 dark:text-gray-400">
                                        <c:out value="${reservation.createdAt}" />
                                    </span>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="flex space-x-2">
                                <a href="${pageContext.request.contextPath}/admin/listings/details?id=${reservation.listing.id}" 
                                   class="flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md text-admin-primary dark:text-admin-secondary border border-admin-primary dark:border-admin-secondary hover:bg-admin-primary hover:text-white dark:hover:bg-admin-secondary dark:hover:text-gray-900 transition-colors">
                                    <i class="fas fa-eye mr-1"></i> Voir l'annonce
                                </a>
                                <button 
                                    onclick="showReservationDetails(${reservation.id})"
                                    class="flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md text-white bg-admin-primary hover:bg-admin-dark dark:bg-admin-secondary dark:hover:bg-admin-accent transition-colors">
                                    <i class="fas fa-info-circle mr-1"></i> Détails
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-span-full text-center py-12">
                        <i class="fas fa-calendar-times text-6xl text-gray-300 dark:text-gray-600 mb-4"></i>
                        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Aucune réservation trouvée</h3>
                        <p class="text-gray-600 dark:text-gray-400">Il n'y a aucune réservation correspondant à vos critères de recherche.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>


</main>

<!-- Modal for reservation details -->
<div id="reservationDetailsModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Détails de la réservation</h3>
                <button onclick="closeReservationDetails()" class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div id="reservationDetailsContent">
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/admin_user_details_modal.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>

<script>
    function filterByStatus(status) {
        const urlParams = new URLSearchParams(window.location.search);
        if (status === 'all') {
            urlParams.delete('status');
        } else {
            urlParams.set('status', status);
        }
        window.location.search = urlParams.toString();
    }

    function sortReservations(sort) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('sort', sort);
        window.location.search = urlParams.toString();
    }

    function showReservationDetails(reservationId) {
        document.getElementById('reservationDetailsModal').classList.remove('hidden');
        document.getElementById('reservationDetailsModal').classList.add('flex');
        
        document.getElementById('reservationDetailsContent').innerHTML = `
            <div class="space-y-4">
                <p class="text-gray-600 dark:text-gray-400">Chargement des détails de la réservation #${reservationId}...</p>
            </div>
        `;
    }

    function closeReservationDetails() {
        document.getElementById('reservationDetailsModal').classList.add('hidden');
        document.getElementById('reservationDetailsModal').classList.remove('flex');
    }

    let searchTimeout;
    document.querySelector('input[name="search"]').addEventListener('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            document.getElementById('searchForm').submit();
        }, 500);
    });

    document.getElementById('reservationDetailsModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeReservationDetails();
        }
    });
</script>
</body>
</html>