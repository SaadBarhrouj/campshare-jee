
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
        @layer utilities {
  .no-scrollbar::-webkit-scrollbar {
    display: none;
  }
  .no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
}
    </style>

    <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
        <div class="py-8 px-4 md:px-8">
            <!-- Dashboard header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">Bienvenue, ${user.username} ! Voici un résumé de votre activité.</p>
                </div>
            </div>
            
            <!-- Stats cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                
                
                <!-- Stats card 2 -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-blue-100 dark:bg-blue-900 mr-4">
                            <i class="fa-regular fa-circle-check text-blue-600 dark:text-blue-400"></i>
                        </div>
                        <div>
                            <p class="text-gray-500 dark:text-gray-400 text-sm">Locations réalisées</p>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${completedReservations}</h3>
                            <p class="text-blue-600 dark:text-blue-400 text-sm flex items-center mt-1">
                                
                            </p>
                        </div>
                    </div>
                </div>
                
                
                
                <!-- Stats card 4 -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-purple-100 dark:bg-purple-900 mr-4">
                            <i class="fa-solid fa-campground text-purple-600 dark:text-purple-400"></i>
                        </div>
                        <div>
                            <p class="text-gray-500 dark:text-gray-400 text-sm">Équipements actifs</p>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${countActiveListening} / ${countListening}</h3>
                            <p class="text-purple-600 dark:text-purple-400 text-sm flex items-center mt-1">
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Stats card 3 -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-amber-100 dark:bg-amber-900 mr-4">
                            <i class="fas fa-star text-amber-600 dark:text-amber-400"></i>
                        </div>
                        <div>
                            <p class="text-gray-500 dark:text-gray-400 text-sm">Note moyenne</p>
                            <c:choose>
                                <c:when test="${user.avgRating != null && user.avgRating != 0}">
                                     <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${user.avgRating} / 5</h3>
                                    <p class="text-amber-600 dark:text-amber-400 text-sm flex items-center mt-1"></p>
                                </c:when>
                                <c:otherwise>
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Not Rated</h3>
                                </c:otherwise>
                            </c:choose>

                                
                            
                        </div>
                    </div>
                </div>
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-purple-100 dark:bg-purple-900 mr-4">
                            <i class="fa-solid fa-campground text-purple-600 dark:text-purple-400"></i>
                        </div>
                        <div>
                            <p class="text-gray-500 dark:text-gray-400 text-sm">Revenus du mois</p>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${monthPayment} MAD</h3>
                            <p class="text-purple-600 dark:text-purple-400 text-sm flex items-center mt-1">
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Recent activity and rental requests -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                <!-- Recent activity -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="font-bold text-xl text-gray-900 dark:text-white">Avis Recent</h2>
                    </div>
                      <div class="divide-y divide-gray-200 dark:divide-gray-700">
                        <c:choose>
                            <c:when test="${not empty LastAvisPartnerForObjectList}">
                                <c:forEach var="avis" items="${LastAvisPartnerForObjectList}">
                                    <div class="px-6 py-4">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 mr-4">
                                                <div class="h-10 w-10 rounded-full bg-amber-100 dark:bg-amber-800 flex items-center justify-center">
                                                    <i class="fas fa-star text-amber-600 dark:text-amber-400"></i>
                                                </div>
                                            </div>
                                            <div>
                                                <p class="font-medium text-gray-900 dark:text-white">
                                                    ${avis.reviewer.username} - Equipment: ${avis.item.title}
                                                </p>
                                                <p class="text-gray-600 dark:text-gray-400 text-sm">
                                                    ${avis.comment}
                                                </p>
                                                <p class="text-gray-500 dark:text-gray-500 text-xs mt-1">
                                                    <div class="flex items-center text-sm">
                                                        <i class="fas fa-star text-amber-400 mr-1"></i>
                                                        <span>${avis.rating}</span>
                                                    </div>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="divide-y divide-gray-200 dark:divide-gray-700">
                                    <div class="px-6 py-4 text-sm text-gray-500">
                                        
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
 
                </div>
                
                <!-- Rental requests -->
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                        <h2 class="font-bold text-xl text-gray-900 dark:text-white">Demandes de location</h2>
                        <span class="bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-300 px-3 py-1 text-xs font-medium rounded-full">
                            ${fn:length(PendingReservationsWithMontantTotal)} en attente
                        </span>
                        
                    </div>

                        <c:choose>
                            <c:when test="${not empty PendingReservationsWithMontantTotal}">
                                <c:forEach var="reservation" items="${PendingReservationsWithMontantTotal}"  begin="0" end="1">
                                    <div class="divide-y divide-gray-200 dark:divide-gray-700">
                                        <div class="px-6 py-4">
                                            <div class="flex items-start">
                                                <img src="${pageContext.request.contextPath}/uploads/${reservation.client.avatarUrl}" 
                                                    alt="${reservation.client.username}" 
                                                    class="w-10 h-10 rounded-full object-cover mr-4" />

                                                <div class="flex-1">
                                                    <div class="flex items-center justify-between mb-1">
                                                        <h3 class="font-medium text-gray-900 dark:text-white">${reservation.client.username}</h3>
                                                        <span class="text-xs text-gray-500 dark:text-gray-400">${reservation.createdAt}</span>
                                                    </div>
                                                    <p class="text-gray-600 dark:text-gray-400 text-sm mb-2">
                                                        Souhaite louer <span class="font-medium">${reservation.listing.item.title}</span>
                                                    </p>
                                                    <div class="bg-gray-50 dark:bg-gray-700/50 rounded p-2 mb-3">
                                                        <div class="flex justify-between text-sm mb-1">
                                                            <span class="text-gray-600 dark:text-gray-400">Durée de résérvation</span>
                                                            <span class="font-medium text-gray-900 dark:text-white">
                                                                ${reservation.startDate} -> ${reservation.endDate}
                                                            </span>
                                                        </div>
                                                        <div class="flex justify-between text-sm">
                                                            <span class="text-gray-600 dark:text-gray-400">Montant total</span>
                                                            <span class="font-medium text-gray-900 dark:text-white">
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center space-x-2">
                                                        <form action="reservationAction" method="post" class="flex-1">
                                                            <input type="hidden" name="reservation_id" value="${reservation.id}" />
                                                            <input type="hidden" name="action" value="accept" />
                                                            <button type="submit" class="px-3 py-1.5 bg-green-600 hover:bg-green-700 text-white text-sm rounded-md w-full">
                                                                Accepter
                                                            </button>
                                                        </form>

                                                        <form action="reservationAction" method="post" class="flex-1">
                                                            <input type="hidden" name="reservation_id" value="${reservation.id}" />
                                                            <input type="hidden" name="action" value="refuse" />
                                                            <button type="submit" class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-md hover:bg-gray-50 dark:hover:bg-gray-700 w-full">
                                                                Refuser
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${fn:length(PendingReservationsWithMontantTotal) != 0}">
                                    <div class="px-6 py-3 bg-gray-50 dark:bg-gray-700/50 text-center">
                                        <a href="/webapp/partner/DemandeLocation" class="text-forest dark:text-meadow hover:underline text-sm font-medium">
                                            Voir toutes les demandes
                                        </a>
                                    </div>
                                </c:if>

                            </c:when>
                            <c:otherwise>
                                <div class="divide-y divide-gray-200 dark:divide-gray-700">
                                    <div class="px-6 py-4 text-sm text-gray-500">
                                        Vous n'avez aucune demande de location dans ce moment.
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                </div>
            </div>

            
            <!-- My equipment section -->
            <div class="mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes équipements</h2>
                    <a href="${pageContext.request.contextPath}/partner/MesEquipements" data-target="AllMyEquipement" class="sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                        Voir tous mes équipements
                    </a>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    <c:forEach var="equipment" items="${partnerEquipment}" begin="0" end="2">
                        <!-- Calculate review count -->
                        <c:set var="reviewCount" value="${fn:length(equipment.reviews)}" />

                        <!-- Calculate average rating -->
                        <c:set var="sumRating" value="0" />
                        <c:forEach var="review" items="${equipment.reviews}">
                            <c:set var="sumRating" value="${sumRating + review.rating}" />
                        </c:forEach>
                        <c:set var="avgRating" value="${reviewCount > 0 ? sumRating / reviewCount : 0}" />

                        <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
                            <div class="relative h-48">
                                <c:if test="${equipment.images != null && fn:length(equipment.images) > 0}">
                                    <img src="${pageContext.request.contextPath}/uploads/${equipment.images[0].url}"
                                        alt="${equipment.title}" 
                                        class="w-full h-full object-cover" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                </c:if>

                                <div class="absolute bottom-4 left-4 right-4">
                                    <h3 class="text-white font-bold text-lg truncate">${equipment.title}</h3>
                                    <p class="text-gray-200 text-sm">${equipment.category.name}</p>
                                </div>
                            </div>

                            <div class="p-4">
                                <div class="flex justify-between items-center mb-3">
                                    <div>
                                        <span class="font-bold text-lg text-gray-900 dark:text-white">${equipment.pricePerDay} MAD</span>
                                        <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                    </div>

                                    <div class="flex items-center text-sm">
                                        <c:choose>
                                            <c:when test="${reviewCount != 0}">
                                                <i class="fas fa-star text-amber-400 mr-1"></i>
                                                <span>
                                                    <fmt:formatNumber value="${avgRating}" type="number" maxFractionDigits="1" minFractionDigits="1" />
                                                    ${avgRating}
                                                    <span class="text-gray-500 dark:text-gray-400">(${reviewCount})</span>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star text-amber-400 mr-1"></i>
                                                <span>Non noté</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- buttons and other HTML remain the same -->
                            </div>
                        </div>
                    </c:forEach>
                    <!-- Add Equipment Card -->
                    <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden border-2 border-dashed border-gray-300 dark:border-gray-600 flex flex-col items-center justify-center h-80">
                        <div class="flex flex-col items-center justify-center p-6 text-center">
                            <div class="w-16 h-16 bg-forest/10 dark:bg-forest/20 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-plus text-forest dark:text-meadow text-xl"></i>
                            </div>
                            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">Ajouter un équipement</h3>
                            <p class="text-gray-600 dark:text-gray-400 text-sm mb-4">
                                Vous pouvez ajouter un nouvel équipement pour le proposer à la location.
                            </p>
                            <button id="add-equipment-button"
                                    class="px-4 py-3 bg-forest hover:bg-meadow text-white rounded-md shadow-lg flex items-center font-medium">
                                <i class="fas fa-plus mr-2"></i>
                                Ajouter
                            </button>
                        </div>
                    </div>
                </div>

            </div>
            
            <!-- Latest reviews -->
            
        </div>
    </main>

    <!-- Equipment Settings Modal (hidden by default) -->
    <div id="equipment-settings-modal" class="fixed inset-0 bg-black bg-opacity-50 items-center justify-center z-50 hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-lg w-full mx-4">
            <div class="p-5 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Paramètres de l'équipement</h3>
                <button id="close-equipment-settings" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 focus:outline-none">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="p-5">
                <div class="flex items-center mb-6">
                    <img src="https://images.unsplash.com/photo-1504851149312-7a075b496cc7?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80" 
                         alt="Pack Camping Complet 2p" 
                         class="w-14 h-14 rounded-md object-cover mr-4" />
                    <div>
                        <h4 class="font-semibold text-gray-900 dark:text-white">Pack Camping Complet 2p</h4>
                        <p class="text-sm text-gray-600 dark:text-gray-400">MSR - Excellent état</p>
                    </div>
                </div>
                
                <div class="space-y-4">
                    <!-- Status toggle -->
                    <div class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-700">
                        <div>
                            <h5 class="font-medium text-gray-900 dark:text-white">Statut de l'annonce</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Activer ou désactiver l'annonce</p>
                        </div>
                        <div>
                            <label class="toggle-switch">
                                <input type="checkbox" checked>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Archive option -->
                    <div class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-700">
                        <div>
                            <h5 class="font-medium text-gray-900 dark:text-white">Archiver l'annonce</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">L'annonce ne sera plus visible</p>
                        </div>
                        <button class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-md hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                            Archiver
                        </button>
                    </div>
                    
                    <!-- Availability dates -->
                    <div class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-700">
                        <div>
                            <h5 class="font-medium text-gray-900 dark:text-white">Dates de disponibilité</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Du 1 août au 1 oct. 2023</p>
                        </div>
                        <button class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-md hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                            Modifier
                        </button>
                    </div>
                    
                    <!-- Price setting -->
                    <div class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-700">
                        <div>
                            <h5 class="font-medium text-gray-900 dark:text-white">Prix journalier</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">450 MAD/jour</p>
                        </div>
                        <button class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-md hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                            Modifier
                        </button>
                    </div>
                    
                    <!-- Equipment details edit -->
                    <div class="flex items-center justify-between py-3 border-b border-gray-200 dark:border-gray-700">
                        <div>
                            <h5 class="font-medium text-gray-900 dark:text-white">Éditer les détails</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Photos, description, etc.</p>
                        </div>
                        <button class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 text-sm rounded-md hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                            Éditer
                        </button>
                    </div>
                    
                    <!-- Delete equipment -->
                    <div class="flex items-center justify-between py-3">
                        <div>
                            <h5 class="font-medium text-red-600 dark:text-red-400">Supprimer l'équipement</h5>
                            <p class="text-sm text-gray-600 dark:text-gray-400">Cette action est irréversible</p>
                        </div>
                        <button class="px-3 py-1.5 bg-red-600 hover:bg-red-700 text-white text-sm rounded-md transition-colors">
                            Supprimer
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="p-5 border-t border-gray-200 dark:border-gray-700 flex justify-end">
                <button id="cancel-equipment-settings" class="px-4 py-2 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 font-medium rounded-md mr-3 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                    Annuler
                </button>
                <button class="px-4 py-2 bg-forest hover:bg-green-700 text-white font-medium rounded-md shadow-sm transition-colors">
                    Enregistrer
                </button>
            </div>
        </div>
    </div>

    <!-- Message Modal (hidden by default) -->
    <div id="message-modal" class="fixed inset-0 bg-black bg-opacity-50 items-center justify-center z-50 hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] flex flex-col">
            <div class="p-5 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
                <div class="flex items-center">
                    <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80" 
                        alt="Mehdi Idrissi" 
                        class="w-10 h-10 rounded-full object-cover mr-3" />
                    <div>
                        <h3 class="text-xl font-bold text-gray-900 dark:text-white">Mehdi Idrissi</h3>
                        <p class="text-sm text-gray-600 dark:text-gray-400">Pack Camping Complet 2p</p>
                    </div>
                </div>
                <button id="close-message-modal" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 focus:outline-none">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="p-5 overflow-y-auto flex-grow">
                <div class="chat-container">
                    <!-- Message thread -->
                    <div class="chat-message incoming">
                        <div class="chat-bubble">
                            <p class="text-gray-800 dark:text-gray-200">Bonjour ! Je suis intéressé par votre Pack Camping Complet 2p pour un séjour au lac Lalla Takerkoust du 10 au 15 août. Est-ce qu'il est disponible durant cette période ?</p>
                            <p class="text-xs text-gray-500 mt-1">11:42 AM</p>
                        </div>
                    </div>
                    
                    <div class="chat-message outgoing">
                        <div class="chat-bubble">
                            <p class="text-white">Bonjour Mehdi, oui le pack est disponible pour ces dates ! Avez-vous besoin d'informations supplémentaires sur le contenu du pack ?</p>
                            <p class="text-xs text-gray-300 mt-1">11:48 AM</p>
                        </div>
                    </div>
                    
                    <div class="chat-message incoming">
                        <div class="chat-bubble">
                            <p class="text-gray-800 dark:text-gray-200">Super ! Est-ce que le pack inclut des assiettes et des couverts ? Nous serons 2 personnes.</p>
                            <p class="text-xs text-gray-500 mt-1">11:53 AM</p>
                        </div>
                    </div>
                    
                    <div class="chat-message outgoing">
                        <div class="chat-bubble">
                            <p class="text-white">Oui, le pack comprend 2 sets d'assiettes, bols, couverts et tasses en plastique réutilisable. Il y a aussi une petite casserole, une poêle et une bouilloire.</p>
                            <p class="text-xs text-gray-300 mt-1">11:57 AM</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="p-4 border-t border-gray-200 dark:border-gray-700">
                <form id="message-form" class="flex items-end">
                    <div class="flex-grow">
                        <textarea id="message-input" placeholder="Tapez votre message..." class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow text-base resize-none custom-input" rows="3"></textarea>
                    </div>
                    <div class="ml-3 flex flex-col space-y-2">
                        <button type="button" class="p-2 text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-md transition-colors">
                            <i class="fas fa-paperclip"></i>
                        </button>
                        <button type="submit" class="p-2 bg-forest hover:bg-green-700 text-white rounded-md shadow-sm transition-colors">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="equipment-details-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-6xl w-full max-h-screen overflow-y-auto no-scrollbar">
        <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
            <h3 class="text-xl font-bold text-gray-900 dark:text-white" id="detail-title">Détails de l'équipement</h3>
            <button id="close-details-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>
        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Colonne de gauche: Images et informations de base -->
                <div>
                    <div class="bg-gray-100 dark:bg-gray-700 rounded-lg overflow-hidden mb-4">
                        <div id="detail-image-slider" class="w-full h-64 flex overflow-x-auto snap-x snap-mandatory scrollbar-hide no-scrollbar">
                            <!-- Images will be added here dynamically -->
                            <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                                <i class="fas fa-campground text-5xl text-gray-400 dark:text-gray-500"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Informations générales</h4>
                        <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400">Catégorie</h5>
                                    <p class="text-gray-900 dark:text-white" id="detail-category">-</p>
                                </div>
                                <div>
                                    <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400">Prix par jour</h5>
                                    <p class="text-xl font-bold text-forest dark:text-meadow" id="detail-price">-</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Description</h4>
                        <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
                            <p class="text-gray-700 dark:text-gray-300" id="detail-description">-</p>
                        </div>
                    </div>
                </div>
                
                <!-- Colonne de droite: Statistiques et avis -->
                <div>
                    <div class="mb-4">
                        <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Statistiques</h4>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-3">
                                <h5 class="text-sm font-medium text-blue-800 dark:text-blue-300">Nombre d'annonces</h5>
                                <p class="text-xl font-bold text-blue-600 dark:text-blue-400 mt-1" id="detail-annonces-count">0</p>
                                <p class="text-xs text-blue-600 dark:text-blue-400" id="detail-active-annonces">0 actives</p>
                            </div>
                            
                            <div class="bg-green-50 dark:bg-green-900/20 rounded-lg p-3">
                                <h5 class="text-sm font-medium text-green-800 dark:text-green-300">Réservations</h5>
                                <p class="text-xl font-bold text-green-600 dark:text-green-400 mt-1" id="detail-reservations-count">0</p>
                                <p class="text-xs text-green-600 dark:text-green-400" id="detail-completed-reservations">0 terminées</p>
                            </div>
                            
                            <div class="bg-purple-50 dark:bg-purple-900/20 rounded-lg p-3">
                                <h5 class="text-sm font-medium text-purple-800 dark:text-purple-300">Évaluation moyenne</h5>
                                <div class="flex items-center mt-1">
                                    <span class="text-xl font-bold text-purple-600 dark:text-purple-400 mr-1" id="detail-avg-rating">0</span>
                                    <div class="text-amber-400">
                                        <i class="fas fa-star"></i>
                                    </div>
                                </div>
                                <p class="text-xs text-purple-600 dark:text-purple-400" id="detail-review-count">0 avis</p>
                            </div>
                            
                            <div class="bg-amber-50 dark:bg-amber-900/20 rounded-lg p-3">
                                <h5 class="text-sm font-medium text-amber-800 dark:text-amber-300">Revenus générés</h5>
                                <p class="text-xl font-bold text-amber-600 dark:text-amber-400 mt-1" id="detail-revenue">0 MAD</p>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <div class="flex justify-between items-center mb-2">
                            <h4 class="font-bold text-lg text-gray-900 dark:text-white">Avis</h4>
                            <span class="text-sm text-gray-500 dark:text-gray-400" id="detail-reviews-summary">Chargement...</span>
                        </div>
                        
                        <div id="detail-reviews-container" class="space-y-4 max-h-96 overflow-y-auto pr-2 no-scrollbar">
                            <!-- Reviews will be loaded here dynamically -->
                            <div class="text-center py-8 text-gray-500 dark:text-gray-400" id="no-reviews-message">
                                <i class="far fa-comment-alt text-3xl mb-2"></i>
                                <p>Aucun avis pour le moment</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-6 border-t border-gray-200 dark:border-gray-700 pt-4 flex justify-end">
                <a id="detail-create-annonce-link" href="#" class="px-4 py-2 bg-forest hover:bg-meadow dark:bg-meadow dark:hover:bg-forest/partenaire/annonces/create/ text-white font-medium rounded-md shadow-sm transition-colors">
                    <i class="fas fa-bullhorn mr-2"></i>
                    Créer une annonce
                </a>
            </div>
        </div>
    </div>
    </div>
    <!-- Add Equipment Modal -->
    <div id="add-equipment-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-3xl w-full max-h-screen overflow-y-auto">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Ajouter un équipement</h3>
                <button id="close-add-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <form id="add-equipment-form" action="${pageContext.request.contextPath}/partner/AddItem" method="POST" enctype="multipart/form-data" class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label for="title" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre</label>
                        <input type="text" id="title" name="title" required placeholder="Titre de l'équipement ..."
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                    </div>
                    
                    <div>
                        <label for="category_id" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
                        <select id="category_id" name="category_id" required
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="">Sélectionner une catégorie</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label for="price_per_day" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prix par jour (MAD)</label>
                        <input type="number" id="price_per_day" name="price_per_day" min="0" step="0.01" required placeholder="Prix /jour"
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                    </div>
                    
                    <div class="md:col-span-2">
                        <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
                        <textarea id="description" name="description" rows="4" required placeholder="Description de votre équipement ..."
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow"></textarea>
                    </div>
                    
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Images (Minimum 1, Maximum 5 images)</label>
                        <div class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-md px-6 pt-5 pb-6 cursor-pointer" id="image-drop-area">
                            <div class="space-y-1 text-center">
                                <i class="fas fa-cloud-upload-alt text-4xl text-gray-400 dark:text-gray-500 mb-3"></i>
                                <div class="flex text-sm text-gray-600 dark:text-gray-400 justify-center">
                                    <label for="images" class="relative cursor-pointer rounded-md font-medium text-forest dark:text-meadow hover:text-meadow focus-within:outline-none">
                                        <span>Ajouter des images</span>
                                        <input id="images" name="temp_images" type="file" class="sr-only" accept="image/*" multiple>
                                    </label>
                                </div>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-2">
                                    PNG, JPG, GIF jusqu'à 2MB
                                </p>
                                <p class="text-sm font-medium mt-2">
                                    <span id="image-count">0</span>/5 images ajoutées
                                </p>
                            </div>
                        </div>
                        <div id="image-preview-container" class="mt-4 grid grid-cols-2 md:grid-cols-4 gap-4"></div>
                        <div id="image-count-error" class="mt-2 text-red-500 text-sm hidden">Veuillez sélectionner entre 1 et 5 images.</div>
                    </div>
                </div>
                
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancel-add" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                        Annuler
                    </button>
                    <button type="submit" class="px-4 py-2 bg-forest hover:bg-meadow text-white rounded-md shadow-sm">
                        Ajouter l'équipement
                    </button>
                </div>
            </form>
        </div>
    </div>
    <script>
        const addEquipmentButton = document.getElementById('add-equipment-button');
        const addEquipmentForm = document.getElementById('add-equipment-form');
        const addEquipmentModal = document.getElementById('add-equipment-modal');
        const imagePreviewContainer = document.getElementById('image-preview-container');
        const imageInput = document.getElementById('images');
        const deleteEquipmentModal = document.getElementById('delete-equipment-modal');
        const deleteEquipmentForm = document.getElementById('delete-equipment-form');
        const contextPath = '${pageContext.request.contextPath}';


        const viewDetailsButtons = document.querySelectorAll('.view-details-btn');
        const detailsModal = document.getElementById('equipment-details-modal');

            // Show Add Equipment Modal

        if (addEquipmentButton) {
            addEquipmentButton.addEventListener('click', () => {
                addEquipmentModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        }
        if (addEquipmentForm) {
            addEquipmentForm.addEventListener('submit', function(e) {
                // Compter le nombre d'inputs de fichier cachés (qui contiennent les images réelles)
                const hiddenInputs = addEquipmentForm.querySelectorAll('input[type="file"].hidden-file-input');
                const imageCount = hiddenInputs.length;
                const errorDiv = document.getElementById('image-count-error');
                
                if (imageCount < 1 || imageCount > 5) {
                    e.preventDefault();
                    errorDiv.textContent = imageCount < 1 
                        ? "Veuillez sélectionner au moins 1 image."
                        : "Veuillez sélectionner au maximum 5 images.";
                    errorDiv.classList.remove('hidden');
                    return false;
                } else {
                    errorDiv.classList.add('hidden');
                    return true;
                }
            });
        }
        if (imageInput) {
            imageInput.addEventListener('change', function() {
                handleFileSelect(this.files, imagePreviewContainer);
            });
        }
        function handleFileSelect(files, previewContainer) {
            // Limiter à maximum 5 images au total
            const maxFiles = 5;
            const currentImages = previewContainer.querySelectorAll('.relative').length;
            const maxNewImages = maxFiles - currentImages;
            
            if (maxNewImages <= 0) {
                const errorDiv = previewContainer.id === 'image-preview-container' 
                    ? document.getElementById('image-count-error') 
                    : document.getElementById('edit-image-count-error');
                
                if (errorDiv) {
                    errorDiv.textContent = "Maximum 5 images autorisées. Veuillez supprimer des images avant d'en ajouter d'autres.";
                    errorDiv.classList.remove('hidden');
                }
                return;
            }
            
            const filesToProcess = files.length > maxNewImages ? Array.from(files).slice(0, maxNewImages) : files;
            
            // Déterminer le formulaire parent
            const formId = previewContainer.id === 'image-preview-container' 
                ? 'add-equipment-form' 
                : 'edit-equipment-form';
            const form = document.getElementById(formId);
            
            for (let i = 0; i < filesToProcess.length; i++) {
                const file = filesToProcess[i];
                
                if (!file.type.match('image.*')) {
                    continue;
                }
                
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    const imgContainer = document.createElement('div');
                    imgContainer.className = 'relative';
                    imgContainer.dataset.fileIndex = Date.now() + '_' + i; // Identifiant unique
                    
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'w-full h-32 object-cover rounded-md';
                    imgContainer.appendChild(img);
                    
                    // Créer un champ de fichier caché pour cette image spécifique
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'file';
                    hiddenInput.name = 'images[]';
                    hiddenInput.classList.add('hidden-file-input');
                    hiddenInput.style.display = 'none';
                    
                    // Créer un objet DataTransfer pour y mettre le fichier
                    const dataTransfer = new DataTransfer();
                    dataTransfer.items.add(file);
                    hiddenInput.files = dataTransfer.files;
                    
                    // Ajouter l'input au formulaire
                    form.appendChild(hiddenInput);
                    
                    // Stocker la référence à l'input dans le conteneur d'image
                    imgContainer.dataset.inputId = hiddenInput.id = 'file-input-' + imgContainer.dataset.fileIndex;
                    
                    const removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center';
                    removeBtn.innerHTML = '<i class="fas fa-times text-xs"></i>';
                    removeBtn.addEventListener('click', function() {
                        // Supprimer l'input de fichier associé
                        const inputToRemove = document.getElementById(imgContainer.dataset.inputId);
                        if (inputToRemove) {
                            inputToRemove.remove();
                        }
                        
                        // Supprimer la prévisualisation
                        imgContainer.remove();
                        
                        // Masquer le message d'erreur après la suppression
                        const errorDiv = previewContainer.id === 'image-preview-container' 
                            ? document.getElementById('image-count-error') 
                            : document.getElementById('edit-image-count-error');
                        
                        if (errorDiv) {
                            errorDiv.classList.add('hidden');
                        }
                        
                        // Mettre à jour le compteur d'images
                        updateImageCount(previewContainer);
                    });
                    imgContainer.appendChild(removeBtn);
                    
                    previewContainer.appendChild(imgContainer);
                    
                    // Mettre à jour le compteur d'images
                    updateImageCount(previewContainer);
                };
                
                reader.readAsDataURL(file);
            }
            
            // Afficher message d'erreur si dépassement
            const errorDiv = previewContainer.id === 'image-preview-container' 
                ? document.getElementById('image-count-error') 
                : document.getElementById('edit-image-count-error');
            
            if (files.length > maxNewImages && errorDiv) {
                errorDiv.textContent = `Vous ne pouvez ajouter que ${maxNewImages} image(s) supplémentaire(s). Seules les ${maxNewImages} premières ont été sélectionnées.`;
                errorDiv.classList.remove('hidden');
            } else if (errorDiv) {
                errorDiv.classList.add('hidden');
            }
            
            // Réinitialiser l'input de fichier principal pour permettre de sélectionner à nouveau le même fichier
            const mainFileInput = previewContainer.id === 'image-preview-container' 
                ? document.getElementById('images') 
                : document.getElementById('edit-images');
            
            mainFileInput.value = '';
        }
        function updateImageCount(previewContainer) {
            const isEdit = previewContainer.id === 'edit-image-preview-container';
            const imageCount = previewContainer.querySelectorAll('.relative').length;
            
            // Pour l'édition, on compte aussi les images existantes
            if (isEdit) {
                const currentImagesContainer = document.getElementById('current-images-container');
                const keptImagesCount = currentImagesContainer ? currentImagesContainer.querySelectorAll('input[name="keep_images[]"]').length : 0;
                const totalCount = imageCount + keptImagesCount;
                
                const countElement = document.getElementById('edit-image-count');
                if (countElement) {
                    countElement.textContent = totalCount;
                }
            } else {
                // Pour l'ajout simple
                const countElement = document.getElementById('image-count');
                if (countElement) {
                    countElement.textContent = imageCount;
                }
            }
        }

        document.querySelectorAll('.delete-equipment-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const equipmentId = this.dataset.id;
                document.getElementById('delete-equipment-name').textContent = this.dataset.title;
                const form = document.getElementById('delete-equipment-form');

                form.action = contextPath + '/partner/DeleteItem' + '/' + equipmentId;
                deleteEquipmentModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        });
        // View Equipment Details
        viewDetailsButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                const id = button.getAttribute('data-id');
                
                // Afficher le modal avec indicateur de chargement
                const modal = document.getElementById('equipment-details-modal');
                modal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
                
                // Initialiser les éléments avec des indicateurs de chargement
                document.getElementById('detail-title').textContent = 'Chargement...';
                document.getElementById('detail-price').textContent = '...';
                document.getElementById('detail-category').textContent = '...';
                document.getElementById('detail-description').textContent = 'Chargement des informations...';
                document.getElementById('detail-annonces-count').textContent = '...';
                document.getElementById('detail-active-annonces').textContent = '...';
                document.getElementById('detail-reservations-count').textContent = '...';
                document.getElementById('detail-completed-reservations').textContent = '...';
                document.getElementById('detail-avg-rating').textContent = '...';
                document.getElementById('detail-review-count').textContent = '...';
                document.getElementById('detail-revenue').textContent = '...';
                document.getElementById('detail-reviews-summary').textContent = 'Chargement...';
                
                // Vider le conteneur d'images et afficher un placeholder
                const imageSlider = document.getElementById('detail-image-slider');
                imageSlider.innerHTML = `
                    <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                        <i class="fas fa-sync fa-spin text-5xl text-gray-400 dark:text-gray-500"></i>
                    </div>
                `;
                
                // Charger les données détaillées de l'équipement
                console.log('Fetching equipment details for ID:', id);
                console.log('URL:', `${contextPath}/partner/equipment/details?id=${id}`);

                const idbtn = button.getAttribute('data-id');
                
                fetch(contextPath + '/partner/equipment/details?id=' + idbtn)
                    .then(response => {
                        console.log('Response status:', response.status);
                        console.log('Response ok:', response.ok);
                        if (!response.ok) {
                            console.log('Error fetching equipment details:', response.statusText);
                            throw new Error(`Erreur HTTP ${response.status}: ${response.statusText}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Equipment details data:', data);
                        // Mettre à jour les informations de base
                        const equipment = data.item;
                        const stats = data.stats;
                        console.log('Equipment title:', data.pricePerDay);
                        document.getElementById('detail-title').textContent = data.item.title;
                        document.getElementById('detail-price').textContent = data.item.pricePerDay + " MAD/jour";;
                        document.getElementById('detail-category').textContent = data.item.category ? data.item.category.name : 'Non catégorisé';
                        document.getElementById('detail-description').textContent = data.item.description || 'Aucune description';
                        
                        // Statistiques
                        document.getElementById('detail-annonces-count').textContent = data.nbrListing;
                        //document.getElementById('detail-active-annonces').textContent = `${stats.active_annonce_count} actives`;
                        document.getElementById('detail-reservations-count').textContent = data.nbrReservation;
                        //document.getElementById('detail-completed-reservations').textContent = `${stats.completed_reservations_count} terminées`;
                       // document.getElementById('detail-revenue').textContent = `${stats.revenue.toLocaleString()} MAD`;
                        
                        // Avis
                        const avgRating = data.item.reviews && data.item.reviews.length > 0 
                            ? data.item.reviews.reduce((sum, review) => sum + review.rating, 0) / data.item.reviews.length 
                            : 0;
                        document.getElementById('detail-avg-rating').textContent = avgRating.toFixed(1);
                        document.getElementById('detail-review-count').textContent = data.item.reviews ? data.item.reviews.length : 0 + "avis";
                        document.getElementById('detail-reviews-summary').textContent = data.item.reviews && data.item.reviews.length > 0 
                            ? `${data.item.reviews.length} avis` 
                            : 'Aucun avis'; 
                        
                        // Images
                        imageSlider.innerHTML = '';
                        
                        // Créer le carousel d'images
                        console.log('Creating image slider with images:', data.item.images);
                        if (data.item.images && data.item.images.length > 0) {
                            // Conteneur pour les indicateurs
                            console.log('Creating image slider with images:', data.item.images);
                            const imageDots = document.createElement('div');
                            imageDots.className = 'flex justify-center mt-2 space-x-2';
                            //imageDots.id = 'detail-image-dots';
                            
                            // Ajouter chaque image au slider
                            data.item.images.forEach((image, index) => {
                                // Créer la diapositive d'image
                                const imgDiv = document.createElement('div');
                                imgDiv.className = 'w-full h-64 flex-shrink-0 snap-center relative overflow-hidden';
                                imgDiv.setAttribute('data-index', index);
                                console.log('Adding image to slider:', image.url);
                                imgDiv.innerHTML = `
                                    <img src="http://localhost:8080/webapp//assets/images/items/\${image.url}" alt="\${data.title}" class="w-full h-full object-cover">
                                    <div class="absolute bottom-2 right-2 bg-black bg-opacity-50 text-white text-xs px-2 py-1 rounded-full">
                                        \${index + 1}/\${data.item.images.length}
                                    </div>
                                `;
                                imageSlider.appendChild(imgDiv);
                                
                                // Créer l'indicateur (point) pour cette image
                                const dot = document.createElement('button');
                                dot.className = `w-3 h-3 rounded-full `;
                                dot.setAttribute('data-index', index);
                                dot.addEventListener('click', () => {
                                    // Faire défiler jusqu'à cette image
                                    const imgElement = imageSlider.querySelector(`[data-index="${index}"]`);
                                    console.log("aa",imgElement);
                                    if (imgElement) {
                                        imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    }
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    dot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    dot.classList.add('bg-forest', 'dark:bg-meadow');
                                });
                                imageDots.appendChild(dot);
                            });
                            
                            // Ajouter les indicateurs sous le slider
                            const sliderContainer = imageSlider.closest('.bg-gray-100, .dark\\:bg-gray-700');
                            sliderContainer.appendChild(imageDots);
                            
                            // Ajouter des contrôles de navigation (boutons précédent/suivant)
                            const prevButton = document.createElement('button');
                            prevButton.className = 'absolute left-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                            prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
                            prevButton.addEventListener('click', () => {
                                console.log('Prev button clicked');
                                // Trouver l'image visible actuelle
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Calculer l'index de l'image précédente
                                const prevIndex = (currentIndex - 1 + data.item.images.length) % data.item.images.length;
                                
                                // Faire défiler jusqu'à l'image précédente
                                const imgElement = imageSlider.querySelector(`[data-index="\${prevIndex}"]`);
                                if (imgElement) {
                                    imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    const activeDot = imageDots.querySelector(`[data-index="\${prevIndex}"]`);
                                    if (activeDot) {
                                        activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                        activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                    }
                                }
                            });
                            
                            const nextButton = document.createElement('button');
                            nextButton.className = 'absolute right-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                            nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
                            nextButton.addEventListener('click', () => {
                                // Trouver l'image visible actuelle
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Calculer l'index de l'image suivante
                                const nextIndex = (currentIndex + 1) % data.item.images.length;
                                
                                // Faire défiler jusqu'à l'image suivante
                                const imgElement = imageSlider.querySelector(`[data-index="\${nextIndex}"]`);
                                if (imgElement) {
                                    imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    const activeDot = imageDots.querySelector(`[data-index="\${nextIndex}"]`);
                                    if (activeDot) {
                                        activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                        activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                    }
                                }
                            });
                            
                            // Ajouter les boutons de navigation directement au slider
                            sliderContainer.appendChild(prevButton);
                            sliderContainer.appendChild(nextButton);
                            sliderContainer.style.position = 'relative';
                            
                            // Détecter le changement d'image lors du défilement
                            imageSlider.addEventListener('scroll', () => {
                                // Calculer l'index de l'image actuellement visible
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Mettre à jour les indicateurs
                                imageDots.querySelectorAll('button').forEach(btn => {
                                    btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                    btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                });
                                const activeDot = imageDots.querySelector(`[data-index="\${currentIndex}"]`);
                                if (activeDot) {
                                    activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                }
                            });
                        } else {
                            // Add placeholder if no images
                            const placeholderDiv = document.createElement('div');
                            placeholderDiv.className = 'w-full h-64 bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center';
                            placeholderDiv.innerHTML = '<i class="fas fa-campground text-5xl text-gray-400 dark:text-gray-500"></i>';
                            imageSlider.appendChild(placeholderDiv);
                        }
                        
                        // Lien pour créer une annonce
                        const createAnnonceLink = document.getElementById('detail-create-annonce-link');
                        createAnnonceLink.href = `\${contextPath}/partner/annonces/create?equipment_id=\${data.item.id}`;
                        
                        // Avis
                        const reviewsContainer = document.getElementById('detail-reviews-container');
                        const noReviewsMessage = document.getElementById('no-reviews-message');
                        
                        // Clear previous reviews
                        reviewsContainer.innerHTML = '';
                        
                        if (!data.item.reviews || data.item.reviews.length === 0) {
                            reviewsContainer.appendChild(noReviewsMessage);
                        } else {
                            data.item.reviews.forEach(review => {
                            const reviewDiv = document.createElement('div');
                            reviewDiv.className = 'bg-gray-50 dark:bg-gray-700 p-4 rounded-lg';

                            // Reviewer section
                            const reviewerDiv = document.createElement('div');
                            reviewerDiv.className = 'flex items-center mb-2';

                            const img = document.createElement('img');
                            img.className = 'w-8 h-8 rounded-full mr-2';
                            img.alt = review.reviewer?.username || 'Utilisateur';
                            img.src = review.reviewer?.avatarUrl ? contextPath + '/assets/images/users/' + review.reviewer.avatarUrl
                                                                : contextPath + '/assets/images/default-avatar.png';

                            const infoDiv = document.createElement('div');
                            console.log("img.src:", img.src);
                            const nameDiv = document.createElement('div');
                            nameDiv.textContent = review.reviewer?.username || 'Utilisateur';
                            const dateDiv = document.createElement('div');
                            dateDiv.textContent = new Date(review.createdAt).toLocaleDateString('fr-FR');

                            infoDiv.appendChild(nameDiv);
                            infoDiv.appendChild(dateDiv);

                            reviewerDiv.appendChild(img);
                            reviewerDiv.appendChild(infoDiv);

                            // Stars
                            const starsDiv = document.createElement('div');
                            starsDiv.className = 'flex mb-2';
                            for (let i = 0; i < 5; i++) {
                                const star = document.createElement('i');
                                star.className = i < review.rating ? 'fas fa-star text-amber-400' : 'far fa-star text-amber-400';
                                starsDiv.appendChild(star);
                            }

                            // Comment
                            const commentP = document.createElement('p');
                            commentP.className = 'text-gray-700 dark:text-gray-300';
                            commentP.textContent = review.comment || 'Aucun commentaire';

                            // Assemble
                            reviewDiv.appendChild(reviewerDiv);
                            reviewDiv.appendChild(starsDiv);
                            reviewDiv.appendChild(commentP);

                            reviewsContainer.appendChild(reviewDiv);
                        });
                        }
                    })
                    .catch(error => {
                        console.error('Erreur détaillée:', error);
                        console.error('Message d\'erreur:', error.message);
                        // Afficher un message d'erreur
                        //document.getElementById('detail-title').textContent = 'Erreur de chargement';
                        //document.getElementById('detail-description').textContent = `Erreur: ${error.message}`;
                        
                        // Vider le conteneur d'images et afficher une icône d'erreur
                        
                    });
            });
        });
        

        // Modal event handlers
        const closeAddModal = document.getElementById('close-add-modal');
        const closeEditModal = document.getElementById('close-edit-modal');
        const closeDeleteModal = document.getElementById('close-delete-modal');
        const closeDeleteAllModal = document.getElementById('close-delete-all-modal');
        const closeDetailsModal = document.getElementById('close-details-modal');
        const cancelAdd = document.getElementById('cancel-add');
        const cancelEdit = document.getElementById('cancel-edit');
        const cancelDelete = document.getElementById('cancel-delete');
        const cancelDeleteAll = document.getElementById('cancel-delete-all');

        // Close modals
        if (closeAddModal) {
            closeAddModal.addEventListener('click', () => {
                document.getElementById('add-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeEditModal) {
            closeEditModal.addEventListener('click', () => {
                document.getElementById('edit-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDeleteModal) {
            closeDeleteModal.addEventListener('click', () => {
                document.getElementById('delete-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDeleteAllModal) {
            closeDeleteAllModal.addEventListener('click', () => {
                document.getElementById('delete-all-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDetailsModal) {
            closeDetailsModal.addEventListener('click', () => {
                document.getElementById('equipment-details-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        // Cancel buttons
        if (cancelAdd) {
            cancelAdd.addEventListener('click', () => {
                document.getElementById('add-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelEdit) {
            cancelEdit.addEventListener('click', () => {
                document.getElementById('edit-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelDelete) {
            cancelDelete.addEventListener('click', () => {
                document.getElementById('delete-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelDeleteAll) {
            cancelDeleteAll.addEventListener('click', () => {
                document.getElementById('delete-all-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        // Close modals when clicking outside
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('fixed')) {
                e.target.classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            }
        });



    </script>
    