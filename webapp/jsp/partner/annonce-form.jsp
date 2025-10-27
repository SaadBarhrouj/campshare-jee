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

    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>

    <script src="https://cdn.tailwindcss.com"></script>
    <script src="${pageContext.request.contextPath}/assets/js/partner.js"></script>



   
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
        ${item}
        <div class="mb-8">
            <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Publier une annonce pour  ${item.title}</h1> 
            <p class="text-gray-600 dark:text-gray-400 mt-2">
                Remplissez ce formulaire pour rendre votre équipement disponible à la location.
            </p>
        </div>
        
        <!-- Progress bar -->
        <div class="mb-8">
            <div class="flex items-center justify-between">
                <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2.5">
                    <div class="bg-forest dark:bg-meadow h-2.5 rounded-full progress-bar" style="width: 25%"></div>
                </div>
            </div>
            <div class="flex justify-between mt-2 text-sm text-gray-600 dark:text-gray-400">
                <div class="step-indicator active" data-step="1">
                    <span class="font-medium text-forest dark:text-meadow">1. Informations</span>
                </div>
                <div class="step-indicator" data-step="2">
                    <span>2. Disponibilité</span>
                </div>
                <div class="step-indicator" data-step="3">
                    <span>3. Options</span>
                </div>
                <div class="step-indicator" data-step="4">
                    <span>4. Publication</span>
                </div>
            </div>
        </div>
        
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden mb-10">
            <form id="listing-form" action="${pageContext.request.contextPath}/partner/AddAnnonceForm" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="item_id" value="${item.id}">
                
                <!-- Step 1: Informations de base -->
                <div class="form-step active" id="step-1">
                    <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Informations de l'équipement </h2>
                        <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
                            Vérifiez les détails de votre équipement de camping.
                        </p>
                    </div>
                    
                    <div class="p-6 space-y-6">
                        <!-- Aperçu de l'équipement -->
                        <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-4">
                            <div class="flex items-start">
                            <c:choose>
                                <c:when test="${not empty item.images and fn:length(item.images) > 0}">
                                    <img src="${pageContext.request.contextPath}/assets/images/items/${item.images[0].url}" 
                                        alt="${item.title}" 
                                        class="w-24 h-24 object-cover rounded-md mr-4">
                                </c:when>

                                <c:otherwise>
                                    <div class="w-24 h-24 bg-gray-200 dark:bg-gray-600 rounded-md flex items-center justify-center mr-4">
                                        <i class="fas fa-campground text-gray-400 dark:text-gray-500 text-2xl"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                                
                                <div>
                                    <h3 class="title text-lg font-semibold text-gray-900 dark:text-white">${item.title}</h3>
                                    <p class="priceperday text-forest dark:text-meadow font-medium">${item.pricePerDay} MAD / jour</p>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 mt-1 line-clamp-2">${item.description}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="bg-blue-50 dark:bg-blue-900/20 rounded-md p-4">
                            <h4 class="font-medium text-blue-800 dark:text-blue-300 flex items-center mb-2">
                                <i class="fas fa-info-circle mr-2"></i>
                                Information
                            </h4>
                            <p class="text-sm text-blue-700 dark:text-blue-200">
                                Les informations de base de votre équipement sont déjà renseignées. Vous allez maintenant définir la disponibilité pour créer votre annonce.
                            </p>
                        </div>
                    </div>
                    
                    <div class="p-6 bg-gray-50 dark:bg-gray-700/50 flex justify-end space-x-4">
                        <button type="button" id="next-to-step-2" class="btn-continue px-6 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-forest text-white font-medium rounded-md shadow-sm transition-colors">
                            Continuer vers Disponibilité
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Step 2: Disponibilité et localisation -->
                <div class="form-step" id="step-2" style="display: none;">
                    <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Disponibilité et localisation</h2>
                        <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
                            Définissez quand et où votre équipement sera disponible.
                        </p>
                    </div>
                    
                    <div class="p-6 space-y-6">
                        <!-- Période de disponibilité -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Période de disponibilité</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="start_date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Disponible à partir du</label>
                                    <input type="date" id="start_date" name="start_date" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" required>

                                </div>
                                <div>
                                    <label for="end_date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Disponible jusqu'au</label>
                                    <input type="date" id="end_date" name="end_date" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" required>

                                </div>
                            </div>
                        </div>
                        
                        <!-- Options de livraison -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Options de livraison</h3>
                            <div class="space-y-3">
                                <div class="flex items-start">
                                    <div class="flex items-center h-5">
                                        <input id="delivery_option_pickup" name="delivery_option" type="radio" value="pickup" class="h-4 w-4 text-forest dark:text-meadow focus:ring-forest dark:focus:ring-meadow border-gray-300 dark:border-gray-600" checked>
                                    </div>
                                    <div class="ml-3">
                                        <label for="delivery_option_pickup" class="text-sm font-medium text-gray-700 dark:text-gray-300">Récupération sur place</label>
                                        <p class="text-sm text-gray-500 dark:text-gray-400">
                                            Les locataires devront venir chercher l'équipement à l'adresse indiquée.
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="flex items-start">
                                    <div class="flex items-center h-5">
                                        <input id="delivery_option_delivery" name="delivery_option" type="radio" value="delivery" class="h-4 w-4 text-forest dark:text-meadow focus:ring-forest dark:focus:ring-meadow border-gray-300 dark:border-gray-600">
                                    </div>
                                    <div class="ml-3">
                                        <label for="delivery_option_delivery" class="text-sm font-medium text-gray-700 dark:text-gray-300">Livraison</label>
                                        <p class="text-sm text-gray-500 dark:text-gray-400">
                                            Vous vous engagez à livrer l'équipement au locataire.
                                        </p>
                                    </div>
                                </div>
                                
                            </div>
                         
                        </div>
                        <!-- Localisation -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Localisation</h3>
                            <div class="mb-4">
                                <label for="city_id" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Ville</label>
                                <select id="city_id" name="city_id" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" required>
                                    <option value="">Sélectionnez une ville</option>                                  
                                    <c:forEach var="city" items="${cities}">
                                        <option value="${city.id}">${city.name}</option>
                                    </c:forEach>
                                </select>

                            </div>
                            
                            <div class="mb-4">
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Position exacte</label>
                                <p class="text-gray-500 dark:text-gray-400 text-sm mb-2">Cliquez sur la carte pour indiquer où vous pouvez mettre l'équipement à disposition.</p>
                                
                                <div id="map-container" class="w-full h-80 rounded-lg overflow-hidden border border-gray-300 dark:border-gray-600 mb-3"></div>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                        <label for="latitude" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Latitude</label>
                                        <input type="text" id="latitude" name="latitude" placeholder="Ex: 33.5731104" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" readonly>
                                </div>
                                <div>
                                        <label for="longitude" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Longitude</label>
                                        <input type="text" id="longitude" name="longitude" placeholder="Ex: -7.5898434" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" readonly>
                                    </div>
                                </div>
                                <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
                                    <i class="fas fa-info-circle mr-1"></i> L'emplacement exact ne sera partagé qu'avec les locataires après confirmation de la réservation.
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="p-6 bg-gray-50 dark:bg-gray-700/50 flex justify-between space-x-4">
                        <button type="button" id="back-to-step-1" class="btn-back px-6 py-2 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 font-medium rounded-md shadow-sm border border-gray-300 dark:border-gray-600 transition-colors">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Retour
                        </button>
                        <button type="button" id="next-to-step-4" class="btn-continue px-6 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-forest text-white font-medium rounded-md shadow-sm transition-colors">
                            Continuer vers Publication
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Step 3: Options premium -->
                <div class="form-step" id="step-3" style="display: none;">
                    <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Options de mise en avant</h2>
                        <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
                            Augmentez la visibilité de votre annonce pour attirer plus de locataires.
                        </p>
                    </div>
                    
                    <div class="p-6 space-y-6">
                        <!-- Toggle pour activer les options premium -->
                        <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                            <div>
                                <h3 class="font-medium text-gray-900 dark:text-white">Mettre en avant mon annonce</h3>
                                <p class="text-sm text-gray-500 dark:text-gray-400">
                                    Augmentez la visibilité et obtenez plus de locations
                                </p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" id="is_premium" name="is_premium" class="sr-only peer" value="1">
                                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-forest/20 dark:peer-focus:ring-meadow/20 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-forest dark:peer-checked:bg-meadow"></div>
                            </label>
                        </div>
                        
                        <!-- Options premium (affichées uniquement si la case est cochée) -->
                        <div id="premium-options" class="space-y-4" style="display: none;">
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white">Choisissez votre formule</h3>
                            
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <!-- Option 7 jours -->
                                <div class="premium-option border border-gray-200 dark:border-gray-700 rounded-lg p-4 cursor-pointer hover:border-forest dark:hover:border-meadow transition-colors" data-value="7 jours" data-price="49">
                                    <div class="flex justify-between items-start mb-2">
                                        <h4 class="font-semibold text-gray-900 dark:text-white">Basique</h4>
                                        <span class="bg-amber-100 dark:bg-amber-900/30 text-amber-800 dark:text-amber-300 text-xs px-2 py-1 rounded-full">7 jours</span>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">Apparaît en haut des résultats de recherche pendant 7 jours.</p>
                                    <p class="font-bold text-forest dark:text-meadow">+ 49 MAD</p>
                                    <input type="radio" name="premium_type" value="7 jours" class="hidden premium-radio">
                                </div>
                                
                                <!-- Option 15 jours -->
                                <div class="premium-option border border-gray-200 dark:border-gray-700 rounded-lg p-4 cursor-pointer hover:border-forest dark:hover:border-meadow transition-colors" data-value="15 jours" data-price="89">
                                    <div class="flex justify-between items-start mb-2">
                                        <h4 class="font-semibold text-gray-900 dark:text-white">Standard</h4>
                                        <span class="bg-amber-100 dark:bg-amber-900/30 text-amber-800 dark:text-amber-300 text-xs px-2 py-1 rounded-full">15 jours</span>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">Apparaît en haut des résultats et dans les recommandations pendant 15 jours.</p>
                                    <p class="font-bold text-forest dark:text-meadow">+ 89 MAD</p>
                                    <input type="radio" name="premium_type" value="15 jours" class="hidden premium-radio">
                                </div>
                                
                                <!-- Option 30 jours -->
                                <div class="premium-option border border-gray-200 dark:border-gray-700 rounded-lg p-4 cursor-pointer hover:border-forest dark:hover:border-meadow transition-colors" data-value="30 jours" data-price="149">
                                    <div class="flex justify-between items-start mb-2">
                                        <h4 class="font-semibold text-gray-900 dark:text-white">Premium</h4>
                                        <span class="bg-amber-100 dark:bg-amber-900/30 text-amber-800 dark:text-amber-300 text-xs px-2 py-1 rounded-full">30 jours</span>
                                    </div>
                                    <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">Apparaît en haut des résultats, dans les recommandations et sur la page d'accueil pendant 30 jours.</p>
                                    <p class="font-bold text-forest dark:text-meadow">+ 149 MAD</p>
                                    <input type="radio" name="premium_type" value="30 jours" class="hidden premium-radio">
                                </div>
                            </div>
                            
                            <!-- Message d'information -->
                            <div class="bg-blue-50 dark:bg-blue-900/20 rounded-md p-4 mt-4">
                                <h4 class="font-medium text-blue-800 dark:text-blue-300 flex items-center mb-2">
                                    <i class="fas fa-info-circle mr-2"></i>
                                    Information
                                </h4>
                                <p class="text-sm text-blue-700 dark:text-blue-200">
                                    Le paiement sera prélevé une fois l'annonce publiée.
                                </p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="p-6 bg-gray-50 dark:bg-gray-700/50 flex justify-between space-x-4">
                        <button type="button" id="" class="btn-back px-6 py-2 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 font-medium rounded-md shadow-sm border border-gray-300 dark:border-gray-600 transition-colors">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Retour
                        </button>
                        <button type="button" id="next-to-step-4" class="btn-continue px-6 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-forest text-white font-medium rounded-md shadow-sm transition-colors">
                            Continuer vers Publication
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Step 4: Publication (Récapitulatif) -->
                <div class="form-step" id="step-4" style="display: none;">
                    <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Récapitulatif de votre annonce</h2>
                        <p class="text-gray-600 dark:text-gray-400 text-sm mt-1">
                            Vérifiez les détails de votre annonce avant de la publier.
                        </p>
                    </div>
                    
                    <div class="p-6 space-y-6">
                        <!-- Informations de l'équipement -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-3">Votre équipement</h3>
                            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-4">
                                <div class="flex items-start">
                            <c:choose>
                                <c:when test="${not empty item.images and fn:length(item.images) > 0}">
                                    <img src="${pageContext.request.contextPath}/assets/images/items/${item.images[0].url}" 
                                        alt="${item.title}" 
                                        class="w-24 h-24 object-cover rounded-md mr-4">
                                </c:when>

                                <c:otherwise>
                                    <div class="w-24 h-24 bg-gray-200 dark:bg-gray-600 rounded-md flex items-center justify-center mr-4">
                                        <i class="fas fa-campground text-gray-400 dark:text-gray-500 text-2xl"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                                    
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-900 dark:text-white" id="recap-equipment-title">${item.title}</h4>
                                        <p class="text-forest dark:text-meadow font-medium" id="recap-equipment-price">${item.pricePerDay} MAD / jour</p>
                                    </div>
                                </div>
                            </div>
                            </div>
                            
                        <!-- Détails de l'annonce -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-3">Détails de l'annonce</h3>
                            <div class="bg-gray-50 dark:bg-gray-700/50 rounded-lg p-4 space-y-3">
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                    <div>
                                        <h4 class="text-sm font-medium text-gray-600 dark:text-gray-400">Période de disponibilité</h4>
                                        <p class="text-gray-900 dark:text-white" id="recap-dates">-</p>
                                    </div>
                                    <div>
                                        <h4 class="text-sm font-medium text-gray-600 dark:text-gray-400">Localisation</h4>
                                        <p class="text-gray-900 dark:text-white" id="recap-location">-</p>
                                    </div>
                                    <div>
                                        <h4 class="text-sm font-medium text-gray-600 dark:text-gray-400">Option de livraison</h4>
                                        <p class="text-gray-900 dark:text-white" id="recap-delivery">-</p>
                                    </div>
                                    <div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    
                    <div class="p-6 bg-gray-50 dark:bg-gray-700/50 flex justify-between space-x-4">
                        <button type="button" id="back-to-step-2" class="btn-back px-6 py-2 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 font-medium rounded-md shadow-sm border border-gray-300 dark:border-gray-600 transition-colors">
                            <i class="fas fa-arrow-left mr-2"></i>
                            Retour
                        </button>
                        <button type="submit" id="publish-button" class="px-6 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-green-600 text-white font-medium rounded-md shadow-sm transition-colors flex items-center">
                            <i class="fas fa-paper-plane mr-2"></i>
                            <span id="button-text">Publier l'annonce</span>
                            <span id="premium-text" class="hidden ml-2">- Payer <span id="premium-amount"></span> MAD</span>
                        </button>
                    </div>
                </div>
                
            </form>
        </div>
            </div>
</main>




</body>
</html>