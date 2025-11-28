<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Dashboard Client</title>

    <!-- Styles / Scripts -->

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    


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
        <!-- Dashboard header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Bienvenue, ${user.username} ! Voici un resume de vos reservations.</p>
            </div>
        </div>

                <!-- Stats cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Stats card 1 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-blue-100 dark:bg-blue-900 mr-4">
                        <i class="fas fa-shopping-cart text-blue-600 dark:text-blue-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Total reservations</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalReservations}</h3>
                        
                    </div>
                </div>
            </div>
            
            <!-- Stats card 2 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-green-100 dark:bg-green-900 mr-4">
                        <i class="fas fa-money-bill-wave text-green-600 dark:text-green-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Montant total depense</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalDepense}</h3>
                      
                    </div>
                </div>
            </div>
            
            <!-- Stats card 3 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-yellow-100 dark:bg-yellow-900 mr-4">
                        <i class="fas fa-star text-yellow-600 dark:text-yellow-400"></i>
                    </div>
                <div>
                    <p class="text-gray-500 dark:text-gray-400 text-sm">Note moyenne</p>

                    <c:choose>
                        <c:when test="${noteMoyenne != null and noteMoyenne != 0}">
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${noteMoyenne}</h3>
                        </c:when>
                        <c:otherwise>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Non note</h3>
                        </c:otherwise>
                    </c:choose>
                </div>

                </div>
            </div>
        </div>
        <div class="mb-8">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes reservations</h2>
                <a href="${pageContext.request.contextPath}/client/allReservation" data-target = "allRes" class=" sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                    Voir toutes mes réservations
                </a>
            </div>

            <%
                java.util.Map<String, String> statusMap = new java.util.HashMap<>();
                statusMap.put("pending", "En attente");
                statusMap.put("confirmed", "Confirmée");
                statusMap.put("ongoing", "En cours");
                statusMap.put("canceled", "Annulée");
                statusMap.put("completed", "Terminée");
                request.setAttribute("statusMap", statusMap);
            %>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <c:choose>
                    <c:when test="${not empty reservations}">
                        <c:forEach var="res" items="${reservations}">
                            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                                <div class="relative h-40">
                                    <img src="${pageContext.request.contextPath}/uploads/${res.listing.item.images.get(0).url}" alt="Image" class="w-full h-full object-cover" />
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                    <div class="absolute top-4 left-4">
                                        <span class="bg-gray-400 text-white text-xs px-2 py-1 rounded-full">
                                            <c:out value="${statusMap[res.status]}" />
                                        </span>
                                    </div>
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <h3 class="text-white font-bold text-lg truncate">
                                            <c:out value="${res.listing.item.title}" />
                                        </h3>
                                        <p class="text-gray-200 text-sm">
                                            <c:out value="${res.listing.item.description}" />
                                        </p>
                                    </div>
                                </div>

                                <div class="p-4">
                                    <div class="flex items-start mb-4">
                                        <c:if test="${not empty res.partner}">
                                            <a href="#">
                                                <img src="${pageContext.request.contextPath}/uploads/${res.partner.avatarUrl}" alt="image"
                                                    class="w-8 h-8 rounded-full object-cover mr-3" />
                                            </a>
                                            <div>
                                                <p class="font-medium text-gray-900 dark:text-white">
                                                    <c:out value="${res.partner.username}" />
                                                </p>
                                                <div class="flex items-center text-sm">
                                                    <c:choose>
                                                        <c:when test="${res.partner.avgRating != 0}">
                                                            <div class="flex text-amber-400 mr-1">
                                                                <c:forEach var="i" begin="1" end="5">
                                                                    <c:choose>
                                                                        <c:when test="${i <= res.partner.avgRating}">
                                                                            <i class="fas fa-star text-base"></i>
                                                                        </c:when>
                                                                        <c:when test="${i - res.partner.avgRating <= 0.5 && i - res.partner.avgRating > 0}">
                                                                            <i class="fas fa-star-half-alt text-base"></i>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <i class="far fa-star text-base"></i>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </div>

                                                            <span class="text-gray-600 dark:text-gray-300 text-sm ml-1">
                                                                <fmt:formatNumber value="${res.partner.avgRating}" maxFractionDigits="1"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400 text-sm">Non noté</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="bg-gray-50 dark:bg-gray-700/50 rounded p-3 mb-4">
                                        <div class="flex justify-between text-sm mb-1">
                                            <span class="text-gray-600 dark:text-gray-400">Date</span>
                                            <span class="font-medium text-gray-900 dark:text-white">
                                                <fmt:formatDate value="${res.startDate}" pattern="yyyy-MM-dd" /> -
                                                <fmt:formatDate value="${res.endDate}" pattern="yyyy-MM-dd" />
                                            </span>
                                        </div>
                                        <div class="flex justify-between text-sm mb-1">
                                            <span class="text-gray-600 dark:text-gray-400">Prix</span>
                                                <fmt:parseDate value="${res.startDate}" pattern="yyyy-MM-dd" var="startDate" />
                                                <fmt:parseDate value="${res.endDate}" pattern="yyyy-MM-dd" var="endDate" />

                                                <!-- Compute difference in milliseconds -->
                                                <c:set var="diffDays" value="${(endDate.time - startDate.time) / (1000 * 60 * 60 * 24)}" />
                                                <!-- Convert to days (1000 * 60 * 60 * 24 = 86400000) -->
                                               
                                            
                                                <c:set var="montantTotal" value="${res.listing.item.pricePerDay * diffDays}" />
                                                
                                                <span class="font-medium text-gray-900 dark:text-white">
                                                    <p class="font-medium text-gray-900 dark:text-white">${montantTotal} MAD</p>
                                            </span>
                                        </div>
                                    </div>

                                    <c:if test="${res.status eq 'pending'}">
                                        <button onclick="cancelReservation(${res.id})" 
                                                class="px-3 py-1.5 border border-red-300 dark:border-red-800 text-red-700 
                                                       dark:text-red-400 text-sm rounded-md hover:bg-red-50 
                                                       dark:hover:bg-red-900/20 transition-colors flex-1">
                                            <i class="fas fa-times mr-2"></i> Annuler
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-lg shadow-sm overflow-hidden">
                            <p class="mx-8 text-sm text-gray-600 dark:text-gray-400">
                                Vous n'avez aucune réservation.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Equipment recommendations -->
            <div class="mb-8 mt-10">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-xl font-bold text-gray-900 dark:text-white">Équipements recommandés</h2>
                    <a href="${pageContext.request.contextPath}/client/equipement" class="sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                        Voir plus de recommandations
                    </a>
                </div>

                <c:choose>
                    <c:when test="${not empty similarListings}">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:forEach var="item" items="${similarListings}">
                                <c:if test="${item.listing != null && item.listing.item != null}">
                                    <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
                                        <a href="${pageContext.request.contextPath}/listing?id=${item.listing.id}">
                                            <div class="relative h-48">
                                                <c:choose>
                                                    <c:when test="${not empty item.listing.item.images && not empty item.listing.item.images[0]}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${item.listing.item.images[0].url}" 
                                                            alt="Image" class="w-full h-full object-cover" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                                                            <i class="fas fa-image text-gray-400 text-4xl"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                                <div class="absolute bottom-4 left-4 right-4">
                                                    <h3 class="text-white font-bold text-lg truncate">${item.listing.item.title}</h3>
                                                    <c:if test="${item.listing.item.category != null}">
                                                        <p class="text-gray-200 text-sm">${item.listing.item.category.name}</p>
                                                    </c:if>
                                                </div>
                                            </div>

                                        <div class="p-4">
                                            <div class="flex justify-between items-center mb-3">
                                                <div>
                                                    <span class="font-bold text-lg text-gray-900 dark:text-white">${item.listing.item.pricePerDay} MAD</span>
                                                    <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                                </div>

                                                <div class="flex items-center text-sm">
                                                    <c:choose>
                                                        <c:when test="${item.partner != null && item.partner.reviewCount > 0 && item.partner.avgRating > 0}">
                                                            <c:set var="rating" value="${item.partner.avgRating}" />
                                                            <c:set var="ratingInt" value="${fn:substringBefore(fn:replace(rating, ',', '.'), '.')}" />
                                                            <c:choose>
                                                                <c:when test="${empty ratingInt}">
                                                                    <c:set var="ratingInt" value="0" />
                                                                </c:when>
                                                            </c:choose>
                                                            <c:set var="fullStars" value="${ratingInt}" />
                                                            <c:set var="decimalPart" value="${rating - fullStars}" />
                                                            <c:set var="hasHalfStar" value="${decimalPart ge 0.5 and decimalPart lt 1.0}" />
                                                            <c:set var="emptyStarsCalc" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}" />
                                                            <c:choose>
                                                                <c:when test="${emptyStarsCalc < 0}">
                                                                    <c:set var="emptyStars" value="0" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="emptyStars" value="${emptyStarsCalc}" />
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <div class="flex items-center">
                                                                <div class="flex text-amber-400 mr-1">
                                                                    <c:if test="${fullStars > 0}">
                                                                        <c:forEach begin="1" end="${fullStars}" var="i">
                                                                            <i class="fas fa-star"></i>
                                                                        </c:forEach>
                                                                    </c:if>
                                                                    <c:if test="${hasHalfStar}">
                                                                        <i class="fas fa-star-half-alt"></i>
                                                                    </c:if>
                                                                    <c:if test="${emptyStars > 0}">
                                                                        <c:forEach begin="1" end="${emptyStars}" var="i">
                                                                            <i class="far fa-star"></i>
                                                                        </c:forEach>
                                                                    </c:if>
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

                                            <c:if test="${item.listing.startDate != null && item.listing.endDate != null}">
                                                <div class="text-sm mb-3">
                                                    <span class="text-gray-600 dark:text-gray-300">
                                                        Dispo. du <fmt:formatDate value="${item.listing.startDate}" pattern="dd MMM"/>
                                                        au <fmt:formatDate value="${item.listing.endDate}" pattern="dd MMM"/>
                                                    </span>
                                                </div>
                                            </c:if>

                                            <div class="flex items-center justify-between">
                                                <div class="text-sm text-gray-600 dark:text-gray-300">
                                                    <c:if test="${item.listing.city != null}">
                                                        <span class="font-medium text-green-800 dark:text-green-600">
                                                            <i class="fas fa-map-marker-alt mr-1"></i> 
                                                            ${item.listing.city.name}
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/listing?id=${item.listing.id}" class="px-3 py-1.5 bg-forest hover:bg-green-700 text-white text-sm rounded-md transition-colors">
                                                    Voir les détails
                                                </a>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-gray-500 dark:text-gray-400 text-center col-span-3">
                            Aucune recommandation disponible pour le moment.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>


    </div>

                <!-- My reservations section -->
        
</main>


<script>
    function cancelReservation(reservationId) {
        if (confirm('Êtes-vous sûr de vouloir annuler cette réservation ?')) {
            fetch('${pageContext.request.contextPath}/client/reservations/cancel', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'reservationId=' + reservationId
            })
            .then(response => {
                if (response.ok) {
                    alert('Réservation annulée avec succès');
                    location.reload(); // Recharger la page pour voir les changements
                } else {
                    alert('Erreur lors de l\'annulation de la réservation');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Une erreur est survenue');
            });
        }
    }
</script>

</body>
</html>