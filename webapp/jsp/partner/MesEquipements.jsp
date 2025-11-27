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
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Équipements</h1>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">Gérez toutes vos équipements.</p>
                </div>
                    
                <div class="mt-4 md:mt-0">
                    <button id="add-equipment-button" class="px-4 py-3 bg-forest hover:bg-meadow text-white rounded-md shadow-lg flex items-center font-medium">
                        <i class="fas fa-plus mr-2"></i>
                        Ajouter un équipement
                    </button>
                </div>
                          
            </div>

            <!-- Filters and search -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-4 mb-6">
                <div  class="grid grid-cols-1 md:grid-cols-3 gap-5 gap-x-16">
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
                    
                    <!-- Catégorie -->
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
                        <select name="category" id="category" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="">Toutes les catégories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}" ${param.category == category.id ? 'selected' : ''}>
                                ${category.name}
                            </option>
                        </c:forEach>
                        </select>
                    </div>
                    

                    <div class="md:col-span-2">
                        <label for="sort_by" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Trier par</label>
                        <select name="sort_by" id="sort_by" class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="newest" {{ request('sort_by') == 'newest' ? 'selected' : '' }}>Plus récents</option>
                            <option value="price-asc" {{ request('sort_by') == 'price-asc' ? 'selected' : '' }}>Prix croissant</option>
                            <option value="price-desc" {{ request('sort_by') == 'price-desc' ? 'selected' : '' }}>Prix décroissant</option>
                            <option value="title-asc" {{ request('sort_by') == 'title-asc' ? 'selected' : '' }}>Titre A-Z</option>
                            <option value="title-desc" {{ request('sort_by') == 'title-desc' ? 'selected' : '' }}>Titre Z-A</option>
                        </select>
                        
                    </div>
                    
                    
                </div>
            </div>
            <%-- ${PartenerEquipment} --%>
            <!-- Equipment Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-3 gap-8" id="equipment-container">
                <c:forEach var="equipment" items="${PartenerEquipment}" >
                <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-md hover:shadow-lg transition-shadow overflow-hidden"
                data-title="${equipment.title}"
                data-description="${equipment.description}"
                data-category="${equipment.category.id}"
                data-price="${equipment.pricePerDay}">
                    <div class="relative h-48">
                            <img src="${pageContext.request.contextPath}/uploads/${equipment.images[0].url}" 
                                 alt="${equipment.title}" 
                                 class="w-full h-full object-cover">
                       
                        
                        <div class="absolute top-2 right-2 flex space-x-2">
                            <%-- <button class="edit-equipment-btn p-2 bg-white dark:bg-gray-700 rounded-full shadow-md text-forest dark:text-meadow hover:bg-forest hover:text-white dark:hover:bg-meadow transition-colors" 
                                    data-id="${equipment.id}" 
                                    data-title="${equipment.title}" 
                                    data-description="${equipment.description}" 
                                    data-price="${equipment.pricePerDay}" 
                                    data-category="${equipment.category.id}">
                                <i class="fas fa-edit"></i>
                            </button> --%>
                            <button class="delete-equipment-btn p-2 bg-white dark:bg-gray-700 rounded-full shadow-md text-red-500 hover:bg-red-500 hover:text-white transition-colors" 
                                    data-id="${equipment.id}" 
                                    data-title="${equipment.title}">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="p-4">
                        <div class="flex justify-between items-start mb-2">
                            <div>
                                <h3 class="font-bold text-lg text-gray-900 dark:text-white truncate">${equipment.title}</h3>
                                <span class="text-forest dark:text-meadow font-bold">${equipment.pricePerDay} MAD/jour</span>
                            </div>
                        </div>
                        
                        <div class="flex items-center mb-2">
                            <span class="text-sm text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 rounded-full px-2 py-1" data-category-id="${equipment.category.id}">
                                ${equipment.category.name}
                            </span>
                        </div>
                        
                        <p class="text-gray-600 dark:text-gray-400 text-sm line-clamp-2 mb-3">${equipment.description}</p>


                        <div class="flex items-center justify-between mt-6">

                                <a href="${pageContext.request.contextPath}/partner/AddAnnonce?equipment_id=${equipment.id}" 
                                   class="px-3 py-2 bg-forest hover:bg-meadow text-white rounded-md shadow-sm flex items-center justify-center text-sm ">
                                    <i class="fas fa-bullhorn mr-2"></i> Publier
                                </a>
                                <button class="view-details-btn px-3 py-2 border border-forest text-forest dark:border-meadow dark:text-meadow hover:bg-forest dark:hover:text-white dark:hover:bg-meadow rounded-md text-sm font-medium flex items-center justify-center" 
                                        data-id="${equipment.id}">
                                    <i class="fas fa-eye mr-2"></i> Voir détails
                                </button>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
            
            <!-- Empty state if no equipment -->
            <c:if test="${fn:length(PartenerEquipment) == 0}">
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-8 flex flex-col items-center justify-center">
                    <i class="fas fa-campground text-6xl text-gray-300 dark:text-gray-600 mb-4"></i>
                    <h3 class="text-xl font-medium text-gray-900 dark:text-white mb-2">Vous n'avez aucun équipement</h3>
                    <p class="text-gray-600 dark:text-gray-400 text-center mb-6">Commencez par ajouter votre premier équipement de camping pour le proposer à la location.</p>
                    <button id="add-first-equipment" class="px-5 py-3 bg-forest hover:bg-meadow text-white rounded-md shadow-lg flex items-center font-medium text-lg">
                        <i class="fas fa-plus mr-2"></i> Ajouter un équipement
                    </button>
                </div>
            </c:if>
        </div>
