<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Dashboard Client</title>

    <!-- Styles / Scripts -->

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    


    <meta name="msapplication-TileColor" content="#da532c">
    <meta name="theme-color" content="#ffffff">
    <meta name="description" content="CampShare - Louez facilement le matériel de camping dont vous avez besoin
    directement entre particuliers.">
    <meta name="keywords" content="camping, location, matériel, aventure, plein air, partage, communauté">

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
<jsp:include page="components/sidebar.jsp" />

<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
    <div class="py-8 px-4 md:px-8">
        <!-- Dashboard header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Bienvenue, ${user.username} ! Voici un resume de vos reservations.</p>
            </div>
        </div>

                <!-- Stats cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Stats card 1 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-blue-100 dark:bg-blue-900 mr-4">
                        <i class="fas fa-shopping-cart text-blue-600 dark:text-blue-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Total reservations</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalReservations}</h3>
                        
                    </div>
                </div>
            </div>
            
            <!-- Stats card 2 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-green-100 dark:bg-green-900 mr-4">
                        <i class="fas fa-money-bill-wave text-green-600 dark:text-green-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Montant total depense</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalDepense}</h3>
                      
                    </div>
                </div>
            </div>
            
            <!-- Stats card 3 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-yellow-100 dark:bg-yellow-900 mr-4">
                        <i class="fas fa-star text-yellow-600 dark:text-yellow-400"></i>
                    </div>
                <div>
                    <p class="text-gray-500 dark:text-gray-400 text-sm">Note moyenne</p>

                    <c:choose>
                        <c:when test="${noteMoyenne != null and noteMoyenne != 0}">
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${noteMoyenne}</h3>
                        </c:when>
                        <c:otherwise>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Non note</h3>
                        </c:otherwise>
                    </c:choose>
                </div>

                </div>
            </div>
        </div>
        <div class="mb-8">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes reservations</h2>
                <a href="${pageContext.request.contextPath}/client/allReservation" data-target = "allRes" class=" sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                    Voir toutes mes réservations
                </a>
            </div>

            <%
                java.util.Map<String, String> statusMap = new java.util.HashMap<>();
                statusMap.put("pending", "En attente");
                statusMap.put("confirmed", "Confirmée");
                statusMap.put("ongoing", "En cours");
                statusMap.put("canceled", "Annulée");
                statusMap.put("completed", "Terminée");
                request.setAttribute("statusMap", statusMap);
            %>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <c:forEach var="res" items="${reservations}">
                            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                                <div class="relative h-40">
                                    <img src="${pageContext.request.contextPath}/images/items/${res.listing.item.images.get(0).url}" alt="Image" class="w-full h-full object-cover" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                    <div class="absolute top-4 left-4">
                                        <span class="bg-gray-400 text-white text-xs px-2 py-1 rounded-full">
                                            <c:out value="${statusMap[res.status]}" />
                                        </span>
                                    </div>
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <h3 class="text-white font-bold text-lg truncate">
                                            <c:out value="${res.listing.item.title}" />
                                        </h3>
                                        <p class="text-gray-200 text-sm">
                                            <c:out value="${res.listing.item.description}" />
                                        </p>
                                    </div>
                                </div>

                                <div class="p-4">
                                    <div class="flex items-start mb-4">
                                        <c:if test="${not empty res.partner}">
                                            <a href="#">
                                                <img src="${pageContext.request.contextPath}/images/avatars/${res.partner.avatarUrl}" alt="image"
                                                    class="w-8 h-8 rounded-full object-cover mr-3" />
                                            </a>
                                            <div>
                                                <p class="font-medium text-gray-900 dark:text-white">
                                                    <c:out value="${res.partner.username}" />
                                                </p>
                                                <div class="flex items-center text-sm">
                                                    <c:choose>
                                                        <c:when test="${noteMoyenne != null and noteMoyenne != 0}">
                                                            <fmt:formatNumber value="" maxFractionDigits="1" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-sm text-gray-500">No ratings yet</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="bg-gray-50 dark:bg-gray-700/50 rounded p-3 mb-4">
                                        <div class="flex justify-between text-sm mb-1">
                                            <span class="text-gray-600 dark:text-gray-400">Date</span>
                                            <span class="font-medium text-gray-900 dark:text-white">
                                                <fmt:formatDate value="${res.startDate}" pattern="yyyy-MM-dd" /> -
                                                <fmt:formatDate value="${res.endDate}" pattern="yyyy-MM-dd" />
                                            </span>
                                        </div>
                                        <div class="flex justify-between text-sm mb-1">
                                            <span class="text-gray-600 dark:text-gray-400">Prix</span>
                                                <fmt:parseDate value="${res.startDate}" pattern="yyyy-MM-dd" var="startDate" />
                                                <fmt:parseDate value="${res.endDate}" pattern="yyyy-MM-dd" var="endDate" />

                                                <!-- Compute difference in milliseconds -->
                                                <c:set var="diffDays" value="${(endDate.time - startDate.time) / (1000 * 60 * 60 * 24)}" />
                                                <!-- Convert to days (1000 * 60 * 60 * 24 = 86400000) -->
                                               
                                            
                                                <c:set var="montantTotal" value="${res.listing.item.pricePerDay * diffDays}" />
                                                
                                                <span class="font-medium text-gray-900 dark:text-white">
                                                    <p class="font-medium text-gray-900 dark:text-white">${montantTotal} MAD</p>
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${res.status eq 'pending'}">
                                        <button class="px-3 py-1.5 border border-red-300 dark:border-red-800 text-red-700 
                                                    dark:text-red-400 text-sm rounded-md hover:bg-red-50 
                                                    dark:hover:bg-red-900/20 transition-colors flex-1">
                                            <i class="fas fa-times mr-2"></i> Annuler
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-lg shadow-sm overflow-hidden">
                            <p class="mx-8 text-sm text-gray-600 dark:text-gray-400">
                                Vous n'avez aucune réservation.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Equipment recommendations -->
            <div class="mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Équipements recommandés</h2>
                    <a href="allEquipment.jsp" class="sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                        Voir plus de recommandations
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty similarListings}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="item" items="${similarListings}">
                                <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
                                    <a href="listingDetails.jsp?listingId=${item.listing.id}">
                                        <div class="relative h-48">
                                            <img src="${pageContext.request.contextPath}/images/items/${item.listing.item.images.get(0).url}" 
                                                alt="Image" class="w-full h-full object-cover" />
                                            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                            <div class="absolute bottom-4 left-4 right-4">
                                                <h3 class="text-white font-bold text-lg truncate">${item.listing.item.title}</h3>
                                                <p class="text-gray-200 text-sm">${item.listing.item.category.name}</p>
                                            </div>
                                        </div>

                                        <div class="p-4">
                                            <div class="flex justify-between items-center mb-3">
                                                <div>
                                                    <span class="font-bold text-lg text-gray-900 dark:text-white">${item.listing.item.pricePerDay} MAD</span>
                                                    <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                                </div>

                                                <div class="flex items-center text-sm">
                                                    <c:choose>
                                                        <c:when test="${item.partner != null && item.partner.reviewCount > 0}">
                                                            <c:set var="rating" value="${item.partner.avgRating}" />
                                                            <c:set var="fullStars" value="${fn:substringBefore(rating, '.')}" />
                                                            <c:set var="hasHalfStar" value="${(rating - fullStars) ge 0.5}" />
                                                            <c:set var="emptyStars" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}" />

                                                            <div class="flex items-center">
                                                                <div class="flex text-amber-400 mr-1">
                                                                    <c:forEach begin="0" end="${fullStars - 1}" var="i">
                                                                        <i class="fas fa-star"></i>
                                                                    </c:forEach>
                                                                    <c:if test="${hasHalfStar}">
                                                                        <i class="fas fa-star-half-alt"></i>
                                                                    </c:if>
                                                                    <c:forEach begin="0" end="${emptyStars - 1}" var="i">
                                                                        <i class="far fa-star"></i>
                                                                    </c:forEach>
                                                                </div>
                                                                <span class="text-gray-600 dark:text-gray-400">
                                                                    <fmt:formatNumber value="${rating}" maxFractionDigits="1"/>
                                                               
                                                                </span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-sm text-gray-500">No ratings yet</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="text-sm mb-3">
                                                <span class="text-gray-600 dark:text-gray-300">
                                                    Dispo. du <fmt:formatDate value="${item.listing.startDate}" pattern="dd MMM"/>
                                                    au <fmt:formatDate value="${item.listing.endDate}" pattern="dd MMM"/>
                                                </span>
                                            </div>

                                            <div class="flex items-center justify-between">
                                                <div class="text-sm text-gray-600 dark:text-gray-300">
                                                    <span class="font-medium text-green-800 dark:text-green-600">
                                                        <i class="fas fa-map-marker-alt mr-1"></i> 
                                                        ${item.listing.city.name}
                                                   
                                                    </span>
                                                </div>
                                                <a href="listingDetails.jsp?listingId=${item.listing.id}" class="px-3 py-1.5 bg-forest hover:bg-green-700 text-white text-sm rounded-md transition-colors">
                                                    Voir les détails
                                                </a>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-gray-500 dark:text-gray-400 text-center col-span-3">
                            Aucune recommandation disponible pour le moment.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>


    </div>

                <!-- My reservations section -->
        
