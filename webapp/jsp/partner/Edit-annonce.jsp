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
    <script src="${pageContext.request.contextPath}/assets/js/editAnnonce.js"></script>
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

    <div class="max-w-6xl mx-auto">
     

        <!-- Page header -->
        <div class="mb-8">
            <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Modifier l'annonce pour "${item.title}"</h1>
            <p class="text-gray-600 dark:text-gray-400 mt-2">
                Modifiez les informations de votre annonce.
            </p>
        </div>
        
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden mb-10">
            <form id="listing-form" method="POST" action="${pageContext.request.contextPath}/partner/AnnonceEdit">
    
                <input type="hidden" name="listing_id" value="${listing.id}">

                <!-- Informations de base -->
                <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Informations de l'équipement</h2>
                </div>
                <div class="p-6 space-y-6">
                    <div>
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre</label>
                            <p class="text-gray-800 dark:text-gray-200 font-medium">${item.title}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
                            <p class="text-gray-800 dark:text-gray-200">${item.description}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Disponibilité et localisation -->
                <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Disponibilité et localisation</h2>
                </div>
                <div class="p-6 space-y-6">
                    <!-- Période de disponibilité -->
                    <div>
                        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Période de disponibilité</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="start_date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de début</label>
                                <input type="date" id="start_date" name="start_date" value="${listing.startDate}" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" required>
                            </div>
                            <div>
                                <label for="end_date" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date de fin</label>
                                <input type="date" id="end_date" name="end_date" value="${listing.endDate}" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" required>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Options de livraison -->
                    <div>
                        <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-4">Options de livraison</h3>
                        <div class="space-y-3">
                            <div class="flex items-start">
                                <div class="flex items-center h-5">
                                    <input id="delivery_pickup" name="delivery_option" type="radio" value="pickup" {{ (!$listing-.delivery_option) ? 'checked' : '' }} class="focus:ring-forest dark:focus:ring-meadow h-4 w-4 text-forest dark:text-meadow border-gray-300 dark:border-gray-600 dark:bg-gray-700">
                                </div>
                                <div class="ml-3 text-sm">
                                    <label for="delivery_pickup" class="font-medium text-gray-700 dark:text-gray-300">Récupération sur place uniquement</label>
                                    <p class="text-gray-500 dark:text-gray-400">Les locataires devront venir chercher l'équipement à l'adresse indiquée</p>
                                </div>
                            </div>
                            <div class="flex items-start">
                                <div class="flex items-center h-5">
                                    <input id="delivery_both" name="delivery_option" type="radio" value="both"  class="focus:ring-forest dark:focus:ring-meadow h-4 w-4 text-forest dark:text-meadow border-gray-300 dark:border-gray-600 dark:bg-gray-700">
                                </div>
                                <div class="ml-3 text-sm">
                                    <label for="delivery_both" class="font-medium text-gray-700 dark:text-gray-300">Récupération sur place ou livraison</label>
                                    <p class="text-gray-500 dark:text-gray-400">Vous proposez les deux options aux locataires</p>
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
                                <option value="${city.id}" <c:if test="${city.id == listing.cityId}">selected</c:if> >
                                    ${city.name}
                                </option>
                            </c:forEach>
                        </select>
                        </div>
                        <div class="mb-4">
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Position exacte</label>
                            <p class="text-gray-500 dark:text-gray-400 text-sm mb-2">Cliquez sur la carte pour indiquer où vous pouvez mettre l'équipement à disposition.</p>
                            
                            <div id="map-container" class="z-0 w-full h-80 rounded-lg overflow-hidden border border-gray-300 dark:border-gray-600 mb-3"></div>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="latitude" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Latitude</label>
                                    <input type="text" id="latitude" name="latitude" value="${listing.latitude}" placeholder="Ex: 33.5731104" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" readonly>
                                </div>
                                <div>
                                    <label for="longitude" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Longitude</label>
                                    <input type="text" id="longitude" name="longitude" value="${listing.longitude}" placeholder="Ex: -7.5898434" class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow dark:bg-gray-700 dark:text-white" readonly>
                                </div>
                            </div>
                            <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
                                <i class="fas fa-info-circle mr-1"></i> L'emplacement exact ne sera partagé qu'avec les locataires après confirmation de la réservation.
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Options premium -->
                
                    
                   
                </div>
                
                <!-- Boutons de soumission -->
                <div class="p-6 bg-gray-50 dark:bg-gray-700/50 flex justify-between space-x-4">
                    <a href="{{ route('HomePartenaie.mesannonces') }}" class="btn-cancel px-6 py-2 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-200 font-medium rounded-md shadow-sm border border-gray-300 dark:border-gray-600 transition-colors">
                        <i class="fas fa-times mr-2"></i>
                        Annuler
                    </a>
                    <button type="submit" class="btn-save px-6 py-2 bg-forest hover:bg-green-700 dark:bg-meadow dark:hover:bg-green-600 text-white font-medium rounded-md shadow-sm transition-colors">
                        <i class="fas fa-save mr-2"></i>
                        Enregistrer les modifications
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</main>
</body>



