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
            <form action="${pageContext.request.contextPath}/admin/reservations" method="GET">
                <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                    
                    <%-- Recherche --%>
                    <div class="flex-1">
                        <div class="relative">
                            <input type="text" name="search" placeholder="Rechercher (client, partenaire, titre)..." 
                                class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 text-sm focus:outline-none focus:ring-2 focus:ring-admin-primary"
                                value="<c:out value='${searchQuery}'/>">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                            </div>
                        </div>
                    </div>
                    
                    <%-- Filtre Statut --%>
                    <select name="status" class="w-full md:w-auto px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-admin-primary">
                        <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Statut: Tous</option>
                        <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>En attente</option>
                        <option value="confirmed" ${statusFilter == 'confirmed' ? 'selected' : ''}>Confirmées</option>
                        <option value="completed" ${statusFilter == 'completed' ? 'selected' : ''}>Terminées</option>
                        <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Annulées</option>
                        <option value="rejected" ${statusFilter == 'rejected' ? 'selected' : ''}>Rejetées</option>
                    </select>
                    
                    <%-- Filtre Tri --%>
                    <select name="sort" class="w-full md:w-auto px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-admin-primary">
                        <option value="date_desc" ${sortBy == 'date_desc' ? 'selected' : ''}>Trier par: Plus récentes</option>
                        <option value="date_asc" ${sortBy == 'date_asc' ? 'selected' : ''}>Trier par: Plus anciennes</option>
                        <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Prix décroissant</option>
                        <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Prix croissant</option>
                    </select>
                    
                    <button type="submit" class="w-full md:w-auto px-4 py-2 bg-admin-primary text-white rounded-md text-sm font-medium hover:bg-admin-dark">
                        Filtrer
                    </button>
                </div>
            </form>
        </div>

        <!-- Reservations Cards -->
        <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="reservation" items="${reservations}">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-300 flex flex-col">
                            <div class="p-6">
                                <div class="flex justify-between items-start mb-4">
                                    <div>
                                        <p class="text-sm text-gray-500 dark:text-gray-400">Réservation #${reservation.id}</p>
                                        <h3 class="font-bold text-lg text-gray-900 dark:text-white leading-tight">
                                            <c:out value="${reservation.listing.item.title}"/>
                                        </h3>
                                    </div>
                                    <c:set var="status" value="${reservation.status}"/>
                                    <span class="px-2.5 py-1 text-xs font-semibold rounded-full
                                        ${status == 'confirmed' ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : ''}
                                        ${status == 'pending' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400' : ''}
                                        ${status == 'completed' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400' : ''}
                                        ${status == 'cancelled' ? 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400' : ''}
                                        ${status == 'rejected' ? 'bg-gray-200 text-gray-800 dark:bg-gray-700 dark:text-gray-400' : ''}">
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

                                <div class="grid grid-cols-2 gap-4 mb-5 text-sm">
                                    <div>
                                        <p class="text-gray-500 dark:text-gray-400">Client</p>
                                        <div class="flex items-center mt-2">
                                            <c:choose>
                                                <c:when test="${not empty fn:trim(reservation.client.avatarUrl)}">
                                                    <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/uploads/${reservation.client.avatarUrl}" alt="Avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                                </c:otherwise>
                                            </c:choose>
                                            <button onclick="showUserDetails(${reservation.client.id})" class="font-medium text-gray-800 dark:text-gray-200 hover:text-admin-secondary dark:hover:text-admin-accent transition-colors truncate">
                                                <c:out value="${reservation.client.firstName} ${reservation.client.lastName}"/>
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <p class="text-gray-500 dark:text-gray-400">Partenaire</p>
                                        <div class="flex items-center mt-2">
                                            <c:choose>
                                                <c:when test="${not empty fn:trim(reservation.partner.avatarUrl)}">
                                                    <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/uploads/${reservation.partner.avatarUrl}" alt="Avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <img class="w-6 h-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                                </c:otherwise>
                                            </c:choose>
                                            <button onclick="showUserDetails(${reservation.partner.id})" class="font-medium text-gray-800 dark:text-gray-200 hover:text-admin-secondary dark:hover:text-admin-accent transition-colors truncate">
                                                <c:out value="${reservation.partner.firstName} ${reservation.partner.lastName}"/>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="border-t border-b border-gray-200 dark:border-gray-700 my-5 py-4">
                                    <div class="grid grid-cols-3 gap-4 text-sm text-center">
                                        <div>
                                            <p class="text-gray-500 dark:text-gray-400">Début</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200 mt-2">
                                                <fmt:formatDate value="${reservation.startDate}" pattern="dd MMM yy"/>
                                            </p>
                                        </div>
                                        <div>
                                            <p class="text-gray-500 dark:text-gray-400">Fin</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200 mt-2">
                                                <fmt:formatDate value="${reservation.endDate}" pattern="dd MMM yy"/>
                                            </p>
                                        </div>
                                        <div>
                                            <p class="text-gray-500 dark:text-gray-400">Durée</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200 mt-2">${reservation.days} jour(s)</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="flex justify-between items-center text-sm">
                                    <p class="text-gray-500 dark:text-gray-400">Montant total</p>
                                    <p class="font-bold text-lg text-gray-900 dark:text-white">
                                        <fmt:formatNumber value="${reservation.montantTotal}" type="currency" currencySymbol="MAD"/>
                                    </p>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="mt-auto p-5 bg-gray-50 dark:bg-gray-800/50 border-t border-gray-200 dark:border-gray-700 flex space-x-3">
                                <a href="${pageContext.request.contextPath}/admin/listings/details?id=${reservation.listing.id}" 
                                   class="flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md text-admin-primary dark:text-admin-accent bg-admin-light hover:bg-blue-200 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors">
                                    <i class="fas fa-eye mr-2"></i> Annonce
                                </a>
                                <button 
                                    data-reservation-id="${reservation.id}"
                                    class="flex-1 flex items-center justify-center px-3 py-2 text-xs font-medium rounded-md text-admin-primary dark:text-admin-accent bg-admin-light hover:bg-blue-200 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors show-reservation-details">
                                    <i class="fas fa-star mr-2"></i> Avis                 
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-span-full text-center py-16 text-gray-500">
                        <i class="fas fa-box-open fa-3x mb-4"></i>
                        <h3 class="text-xl font-semibold">Aucune réservation trouvée</h3>
                        <p>Il n'y a actuellement aucune réservation à afficher avec les filtres actuels.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm my-8 p-4 flex items-center justify-between">
            <div>
                <p class="text-sm text-gray-700 dark:text-gray-400">
                    Page <span class="font-medium">${currentPage}</span> sur <span class="font-medium">${totalPages}</span>
                </p>
            </div>

            <c:if test="${totalPages > 1}">
                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/admin/reservations?page=${currentPage - 1}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                           class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-700">
                            <i class="fas fa-chevron-left h-5 w-5"></i>
                        </a>
                    </c:if>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/reservations?page=${i}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                           class="relative inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium 
                                  ${i == currentPage ? 'z-10 bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-accent' : 'bg-white dark:bg-gray-800 text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-700'}">
                            ${i}
                        </a>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/admin/reservations?page=${currentPage + 1}&search=${searchQuery}&status=${statusFilter}&sort=${sortBy}"
                           class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-700">
                            <i class="fas fa-chevron-right h-5 w-5"></i>
                        </a>
                    </c:if>
                </nav>
            </c:if>
        </div>
    </div>
</main>

<div id="reservationDetailsModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto">
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
    let searchTimeout;
    document.querySelector('input[name="search"]').addEventListener('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            document.getElementById('searchForm').submit(); // Assurez-vous que votre form a l'id="searchForm" ou adaptez
            // Sinon : document.querySelector('form').submit();
        }, 500);
    });

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
        const modal = document.getElementById('reservationDetailsModal');
        const content = document.getElementById('reservationDetailsContent');

        modal.classList.remove('hidden');
        modal.classList.add('flex');
        
        content.innerHTML = 
            '<div class="text-center">' +
                '<i class="fas fa-spinner fa-spin fa-2x text-admin-primary"></i>' +
                '<p class="mt-2 text-gray-600 dark:text-gray-400">Chargement des avis...</p>' +
            '</div>';

        fetch('${pageContext.request.contextPath}/admin/reservation-reviews?id=' + reservationId)
            .then(response => {
                if (!response.ok) throw new Error('Erreur réseau');
                return response.json();
            })
            .then(data => {
                content.innerHTML = generateReviewsHTML(reservationId, data);
            })
            .catch(error => {
                console.error('Erreur:', error);
                content.innerHTML = '<div class="text-center text-red-500">Impossible de charger les avis.</div>';
            });
    }

    function generateReviewsHTML(reservationId, reviewsDTO) {
        if (!reviewsDTO || Object.keys(reviewsDTO).length === 0) {
            return '<div class="text-center pb-4">' +
                        '<h4 class="text-xl font-bold text-gray-900 dark:text-white">Avis pour la Réservation #' + reservationId + '</h4>' +
                   '</div>' + 
                   generateNoReviewHTML('Aucun avis trouvé pour cette réservation.');
        }

        const clientReviewHTML = reviewsDTO.reviewFromClient 
            ? generateSingleReviewHTML('Évaluation du Client', reviewsDTO.reviewFromClient)
            : generateNoReviewHTML('Le client n\'a pas encore laissé d\'avis.');

        const partnerReviewHTML = reviewsDTO.reviewFromPartner
            ? generateSingleReviewHTML('Évaluation du Partenaire', reviewsDTO.reviewFromPartner)
            : generateNoReviewHTML('Le partenaire n\'a pas encore laissé d\'avis.');

        return '<div class="space-y-6">' +
                    '<div class="text-center border-b border-gray-200 dark:border-gray-700 pb-4">' +
                        '<h4 class="text-xl font-bold text-gray-900 dark:text-white">Avis pour la Réservation #' + reservationId + '</h4>' +
                        '<p class="text-sm text-gray-600 dark:text-gray-400 mt-1">Évaluations croisées.</p>' +
                    '</div>' +
                    '<div class="grid grid-cols-1 md:grid-cols-2 gap-6">' +
                        clientReviewHTML +
                        partnerReviewHTML +
                    '</div>' +
                    '<div class="flex justify-end pt-4 mt-4 border-t border-gray-200 dark:border-gray-700">' +
                        '<button onclick="closeReservationDetails()" class="px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white rounded-lg transition-colors">' +
                            '<i class="fas fa-times mr-2"></i> Fermer' +
                        '</button>' +
                    '</div>' +
                '</div>';
    }

    function generateSingleReviewHTML(title, review) {
        const ratingStars = generateStarRating(review.rating);
        const date = new Date(review.createdAt).toLocaleDateString('fr-FR');
        
        let reviewerName = "Utilisateur inconnu";
        let reviewerAvatar = "${pageContext.request.contextPath}/assets/images/default-avatar.png";
        
        if (review.reviewer) {
            reviewerName = review.reviewer.username || (review.reviewer.firstName + " " + review.reviewer.lastName);
            if (review.reviewer.avatarUrl) {
                reviewerAvatar = "${pageContext.request.contextPath}/uploads/" + review.reviewer.avatarUrl;
            }
        }

        return '<div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-5">' +
                    '<div class="flex items-center mb-4">' +
                        '<img src="' + reviewerAvatar + '" alt="Avatar" class="w-8 h-8 rounded-full object-cover mr-3">' +
                        '<div>' +
                            '<h5 class="font-semibold text-gray-900 dark:text-white">' + title + '</h5>' +
                            '<p class="text-sm text-gray-600 dark:text-gray-400">par ' + reviewerName + '</p>' +
                        '</div>' +
                    '</div>' +
                    '<div class="space-y-4">' +
                        '<div class="flex items-center">' +
                            '<span class="text-sm text-gray-600 dark:text-gray-400 mr-2">Note :</span>' +
                            '<div class="flex items-center text-yellow-400">' +
                                ratingStars +
                                '<span class="text-sm font-bold text-gray-700 dark:text-gray-300 ml-2 text-black">' + review.rating + '/5</span>' +
                            '</div>' +
                        '</div>' +
                        '<div>' +
                            '<p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Commentaire :</p>' +
                            '<p class="text-sm text-gray-800 dark:text-gray-200 italic bg-white dark:bg-gray-800 p-3 rounded-lg border-l-4 border-admin-secondary">' +
                                '"' + review.comment + '"' +
                            '</p>' +
                        '</div>' +
                        '<p class="text-xs text-gray-500 dark:text-gray-400 pt-2 border-t border-gray-200">' +
                            '<i class="fas fa-clock mr-1"></i> Publié le ' + date +
                        '</p>' +
                    '</div>' +
                '</div>';
    }

    function generateNoReviewHTML(message) {
        return '<div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-5 flex items-center justify-center text-center">' +
                    '<div>' +
                        '<i class="fas fa-comment-slash fa-2x text-gray-400 dark:text-gray-500 mb-3"></i>' +
                        '<p class="text-sm text-gray-600 dark:text-gray-400">' + message + '</p>' +
                    '</div>' +
                '</div>';
    }

    function generateStarRating(rating) {
        let stars = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars += '<i class="fas fa-star text-yellow-400"></i>';
            } else {
                stars += '<i class="fas fa-star text-gray-300 dark:text-gray-600"></i>';
            }
        }
        return stars;
    }

    function closeReservationDetails() {
        const modal = document.getElementById('reservationDetailsModal');
        modal.classList.add('hidden');
        modal.classList.remove('flex');
        document.getElementById('reservationDetailsContent').innerHTML = '';
    }

    document.querySelectorAll('.show-reservation-details').forEach(button => {
        button.addEventListener('click', function(e) {
            const btn = e.currentTarget;
            const reservationId = btn.getAttribute('data-reservation-id');
            console.log('Clicked reservationId:', reservationId);
            
            if(reservationId) {
                showReservationDetails(reservationId);
            }
        });
    });

    document.getElementById('reservationDetailsModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeReservationDetails();
        }
    });
</script>
</body>
</html>