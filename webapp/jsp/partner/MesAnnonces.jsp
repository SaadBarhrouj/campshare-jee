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
</head>
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col">
    <!-- Navigation -->
    <jsp:include page="components/side-bar.jsp" />

    <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
        <div class="py-8 px-4 md:px-8">
            <!-- Page header -->
            <div class="mb-8 flex flex-col md:flex-row md:items-center md:justify-between">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Annonces</h1>
                    <p class="mt-1 text-gray-600 dark:text-gray-400">
                        Gérez vos annonces d'équipements de camping publiées
                    </p>
                </div>
                <div class="mt-4 md:mt-0 flex space-x-4">
                    <a href="{{ route('partenaire.equipements') }}" class="inline-flex items-center px-4 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-green-600 text-white font-medium rounded-md shadow-sm">
                        <i class="fas fa-plus mr-2"></i>
                        Publier une annonce
                    </a>
                </div>
            </div>

            <!-- Filtres -->
            <div class="mb-6 bg-white dark:bg-gray-800 rounded-lg shadow-sm p-4">
                <div  class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <!-- Recherche -->
                    <div class="md:col-span-2">
                        <label for="search" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Rechercher</label>
                        <div class="relative">
                            <input type="text" name="search" id="search" value="" placeholder="Rechercher par titre, description..." class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Statut -->
                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Statut</label>
                        <select name="status" id="status" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="all">Tous les statuts</option>
                            <option value="active">Actives</option>
                            <option value="archived">Archivée</option>
                        </select>
                    </div>
                    
                    <!-- Tri -->
                    <div>
                        <label for="sort_by" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Trier par</label>
                        <select name="sort_by" id="sort_by" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="newest">Plus récentes</option>
                            <option value="oldest">Plus anciennes</option>
                            <option value="price-asc">Prix croissant</option>
                            <option value="price-desc">Prix décroissant</option>
                        </select>
                    </div>
                    
                   
                </div>
            </div>

            <!-- Liste des annonces -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                <c:choose>
                    <c:when test="${empty PartenerListings}">
                    <div class="p-8 text-center">
                        <div class="inline-flex items-center justify-center w-16 h-16 bg-gray-100 dark:bg-gray-700 rounded-full mb-4">
                            <i class="fas fa-bullhorn text-gray-400 dark:text-gray-500 text-2xl"></i>
                        </div>
                        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">Vous n'avez aucune annonce</h3>
                        <p class="text-gray-600 dark:text-gray-400 mb-4">Commencez par ajouter votre équipement, puis publiez votre première annonce.</p>
                        <a href="{{ route('partenaire.equipements') }}" class="inline-flex items-center px-4 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-green-600 text-white font-medium rounded-md shadow-sm">
                            <i class="fas fa-campground mr-2"></i>
                            Gérer mes équipements
                        </a>
                    </div>
                    </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                            <thead class="bg-gray-50 dark:bg-gray-700">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Annonce</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Statut</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Prix</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Lieu</th>
                                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            
                            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                                <c:forEach var="annonce" items="${PartenerListings}">
                                <tr class="listing-row hover:bg-gray-50 dark:hover:bg-gray-700/50"
                                data-title="${annonce.item.title.toLowerCase()}"
                                data-status="${annonce.status}"
                                data-price="${annonce.item.pricePerDay}"
                                data-date="${annonce.createdAt.time}">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="flex-shrink-0 h-10 w-10">
                                                <c:choose>
                                                    <c:when test="${not empty annonce.item.images}">
                                                        <img class="h-10 w-10 rounded-md object-cover"
                                                            src="${pageContext.request.contextPath}/assets/images/items/${annonce.item.images[0].url}"
                                                            alt="${annonce.item.title}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="h-10 w-10 rounded-md bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                                                            <i class="fas fa-campground text-gray-400 dark:text-gray-500"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                        </div>
                                            <div class="ml-4">
                                                <div class="text-sm font-medium text-gray-900 dark:text-white">
                                                    ${annonce.item.title}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${annonce.status == 'active'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-400">
                                                    Active
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 dark:bg-gray-800 text-gray-800 dark:text-gray-300">
                                                    Inactive
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="text-sm text-gray-900 dark:text-white font-medium">${annonce.item.pricePerDay} MAD</span>
                                        <span class="text-sm text-gray-500 dark:text-gray-400">/jour</span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="text-sm text-gray-900 dark:text-white">${annonce.city.name}</div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <div class="flex space-x-2 justify-end">
                                            <a href="${pageContext.request.contextPath}/partner/AnnonceDetails?listing_id=${annonce.id}" 
                                            class="px-2 py-1 bg-blue-100 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 rounded hover:bg-blue-200 dark:hover:bg-blue-800/50" 
                                            title="Voir les détails">
                                            <i class="fas fa-eye mr-1"></i> Voir
                                            </a>

                                            
                                            <a  href="${pageContext.request.contextPath}/partner/AnnonceEdit?listing_id=${annonce.id}"  class="px-2 py-1 bg-indigo-100 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded hover:bg-indigo-200 dark:hover:bg-indigo-800/50" title="Modifier l'annonce">
                                                <i class="fas fa-edit mr-1"></i> Modifier
                                            </a>
                                            
                                            <form action="${pageContext.request.contextPath}/partner/MesAnnonces" method="POST" class="inline-block">
                                                <input type="hidden" name="action" value="toggle_status">
                                                <input type="hidden" name="listing_id" value="${annonce.id}">
                                                
                                                <c:choose>
                                                    <c:when test="${annonce.status == 'active'}">
                                                        <input type="hidden" name="status" value="archived">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="status" value="active">
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <button type="submit"
                                                    class="<c:choose>
                                                            <c:when test='${annonce.status == "active"}'>
                                                                bg-orange-100 dark:bg-orange-900/30 text-orange-600 dark:text-orange-400 hover:bg-orange-200 dark:hover:bg-orange-800/50
                                                            </c:when>
                                                            <c:otherwise>
                                                                bg-green-100 dark:bg-green-900/30 text-green-600 dark:text-green-400 hover:bg-green-200 dark:hover:bg-green-800/50
                                                            </c:otherwise>
                                                        </c:choose> px-2 py-1 rounded"
                                                    title="<c:choose>
                                                            <c:when test='${annonce.status == "active"}'>Désactiver l'annonce</c:when>
                                                            <c:otherwise>Activer l'annonce</c:otherwise>
                                                        </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${annonce.status == 'active'}">
                                                            <i class="fas fa-toggle-off mr-1"></i> Archiver
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-toggle-on mr-1"></i> Activer
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </form>

                                            <form  action="${pageContext.request.contextPath}/partner/MesAnnonces" method="POST"  class="inline-block" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette annonce ?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="listing_id" value="${annonce.id}">
                                                <button type="submit" class="px-2 py-1 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 rounded hover:bg-red-200 dark:hover:bg-red-800/50" title="Supprimer l'annonce">
                                                    <i class="fas fa-trash mr-1"></i> Supprimer
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                </c:forEach>
                                   
                            </tbody>
                        </table>
                    </div>
                    
                            
                </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('search');
    const statusSelect = document.getElementById('status');
    const sortSelect = document.getElementById('sort_by');

    const tableBody = document.querySelector('tbody'); // <tbody> containing rows
    const rows = Array.from(document.querySelectorAll('.listing-row'));

    function filterAndSort() {
        const search = searchInput.value.toLowerCase();
        const status = statusSelect.value;
        const sortBy = sortSelect.value;

        let filteredRows = rows.filter(row => {
            const title = row.dataset.title.toLowerCase();
            const rowStatus = row.dataset.status;
            return title.includes(search) && (status === 'all' || status === rowStatus);
        });

        filteredRows.sort((a, b) => {
            if (sortBy === 'newest') 
                return Number(b.dataset.date) - Number(a.dataset.date);
            if (sortBy === 'oldest') 
                return Number(a.dataset.date) - Number(b.dataset.date);
            if (sortBy === 'price-asc') 
                return Number(a.dataset.price) - Number(b.dataset.price);
            if (sortBy === 'price-desc') 
                return Number(b.dataset.price) - Number(a.dataset.price);
            return 0;
        });

        // Clear table body
        tableBody.innerHTML = '';

        // Append sorted & filtered rows
        filteredRows.forEach(row => tableBody.appendChild(row));
    }

    // Event listeners
    searchInput.addEventListener('input', filterAndSort);
    statusSelect.addEventListener('change', filterAndSort);
    sortSelect.addEventListener('change', filterAndSort);

    // Initial call
    filterAndSort();
});
</script>

</body>
</html>