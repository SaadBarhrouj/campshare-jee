<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
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

    <!-- Navigation -->
    <nav class="bg-white bg-opacity-95 dark:bg-gray-800 dark:bg-opacity-95 shadow-md fixed w-full z-50 transition-all duration-300">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex-shrink-0 flex items-center">
                    <!-- Logo -->
                    <a href="" class="flex items-center">
                        <span class="text-admin-primary dark:text-admin-secondary text-3xl font-extrabold">Camp<span class="text-sunlight">Share</span></span>
                        <span class="text-xs ml-2 text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 px-2 py-1 rounded">ADMIN</span>
                    </a>
                </div>
                
                <!-- Desktop Navigation -->
                <div class="hidden md:flex items-center space-x-8">

                    <!-- User menu -->
                    <div class="relative ml-4">
                        <div class="flex items-center space-x-4">
                                        
                            <!-- User profile menu -->
                                <div class="relative">
                                    <button id="user-menu-button" class="flex items-center space-x-2 focus:outline-none">
                                        <img src=""
                                         alt="Admin User" 
                                         class="h-8 w-8 rounded-full object-cover" />
                                        <div class="flex flex-col items-start">
                                            <span class="font-medium text-gray-800 dark:text-gray-200 text-sm"> </span>
                                            <span
                                                class="text-xs text-admin-primary dark:text-admin-secondary font-medium">
                                            </span>
                                        </div>
                                        <i class="fas fa-chevron-down text-sm text-gray-500"></i>
                                    </button>

                                    <!-- User dropdown menu -->
                                    <div id="user-dropdown"
                                    class="hidden absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-md shadow-lg z-50 border border-gray-200 dark:border-gray-600 py-1">
                                    <a href=""
                                        class="block px-4 py-2 text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700">
                                                <i class="fas fa-user-circle mr-2 opacity-70"></i> Mon profil
                                            </a>
                                    <div class="border-t border-gray-200 dark:border-gray-700"></div>

                                    <a href="${pageContext.request.contextPath}/logout" 
                                    class="block px-4 py-2 text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700"
                                    onclick="event.preventDefault(); document.getElementById('admin-logout-form').submit();">
                                        <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se déconnecter
                                    </a>

                                    <form id="admin-logout-form" 
                                        action="${pageContext.request.contextPath}/logout" 
                                        method="POST" 
                                        class="hidden">
                                    </form>

                                </div>
                            </div>


                      
                        </div>
                    </div>
                </div>

                <!-- Mobile menu button -->
                <div class="md:hidden flex items-center">
                    <button id="mobile-menu-button" class="text-gray-600 dark:text-gray-300 hover:text-admin-primary dark:hover:text-admin-secondary focus:outline-none">
                        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile menu -->
        <div id="mobile-menu" class="hidden md:hidden bg-white dark:bg-gray-800 pb-4 shadow-lg">
            <div class="pt-2 pb-3 px-3">
                <!-- Mobile search -->
                <div class="relative mb-3">
                    <input type="text" placeholder="Recherche rapide..."
                        class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-gray-50 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-sm">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                    </div>
                </div>
            </div>

            <!-- Mobile profile menu -->
            <div class="border-t border-gray-200 dark:border-gray-700 pt-4 pb-3">
                <div class="flex items-center px-4">
                    <div class="flex-shrink-0">
                        <img src="https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80" alt="Admin User" class="h-10 w-10 rounded-full" />
                    </div>
                    <div class="ml-3">
                        <div class="text-base font-medium text-gray-800 dark:text-white">Saad Barhrouj</div>
                        <div class="text-sm font-medium text-admin-primary dark:text-admin-secondary">Admin</div>
                    </div>
                    <div class="ml-auto flex items-center space-x-4">
                        <button
                            class="flex-shrink-0 p-1 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300">
                            <i class="fas fa-bell text-lg"></i>
                            <span
                                class="absolute -mt-1 -mr-1 bg-red-500 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">5</span>
                        </button>
                        <button
                            class="flex-shrink-0 p-1 rounded-full text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300">
                            <i class="fas fa-cog text-lg"></i>
                        </button>
                    </div>
                </div>
                <div class="mt-3 space-y-1 px-2">
                    <a href="#profile"
                        class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <i class="fas fa-user-circle mr-2 opacity-70"></i> Mon profil
                    </a>
                    <a href="#account-settings"
                        class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <i class="fas fa-cog mr-2 opacity-70"></i> Paramètres
                    </a>
                    <a href="#admin-logs"
                        class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <i class="fas fa-history mr-2 opacity-70"></i> Historique d'actions
                    </a>
                    <a href="#logout"
                        class="block px-3 py-2 rounded-md text-base font-medium text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <i class="fas fa-sign-out-alt mr-2 opacity-70"></i> Se déconnecter
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Dashboard container -->
    <div class="flex flex-col md:flex-row pt-16">
        <!-- Sidebar (hidden on mobile) -->
        <aside class="hidden md:block w-64 bg-white dark:bg-gray-800 shadow-md h-screen fixed overflow-y-auto">
            <div class="p-5">
                <div class="mb-6 px-3">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Menu Principal</h5>
                    <nav class="space-y-1">
                        <a href=""
                            class="sidebar-link active flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-tachometer-alt w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Tableau de bord
                        </a>
                                  
                    </nav>
                </div>

                <div class="mb-6 px-3">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Utilisateurs</h5>
                    <nav class="space-y-1">
                        <a href=""
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Partenaires
                            <span
                                class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"><c:out value="${dashboardStats.totalUsers}"/></span>
                        </a>
                        <a href=""
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-users w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Clients
                            <span
                                class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"><c:out value="${dashboardStats.totalClients}"/></span>
                        </a>

                    </nav>
                </div>

                <div class="mb-6 px-3">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Equi. Réserv. & Avis</h5>
                    <nav class="space-y-1">
                    <a href=""
                    class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                    <i class="fas fa-campground w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                    Équipements
                    <span class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"><c:out value="${dashboardStats.totalClients}"/>
                    </span>
                    </a>

                    <a href="" 
                    class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-calendar-alt w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                        Réservations
                     <span class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"><c:out value="${dashboardStats.totalReservations}"/>
                    </span>
                    </a>

                                        
                            <a href=""
                    class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <i class="fas fa-star w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                        Avis
                         <span class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center"><c:out value="${dashboardStats.totalClients}"/>
                        </span>

                    </a>

                    </nav>
                </div>

            </div>
        </aside>

        <!-- Mobile sidebar toggle -->
        <div id="mobile-sidebar-overlay" class="md:hidden fixed inset-0 bg-gray-800 bg-opacity-50 z-40 hidden"></div>

        <div class="md:hidden fixed bottom-4 right-4 z-50">
            <button id="mobile-sidebar-toggle"
                class="w-14 h-14 rounded-full bg-admin-primary dark:bg-admin-secondary text-white shadow-lg flex items-center justify-center">
                <i class="fas fa-bars text-xl"></i>
            </button>
        </div>

        <div id="mobile-sidebar"
            class="md:hidden fixed inset-y-0 left-0 transform -translate-x-full w-64 bg-white dark:bg-gray-800 shadow-xl z-50 transition-transform duration-300">
            <div class="p-5">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Menu Admin</h2>
                    <button id="close-mobile-sidebar" class="text-gray-600 dark:text-gray-400 focus:outline-none">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>

                <div class="mb-6">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Menu Principal</h5>
                    <nav class="space-y-1">
                        <a href="#dashboard"
                            class="sidebar-link active flex items-center px-3 py-2.5 text-sm font-medium rounded-md transition-colors">
                            <i class="fas fa-tachometer-alt w-5 mr-3 text-admin-primary dark:text-admin-secondary"></i>
                            Tableau de bord
                        </a>
                        <!-- Dans la section MENU PRINCIPAL -->
                        <div class="sidebar-link flex items-center px-3 py-2.5" id="clients-link">
                            <i class="fas fa-users w-5 mr-3"></i>
                            <span>Clients</span>
                            <span class="ml-auto bg-blue-100 text-blue-800 rounded-full px-2">33</span>
                        </div>
                        <a href="" id="partners-link"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                            id="partners-link">
                            <i class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Partenaires
                            <span
                                class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center">33</span>
                        </a>
                        <a href="" id="partners-link"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                            id="partners-link">
                            <i class="fas fa-handshake w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            hhhhhhh
                            <span
                                class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center">33</span>
                        </a>
                        <a href="#reservations"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-calendar-alt w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Réservations
                            <span
                                class="ml-auto bg-admin-light dark:bg-admin-dark text-admin-primary dark:text-admin-secondary text-xs rounded-full h-5 px-1.5 flex items-center justify-center">278</span>
                        </a>
                        <a href=""
                        class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-star w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Avis
                            <span class="ml-auto bg-red-100 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-xs rounded-full h-5 px-1.5 flex items-center justify-center">
                            </span>
                        </a>
                    </nav>
                </div>
                
                <div class="mb-6">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Utilisateurs</h5>
                    <nav class="space-y-1">
                        <a href="#analytics"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-chart-line w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Statistiques
                        </a>
                        <a href="#financial"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-money-bill-wave w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Finances
                        </a>
                        <a href="#reports-gen"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-file-alt w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Rapports
                        </a>
                    </nav>
                </div>

                <div class="mb-6">
                    <h5 class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                        Equi. Réserv. & Avis</h5>
                    <nav class="space-y-1">
                        <a href="#analytics"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-chart-line w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Statistiques
                        </a>
                        <a href="#financial"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-money-bill-wave w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Finances
                        </a>
                        <a href="#reports-gen"
                            class="sidebar-link flex items-center px-3 py-2.5 text-sm font-medium text-gray-600 dark:text-gray-300 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                            <i class="fas fa-file-alt w-5 mr-3 text-gray-500 dark:text-gray-400"></i>
                            Rapports
                        </a>
                    </nav>
                </div>

            </div>
        </div>

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
                                    <c:out value="${dashboardStats.totalClients}"/> clients, <c:out value="${dashboardStats.totalClients}"/> partenaires
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
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Revenu (MAD)</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">86.4K</h3>
                                    
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
                    <!-- Graph card -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
                            <div class="flex items-center justify-between">
                                <h2 class="font-bold text-lg text-gray-900 dark:text-white">Graphique des utilisateurs</h2>
                                <div class="flex space-x-2">
                                    <button
                                        class="px-3 py-1 text-xs font-medium text-gray-600 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 rounded">Nombre Total : <c:out value="${dashboardStats.totalUsers}"/></button>
                                    
                                </div>
                            </div>
                        </div>

                        <!-- Chart container -->
                        <div class="p-4">
                            <div class="chart-container">
                                <!-- Placeholder for chart -->
                                <div
                                    class="w-full h-full flex items-center justify-center bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                    <div class="chart-container bg-white dark:bg-gray-800 p-4 rounded-lg flex justify-center items-center">
                                        <canvas id="userPieChart"></canvas>
                                    </div>
                                </div>     
                                
                            </div>
                        </div>
                    </div>

                    <!-- Graph card -->
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
                            <div class="flex items-center justify-between">
                                <h2 class="font-bold text-lg text-gray-900 dark:text-white">Graphique des résérvations</h2>
                                <div class="flex space-x-2">
                                    <button
                                        class="px-3 py-1 text-xs font-medium text-gray-600 dark:text-gray-300 bg-gray-100 dark:bg-gray-700 rounded">Nombre Total : <c:out value="${dashboardStats.totalReservations}"/></button>
                                    
                                </div>
                            </div>
                        </div>
                       
                        <!-- Chart container -->
                        <div class="p-4">
                            <div class="chart-container">
                                <!-- Placeholder for chart -->
                                <div
                                    class="w-full h-full flex items-center justify-center bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                    <div class="rounded-lg p-4 w-max">
                                        <canvas id="reservationBarChart" height="200" width="500"></canvas>
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
                                <tr>
                                    <td>
                                        <div class="flex items-center">
                                            <img class="h-8 w-8 rounded-full object-cover mr-3" src="https://i.pravatar.cc/150?img=1" alt="Avatar">
                                            <span>Saad Barhrouj</span>
                                        </div>
                                    </td>
                                    <td>saadBarh</td>
                                    <td>saad.barhrouj@gmail.com</td>
                                    <td><span class="badge badge-info">Client</span></td>
                                    <td>06 Oct, 2025</td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="flex items-center">
                                            <img class="h-8 w-8 rounded-full object-cover mr-3" src="https://i.pravatar.cc/150?img=2" alt="Avatar">
                                            <span>Mohamed El Haouari</span>
                                        </div>
                                    </td>
                                    <td>medo</td>
                                    <td>mohamed.elhaouari@gmail.com</td>
                                    <td><span class="badge badge-info">Client</span></td>
                                    <td>05 Oct, 2025</td>
                                </tr>
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
                                <tr>
                                    <td>
                                        <div class="flex items-center">
                                            <img class="h-8 w-8 rounded-full object-cover mr-3" src="https://i.pravatar.cc/150?img=3" alt="Avatar">
                                            <span>Ilias Maroun</span>
                                        </div>
                                    </td>
                                    <td>ilias.maround@gmail.com</td>
                                    <td><span class="badge badge-success">Actif</span></td>
                                    <td>04 Oct, 2025</td>
                                </tr>
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
                                <tr>
                                    <td>Tente familiale Quechua 4 places</td>
                                    <td>Ilias Maroun</td>
                                    <td>25 €</td>
                                    <td>05 Oct, 2025</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

</body>

</html>