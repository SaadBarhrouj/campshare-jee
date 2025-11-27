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
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Les Avis Reçus</h1>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez toutes vos demandes de location entrantes.</p>
                </div>
            </div>

            <!-- Filters and search -->
            <div  id="filtersFormulaireAvis" >

                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-4 mb-6">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-4">
                        <h2 class="text-lg font-medium text-gray-900 dark:text-white mb-2 md:mb-0">Filtrer les avis</h2>
                        <div class="relative">
                            <input type="hidden" id="partner-email" name="email" value="{{ $user->email }}">

                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                <i class="fas fa-search text-gray-400"></i>
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-wrap gap-4">
                    <c:set var="statuses" value="all,Tous;forObject,Pour Équipement;forPartner,Pour Partenaire" />
                        <c:forTokens var="status" items="${statuses}" delims=";">
                            <c:set var="parts" value="${fn:split(status, ',')}" />
                            <c:set var="key" value="${parts[0]}" />
                            <c:set var="label" value="${parts[1]}" />

                            <button 
                                type="button"
                                value="${key}"
                                class="filter-chip ${param.type == key || (empty param.type && key == 'all') ? 'active' : ''}">
                                <span>${label}</span>
                            </button>
                        </c:forTokens>
                    </div>
                <input type="hidden" name="type" id="selected-status" value="{{ request('type', 'all') }}">

                    <div class="mt-4 flex flex-col sm:flex-row items-start sm:items-center space-y-2 sm:space-y-0 sm:space-x-4">
                        <div class="flex items-center">
                            <label for="date-filter" class="text-sm text-gray-700 dark:text-gray-300 mr-2">Date</label>
                            <select 
                                id="date-filter" 
                                name="date" 
                                class="px-3 py-1.5 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow text-sm custom-input"
                            >
                                <option value="all" >Toutes les Avis</option>
                                <option value="this-month" >Ce mois-ci</option>
                                <option value="last-month" >Mois dernier</option>
                                <option value="last-3-months">3 derniers mois</option>
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
                    <h2 class="font-bold text-xl text-gray-900 dark:text-white">Liste des Avis Reçus</h2>
                    <span class="bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-300 px-3 py-1 text-xs font-medium rounded-full">
                        2 Total Avis Reçus
                    </span>
                </div>
                <%-- ${ParteneReviews} --%>

                <!-- Request items -->
                <div class="divide-y divide-gray-200 dark:divide-gray-700">
                    <div id="Avis">
                        <c:forEach var="review" items="${ParteneReviews}" >
                            <div class="review-card px-6 py-4" 
                            data-type="${not empty review.item.title ? 'forObject' : 'forPartner'}"
                            data-date="${review.createdAt}">
                                <div class="flex flex-col lg:flex-row lg:items-start">
                                    

                                    <div class="flex-grow grid grid-cols-1 lg:grid-cols-9 gap-3 mb-4 lg:mb-0">
                                        <div class="col-span-2">
                                            <div class="flex gap-2 items-center content-center mb-4 lg:mb-0 lg:mr-6 w-full lg:w-auto">
                                                <div class="flex items-center content-center w-12">
                                                    <a href="{{ route('client.profile.index', 21) }}">
                                                    <img src="${pageContext.request.contextPath}/uploads/${review.reviewer.avatarUrl}"
                                                        alt="Mehdi Idrissi" 
                                                        class="w-12 h-12 rounded-full object-cover" />
                                                    </a>
                                                </div>
                                                <div class="lg:block mt-2 pb-2">
                                                    <a href="{{ route('client.profile.index', 21) }}">
                                                        <h3 class="font-medium text-gray-900 dark:text-white ">${review.reviewer.username}</h3>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div>

                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Note reçue</p>
                                            <div class="flex items-center text-sm">
                                                <i class="fas fa-star text-amber-400 mr-1"></i>
                                                <span>${review.rating}</span>
                                            </div>

                                        </div>
                                        <div class="col-span-4">
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Commentaire</p>
                                            <p class="font-medium text-gray-900 dark:text-white">${review.comment}</p>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty review.item.title}">
                                                <div>
                                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Sur l'équipement</p>
                                                    <p class="font-medium text-gray-900 dark:text-white">${review.item.title}</p>
                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <div>
                                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Sur vous</p>
                                                    <p class="font-medium text-gray-900 dark:text-white">-</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Date</p>
                                            <p class="font-medium text-gray-900 dark:text-white">${review.createdAt}</p>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </c:forEach>
                    </div>



                <!-- Pagination -->
                

                </div>
            </div>
        </div>
    </main>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const filterChips = document.querySelectorAll("#filtersFormulaireAvis .filter-chip");
            const dateFilter = document.getElementById("date-filter");
            const sortBy = document.getElementById("sort-by");
            const reviewsContainer = document.querySelectorAll(".review-card");

            function filterReviews() {
                const selectedType = document.querySelector("#filtersFormulaireAvis .filter-chip.active")?.value || "all";
                const dateValue = dateFilter.value;
                const now = new Date();

                reviewsContainer.forEach(card => {
                    const type = card.dataset.type;
                    const date = new Date(card.dataset.date);

                    let visible = true;

                    // type filter
                    if (selectedType !== "all" && selectedType !== type) {
                        visible = false;
                    }

                    // date filter
                    if (visible) {
                        const monthsDiff = (now.getFullYear() - date.getFullYear()) * 12 + (now.getMonth() - date.getMonth());
                        if (dateValue === "this-month" && monthsDiff !== 0) visible = false;
                        if (dateValue === "last-month" && monthsDiff !== 1) visible = false;
                        if (dateValue === "last-3-months" && monthsDiff > 2) visible = false;
                    }

                    card.style.display = visible ? "" : "none";
                });

                // sort
                const sorted = Array.from(reviewsContainer).sort((a, b) => {
                    const dateA = new Date(a.dataset.date);
                    const dateB = new Date(b.dataset.date);
                    return sortBy.value === "date-asc" ? dateA - dateB : dateB - dateA;
                });

                const parent = sorted[0]?.parentNode;
                if (parent) sorted.forEach(card => parent.appendChild(card));
            }

            // chip click
            filterChips.forEach(chip => {
                chip.addEventListener("click", () => {
                    filterChips.forEach(c => c.classList.remove("active"));
                    chip.classList.add("active");
                    filterReviews();
                });
            });

            // date/sort change
            dateFilter.addEventListener("change", filterReviews);
            sortBy.addEventListener("change", filterReviews);
        });
        </script>
    </body>






</html>








