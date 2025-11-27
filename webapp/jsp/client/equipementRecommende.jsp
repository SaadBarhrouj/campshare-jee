<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Équipements Recommandés</title>

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
<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
    <div class="py-8 px-4 md:px-8">
   
    
        
        <!-- Equipment recommendations -->
        <div class="mb-8">

            <div class="mb-16">
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Équipements recommandés</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Voici quelques équipements que vous pouvez utiliser dans votre prochain camping</p>
            </div>
                
            <div class="flex justify-end">
                <a href="${pageContext.request.contextPath}/listings"
                    class="inline-block mb-8 px-4 py-2 bg-forest text-white text-sm font-medium rounded hover:bg-green-700 transition">
                    Voir tous les équipements
                    <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>
            
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:choose>
                    <c:when test="${not empty similarListings}">
                        <c:forEach var="res" items="${similarListings}">
                            <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden flex flex-col h-full">
                                
                                <a href="${pageContext.request.contextPath}/listing?id=${res.listing.id}" class="block relative h-48">
                                    <img src="${pageContext.request.contextPath}/uploads/${res.listing.item.images.get(0).url}" 
                                        alt="Image" class="w-full h-full object-cover" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <h3 class="text-white font-bold text-lg truncate">
                                            <c:out value="${res.listing.item.title}" />
                                        </h3>
                                        <p class="text-gray-200 text-sm">
                                            <c:out value="${res.listing.item.category.name}" />
                                        </p>
                                    </div>
                                </a>

                                <div class="p-4 flex flex-col flex-grow">
                                    
                                    <div class="flex justify-between items-start mb-3">
                                        <div>
                                            <span class="font-bold text-lg text-gray-900 dark:text-white">
                                                ${res.listing.item.pricePerDay} MAD
                                            </span>
                                            <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                        </div>
                                        
                                        <div class="flex items-center text-sm">
                                            <c:choose>
                                                <c:when test="${res.partner != null && res.partner.reviewCount > 0}">
                                                    <c:set var="rating" value="${res.partner.avgRating}" />
                                                    <c:set var="fullStars" value="${fn:substringBefore(rating, '.')}" />
                                                    <c:set var="hasHalfStar" value="${(rating - fullStars) ge 0.5}" />
                                                    <c:set var="emptyStars" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}" />

                                                    <div class="flex items-center">
                                                        <div class="flex text-amber-400 mr-1">
                                                            <c:forEach begin="0" end="${fullStars - 1}" var="i">
                                                                <i class="fas fa-star"></i>
                                                            </c:forEach>
                                                            <c:if test="${hasHalfStar}">
                                                                <i class="fas fa-star-half-alt"></i>
                                                            </c:if>
                                                            <c:forEach begin="0" end="${emptyStars - 1}" var="i">
                                                                <i class="far fa-star"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <span class="text-gray-600 dark:text-gray-400">
                                                            <fmt:formatNumber value="${rating}" maxFractionDigits="1"/>
                                                        </span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-sm text-gray-500">No ratings yet</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="text-sm mb-3">
                                        <span class="text-gray-600 dark:text-gray-300">
                                            Dispo. du <fmt:formatDate value="${res.listing.startDate}" pattern="dd MMM"/>
                                            au <fmt:formatDate value="${res.listing.endDate}" pattern="dd MMM"/>
                                        </span>
                                    </div>

                                    <div class="text-sm text-gray-600 dark:text-gray-300 mb-4">
                                        <span class="font-medium text-green-700 dark:text-green-600">
                                            <i class="fas fa-map-marker-alt mr-1"></i> 
                                            <c:out value="${res.listing.city.name}" />
                                        </span>
                                    </div>

                                    <div class="mt-auto pt-2">
                                        <a href="${pageContext.request.contextPath}/listing?id=${res.listing.id}" class="inline-block px-3 py-1.5 bg-forest hover:bg-green-700 text-white text-sm rounded-md transition-colors">
                                            Voir les détails
                                        </a>
                                    </div>

                                </div> </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-3 text-center py-8">
                            <p class="text-gray-500 dark:text-gray-400">
                                Aucun équipement recommandé disponible pour le moment.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

</body>
</html>