</main>

<script>
    // Mobile menu toggle
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    
    mobileMenuButton?.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
    });
    
    // User dropdown toggle
    const userMenuButton = document.getElementById('user-menu-button');
    const userDropdown = document.getElementById('user-dropdown');
    
    userMenuButton?.addEventListener('click', () => {
        userDropdown.classList.toggle('hidden');
    });
    
    // Notifications dropdown toggle
    const notificationsButton = document.getElementById('notifications-button');
    const notificationsDropdown = document.getElementById('notifications-dropdown');
    
    notificationsButton?.addEventListener('click', () => {
        notificationsDropdown.classList.toggle('hidden');
    });
    
    // Messages dropdown toggle
    const messagesButton = document.getElementById('messages-button');
    const messagesDropdown = document.getElementById('messages-dropdown');
    
    messagesButton?.addEventListener('click', () => {
        messagesDropdown.classList.toggle('hidden');
    });
    
    // Hide dropdowns when clicking outside
    document.addEventListener('click', (e) => {
        // User dropdown
        if (userMenuButton && !userMenuButton.contains(e.target) && userDropdown && !userDropdown.contains(e.target)) {
            userDropdown.classList.add('hidden');
        }
        
        // Notifications dropdown
        if (notificationsButton && !notificationsButton.contains(e.target) && notificationsDropdown && !notificationsDropdown.contains(e.target)) {
            notificationsDropdown.classList.add('hidden');
        }
        
        // Messages dropdown
        if (messagesButton && !messagesButton.contains(e.target) && messagesDropdown && !messagesDropdown.contains(e.target)) {
            messagesDropdown.classList.add('hidden');
        }
    });
    
    // Mobile sidebar toggle
    const mobileSidebarToggle = document.getElementById('mobile-sidebar-toggle');
    const mobileSidebar = document.getElementById('mobile-sidebar');
    const closeMobileSidebar = document.getElementById('close-mobile-sidebar');
    const mobileSidebarOverlay = document.getElementById('mobile-sidebar-overlay');
    
    mobileSidebarToggle?.addEventListener('click', () => {
        mobileSidebar.classList.toggle('-translate-x-full');
        mobileSidebarOverlay.classList.toggle('hidden');
        document.body.classList.toggle('overflow-hidden');
    });
    
    closeMobileSidebar?.addEventListener('click', () => {
        mobileSidebar.classList.add('-translate-x-full');
        mobileSidebarOverlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    });
    
    mobileSidebarOverlay?.addEventListener('click', () => {
        mobileSidebar.classList.add('-translate-x-full');
        mobileSidebarOverlay.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    });
    
    // Sidebar link active state
    const sidebarLinks = document.querySelectorAll('.sidebar-link');
    
    sidebarLinks.forEach(link => {
        link.addEventListener('click', () => {
            // Remove active class from all links
            sidebarLinks.forEach(el => el.classList.remove('active'));
            
            // Add active class to clicked link
            link.classList.add('active');
        });
    });
    
    // Message modal
    const messageButtons = document.querySelectorAll('button .fas.fa-comment-alt, .fas.fa-envelope');
    const messageModal = document.getElementById('message-modal');
    const closeMessageModal = document.getElementById('close-message-modal');
    const messageForm = document.getElementById('message-form');
    const messageInput = document.getElementById('message-input');
    
    messageButtons.forEach(button => {
        button.parentElement.addEventListener('click', (e) => {
            e.preventDefault();
            messageModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
            // Scroll to bottom of chat
            const chatContainer = document.querySelector('.chat-container');
            if (chatContainer) {
                chatContainer.scrollTop = chatContainer.scrollHeight;
            }
            // Focus input
            messageInput?.focus();
        });
    });
    
    closeMessageModal?.addEventListener('click', () => {
        messageModal.classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    });
    
    // Close modal when clicking outside
    messageModal?.addEventListener('click', (e) => {
        if (e.target === messageModal) {
            messageModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        }
    });
    
    // Handle message form submission
    messageForm?.addEventListener('submit', (e) => {
        e.preventDefault();
        const message = messageInput.value.trim();
        if (message) {
            // Create and append new message
            const chatContainer = document.querySelector('.chat-container');
            const newMessage = document.createElement('div');
            newMessage.className = 'chat-message outgoing';
            
            const now = new Date();
            const hours = now.getHours();
            const minutes = now.getMinutes();
            const timeString = `${hours}:${minutes < 10 ? '0' + minutes : minutes}`;
            
            newMessage.innerHTML = `
                <div class="chat-bubble">
                    <p class="text-white">${message}</p>
                    <p class="text-xs text-gray-300 mt-1">${timeString}</p>
                </div>
            `;
            
            chatContainer.appendChild(newMessage);
            messageInput.value = '';
            
            // Scroll to bottom of chat
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }
    });
    
    // Add to favorites functionality
    const heartButtons = document.querySelectorAll('.far.fa-heart');
    
    heartButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            e.stopPropagation();
            if (button.classList.contains('far')) {
                button.classList.remove('far');
                button.classList.add('fas');
            } else {
                button.classList.remove('fas');
                button.classList.add('far');
            }
        });
    });
