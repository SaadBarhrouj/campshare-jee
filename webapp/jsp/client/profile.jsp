<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Dashboard Client</title>

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
<jsp:include page="components/sidebar.jsp" />
<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900">
    <div class="py-8 px-4 md:px-8">
        <div class="mb-8">
            <section class="bg-gray-50 dark:bg-gray-800 py-10 border-b border-gray-200 dark:border-gray-700">
                <div id="profileView">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div class="flex flex-col md:flex-row items-start md:items-center">
                            <div class="relative mb-6 md:mb-0 md:mr-8">
                                <div class="w-24 h-24 md:w-32 md:h-32 rounded-full overflow-hidden border-4 border-white dark:border-gray-700 shadow-md">
                                    <img src="${pageContext.request.contextPath}/images/avatars/${userProfile.avatarUrl}" 
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
                                            <span id="viewUsername">${userProfile.firstName} ${userProfile.lastName} - ${userProfile.username}</span>
                                            <span class="ml-3 text-sm font-medium px-2 py-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-md">
                                                Membre depuis
                                                <fmt:formatDate value="${userProfile.createdAt}" pattern="MM/yyyy"/>
                                                
                                            </span>
                                        </h1>
                                        <div class="mt-2 flex items-center text-gray-600 dark:text-gray-300">
                                            <i class="fas fa-map-marker-alt mr-2 text-gray-400"></i>
                                            <span id="viewAddress"> </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex flex-wrap gap-16 mt-6">
                                    <div class="flex flex-col items-center">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">
                                            <c:choose>
                                                <c:when test="${noteMoyenne != 0}">
                                                    <div class="flex text-amber-400 mr-1">
                                                        <!-- Full stars -->
                                                        <c:forEach var="i" begin="1" end="${fullStars}">
                                                            <i class="fas fa-star text-base"></i>
                                                        </c:forEach>

                                                        <!-- Half star -->
                                                        <c:if test="${hasHalfStar}">
                                                            <i class="fas fa-star-half-alt text-base"></i>
                                                        </c:if>

                                                        <!-- Empty stars -->
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
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">${totalReservations }</div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Résérvations réalisées</div>
                                    </div>

                                    <div class="flex flex-col items-center">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">${totalDepense}</div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Montant total dépensé</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class=" flex gap-20 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div>
                            <h2 class="text-md font-bold text-gray-900 dark:text-white mb-1">Email</h2>
                            <p class="text-gray-600 dark:text-gray-300 max-w-3xl" id="viewEmail">
                                ${userProfile.email}
                            </p>
                        </div>
                        <div>
                            <h2 class="text-md font-bold text-gray-900 dark:text-white mb-1">Nº téléphone</h2>
                            <p class="text-gray-600 dark:text-gray-300 max-w-3xl" id="viewPhone">
                                ${userProfile.phoneNumber}
                            </p>
                        </div> 
                    </div>

                    <div class="flex items-center justify-end max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-8 text-right gap-4">
                        <a href="{{ route('client.profile.index', $user->id) }}"
                            class="inline-flex items-center px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                            <i class="fa-solid fa-address-card mr-2"></i> Mon profil Public
                        </a>
                        <button onclick="toggleEditMode(true)" 
                               class="inline-flex items-center px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                            <i class="fas fa-edit mr-2"></i> Modifier le profil
                        </button>
                    </div>
                </div>

            </section>
        </div>
    </div>
</main>     
</body>
</html>