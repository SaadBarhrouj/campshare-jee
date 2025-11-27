<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
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
        
        .custom-input {
            transition: all 0.3s ease;
            border-width: 2px;
        }
        
        .custom-input:focus {
            box-shadow: 0 0 0 3px rgba(45, 95, 43, 0.2);
        }
        
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
        
        .sidebar-link.active {
            background-color: rgba(45, 95, 43, 0.1);
            color: #2D5F2B;
            border-left: 4px solid #2D5F2B;
        }
        
        .dark .sidebar-link.active {
            background-color: rgba(79, 121, 66, 0.2);
            color: #4F7942;
            border-left: 4px solid #4F7942;
        }
        
        .equipment-card {
            transition: all 0.3s ease;
        }
        
        .equipment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
        }
        
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
    </style>
    
    
    <!-- Header -->
    <jsp:include page="/jsp/common/header.jsp" />


    <div class="flex flex-col md:flex-row pt-16">
        <aside class="hidden md:block w-64 bg-white dark:bg-gray-800 shadow-md h-screen fixed overflow-y-auto">
            <div class="p-5">
                <div class="mb-6 px-3 flex flex-col items-center">
                    <div class="relative">
                    <img src="${pageContext.request.contextPath}/images/avatars/${user.avatarUrl}"
                         
                        class="w-24 h-24 rounded-full border-4 border-forest dark:border-meadow object-cover" />
                        <div class="absolute bottom-1 right-1 bg-green-500 p-1 rounded-full border-2 border-white dark:border-gray-800">
                            <i class="fas fa-check text-white text-xs"></i>
                        </div>
                    </div>
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white mt-4">${user.username}</h2>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                        Membre depuis : 
                        <fmt:formatDate value="${user.createdAt}" pattern="MM/yyyy"/>
                    </div>

                <div class="flex items-center mt-2">
                    <c:choose>
                        <c:when test="${noteMoyenne != 0}">
                            <div class="flex text-amber-400 mr-1">
                                <!-- Full stars -->
                                <c:forEach var="i" begin="1" end="${fullStars}">
                                    <i class="fas fa-star text-base"></i>
                                </c:forEach>

                                <!-- Half star -->
                                <c:if test="${hasHalfStar}">
                                    <i class="fas fa-star-half-alt text-base"></i>
                                </c:if>

                                <!-- Empty stars -->
                                <c:forEach var="i" begin="1" end="${emptyStars}">
                                    <i class="far fa-star text-base"></i>
                                </c:forEach>
                            </div>

                            <span class="text-gray-600 dark:text-gray-300 text-sm ml-1">
                                <fmt:formatNumber value="${noteMoyenne}" maxFractionDigits="1"/>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-gray-400 text-sm">Non note</span>
                        </c:otherwise>
                    </c:choose>
                </div>


                </div>
                <nav class="mt-6 space-y-1">
                    <a href="${pageContext.request.contextPath}/client/dashboard" data-target="dashboard" class="sidebar-link2 active flex items-center px-4 py-3 text-base font-medium rounded-md transition-colors">
                        <i class="fas fa-tachometer-alt w-5 mr-3"></i>
                        Tableau de bord
                    </a>
                    <a href="${pageContext.request.contextPath}/client/allReservation" data-target="allRes" class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-shopping-cart w-5 mr-3"></i>
                        Mes reservations
                    </a>
                    <a href="${pageContext.request.contextPath}/client/equipement" data-target="allSim" class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-heart w-5 mr-3"></i>
                        Equip recommandes
                    </a>
                    <a href="${pageContext.request.contextPath}/client/avis" data-target="mes-avis" class="sidebar-link2 flex items-center px-4 py-3 text-base font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-star w-5 mr-3"></i>
                        Avis recus
                    </a>
                    
                </nav>
                <div class="mt-32">
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link2 flex items-center px-4 py-3 text-base font-mediumtext-red-600 dark:text-red-400 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se deconnecter
                    </a>
                </div>
            </div>
        </aside>
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
                        <img src="https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" 
                             alt="Fatima Benali" 
                             class="w-20 h-20 rounded-full border-4 border-forest dark:border-meadow object-cover" />
                        <div class="absolute bottom-1 right-1 bg-green-500 p-1 rounded-full border-2 border-white dark:border-gray-800">
                            <i class="fas fa-check text-white text-xs"></i>
                        </div>
                    </div>
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white mt-3">${user.username}</h2>
                </div>
            </div>
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
        
        // Special handling for dashboard
        if (currentPath.includes('/client/dashboard') || currentPath === '/client/dashboard' || currentPath.endsWith('/client/dashboard')) {
            const dashboardLink = document.querySelector('a[data-target="dashboard"]');
            if (dashboardLink) {
                document.querySelectorAll('.sidebar-link2').forEach(link => link.classList.remove('active'));
                dashboardLink.classList.add('active');
            }
        }
    }
    document.addEventListener('DOMContentLoaded', setActiveSidebarLink);

</script>
