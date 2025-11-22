<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Dashboard Partenaire</title>

    <!-- Styles / Scripts -->

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    

    <link rel="icon" href="{{ asset('images/favicon_io/favicon.ico') }}" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="180x180" href="{{ asset('images/favicon_io/apple-touch-icon.png') }}">
    <link rel="icon" type="image/png" sizes="32x32" href="{{ asset('images/favicon_io/favicon-32x32.png') }}">
    <link rel="icon" type="image/png" sizes="16x16" href="{{ asset('images/favicon_io/favicon-16x16.png') }}">
    <link rel="manifest" href="{{ asset('images/favicon_io/site.webmanifest') }}">
    <link rel="mask-icon" href="{{ asset('images/favicon_io/safari-pinned-tab.svg') }}" color="#5bbad5">
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

        // Detect dark mode preference
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
    <style>
        .filter-chip {
        @apply px-3 py-1.5 rounded-full text-sm font-medium cursor-pointer transition-colors mr-2 mb-2;
        @apply bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300;
    }

    .filter-chip.active {
        @apply bg-forest dark:bg-meadow text-white;
    }

    .filter-chip:hover {
        @apply bg-gray-200 dark:bg-gray-600;
    }

    .filter-chip.active:hover {
        @apply bg-green-700 dark:bg-green-600;
    }

    </style>
    
    <style>
        .filter-chip {
        @apply px-3 py-1.5 rounded-full text-sm font-medium cursor-pointer transition-colors mr-2 mb-2;
        @apply bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300;
    }

    .filter-chip.active {
        @apply bg-forest dark:bg-meadow text-white;
    }

    .filter-chip:hover {
        @apply bg-gray-200 dark:bg-gray-600;
    }

    .filter-chip.active:hover {
        @apply bg-green-700 dark:bg-green-600;
    }

    /* Filter chip styles */
    .filter-chip {
                display: inline-flex;
                align-items: center;
                padding: 0.5rem 0.75rem;
                border-radius: 0.375rem;
                font-size: 0.875rem;
                font-weight: 500;
                margin-right: 0.5rem;
                margin-bottom: 0.5rem;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .filter-chip.active {
                background-color: #2D5F2B;
                color: white;
            }

            .dark .filter-chip.active {
                background-color: #4F7942;
            }

            .filter-chip:not(.active) {
                background-color: #f3f4f6;
                color: #374151;
                border: 1px solid #e5e7eb;
            }

            .dark .filter-chip:not(.active) {
                background-color: #374151;
                color: #e5e7eb;
                border: 1px solid #4b5563;
            }

            .filter-chip:hover:not(.active) {
                background-color: #e5e7eb;
            }

            .dark .filter-chip:hover:not(.active) {
                background-color: #4b5563;
            }

    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col">
<jsp:include page="components/side-bar.jsp" />

    <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
        <div class="py-8 px-4 md:px-8">
            <!-- Page header -->
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Demandes de Réservation</h1>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez toutes vos demandes de location entrantes.</p>
                </div>
            </div>

            <!-- Filters and search -->
            <div id="formulaire1-filters" >

                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-4 mb-6">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4">
                        <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-2 md:mb-0">Filtrer les demandes</h2>
                        <div class="relative">
                            <input 
                                type="text" 
                                name="search"
                                placeholder="Rechercher..." 
                                class="px-4 py-2 pr-10 w-full md:w-64 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow text-base custom-input"
                            >
                            <input type="hidden" id="partner-email" name="email" value="{{ $user->email }}">

                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>
                    </div>



                    <div class="mt-4 flex flex-col sm:flex-row items-start sm:items-center space-y-2 sm:space-y-0 sm:space-x-4">
                        <div class="flex items-center">
                            <label for="date-filter" class="text-sm text-gray-700 dark:text-gray-300 mr-2">Date</label>
                            <select 
                                id="date-filter" 
                                name="date" 
                                class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow text-sm custom-input"
                            >
                                <option value="all" >Toutes les dates</option>
                                <option value="this-month" >Ce mois-ci</option>
                                <option value="last-month" >Mois dernier</option>
                                <option value="last-3-months" >3 derniers mois</option>
                            </select>
                        </div>

                        <div class="flex items-center">
                            <label for="sort-by" class="text-sm text-gray-700 dark:text-gray-300 mr-2">Trier par</label>
                            <select 
                                id="sort-by" 
                                name="sort" 
                                class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow text-sm custom-input"
                            >
                                <option value="date-desc" >Date (plus récent)</option>
                                <option value="date-asc" >Date (plus ancien)</option>
                            
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden mb-6">
                <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
                    <h2 class="font-bold text-xl text-gray-900 dark:text-white">Liste des demandes</h2>
                    <span class="bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-300 px-3 py-1 text-xs font-medium rounded-full">
                       ${fn:length(PartenerReservation)} Réservations en cours
                    </span>
                </div>

                <!-- Request items -->
                <div class="divide-y divide-gray-200 dark:divide-gray-700">
                    <div id="reservations1">
                        <c:forEach var="location" items="${PartenerReservavtion}" >
                            <div class="reservation-card px-6 py-4"
                            data-client="${location.client.username}"
                            data-equipment="${location.listing.item.title}"
                            data-start="${location.startDate}"
                            data-end="${location.endDate}"
                            data-date="${location.startDate}">
                                <div class="flex flex-col lg:flex-row lg:items-start">
                                    <div class="flex gap-2 mb-4 lg:mb-0 lg:mr-28 w-full lg:w-auto">
                                        <div class="flex items-center lg:w-16">
                                            <img src="${pageContext.request.contextPath}/assets/images/users/${location.client.avatarUrl}"
                                                alt="${location.client.username}" 
                                                class="w-12 h-12 rounded-full object-cover" />
                                            <div class="lg:hidden ml-3">
                                                <h3 class="font-medium text-gray-900 dark:text-white">${location.client.username}</h3>
                                                
                                            </div>
                                        </div>
                                        <div class="hidden lg:block mt-2">
                                            <h3 class="font-medium text-gray-900 dark:text-white text-center">${location.client.username}</h3>
                                            
                                        </div>
                                    </div>

                                    <div class="flex-grow grid grid-cols-1 lg:grid-cols-3 gap-4 mb-4 lg:mb-0">
                                        <div>
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Équipement</p>
                                            <p class="font-medium text-gray-900 dark:text-white flex items-center">
                                                <span class="truncate">${location.listing.item.title}</span>
                                            </p>
                                        </div>
                                        <div>
                                           
                                                <fmt:parseDate value="${location.startDate}" pattern="yyyy-MM-dd" var="startDate" />
                                                <fmt:parseDate value="${location.endDate}" pattern="yyyy-MM-dd" var="endDate" />

                                                <c:set var="diffMs" value="${endDate.time - startDate.time}" />

                                                <!-- Convert to days (1000 * 60 * 60 * 24 = 86400000) -->
                                                <c:set var="diffDays" value="${diffMs / (1000*60*60*24)}" />

                
                                                <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Durée de résérvation</p>
                                                <p class="font-medium text-gray-900 dark:text-white">${location.startDate} - ${location.endDate}</p>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">( ${diffDays} jours )</p>
                                        </div>
                                        <div>
                                            <c:set var="montantTotal" value="${location.listing.item.pricePerDay * diffDays}" />

                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Montant</p>
                                                <p class="font-medium text-gray-900 dark:text-white">${montantTotal} MAD</p>
                                                <p class="text-xs text-gray-500 dark:text-gray-400">( ${location.listing.item.pricePerDay} MAD /jour )</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </c:forEach>
                    </div>



                <%-- <!-- Pagination -->
                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-700/50 flex items-center justify-between">
                    <div class="text-sm text-gray-600 dark:text-gray-400">
                        Affichage de 
                        <span class="font-medium text-gray-900 dark:text-white">
                            {{ $LocationsEncours->firstItem() }}
                        </span> 
                        à 
                        <span class="font-medium text-gray-900 dark:text-white">
                            {{ $LocationsEncours->lastItem() }}
                        </span> 
                        sur 
                        <span class="font-medium text-gray-900 dark:text-white">
                            {{ $LocationsEncours->total() }}
                        </span> demandes
                    </div>
                    <div>
                        {{ $LocationsEncours->links() }}
                    </div>
                </div> --%>

                </div>
            </div>
        </div>
    </main>
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const searchInput = document.querySelector('#formulaire1-filters input[name="search"]');
        const dateSelect = document.querySelector('#date-filter');
        const sortSelect = document.querySelector('#sort-by');
        const cards = Array.from(document.querySelectorAll('.reservation-card'));

        function applyFilters() {
            const search = searchInput.value.toLowerCase();
            const dateFilter = dateSelect.value;
            const now = new Date();

            cards.forEach(card => {
                const client = card.dataset.client.toLowerCase();
                const equipment = card.dataset.equipment.toLowerCase();
                const startDate = new Date(card.dataset.start);
                let show = true;

                // Search
                if (search && !(client.includes(search) || equipment.includes(search))) {
                    show = false;
                }

                // Date filter
                if (dateFilter !== 'all') {
                    const firstOfThisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
                    const firstOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
                    const threeMonthsAgo = new Date(now.getFullYear(), now.getMonth() - 3, 1);

                    if (dateFilter === 'this-month' && startDate < firstOfThisMonth) show = false;
                    if (dateFilter === 'last-month' && !(startDate >= firstOfLastMonth && startDate < firstOfThisMonth)) show = false;
                    if (dateFilter === 'last-3-months' && startDate < threeMonthsAgo) show = false;
                }

                card.style.display = show ? '' : 'none';
            });

            applySort();
        }

        function applySort() {
            const sortValue = sortSelect.value;
            const container = cards[0]?.parentElement;

            const sortedCards = [...cards].sort((a, b) => {
                const dateA = new Date(a.dataset.start);
                const dateB = new Date(b.dataset.start);
                return sortValue === 'date-asc' ? dateA - dateB : dateB - dateA;
            });

            container.innerHTML = '';
            sortedCards.forEach(card => container.appendChild(card));
        }

        searchInput.addEventListener('input', applyFilters);
        dateSelect.addEventListener('change', applyFilters);
        sortSelect.addEventListener('change', applyFilters);
    });
    </script>
</body>




</html>







