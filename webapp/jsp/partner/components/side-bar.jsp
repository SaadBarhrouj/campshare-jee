<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<style>
        /* Navigation hover effects */
        .nav-link {
            position: relative;
            transition: all 0.3s ease;
        }
        
        .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -4px;
            left: 0;
            background-color: currentColor;
            transition: width 0.3s ease;
        }
        
        .nav-link:hover::after {
            width: 100%;
        }
        
        /* Active link style */
        .active-nav-link {
            position: relative;
        }
        
        .active-nav-link::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: -4px;
            left: 0;
            background-color: #FFAA33;
        }
        
        /* Input styles */
        .custom-input {
            transition: all 0.3s ease;
            border-width: 2px;
        }
        
        .custom-input:focus {
            box-shadow: 0 0 0 3px rgba(45, 95, 43, 0.2);
        }
        
        /* Toggle switch */
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .toggle-switch .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }
        
        .toggle-switch .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        .toggle-switch input:checked + .slider {
            background-color: #2D5F2B;
        }
        
        .dark .toggle-switch input:checked + .slider {
            background-color: #4F7942;
        }
        
        .toggle-switch input:checked + .slider:before {
            transform: translateX(26px);
        }
        
        /* Sidebar active */
        .sidebar-link2.active {
            background-color: rgba(45, 95, 43, 0.1);
            color: #2D5F2B;
            border-left: 4px solid #2D5F2B;
        }
        
        .dark .sidebar-link2.active {
            background-color: rgba(79, 121, 66, 0.2);
            color: #4F7942;
            border-left: 4px solid #4F7942;
        }
        
        /* Equipment card hover effect */
        .equipment-card {
            transition: all 0.3s ease;
        }
        
        .equipment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        }
        
        /* Notification badge */
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: #ef4444;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 11px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Chat styles */
        .chat-container {
            max-height: 400px;
            overflow-y: auto;
            scroll-behavior: smooth;
        }
        
        .chat-message {
            margin-bottom: 15px;
            display: flex;
        }
        
        .chat-message.outgoing {
            justify-content: flex-end;
        }
        
        .chat-bubble {
            padding: 10px 15px;
            border-radius: 18px;
            max-width: 80%;
        }
        
        .chat-message.incoming .chat-bubble {
            background-color: #f3f4f6;
            border-bottom-left-radius: 5px;
        }
        
        .dark .chat-message.incoming .chat-bubble {
            background-color: #374151;
        }
        
        .chat-message.outgoing .chat-bubble {
            background-color: #2D5F2B;
            color: white;
            border-bottom-right-radius: 5px;
        }
        
        .dark .chat-message.outgoing .chat-bubble {
            background-color: #4F7942;
        }

        /* Styles pour les boutons principaux - action buttons */
        button[type="submit"],
        a.inline-flex,
        button.px-4.py-2,
        button.px-6.py-2,
        .w-full.md\\:w-auto.px-4.py-2,
        button.inline-flex {
            background-color: #2D5F2B !important; /* forest color */
            color: white !important;
            transition: all 0.3s ease;
        }
        
        /* Exceptions pour les boutons retour/annuler */
        button[id^="back-to-step"],
        button[onclick="toggleEditMode(false)"] {
            background-color: white !important;
            color: #374151 !important;
            border: 1px solid #D1D5DB !important;
        }
        
        /* Hover state for action buttons */
        button[type="submit"]:hover,
        a.inline-flex:hover,
        button.px-4.py-2:hover,
        button.px-6.py-2:hover,
        .w-full.md\\:w-auto.px-4.py-2:hover,
        button.inline-flex:hover {
            background-color: #215A1A !important; /* darker forest */
        }



    </style>  

    <!-- Header -->
    <jsp:include page="/jsp/common/header.jsp" />


    <div class="flex flex-col md:flex-row pt-16">



     <!-- Sidebar (hidden on mobile) -->
        <aside class="hidden md:block w-64 bg-white dark:bg-gray-800 shadow-md h-screen fixed overflow-y-auto">
            <div class="p-5">
                <div class="mb-6 px-3 flex flex-col items-center">
                    <div class="relative">
                        <img src="${pageContext.request.contextPath}/uploads/${user.avatarUrl}"  
                             alt="${user.username}"  
                             class="w-24 h-24 rounded-full border-4 border-forest dark:border-meadow object-cover" />
                        <div class="absolute bottom-1 right-1 bg-green-500 p-1 rounded-full border-2 border-white dark:border-gray-800">
                            <i class="fas fa-check text-white text-xs"></i>
                        </div>
                    </div>
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white mt-4">${user.username}</h2>
                    <div class="text-sm text-gray-500 dark:text-gray-400">Partenaire depuis : <fmt:formatDate value="${user.createdAt}" pattern="MM/yyyy"/></div>

                    <div class="flex items-center mt-2">
                    

                        
                        <div class="flex text-amber-400">
                        
                            <c:set var="fullStars" value="${user.avgRating.intValue()}" />
                            <c:set var="halfStar" value="${user.avgRating - fullStars >= 0.5 ? 1 : 0}" />
                            <c:set var="emptyStars" value="${5 - fullStars - halfStar}" />


                            <c:forEach var="i" begin="1" end="${fullStars}">
                                <i class="fas fa-star"></i>
                            </c:forEach>
                        
    
                        
                                <c:if test="${halfStar == 1}">
                                    <i class="fas fa-star-half-alt"></i>
                                </c:if>
                       
                        </div>
                        <span class="ml-1 text-gray-600 dark:text-gray-400 text-sm">${user.avgRating}</span>
                        <span class="ml-1 text-gray-600 dark:text-gray-400 text-sm">
                            <c:if test="${user.avgRating == 0}">Not Rated</c:if>
                        </span>
                    </div>
                </div>
                
                <nav class="mt-6 space-y-1">
                    <a href="/webapp/partner/dashboard"  class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-tachometer-alt w-5 mr-3"></i>
                        Tableau de bord
                    </a>
                    <a href="/webapp/partner/MesEquipements" class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-campground w-5 mr-3"></i>
                        Mes équipements
                    </a>
                    <a href="/webapp/partner/MesAnnonces"  class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-bullhorn w-5 mr-3"></i>
                        Mes annonces
                    </a>
                    <a href="/webapp/partner/DemandeLocation" class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-clipboard-list w-5 mr-3"></i>
                        Demandes location
                        <!--<span class="ml-auto bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">{{-- $NumberPendingReservation --}}</span>-->
                    </a>
                    <a href="/webapp/partner/LocationEnCours"  class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-exchange-alt w-5 mr-3"></i>
                        Locations en cours
                        <!--<span class="ml-auto bg-blue-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">{{-- $NumberLocationsEncours --}}</span>-->
                    </a>
                    
                 
                    <a href="/webapp/partner/AvisRecu"  class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-star w-5 mr-3"></i>
                        Avis reçus
                    </a>
                </nav>
                <div class="mt-12">
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link2 flex items-center px-4 py-3 text-base font-mediumtext-red-600 dark:text-red-400 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se deconnecter
                    </a>
                </div>
            </div>
        </aside>
        
        <!-- Mobile sidebar toggle -->
        <div id="mobile-sidebar-overlay" class="md:hidden fixed inset-0 bg-gray-800 bg-opacity-50 z-40 hidden"></div>
        
        <div class="md:hidden fixed bottom-4 right-4 z-50">
            <button id="mobile-sidebar-toggle" class="w-14 h-14 rounded-full bg-forest text-white shadow-lg flex items-center justify-center">
                <i class="fas fa-bars text-xl"></i>
            </button>
        </div>

        
        <div id="mobile-sidebar" class="md:hidden fixed inset-y-0 left-0 transform -translate-x-full w-64 bg-white dark:bg-gray-800 shadow-xl z-50 transition-transform duration-300">
            <div class="p-5">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mon compte</h2>
                    <button id="close-mobile-sidebar" class="text-gray-600 dark:text-gray-400 focus:outline-none">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
                
                <div class="mb-6 px-3 flex flex-col items-center">
                    <div class="relative">
                        <img src=""  
                             alt="a"  
                             class="w-20 h-20 rounded-full border-4 border-forest dark:border-meadow object-cover" />
                        <div class="absolute bottom-1 right-1 bg-green-500 p-1 rounded-full border-2 border-white dark:border-gray-800">
                            <i class="fas fa-check text-white text-xs"></i>
                        </div>
                    </div>
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white mt-3">a</h2>
                    <div class="text-sm text-gray-500 dark:text-gray-400">Partenaire depuis 25</div>
                    <div class="flex items-center mt-1">
                        <div class="flex text-amber-400">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                        <span class="ml-1 text-gray-600 dark:text-gray-400 text-sm">4.8</span>
                    </div>
                </div>
                
                <nav class="mt-6 space-y-1">
                    <a href="#dashboard" class="sidebar-link active flex items-center px-4 py-3 text-base font-medium rounded-md transition-colors">
                        <i class="fas fa-tachometer-alt w-5 mr-3"></i>
                        Tableau de bord
                    </a>
                    <a href="#equipment" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-campground w-5 mr-3"></i>
                        Mes équipements
                    </a>
                    <a href="#annonces" data-target="MesAnnonces" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-bullhorn w-5 mr-3"></i>
                        Mes annonces
                    </a>
                    <a href="#rental-requests" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-clipboard-list w-5 mr-3"></i>
                        Demandes de location
                        <span class="ml-auto bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">3</span>
                    </a>
                    <a href="#current-rentals" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-exchange-alt w-5 mr-3"></i>
                        Locations en cours
                        <span class="ml-auto bg-blue-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">2</span>
                    </a>
                    <a href="#my-reservations" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-shopping-cart w-5 mr-3"></i>
                        Mes réservations
                        <span class="ml-auto bg-purple-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">2</span>
                    </a>
                
                    <a href="#reviews" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-star w-5 mr-3"></i>
                        Avis reçus
                    </a>
                    <a href="#calendar" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-calendar-alt w-5 mr-3"></i>
                        Calendrier
                    </a>
                    <a href="#analytics" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-chart-line w-5 mr-3"></i>
                        Statistiques
                    </a>
                    <a href="#settings" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-cog w-5 mr-3"></i>
                        Paramètres
                    </a>
                    <a href="#help" class="sidebar-link flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-question-circle w-5 mr-3"></i>
                        Aide & Support
                    </a>
                </nav>
            </div>
        </div>
        
    <script>


    function setActiveSidebarLink() {
            const currentPath = window.location.pathname;
            const sidebarLinks = document.querySelectorAll('.sidebar-link2');
            
            sidebarLinks.forEach(link => {
                // Remove 'active' class from all links first
                link.classList.remove('active');
                
                // Check if the link's href matches the current path
                const linkPath = link.getAttribute('href');
                if (currentPath === linkPath || 
                    (linkPath !== '/' && currentPath.startsWith(linkPath))) {
                    link.classList.add('active');
                }
            });
        }
        document.addEventListener('DOMContentLoaded', setActiveSidebarLink);
        
        
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

        
        // Equipment settings modal
        const equipmentSettingsLinks = document.querySelectorAll('a[href="#equipment-status"]');
        const equipmentSettingsModal = document.getElementById('equipment-settings-modal');
        const closeEquipmentSettings = document.getElementById('close-equipment-settings');
        const cancelEquipmentSettings = document.getElementById('cancel-equipment-settings');
        
        equipmentSettingsLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                equipmentSettingsModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        });
        
        closeEquipmentSettings?.addEventListener('click', () => {
            equipmentSettingsModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
        
        cancelEquipmentSettings?.addEventListener('click', () => {
            equipmentSettingsModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
        
        // Close modal when clicking outside
        equipmentSettingsModal?.addEventListener('click', (e) => {
            if (e.target === equipmentSettingsModal) {
                equipmentSettingsModal.classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            }
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
        
        // View public profile button
        const viewPublicProfileButton = document.getElementById('view-public-profile');
        
        viewPublicProfileButton?.addEventListener('click', () => {
            window.location.href = 'profil-partenaire-public.html';
        });
    </script>