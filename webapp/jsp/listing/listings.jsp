<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CampShare - Toutes les annonces</title>

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/app.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/styles.css"
    />

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
      integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />

    <link
      rel="icon"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon.ico"
      type="image/x-icon"
    />
    <link
      rel="apple-touch-icon"
      sizes="180x180"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/apple-touch-icon.png"
    />
    <link
      rel="icon"
      type="image/png"
      sizes="32x32"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon-32x32.png"
    />
    <link
      rel="icon"
      type="image/png"
      sizes="16x16"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon-16x16.png"
    />
    <link
      rel="manifest"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/site.webmanifest"
    />
    <link
      rel="mask-icon"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/safari-pinned-tab.svg"
      color="#5bbad5"
    />

    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="theme-color" content="#ffffff" />
    <meta
      name="description"
      content="CampShare - Louez facilement le matériel de camping dont vous avez besoin directement entre particuliers."
    />
    <meta
      name="keywords"
      content="camping, location, matériel, aventure, plein air, partage, communauté"
    />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              forest: "#2D5F2B",
              meadow: "#4F7942",
              earth: "#8B7355",
              wood: "#D2B48C",
              sky: "#5D9ECE",
              water: "#1E7FCB",
              sunlight: "#FFAA33",
            },
          },
        },
        darkMode: "class",
      };

      if (
        window.matchMedia &&
        window.matchMedia("(prefers-color-scheme: dark)").matches
      ) {
        document.documentElement.classList.add("dark");
      }
      window
        .matchMedia("(prefers-color-scheme: dark)")
        .addEventListener("change", (event) => {
          if (event.matches) {
            document.documentElement.classList.add("dark");
          } else {
            document.documentElement.classList.remove("dark");
          }
        });


    </script>

    <!-- Map dependencies -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
    
  </head>
  <body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900">

    <!-- Header -->
    <jsp:include page="/jsp/common/header.jsp" />

    <!-- Page Header -->
    <header class="pt-24 pb-10 bg-gray-50 dark:bg-gray-800 transition-all duration-300">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="max-w-3xl">
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-2">Découvrir le matériel de camping</h1>
                <p class="text-lg text-gray-600 dark:text-gray-300">
                    Trouvez le matériel idéal pour votre prochaine aventure en plein air.
                </p>
                <div class="rounded-lg pt-4 md:pt-6 transition-all duration-300 md:w-180">
                    <form action="${pageContext.request.contextPath}/listings" method="GET" class="flex flex-col md:flex-row space-y-4 md:space-y-0 md:space-x-4">
                        <div class="flex-1">
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-400"></i>
                                </div>
                                <input type="text" id="search" name="search" placeholder="Rechercher des tentes, lampes, boussoles ..." 
                                       value="${search}" class="pl-10 block w-full rounded-md border-gray-300 dark:border-gray-600 shadow-sm focus:border-forest focus:ring-forest dark:bg-gray-700 dark:text-white text-base py-3">
                            </div>
                        </div>
                    
                        <div class="flex items-end">
                            <button type="submit" class="w-full md:w-auto px-6 py-3 bg-sunlight hover:bg-amber-600 text-white font-medium rounded-md shadow-sm transition duration-300 flex items-center justify-center">
                                <i class="fas fa-search mr-2"></i>
                                Rechercher
                            </button>
                        </div>
                    </form>                    
                </div>
                
            </div>
        </div>
    </header>

    <!-- Main -->
    <main class="bg-white dark:bg-gray-900 transition-all duration-300">

      <!-- Filter Panel -->
      <div class="border-b border-gray-200 dark:border-gray-700 shadow-sm top-16 bg-white dark:bg-gray-800 z-40 transition-all duration-300">
        <div class="max-w-7xl mx-auto">
            <div class="px-4 sm:px-6 lg:px-8">
                <div class="py-4 flex flex-wrap items-center justify-between gap-4">
                    <!-- Category Filter Pills -->
                    <div class="flex items-center space-x-3 overflow-x-auto no-scrollbar">
                        <!-- All Categories Button -->
                        <a href="${pageContext.request.contextPath}/listings">
                            <button class="whitespace-nowrap px-5 py-2 ${empty category ? 'bg-forest text-white border-forest' : 'text-sunlight'} rounded-full font-medium border border-sunlight hover:bg-opacity-20 transition-all">
                                Tous les articles
                            </button>
                        </a>

                        <!-- Dynamic Category Buttons -->
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/listings?category=${cat.name}"
                                class="whitespace-nowrap px-5 py-2 ${category == cat.name ? 'bg-forest text-white border-forest' : 'bg-white dark:bg-gray-700 border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-600'} rounded-full font-medium border transition-all">
                                <c:out value="${cat.name}" />
                            </a>
                        </c:forEach>
                    </div>
                    
                    <!-- Price Filter -->
                    <div class="flex items-center space-x-3">
                        <a href="${pageContext.request.contextPath}/listings?price_range=0-50<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if>"
                           class="whitespace-nowrap px-4 py-2 ${priceRange == '0-50' ? 'bg-forest text-white' : 'bg-white dark:bg-gray-700'} rounded-full font-medium border border-gray-200 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-all">
                            0-50 MAD
                        </a>
                        <a href="${pageContext.request.contextPath}/listings?price_range=50-100<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if>"
                           class="whitespace-nowrap px-4 py-2 ${priceRange == '50-100' ? 'bg-forest text-white' : 'bg-white dark:bg-gray-700'} rounded-full font-medium border border-gray-200 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-all">
                            50-100 MAD
                        </a>
                        <a href="${pageContext.request.contextPath}/listings?price_range=100-200<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if>"
                           class="whitespace-nowrap px-4 py-2 ${priceRange == '100-200' ? 'bg-forest text-white' : 'bg-white dark:bg-gray-700'} rounded-full font-medium border border-gray-200 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-all">
                            100-200 MAD
                        </a>
                        <a href="${pageContext.request.contextPath}/listings?price_range=200+<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if>"
                           class="whitespace-nowrap px-4 py-2 ${priceRange == '200+' ? 'bg-forest text-white' : 'bg-white dark:bg-gray-700'} rounded-full font-medium border border-gray-200 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-all">
                            200+ MAD
                        </a>
                        <!-- Reset Button for all filters -->
                        <c:choose>
                            <c:when test="${empty category and empty city and empty priceRange and empty search}">
                                <button class="flex items-center px-4 py-2 bg-sunlight text-white rounded-full font-medium border border-sunlight transition-all opacity-50 cursor-not-allowed" disabled>
                                    <i class="fas fa-times mr-2"></i>
                                    Réinitialiser
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/listings" class="flex items-center px-4 py-2 bg-sunlight hover:bg-amber-600 text-white rounded-full font-medium border border-sunlight transition-all">
                                    <i class="fas fa-times mr-2"></i>
                                    Réinitialiser
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Sort and Map View Options -->
                    <div class="flex space-x-4">
                        
                        <div class="relative">
                            <button id="city-filter-button"
                                class="flex items-center px-4 py-2 bg-white dark:bg-gray-700 rounded-md border border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 transition-all w-46">
                                <i class="fas fa-map-marker-alt mr-2"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty city}">
                                            <c:out value="${city}" />
                                        </c:when>
                                        <c:otherwise>
                                            Toutes les villes
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                        
                            <!-- City Dropdown -->
                            <div id="city-dropdown" class="hidden absolute right-0 mt-1 w-46 bg-white dark:bg-gray-700 rounded-md shadow-lg z-50 border border-gray-200 dark:border-gray-600 max-h-64 overflow-y-auto">
                                <div class="py-1">
                                    <a href="${pageContext.request.contextPath}/listings<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>"
                                       class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">Toutes les villes</a>
                                    <c:forEach var="cityItem" items="${cities}">
                                        <a href="${pageContext.request.contextPath}/listings?city=${cityItem.name}<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>"
                                           class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">
                                            <c:out value="${cityItem.name}" />
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        
                        <div class="relative">
                            <button id="sort-button" 
                                class="flex items-center px-4 py-2 bg-white dark:bg-gray-700 rounded-md border border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 transition-all w-46">
                                <i class="fas fa-sort mr-2"></i>
                                <span>
                                    <c:choose>
                                        <c:when test="${sort == 'price_asc'}">Prix croissant</c:when>
                                        <c:when test="${sort == 'price_desc'}">Prix décroissant</c:when>
                                        <c:when test="${sort == 'oldest'}">Plus anciens</c:when>
                                        <c:otherwise>Plus récents</c:otherwise>
                                    </c:choose>
                                </span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                            
                            <!-- Sort Dropdown -->
                            <div id="sort-dropdown" class="hidden absolute right-0 mt-1 w-46 bg-white dark:bg-gray-700 rounded-md shadow-lg z-50 border border-gray-200 dark:border-gray-600">
                                <div class="py-1">
                                    <a href="${pageContext.request.contextPath}/listings?sort=price_asc<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>" 
                                    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">Prix croissant</a>
                                    <a href="${pageContext.request.contextPath}/listings?sort=price_desc<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>" 
                                    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">Prix décroissant</a>
                                    <a href="${pageContext.request.contextPath}/listings?sort=oldest<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>" 
                                    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">Plus anciens</a>
                                    <a href="${pageContext.request.contextPath}/listings?sort=latest<c:if test='${not empty category}'>&category=${category}</c:if><c:if test='${not empty city}'>&city=${city}</c:if><c:if test='${not empty priceRange}'>&price_range=${priceRange}</c:if>" 
                                    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600">Plus récents</a>
                                </div>
                            </div>
                        </div>
                        
                        <button id="toggleMapBtn" class="flex items-center px-4 py-2 bg-white dark:bg-gray-700 rounded-md border border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 transition-all">
                            <i class="fas fa-map-marked-alt mr-2"></i>
                            <span>Voir la carte</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
      </div>


      <!-- Regular Listings Section -->
      <section class="py-10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

            <!-- Map -->
            <div id="listing-map-container" class="hidden mt-4 mb-8 h-80 sm:h-120 bg-gray-200 dark:bg-gray-700 rounded-lg flex items-center justify-center text-gray-500 dark:text-gray-400 border border-gray-300 dark:border-gray-600 z-0"></div>

            <div class="flex items-center justify-between mb-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white flex items-center">Équipements disponibles (<c:out value="${listingsCount}" />)</h2>
                    <p class="text-gray-600 dark:text-gray-300">Trouvez le matériel idéal avec nos partenaires.</p>
                </div>
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Regular Listings -->
                <c:choose>
                    <c:when test="${not empty listings}">
                        <c:forEach var="listingData" items="${listings}">
                            <c:set var="listing" value="${listingData.listing}" />
                            <c:set var="item" value="${listingData.item}" />
                            <c:set var="category" value="${listingData.category}" />
                            <c:set var="city" value="${listingData.city}" />
                            <c:set var="partner" value="${listingData.partner}" />
                            <c:set var="firstImage" value="${listingData.firstImage}" />
                            <c:set var="reviewCount" value="${listingData.reviewCount}" />
                            <c:set var="averageRating" value="${listingData.averageRating}" />
                            
                            <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden transform transition duration-300 hover:shadow-md hover:-translate-y-1 relative">
                                <div class="absolute top-4 left-4 z-10 bg-forest text-white rounded-full px-3 py-1 font-medium text-xs flex items-center">
                                    <c:out value="${category.name}" />
                                </div>
                                <a href="${pageContext.request.contextPath}/listing?id=${listing.id}">
                                    <div class="relative h-48">
                                        <c:choose>
                                            <c:when test="${not empty firstImage}">
                                                <img src="${pageContext.request.contextPath}/<c:out value='${firstImage.url}' />"
                                                    alt="<c:out value='${item.title}' />" 
                                                    class="w-full h-full object-cover" />
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/images/item-default.jpg"
                                                    alt="<c:out value='${item.title}' />" 
                                                    class="w-full h-full object-cover" />
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="p-4">
                                        <div class="flex justify-between items-start mb-2">
                                            <div>
                                                <h3 class="font-bold text-gray-900 dark:text-white"><c:out value="${item.title}" /></h3>
                                                <p class="text-sm text-gray-500 dark:text-gray-400">Catégorie - <c:out value="${category.name}" /></p>
                                            </div>
                                            <div class="flex items-center text-sm flex-nowrap mt-1">
                                                <span class="flex items-center whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${reviewCount > 0}">
                                                            <i class="fa-solid fa-star text-amber-400 mr-1 ml-3"></i>
                                                            <span class="text-gray-900 dark:text-white font-medium">
                                                                ${averageRating}
                                                            </span>
                                                            <span class="text-gray-500 dark:text-gray-400 ml-1">
                                                                (${reviewCount} <c:choose><c:when test="${reviewCount == 1}">avis</c:when><c:otherwise>avis</c:otherwise></c:choose>)
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star text-amber-400 mr-1 ml-3"></i>
                                                            <span class="text-gray-500 dark:text-gray-400">Non noté</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="flex items-center text-sm text-gray-600 dark:text-gray-300 mb-2">
                                            <i class="fas fa-user mr-1 text-gray-400"></i>
                                            <a href="${pageContext.request.contextPath}/partner/${partner.id}" class="hover:text-forest dark:hover:text-sunlight"><c:out value="${partner.username}" /></a>
                                        </div>
                                        
                                        <div class="flex items-center text-sm text-gray-600 dark:text-gray-300 mb-2">
                                            <i class="fas fa-map-marker-alt mr-1 text-gray-400"></i>
                                            <span><c:out value="${city.name}" />, Maroc</span>
                                        </div>
                                        
                                        <div class="text-sm mb-3">
                                            <span class="text-gray-600 dark:text-gray-300">Disponible du <c:out value="${listing.startDate}" /> au <c:out value="${listing.endDate}" /></span>
                                        </div>
                                        
                                        <div class="flex justify-between items-center">
                                            <div>
                                                <span class="font-bold text-lg text-gray-900 dark:text-white"><c:out value="${item.pricePerDay}" /> MAD</span>
                                                <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/listing?id=${listing.id}" class="inline-block">
                                                <button class="px-4 py-2 bg-forest hover:bg-green-700 text-white rounded-md transition-colors shadow-sm">
                                                    Voir détails
                                                </button>
                                            </a>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full text-center py-12">
                            <p class="text-gray-500 dark:text-gray-400 text-lg">Aucune annonce publiée encore.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Pagination -->
            <div class="mt-12 flex justify-center">
                <!-- Pagination will be implemented later -->
            </div>
        </div>
      </section>
      
    </main>

    <!-- Footer -->
    <jsp:include page="/jsp/common/footer.jsp" />

    <!-- Map Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const toggleBtn = document.getElementById('toggleMapBtn');
            const mapContainer = document.getElementById('listing-map-container');
            console.log("Initializing map...");
            const locations = [
                <c:forEach var="listingData" items="${listings}" varStatus="loop">
                    {
                        lat: ${listingData.listing.latitude},
                        lng: ${listingData.listing.longitude},
                        title: "<c:out value='${listingData.item.title}' />",
                        url: "${pageContext.request.contextPath}/listing?id=${listingData.listing.id}",
                        category: "<c:out value='${listingData.category.name}' />",
                        username: "<c:out value='${listingData.partner.username}' />",
                        image: "rrr"
                    }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ];
            console.log("Locations loaded:", locations);
            let map = null;
            let mapInitialized = false;
    
            toggleBtn.addEventListener('click', function () {
                mapContainer.classList.toggle('hidden');
    
                if (!mapInitialized && !mapContainer.classList.contains('hidden')) {
                    if (!locations.length) return;
    
                    map = L.map('listing-map-container').setView([locations[0].lat, locations[0].lng], 10);
    
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; OpenStreetMap contributors',
                        maxZoom: 19
                    }).addTo(map);
    
                    const bounds = [];
    
                    locations.forEach(loc => {
                        if (loc.lat && loc.lng) {
                            // Small offset to hide the exact location (±0.01 degrees ≈ ±1km)
                            const offsetLat = loc.lat + (Math.random() - 0.5) * 0.02;
                            const offsetLng = loc.lng + (Math.random() - 0.5) * 0.02;
    
                            const circle = L.circle([offsetLat, offsetLng], {
                                color: '#3b82f6',
                                fillColor: '#93c5fd',
                                fillOpacity: 0.3,
                                radius: 1500 
                            }).addTo(map);
    
                            circle.bindPopup(`
                                <div class="flex gap-2 items-center" style="min-width: 250px;">
                                    <img src="${loc.image}" alt="Image" style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px;">
                                    <div>
                                        <strong>${loc.title}</strong><br>
                                        <small>Catégorie: ${loc.category}</small><br>
                                        <small>Partenaire: ${loc.username}</small><br>
                                        <em>Zone approximative</em>
                                    </div>
                                </div>
                            `);
    
                            circle.on('click', function () {
                                window.location.href = loc.url;
                            });

                            circle.on('mouseover', function () {
                                this.openPopup();
                            });
                            circle.on('mouseout', function () {
                                this.closePopup();
                            });

                            bounds.push([offsetLat, offsetLng]);

                        }
                    });
    
                    if (bounds.length) map.fitBounds(bounds);
    
                    mapInitialized = true;
                }
    
                // Change button text
                const span = toggleBtn.querySelector('span');
                span.textContent = mapContainer.classList.contains('hidden') ? 'Voir la carte' : 'Cacher la carte';
            });
        });

        // Sort dropdown toggle
        const sortButtonCity = document.getElementById('city-filter-button');
        const sortDropdownCity = document.getElementById('city-dropdown');

        sortButtonCity?.addEventListener('click', () => {
            sortDropdownCity.classList.toggle('hidden');
        });

        // Hide sort dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (sortButtonCity && !sortButtonCity.contains(e.target) && !sortDropdownCity.contains(e.target)) {
                sortDropdownCity.classList.add('hidden');
            }
        });

        // Sort dropdown toggle
        const sortButton = document.getElementById('sort-button');
        const sortDropdown = document.getElementById('sort-dropdown');

        sortButton?.addEventListener('click', () => {
            sortDropdown.classList.toggle('hidden');
        });

        // Hide sort dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (sortButton && !sortButton.contains(e.target) && !sortDropdown.contains(e.target)) {
                sortDropdown.classList.add('hidden');
            }
        });
    </script>

  </body>
</html>