</main>
    <!-- Add Equipment Modal -->
    <div id="add-equipment-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-3xl w-full max-h-screen overflow-y-auto">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Ajouter un équipement</h3>
                <button id="close-add-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <form id="add-equipment-form" action="${pageContext.request.contextPath}/partner/AddItem" method="POST" enctype="multipart/form-data" class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label for="title" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre</label>
                        <input type="text" id="title" name="title" required placeholder="Titre de l'équipement ..."
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                    </div>
                    
                    <div>
                        <label for="category_id" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
                        <select id="category_id" name="category_id" required
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                            <option value="">Sélectionner une catégorie</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label for="price_per_day" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prix par jour (MAD)</label>
                        <input type="number" id="price_per_day" name="price_per_day" min="0" step="0.01" required placeholder="Prix /jour"
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                    </div>
                    
                    <div class="md:col-span-2">
                        <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
                        <textarea id="description" name="description" rows="4" required placeholder="Description de votre équipement ..."
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow"></textarea>
                    </div>
                    
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Images (Minimum 1, Maximum 5 images)</label>
                        <div class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-md px-6 pt-5 pb-6 cursor-pointer" id="image-drop-area">
                            <div class="space-y-1 text-center">
                                <i class="fas fa-cloud-upload-alt text-4xl text-gray-400 dark:text-gray-500 mb-3"></i>
                                <div class="flex text-sm text-gray-600 dark:text-gray-400 justify-center">
                                    <label for="images" class="relative cursor-pointer rounded-md font-medium text-forest dark:text-meadow hover:text-meadow focus-within:outline-none">
                                        <span>Ajouter des images</span>
                                        <input id="images" name="temp_images" type="file" class="sr-only" accept="image/*" multiple>
                                    </label>
                                </div>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-2">
                                    PNG, JPG, GIF jusqu'à 2MB
                                </p>
                                <p class="text-sm font-medium mt-2">
                                    <span id="image-count">0</span>/5 images ajoutées
                                </p>
                            </div>
                        </div>
                        <div id="image-preview-container" class="mt-4 grid grid-cols-2 md:grid-cols-4 gap-4"></div>
                        <div id="image-count-error" class="mt-2 text-red-500 text-sm hidden">Veuillez sélectionner entre 1 et 5 images.</div>
                    </div>
                </div>
                
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancel-add" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                        Annuler
                    </button>
                    <button type="submit" class="px-4 py-2 bg-forest hover:bg-meadow text-white rounded-md shadow-sm">
                        Ajouter l'équipement
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    
    <!-- Edit Equipment Modal -->
    <div id="edit-equipment-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-5xl w-full max-h-screen overflow-y-auto no-scrollbar">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Modifier l'équipement</h3>
                <button id="close-edit-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <form id="edit-equipment-form" action="${pageContext.request.contextPath}/partner/UpdateItem" method="POST" enctype="multipart/form-data" class="p-6">
                <input type="hidden" name="_method" value="PUT">
                <input type="hidden" id="edit-equipment-id" name="equipment_id">
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label for="edit-title" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Titre</label>
                        <input type="text" id="edit-title" name="title" required
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow no-scrollbar">
                    </div>
                    
                    <div>
                        <label for="edit-category_id" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Catégorie</label>
                        <select id="edit-category_id" name="category_id" required
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow ">
                            <option value="">Sélectionner une catégorie</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div>
                        <label for="edit-price_per_day" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prix par jour (MAD)</label>
                        <input type="number" id="edit-price_per_day" name="price_per_day" min="0" step="0.01" required
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow">
                    </div>
                    
                    <div class="md:col-span-2">
                        <label for="edit-description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Description</label>
                        <textarea id="edit-description" name="description" rows="4" required
                                class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow no-scrollbar"></textarea>
                    </div>
                    
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Images actuelles</label>
                        <div id="current-images-container" class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                            <!-- Les images existantes seront chargées ici dynamiquement -->
                        </div>
                        
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1 mt-4">Ajouter de nouvelles images (Minimum 1, Maximum 5 images au total)</label>
                        <div class="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-md px-6 pt-5 pb-6 cursor-pointer" id="edit-image-drop-area">
                            <div class="space-y-1 text-center">
                                <i class="fas fa-cloud-upload-alt text-4xl text-gray-400 dark:text-gray-500 mb-3"></i>
                                <div class="flex text-sm text-gray-600 dark:text-gray-400 justify-center">
                                    <label for="edit-images" class="relative cursor-pointer rounded-md font-medium text-forest dark:text-meadow hover:text-meadow focus-within:outline-none">
                                        <span>Ajouter des images</span>
                                        <input id="edit-images" name="temp_images" type="file" class="sr-only" accept="image/*" multiple>
                                    </label>
                                </div>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-2">
                                    PNG, JPG, GIF jusqu'à 2MB
                                </p>
                                <p class="text-sm font-medium mt-2">
                                    <span id="edit-image-count">0</span>/5 images au total
                                </p>
                            </div>
                        </div>
                        <div id="edit-image-preview-container" class="mt-4 grid grid-cols-2 md:grid-cols-4 gap-4"></div>
                        <div id="edit-image-count-error" class="mt-2 text-red-500 text-sm hidden">Veuillez sélectionner entre 1 et 5 images.</div>
                    </div>
                </div>
                
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancel-edit" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                        Annuler
                    </button>
                    <button type="submit" class="px-4 py-2 bg-forest hover:bg-meadow text-white rounded-md shadow-sm">
                        Mettre à jour l'équipement
                    </button>
                </div>
            </form>
        </div>
    </div>
    <!-- Delete Equipment Modal -->
    <div id="delete-equipment-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-md w-full">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Confirmer la suppression</h3>
                <button id="close-delete-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-6">
                <p class="text-gray-700 dark:text-gray-300 mb-4">
                    Êtes-vous sûr de vouloir supprimer l'équipement <span id="delete-equipment-name" class="font-bold"></span> ? Cette action est irréversible et supprimera également toutes les images et avis associés.
                </p>
                
                <form id="delete-equipment-form" action="" method="POST">
                    <input type="hidden" name="_method" value="DELETE" />
                    <div class="flex justify-end space-x-3">
                        <button type="button" id="cancel-delete" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                            Annuler
                        </button>
                        <button type="submit" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md shadow-sm">
                            Supprimer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- Delete All Equipment Modal -->
    <div id="delete-all-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-md w-full">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Confirmer la suppression de tous les équipements</h3>
                <button id="close-delete-all-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-6">
                <p class="text-gray-700 dark:text-gray-300 mb-4">
                    <i class="fas fa-exclamation-triangle text-yellow-500 mr-2"></i>
                    <strong>Attention :</strong> Vous êtes sur le point de supprimer <strong>tous</strong> vos équipements. Cette action est irréversible et supprimera également toutes les images et avis associés.
                </p>
                
                <form id="delete-all-form" action="${pageContext.request.contextPath}/partner/DeleteAllItems" method="POST">
                    <input type="hidden" name="_method" value="DELETE" />
                    <div class="flex justify-end space-x-3">
                        <button type="button" id="cancel-delete-all" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-md hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                            Annuler
                        </button>
                        <button type="submit" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md shadow-sm">
                            Tout supprimer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div><!-- Equipment Details Modal -->
    <div id="equipment-details-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-6xl w-full max-h-screen overflow-y-auto no-scrollbar">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white" id="detail-title">Détails de l'équipement</h3>
                <button id="close-details-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Colonne de gauche: Images et informations de base -->
                    <div>
                        <div class="bg-gray-100 dark:bg-gray-700 rounded-lg overflow-hidden mb-4">
                            <div id="detail-image-slider" class="w-full h-64 flex overflow-x-auto snap-x snap-mandatory scrollbar-hide no-scrollbar">
                                <!-- Images will be added here dynamically -->
                                <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                                    <i class="fas fa-campground text-5xl text-gray-400 dark:text-gray-500"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Informations générales</h4>
                            <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400">Catégorie</h5>
                                        <p class="text-gray-900 dark:text-white" id="detail-category">-</p>
                                    </div>
                                    <div>
                                        <h5 class="text-sm font-medium text-gray-500 dark:text-gray-400">Prix par jour</h5>
                                        <p class="text-xl font-bold text-forest dark:text-meadow" id="detail-price">-</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Description</h4>
                            <div class="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
                                <p class="text-gray-700 dark:text-gray-300" id="detail-description">-</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Colonne de droite: Statistiques et avis -->
                    <div>
                        <div class="mb-4">
                            <h4 class="font-bold text-lg text-gray-900 dark:text-white mb-2">Statistiques</h4>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-3">
                                    <h5 class="text-sm font-medium text-blue-800 dark:text-blue-300">Nombre d'annonces</h5>
                                    <p class="text-xl font-bold text-blue-600 dark:text-blue-400 mt-1" id="detail-annonces-count">0</p>
                                    <p class="text-xs text-blue-600 dark:text-blue-400" id="detail-active-annonces">0 actives</p>
                                </div>
                                
                                <div class="bg-green-50 dark:bg-green-900/20 rounded-lg p-3">
                                    <h5 class="text-sm font-medium text-green-800 dark:text-green-300">Réservations</h5>
                                    <p class="text-xl font-bold text-green-600 dark:text-green-400 mt-1" id="detail-reservations-count">0</p>
                                    <p class="text-xs text-green-600 dark:text-green-400" id="detail-completed-reservations">0 terminées</p>
                                </div>
                                
                                <div class="bg-purple-50 dark:bg-purple-900/20 rounded-lg p-3">
                                    <h5 class="text-sm font-medium text-purple-800 dark:text-purple-300">Évaluation moyenne</h5>
                                    <div class="flex items-center mt-1">
                                        <span class="text-xl font-bold text-purple-600 dark:text-purple-400 mr-1" id="detail-avg-rating">0</span>
                                        <div class="text-amber-400">
                                            <i class="fas fa-star"></i>
                                        </div>
                                    </div>
                                    <p class="text-xs text-purple-600 dark:text-purple-400" id="detail-review-count">0 avis</p>
                                </div>
                                
                                <div class="bg-amber-50 dark:bg-amber-900/20 rounded-lg p-3">
                                    <h5 class="text-sm font-medium text-amber-800 dark:text-amber-300">Revenus générés</h5>
                                    <p class="text-xl font-bold text-amber-600 dark:text-amber-400 mt-1" id="detail-revenue">0 MAD</p>
                                </div>
                            </div>
                        </div>
                        
                        <div>
                            <div class="flex justify-between items-center mb-2">
                                <h4 class="font-bold text-lg text-gray-900 dark:text-white">Avis</h4>
                                <span class="text-sm text-gray-500 dark:text-gray-400" id="detail-reviews-summary">Chargement...</span>
                            </div>
                            
                            <div id="detail-reviews-container" class="space-y-4 max-h-96 overflow-y-auto pr-2 no-scrollbar">
                                <!-- Reviews will be loaded here dynamically -->
                                <div class="text-center py-8 text-gray-500 dark:text-gray-400" id="no-reviews-message">
                                    <i class="far fa-comment-alt text-3xl mb-2"></i>
                                    <p>Aucun avis pour le moment</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-6 border-t border-gray-200 dark:border-gray-700 pt-4 flex justify-end">
                    <a id="detail-create-annonce-link" href="#" class="px-4 py-2 bg-forest hover:bg-meadow dark:bg-meadow dark:hover:bg-forest text-white font-medium rounded-md shadow-sm transition-colors">
                        <i class="fas fa-bullhorn mr-2"></i>
                        Créer une annonce
                    </a>
                </div>
            </div>
        </div>
    </div>

   <script>
        const addEquipmentButton = document.getElementById('add-equipment-button');
        const addEquipmentForm = document.getElementById('add-equipment-form');
        const addEquipmentModal = document.getElementById('add-equipment-modal');
        const imagePreviewContainer = document.getElementById('image-preview-container');
        const imageInput = document.getElementById('images');
        const deleteEquipmentModal = document.getElementById('delete-equipment-modal');
        const deleteEquipmentForm = document.getElementById('delete-equipment-form');
        const contextPath = '${pageContext.request.contextPath}';


        const viewDetailsButtons = document.querySelectorAll('.view-details-btn');
        const detailsModal = document.getElementById('equipment-details-modal');

            // Show Add Equipment Modal

        if (addEquipmentButton) {
            addEquipmentButton.addEventListener('click', () => {
                addEquipmentModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        }
        if (addEquipmentForm) {
            addEquipmentForm.addEventListener('submit', function(e) {
                // Compter le nombre d'inputs de fichier cachés (qui contiennent les images réelles)
                const hiddenInputs = addEquipmentForm.querySelectorAll('input[type="file"].hidden-file-input');
                const imageCount = hiddenInputs.length;
                const errorDiv = document.getElementById('image-count-error');
                
                if (imageCount < 1 || imageCount > 5) {
                    e.preventDefault();
                    errorDiv.textContent = imageCount < 1 
                        ? "Veuillez sélectionner au moins 1 image."
                        : "Veuillez sélectionner au maximum 5 images.";
                    errorDiv.classList.remove('hidden');
                    return false;
                } else {
                    errorDiv.classList.add('hidden');
                    return true;
                }
            });
        }
        if (imageInput) {
            imageInput.addEventListener('change', function() {
                handleFileSelect(this.files, imagePreviewContainer);
            });
        }
        function handleFileSelect(files, previewContainer) {
            // Limiter à maximum 5 images au total
            const maxFiles = 5;
            const currentImages = previewContainer.querySelectorAll('.relative').length;
            const maxNewImages = maxFiles - currentImages;
            
            if (maxNewImages <= 0) {
                const errorDiv = previewContainer.id === 'image-preview-container' 
                    ? document.getElementById('image-count-error') 
                    : document.getElementById('edit-image-count-error');
                
                if (errorDiv) {
                    errorDiv.textContent = "Maximum 5 images autorisées. Veuillez supprimer des images avant d'en ajouter d'autres.";
                    errorDiv.classList.remove('hidden');
                }
                return;
            }
            
            const filesToProcess = files.length > maxNewImages ? Array.from(files).slice(0, maxNewImages) : files;
            
            // Déterminer le formulaire parent
            const formId = previewContainer.id === 'image-preview-container' 
                ? 'add-equipment-form' 
                : 'edit-equipment-form';
            const form = document.getElementById(formId);
            
            for (let i = 0; i < filesToProcess.length; i++) {
                const file = filesToProcess[i];
                
                if (!file.type.match('image.*')) {
                    continue;
                }
                
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    const imgContainer = document.createElement('div');
                    imgContainer.className = 'relative';
                    imgContainer.dataset.fileIndex = Date.now() + '_' + i; // Identifiant unique
                    
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'w-full h-32 object-cover rounded-md';
                    imgContainer.appendChild(img);
                    
                    // Créer un champ de fichier caché pour cette image spécifique
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'file';
                    hiddenInput.name = 'images[]';
                    hiddenInput.classList.add('hidden-file-input');
                    hiddenInput.style.display = 'none';
                    
                    // Créer un objet DataTransfer pour y mettre le fichier
                    const dataTransfer = new DataTransfer();
                    dataTransfer.items.add(file);
                    hiddenInput.files = dataTransfer.files;
                    
                    // Ajouter l'input au formulaire
                    form.appendChild(hiddenInput);
                    
                    // Stocker la référence à l'input dans le conteneur d'image
                    imgContainer.dataset.inputId = hiddenInput.id = 'file-input-' + imgContainer.dataset.fileIndex;
                    
                    const removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center';
                    removeBtn.innerHTML = '<i class="fas fa-times text-xs"></i>';
                    removeBtn.addEventListener('click', function() {
                        // Supprimer l'input de fichier associé
                        const inputToRemove = document.getElementById(imgContainer.dataset.inputId);
                        if (inputToRemove) {
                            inputToRemove.remove();
                        }
                        
                        // Supprimer la prévisualisation
                        imgContainer.remove();
                        
                        // Masquer le message d'erreur après la suppression
                        const errorDiv = previewContainer.id === 'image-preview-container' 
                            ? document.getElementById('image-count-error') 
                            : document.getElementById('edit-image-count-error');
                        
                        if (errorDiv) {
                            errorDiv.classList.add('hidden');
                        }
                        
                        // Mettre à jour le compteur d'images
                        updateImageCount(previewContainer);
                    });
                    imgContainer.appendChild(removeBtn);
                    
                    previewContainer.appendChild(imgContainer);
                    
                    // Mettre à jour le compteur d'images
                    updateImageCount(previewContainer);
                };
                
                reader.readAsDataURL(file);
            }
            
            // Afficher message d'erreur si dépassement
            const errorDiv = previewContainer.id === 'image-preview-container' 
                ? document.getElementById('image-count-error') 
                : document.getElementById('edit-image-count-error');
            
            if (files.length > maxNewImages && errorDiv) {
                errorDiv.textContent = `Vous ne pouvez ajouter que ${maxNewImages} image(s) supplémentaire(s). Seules les ${maxNewImages} premières ont été sélectionnées.`;
                errorDiv.classList.remove('hidden');
            } else if (errorDiv) {
                errorDiv.classList.add('hidden');
            }
            
            // Réinitialiser l'input de fichier principal pour permettre de sélectionner à nouveau le même fichier
            const mainFileInput = previewContainer.id === 'image-preview-container' 
                ? document.getElementById('images') 
                : document.getElementById('edit-images');
            
            mainFileInput.value = '';
        }
        function updateImageCount(previewContainer) {
            const isEdit = previewContainer.id === 'edit-image-preview-container';
            const imageCount = previewContainer.querySelectorAll('.relative').length;
            
            // Pour l'édition, on compte aussi les images existantes
            if (isEdit) {
                const currentImagesContainer = document.getElementById('current-images-container');
                const keptImagesCount = currentImagesContainer ? currentImagesContainer.querySelectorAll('input[name="keep_images[]"]').length : 0;
                const totalCount = imageCount + keptImagesCount;
                
                const countElement = document.getElementById('edit-image-count');
                if (countElement) {
                    countElement.textContent = totalCount;
                }
            } else {
                // Pour l'ajout simple
                const countElement = document.getElementById('image-count');
                if (countElement) {
                    countElement.textContent = imageCount;
                }
            }
        }

        document.querySelectorAll('.delete-equipment-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const equipmentId = this.dataset.id;
                document.getElementById('delete-equipment-name').textContent = this.dataset.title;
                const form = document.getElementById('delete-equipment-form');

                form.action = contextPath + '/partner/DeleteItem' + '/' + equipmentId;
                deleteEquipmentModal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
            });
        });
        // View Equipment Details
        viewDetailsButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                
                const id = button.getAttribute('data-id');
                
                // Afficher le modal avec indicateur de chargement
                const modal = document.getElementById('equipment-details-modal');
                modal.classList.remove('hidden');
                document.body.classList.add('overflow-hidden');
                
                // Initialiser les éléments avec des indicateurs de chargement
                document.getElementById('detail-title').textContent = 'Chargement...';
                document.getElementById('detail-price').textContent = '...';
                document.getElementById('detail-category').textContent = '...';
                document.getElementById('detail-description').textContent = 'Chargement des informations...';
                document.getElementById('detail-annonces-count').textContent = '...';
                document.getElementById('detail-active-annonces').textContent = '...';
                document.getElementById('detail-reservations-count').textContent = '...';
                document.getElementById('detail-completed-reservations').textContent = '...';
                document.getElementById('detail-avg-rating').textContent = '...';
                document.getElementById('detail-review-count').textContent = '...';
                document.getElementById('detail-revenue').textContent = '...';
                document.getElementById('detail-reviews-summary').textContent = 'Chargement...';
                
                // Vider le conteneur d'images et afficher un placeholder
                const imageSlider = document.getElementById('detail-image-slider');
                imageSlider.innerHTML = `
                    <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                        <i class="fas fa-sync fa-spin text-5xl text-gray-400 dark:text-gray-500"></i>
                    </div>
                `;
                
                // Charger les données détaillées de l'équipement
                console.log('Fetching equipment details for ID:', id);
                console.log('URL:', `${contextPath}/partner/equipment/details?id=${id}`);

                const idbtn = button.getAttribute('data-id');
                
                fetch(contextPath + '/partner/equipment/details?id=' + idbtn)
                    .then(response => {
                        console.log('Response status:', response.status);
                        console.log('Response ok:', response.ok);
                        if (!response.ok) {
                            console.log('Error fetching equipment details:', response.statusText);
                            throw new Error(`Erreur HTTP ${response.status}: ${response.statusText}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log('Equipment details data:', data);
                        // Mettre à jour les informations de base
                        const equipment = data.item;
                        const stats = data.stats;
                        console.log('Equipment title:', data.pricePerDay);
                        document.getElementById('detail-title').textContent = data.item.title;
                        document.getElementById('detail-price').textContent = data.item.pricePerDay + " MAD/jour";;
                        document.getElementById('detail-category').textContent = data.item.category ? data.item.category.name : 'Non catégorisé';
                        document.getElementById('detail-description').textContent = data.item.description || 'Aucune description';
                        
                        // Statistiques
                        document.getElementById('detail-annonces-count').textContent = data.nbrListing;
                        //document.getElementById('detail-active-annonces').textContent = `${stats.active_annonce_count} actives`;
                        document.getElementById('detail-reservations-count').textContent = data.nbrReservation;
                        //document.getElementById('detail-completed-reservations').textContent = `${stats.completed_reservations_count} terminées`;
                       // document.getElementById('detail-revenue').textContent = `${stats.revenue.toLocaleString()} MAD`;
                        
                        // Avis
                        const avgRating = data.item.reviews && data.item.reviews.length > 0 
                            ? data.item.reviews.reduce((sum, review) => sum + review.rating, 0) / data.item.reviews.length 
                            : 0;
                        document.getElementById('detail-avg-rating').textContent = avgRating.toFixed(1);
                        document.getElementById('detail-review-count').textContent = data.item.reviews ? data.item.reviews.length : 0 + "avis";
                        document.getElementById('detail-reviews-summary').textContent = data.item.reviews && data.item.reviews.length > 0 
                            ? `${data.item.reviews.length} avis` 
                            : 'Aucun avis'; 
                        
                        // Images
                        imageSlider.innerHTML = '';
                        
                        // Créer le carousel d'images
                        console.log('Creating image slider with images:', data.item.images);
                        if (data.item.images && data.item.images.length > 0) {
                            // Conteneur pour les indicateurs
                            console.log('Creating image slider with images:', data.item.images);
                            const imageDots = document.createElement('div');
                            imageDots.className = 'flex justify-center mt-2 space-x-2';
                            //imageDots.id = 'detail-image-dots';
                            
                            // Ajouter chaque image au slider
                            data.item.images.forEach((image, index) => {
                                // Créer la diapositive d'image
                                const imgDiv = document.createElement('div');
                                imgDiv.className = 'w-full h-64 flex-shrink-0 snap-center relative overflow-hidden';
                                imgDiv.setAttribute('data-index', index);
                                console.log('Adding image to slider:', image.url);
                                imgDiv.innerHTML = `
                                    <img src="http://localhost:8080/webapp/uploads/\${image.url}" alt="\${data.title}" class="w-full h-full object-cover">
                                    <div class="absolute bottom-2 right-2 bg-black bg-opacity-50 text-white text-xs px-2 py-1 rounded-full">
                                        \${index + 1}/\${data.item.images.length}
                                    </div>
                                `;
                                imageSlider.appendChild(imgDiv);
                                
                                // Créer l'indicateur (point) pour cette image
                                const dot = document.createElement('button');
                                dot.className = `w-3 h-3 rounded-full `;
                                dot.setAttribute('data-index', index);
                                dot.addEventListener('click', () => {
                                    // Faire défiler jusqu'à cette image
                                    const imgElement = imageSlider.querySelector(`[data-index="${index}"]`);
                                    console.log("aa",imgElement);
                                    if (imgElement) {
                                        imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    }
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    dot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    dot.classList.add('bg-forest', 'dark:bg-meadow');
                                });
                                imageDots.appendChild(dot);
                            });
                            
                            // Ajouter les indicateurs sous le slider
                            const sliderContainer = imageSlider.closest('.bg-gray-100, .dark\\:bg-gray-700');
                            sliderContainer.appendChild(imageDots);
                            
                            // Ajouter des contrôles de navigation (boutons précédent/suivant)
                            const prevButton = document.createElement('button');
                            prevButton.className = 'absolute left-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                            prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
                            prevButton.addEventListener('click', () => {
                                console.log('Prev button clicked');
                                // Trouver l'image visible actuelle
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Calculer l'index de l'image précédente
                                const prevIndex = (currentIndex - 1 + data.item.images.length) % data.item.images.length;
                                
                                // Faire défiler jusqu'à l'image précédente
                                const imgElement = imageSlider.querySelector(`[data-index="\${prevIndex}"]`);
                                if (imgElement) {
                                    imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    const activeDot = imageDots.querySelector(`[data-index="\${prevIndex}"]`);
                                    if (activeDot) {
                                        activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                        activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                    }
                                }
                            });
                            
                            const nextButton = document.createElement('button');
                            nextButton.className = 'absolute right-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                            nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
                            nextButton.addEventListener('click', () => {
                                // Trouver l'image visible actuelle
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Calculer l'index de l'image suivante
                                const nextIndex = (currentIndex + 1) % data.item.images.length;
                                
                                // Faire défiler jusqu'à l'image suivante
                                const imgElement = imageSlider.querySelector(`[data-index="\${nextIndex}"]`);
                                if (imgElement) {
                                    imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                    
                                    // Mettre à jour les indicateurs
                                    imageDots.querySelectorAll('button').forEach(btn => {
                                        btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                        btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                    });
                                    const activeDot = imageDots.querySelector(`[data-index="\${nextIndex}"]`);
                                    if (activeDot) {
                                        activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                        activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                    }
                                }
                            });
                            
                            // Ajouter les boutons de navigation directement au slider
                            sliderContainer.appendChild(prevButton);
                            sliderContainer.appendChild(nextButton);
                            sliderContainer.style.position = 'relative';
                            
                            // Détecter le changement d'image lors du défilement
                            imageSlider.addEventListener('scroll', () => {
                                // Calculer l'index de l'image actuellement visible
                                const scrollPosition = imageSlider.scrollLeft;
                                const imgWidth = imageSlider.offsetWidth;
                                const currentIndex = Math.round(scrollPosition / imgWidth);
                                
                                // Mettre à jour les indicateurs
                                imageDots.querySelectorAll('button').forEach(btn => {
                                    btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                    btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                });
                                const activeDot = imageDots.querySelector(`[data-index="\${currentIndex}"]`);
                                if (activeDot) {
                                    activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                }
                            });
                        } else {
                            // Add placeholder if no images
                            const placeholderDiv = document.createElement('div');
                            placeholderDiv.className = 'w-full h-64 bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center';
                            placeholderDiv.innerHTML = '<i class="fas fa-campground text-5xl text-gray-400 dark:text-gray-500"></i>';
                            imageSlider.appendChild(placeholderDiv);
                        }
                        
                        // Lien pour créer une annonce
                        const createAnnonceLink = document.getElementById('detail-create-annonce-link');
                        createAnnonceLink.href = `\${contextPath}/partner/annonces/create?equipment_id=\${data.item.id}`;
                        
                        // Avis
                        const reviewsContainer = document.getElementById('detail-reviews-container');
                        const noReviewsMessage = document.getElementById('no-reviews-message');
                        
                        // Clear previous reviews
                        reviewsContainer.innerHTML = '';
                        
                        if (!data.item.reviews || data.item.reviews.length === 0) {
                            reviewsContainer.appendChild(noReviewsMessage);
                        } else {
                            data.item.reviews.forEach(review => {
                            const reviewDiv = document.createElement('div');
                            reviewDiv.className = 'bg-gray-50 dark:bg-gray-700 p-4 rounded-lg';

                            // Reviewer section
                            const reviewerDiv = document.createElement('div');
                            reviewerDiv.className = 'flex items-center mb-2';

                            const img = document.createElement('img');
                            img.className = 'w-8 h-8 rounded-full mr-2';
                            img.alt = review.reviewer?.username || 'Utilisateur';
                            img.src = review.reviewer?.avatarUrl ? contextPath + '/uploads/' + review.reviewer.avatarUrl
                                                                : contextPath + '/assets/images/default-avatar.png';

                            const infoDiv = document.createElement('div');
                            console.log("img.src:", img.src);
                            const nameDiv = document.createElement('div');
                            nameDiv.textContent = review.reviewer?.username || 'Utilisateur';
                            const dateDiv = document.createElement('div');
                            dateDiv.textContent = new Date(review.createdAt).toLocaleDateString('fr-FR');

                            infoDiv.appendChild(nameDiv);
                            infoDiv.appendChild(dateDiv);

                            reviewerDiv.appendChild(img);
                            reviewerDiv.appendChild(infoDiv);

                            // Stars
                            const starsDiv = document.createElement('div');
                            starsDiv.className = 'flex mb-2';
                            for (let i = 0; i < 5; i++) {
                                const star = document.createElement('i');
                                star.className = i < review.rating ? 'fas fa-star text-amber-400' : 'far fa-star text-amber-400';
                                starsDiv.appendChild(star);
                            }

                            // Comment
                            const commentP = document.createElement('p');
                            commentP.className = 'text-gray-700 dark:text-gray-300';
                            commentP.textContent = review.comment || 'Aucun commentaire';

                            // Assemble
                            reviewDiv.appendChild(reviewerDiv);
                            reviewDiv.appendChild(starsDiv);
                            reviewDiv.appendChild(commentP);

                            reviewsContainer.appendChild(reviewDiv);
                        });
                        }
                    })
                    .catch(error => {
                        console.error('Erreur détaillée:', error);
                        console.error('Message d\'erreur:', error.message);
                        // Afficher un message d'erreur
                        //document.getElementById('detail-title').textContent = 'Erreur de chargement';
                        //document.getElementById('detail-description').textContent = `Erreur: ${error.message}`;
                        
                        // Vider le conteneur d'images et afficher une icône d'erreur
                        
                    });
            });
        });
        

        // Modal event handlers
        const closeAddModal = document.getElementById('close-add-modal');
        const closeEditModal = document.getElementById('close-edit-modal');
        const closeDeleteModal = document.getElementById('close-delete-modal');
        const closeDeleteAllModal = document.getElementById('close-delete-all-modal');
        const closeDetailsModal = document.getElementById('close-details-modal');
        const cancelAdd = document.getElementById('cancel-add');
        const cancelEdit = document.getElementById('cancel-edit');
        const cancelDelete = document.getElementById('cancel-delete');
        const cancelDeleteAll = document.getElementById('cancel-delete-all');

        // Close modals
        if (closeAddModal) {
            closeAddModal.addEventListener('click', () => {
                document.getElementById('add-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeEditModal) {
            closeEditModal.addEventListener('click', () => {
                document.getElementById('edit-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDeleteModal) {
            closeDeleteModal.addEventListener('click', () => {
                document.getElementById('delete-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDeleteAllModal) {
            closeDeleteAllModal.addEventListener('click', () => {
                document.getElementById('delete-all-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (closeDetailsModal) {
            closeDetailsModal.addEventListener('click', () => {
                document.getElementById('equipment-details-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        // Cancel buttons
        if (cancelAdd) {
            cancelAdd.addEventListener('click', () => {
                document.getElementById('add-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelEdit) {
            cancelEdit.addEventListener('click', () => {
                document.getElementById('edit-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelDelete) {
            cancelDelete.addEventListener('click', () => {
                document.getElementById('delete-equipment-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        if (cancelDeleteAll) {
            cancelDeleteAll.addEventListener('click', () => {
                document.getElementById('delete-all-modal').classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            });
        }

        // Close modals when clicking outside
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('fixed')) {
                e.target.classList.add('hidden');
                document.body.classList.remove('overflow-hidden');
            }
        });



    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const searchInput = document.getElementById('search');
            const categorySelect = document.getElementById('category');
            const sortBySelect = document.getElementById('sort_by');
            const container = document.getElementById('equipment-container');
            const cards = Array.from(container.getElementsByClassName('equipment-card'));

            // Filter + Sort function
            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase().trim();
                const selectedCategory = categorySelect.value;
                const sortBy = sortBySelect.value;

                // Filter
                let filtered = cards.filter(card => {
                    const title = card.dataset.title.toLowerCase();
                    const description = card.dataset.description.toLowerCase();
                    const category = card.dataset.category;

                    const matchesSearch = !searchTerm || title.includes(searchTerm) || description.includes(searchTerm);
                    const matchesCategory = !selectedCategory || category === selectedCategory;
                    
                    return matchesSearch && matchesCategory;
                });

                // Sort
                filtered.sort((a, b) => {
                    const priceA = parseFloat(a.dataset.price);
                    const priceB = parseFloat(b.dataset.price);
                    const titleA = a.dataset.title.toLowerCase();
                    const titleB = b.dataset.title.toLowerCase();

                    switch (sortBy) {
                        case 'price-asc': return priceA - priceB;
                        case 'price-desc': return priceB - priceA;
                        case 'title-asc': return titleA.localeCompare(titleB);
                        case 'title-desc': return titleB.localeCompare(titleA);
                        default: return 0; // newest → keep original order
                    }
                });

                // Clear and re-render
                container.innerHTML = '';
                filtered.forEach(card => container.appendChild(card));
            }

            // Event listeners
            searchInput.addEventListener('input', debounce(applyFilters, 300));
            categorySelect.addEventListener('change', applyFilters);
            sortBySelect.addEventListener('change', applyFilters);

            // Debounce helper (for smoother search)
            function debounce(fn, delay) {
                let timeout;
                return (...args) => {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => fn(...args), delay);
                };
            }
        });
    </script>
</body>










</html>








