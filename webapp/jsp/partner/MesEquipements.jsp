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
                            <img src="${pageContext.request.contextPath}//assets/images/items/${equipment.images[0].url}" 
                                 alt="${equipment.title}" 
                                 class="w-full h-full object-cover">
                       
                        
                        <div class="absolute top-2 right-2 flex space-x-2">
                            <button class="edit-equipment-btn p-2 bg-white dark:bg-gray-700 rounded-full shadow-md text-forest dark:text-meadow hover:bg-forest hover:text-white dark:hover:bg-meadow transition-colors" 
                                    data-id="{{ $equipment->id }}" 
                                    data-title="{{ $equipment->title }}" 
                                    data-description="{{ $equipment->description }}" 
                                    data-price="{{ $equipment->price_per_day }}" 
                                    data-category="{{ $equipment->category_id }}">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="delete-equipment-btn p-2 bg-white dark:bg-gray-700 rounded-full shadow-md text-red-500 hover:bg-red-500 hover:text-white transition-colors" 
                                    data-id="{{ $equipment->id }}" 
                                    data-title="{{ $equipment->title }}">
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
                            <span class="text-sm text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-700 rounded-full px-2 py-1" data-category-id="{{ $equipment->category_id }}">
                                ${equipment.category.name}
                            </span>
                        </div>
                        
                        <p class="text-gray-600 dark:text-gray-400 text-sm line-clamp-2 mb-3">${equipment.description}</p>


                        <div class="flex items-center justify-between mt-6">
                            
                                <a href="{{ route('partenaire.annonces.create', ['equipment_id' => $equipment->id]) }}" 
                                   class="px-3 py-2 bg-forest hover:bg-meadow text-white rounded-md shadow-sm flex items-center justify-center text-sm ">
                                    <i class="fas fa-bullhorn mr-2"></i> Publier
                                </a>
                                <button class="view-details-btn px-3 py-2 border border-forest text-forest dark:border-meadow dark:text-meadow hover:bg-forest dark:hover:text-white dark:hover:bg-meadow rounded-md text-sm font-medium flex items-center justify-center" 
                                        data-id="{{ $equipment->id }}">
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
            <form id="add-equipment-form" action="{{ route('partenaire.equipements.create') }}" method="POST" enctype="multipart/form-data" class="p-6">
                @csrf
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
                            @foreach(\App\Models\Category::all() as $category)
                                <option value="{{ $category->id }}">{{ $category->name }}</option>
                            @endforeach
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
    </div><!-- Edit Equipment Modal -->
    <div id="edit-equipment-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-5xl w-full max-h-screen overflow-y-auto no-scrollbar">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center sticky top-0 bg-white dark:bg-gray-800 z-10">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">Modifier l'équipement</h3>
                <button id="close-edit-modal" class="text-gray-400 hover:text-gray-500 dark:hover:text-gray-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <form id="edit-equipment-form" method="POST" enctype="multipart/form-data" class="p-6">
                @csrf
                @method('PUT')
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
                            @foreach(\App\Models\Category::all() as $category)
                                <option value="{{ $category->id }}">{{ $category->name }}</option>
                            @endforeach
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
    </div><!-- Delete Equipment Modal -->
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
                    @csrf
                    @method('DELETE')
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
    </div><!-- Delete All Equipment Modal -->
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
                
                <form id="delete-all-form" action="{{ route('partenaire.equipements.delete-all') }}" method="POST">
                    @csrf
                    @method('DELETE')
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
                    <a id="detail-create-annonce-link" href="#" class="px-4 py-2 bg-forest hover:bg-meadow dark:bg-meadow dark:hover:bg-forest/partenaire/annonces/create/ text-white font-medium rounded-md shadow-sm transition-colors">
                        <i class="fas fa-bullhorn mr-2"></i>
                        Créer une annonce
                    </a>
                </div>
            </div>
        </div>
    </div>

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








