<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900">
    <div class="py-8 px-4 md:px-8">
        <div class="mb-8">
            
            <section class="bg-gray-50 dark:bg-gray-800 py-10 border-b border-gray-200 dark:border-gray-700">
                <div id="profileView">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div class="flex flex-col md:flex-row items-start md:items-center">
                            <div class="relative mb-6 md:mb-0 md:mr-8">
                                <div class="w-24 h-24 md:w-32 md:h-32 rounded-full overflow-hidden border-4 border-white dark:border-gray-700 shadow-md">
                                    <img src="${pageContext.request.contextPath}/uploads/${userProfile.avatarUrl}"
                                         alt="${userProfile.username}"
                                         class="w-full h-full object-cover" />
                                </div>
                                <div class="absolute -bottom-2 -right-2 bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center border-2 border-white dark:border-gray-700">
                                    <i class="fas fa-check"></i>
                                </div>
                            </div>

                            <div class="flex-1">
                                <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-4">
                                    <div>
                                        <h1 class="text-3xl font-bold text-gray-900 dark:text-white flex items-center">
                                            <span>${userProfile.firstName} ${userProfile.lastName} - ${userProfile.username}</span>
                                            <span class="ml-3 text-sm font-medium px-2 py-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-md">
                                                Membre depuis
                                                <fmt:formatDate value="${userProfile.createdAt}" pattern="MM/yyyy"/>
                                            </span>
                                        </h1>
                                        <div class="mt-2 flex items-center text-gray-600 dark:text-gray-300">
                                            <i class="fas fa-map-marker-alt mr-2 text-gray-400"></i>
                                            <span>${userProfile.address}</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex flex-wrap gap-16 mt-6">
                                    <div class="flex flex-col items-center">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">
                                            <c:choose>
                                                <c:when test="${noteMoyenne != 0}">
                                                    <div class="flex text-amber-400 mr-1">
                                                        <c:forEach var="i" begin="1" end="${fullStars}">
                                                            <i class="fas fa-star text-base"></i>
                                                        </c:forEach>
                                                        <c:if test="${hasHalfStar}">
                                                            <i class="fas fa-star-half-alt text-base"></i>
                                                        </c:if>
                                                        <c:forEach var="i" begin="1" end="${emptyStars}">
                                                            <i class="far fa-star text-base"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="text-gray-600 dark:text-gray-300 text-sm ml-1">
                                                        <fmt:formatNumber value="${noteMoyenne}" maxFractionDigits="1"/>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 text-sm">Non noté</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Note moyenne</div>
                                    </div>

                                    <div class="flex flex-col items-center">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">${totalReservations}</div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Réservations complétées</div>
                                    </div>

                                    <div class="flex flex-col items-center">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">
                                            <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="2"/> MAD
                                        </div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Gains totaux</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="flex gap-20 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex-wrap">
                        <div>
                            <h2 class="text-md font-bold text-gray-900 dark:text-white mb-1">Email</h2>
                            <p class="text-gray-600 dark:text-gray-300 max-w-3xl">
                                ${userProfile.email}
                            </p>
                        </div>
                        <div>
                            <h2 class="text-md font-bold text-gray-900 dark:text-white mb-1">Nº téléphone</h2>
                            <p class="text-gray-600 dark:text-gray-300 max-w-3xl">
                                ${userProfile.phoneNumber}
                            </p>
                        </div>
                    </div>

                    <div class="flex items-center justify-end max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-8 text-right gap-4">
                        <a href="#" class="inline-flex items-center px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                            <i class="fa-solid fa-address-card mr-2"></i> Mon profil public
                        </a>
                        <button onclick="toggleEditMode(true)"
                                class="inline-flex items-center px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                            <i class="fas fa-edit mr-2"></i> Modifier le profil
                        </button>
                    </div>
                </div>

                <div id="profileEdit" class="hidden">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <form id="profileForm" action="${pageContext.request.contextPath}/partner/profile" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update">
                            <div class="flex flex-col md:flex-row items-start md:items-center mb-8">
                                <div class="relative mb-6 md:mb-0 md:mr-8">
                                    <div class="w-24 h-24 md:w-32 md:h-32 rounded-full overflow-hidden border-4 border-white dark:border-gray-700 shadow-md">
                                        <img id="avatarPreview" src="${pageContext.request.contextPath}/uploads/${userProfile.avatarUrl}"
                                             alt="${userProfile.username}"
                                             class="w-full h-full object-cover" />
                                    </div>
                                    <label for="avatarUpload" class="absolute -bottom-2 -right-2 bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center border-2 border-white dark:border-gray-700 cursor-pointer hover:bg-green-600 transition-colors">
                                        <i class="fas fa-camera"></i>
                                        <input type="file" id="avatarUpload" name="avatar" accept="image/*" class="hidden">
                                    </label>
                                </div>

                                <div class="flex-1 space-y-4">
                                    <div>
                                        <label for="firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Prénom</label>
                                        <input type="text" id="firstName" name="firstName" value="${userProfile.firstName}"
                                               class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                    </div>

                                    <div>
                                        <label for="lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom</label>
                                        <input type="text" id="lastName" name="lastName" value="${userProfile.lastName}"
                                               class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                    </div>

                                    <div>
                                        <label for="username" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Nom d'utilisateur</label>
                                        <input type="text" id="username" name="username" value="${userProfile.username}"
                                               class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                    </div>

                                    <div>
                                        <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
                                        <input type="email" id="email" name="email" value="${userProfile.email}"
                                               class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white" disabled>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                                <div>
                                    <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Mot de passe</label>
                                    <input type="password" id="password" name="password"
                                           class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                </div>

                                <div>
                                    <label for="confirm_password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Confirmer mot de passe</label>
                                    <input type="password" id="confirm_password" name="confirm_password"
                                           class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                </div>

                                <div>
                                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Téléphone</label>
                                    <input type="text" id="phoneNumber" name="phoneNumber" value="${userProfile.phoneNumber}"
                                           class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
                                </div>

                                <div>
                                    <label for="address" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Adresse</label>
                                    <input type="text" id="address" name="address" value="${userProfile.address}"
                                           class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-700 dark:text-white" disabled>
                                </div>
                            </div>

                            <div class="flex justify-end space-x-4">
                                <button type="button" onclick="toggleEditMode(false)"
                                        class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
                                    Annuler
                                </button>
                                <button type="submit"
                                        class="px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                                    Enregistrer les modifications
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </section>
        </div>
    </div>
</main>

<script>
    function toggleEditMode(showEdit) {
        const viewMode = document.getElementById('profileView');
        const editMode = document.getElementById('profileEdit');

        if (showEdit) {
            viewMode.classList.add('hidden');
            editMode.classList.remove('hidden');
        } else {
            viewMode.classList.remove('hidden');
            editMode.classList.add('hidden');
        }
    }

    document.getElementById('avatarUpload').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                document.getElementById('avatarPreview').src = event.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
</script>
</body>
</html>