</script>
<script>
    function cancelReservation(reservationId) {
    if (confirm('Êtes-vous sûr de vouloir annuler cette réservation ?')) {
        fetch(`/client/reservations/cancel/${reservationId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                //alert(data.message);
                // Recharger les réservations
                document.getElementById('statusFilter').dispatchEvent(new Event('change'));
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Une erreur est survenue');
        });
    }
}
</script>
<div id="message-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] flex flex-col">
        <div class="p-5 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
            <div class="flex items-center">
                <img src="https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80" 
                        alt="Omar Tazi" 
                        class="w-10 h-10 rounded-full object-cover mr-3" />
                <div>
                    <h3 class="text-xl font-bold text-gray-900 dark:text-white">Omar Tazi</h3>
                    <p class="text-sm text-gray-600 dark:text-gray-400">Grande Tente 6 Personnes</p>
                </div>
            </div>
            <button id="close-message-modal" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 focus:outline-none">
                <i class="fas fa-times"></i>
            </button>
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
    <script>
      
        document.addEventListener('DOMContentLoaded', function() {
            const openModalBtn = document.getElementById('openPartnerModalBtn');
            const partnerModal = document.getElementById('partnerAcceptModal');
            if (openModalBtn && partnerModal) {
                const closeModalBtn = document.getElementById('closePartnerModalBtn');
                const cancelModalBtn = document.getElementById('cancelPartnerModalBtn');
                const openModal = () => {
                    partnerModal.classList.remove('hidden');
                    partnerModal.classList.add('flex');
                    document.body.style.overflow = 'hidden';
                };
                const closeModal = () => {
                    partnerModal.classList.add('hidden');
                    partnerModal.classList.remove('flex');
                    document.body.style.overflow = '';
                };
                openModalBtn.addEventListener('click', (event) => {
                    event.preventDefault();
                    openModal();
                });
                if (closeModalBtn) {
                    closeModalBtn.addEventListener('click', closeModal);
                }
                if (cancelModalBtn) {
                    cancelModalBtn.addEventListener('click', closeModal);
                }
                partnerModal.addEventListener('click', (event) => {
                    if (event.target === partnerModal) {
                        closeModal();
                    }
                });
                document.addEventListener('keydown', (event) => {
                    if (event.key === 'Escape' && !partnerModal.classList.contains('hidden')) {
                        closeModal();
                    }
                });
            }
        });
    </script>
</body>
</html>