<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails : <c:out value="${listingDetails.item.title}"/></title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css" rel="stylesheet" />

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
                        'admin': {
                            'primary': '#1E40AF',
                            'secondary': '#3B82F6',
                            'accent': '#60A5FA',
                            'light': '#DBEAFE',
                            'dark': '#1E3A8A'
                        }
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
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 bg-gray-50 dark:bg-gray-900 min-h-screen flex flex-col">

    <jsp:include page="includes/admin_header.jsp"></jsp:include>
    <jsp:include page="includes/admin_sidebar.jsp">
        <jsp:param name="activePage" value="listings"/>
    </jsp:include>
    
    <main class="flex-1 md:ml-64 min-h-screen">
        <div class="py-8 px-4 md:px-8">

            <c:if test="${param.statusUpdated == 'true'}">
            <div id="alert-success" class="flex items-center p-4 mb-6 text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400" role="alert">
                <i class="fas fa-check-circle"></i>
                <span class="sr-only">Success</span>
                <div class="ms-3 text-sm font-medium">
                    Le statut de l'annonce a été mis à jour avec succès !
                </div>
                <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-green-50 text-green-500 rounded-lg focus:ring-2 focus:ring-green-400 p-1.5 hover:bg-green-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-success" aria-label="Close">
                    <span class="sr-only">Close</span>
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </c:if>
            
            <nav class="flex mb-6" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-1 md:space-x-3">
                    <li class="inline-flex items-center">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-admin-secondary dark:text-gray-400 dark:hover:text-white">
                            <i class="fas fa-home mr-2"></i> Accueil
                        </a>
                    </li>
                    <li>
                        <div class="flex items-center">
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                            <a href="${pageContext.request.contextPath}/admin/listings" class="ml-1 text-sm font-medium text-gray-700 hover:text-admin-secondary md:ml-2 dark:text-gray-400 dark:hover:text-white">Annonces</a>
                        </div>
                    </li>
                    <li aria-current="page">
                        <div class="flex items-center">
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                            <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2 dark:text-gray-400 truncate max-w-xs"><c:out value="${listingDetails.item.title}"/></span>
                        </div>
                    </li>
                </ol>
            </nav>

            <div class="flex justify-between items-center mb-8">
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Détails de l'annonce</h1>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <div class="lg:col-span-2 space-y-6">
                    
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-images mr-2 text-gray-500 dark:text-gray-400"></i> Images de l'équipement
                        </h2>

                        <div id="default-carousel" class="relative w-full" data-carousel="slide">
                        <!-- Carousel wrapper -->
                        <div class="relative h-56 overflow-hidden rounded-lg md:h-96">
                            <!-- Item 1 -->
                            <div class="hidden duration-700 ease-in-out" data-carousel-item>
                                <img src="https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=2070"  class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
                            </div>
                            <!-- Item 2 -->
                            <div class="hidden duration-700 ease-in-out" data-carousel-item>
                                <img src="https://images.unsplash.com/photo-1532339142463-fd0a8979791a?q=80&w=2070" class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
                            </div>
                            <!-- Item 3 -->
                            <div class="hidden duration-700 ease-in-out" data-carousel-item>
                                <img src="https://images.unsplash.com/photo-1517824806704-9040b037703b?q=80&w=2070"  class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
                            </div>
                            <!-- Item 4 -->
                            <div class="hidden duration-700 ease-in-out" data-carousel-item>
                                <img src="https://images.unsplash.com/photo-1517824806704-9040b037703b?q=80&w=2070"  class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
                            </div>
                            <!-- Item 5 -->
                            <div class="hidden duration-700 ease-in-out" data-carousel-item>
                                <img src="https://images.unsplash.com/photo-1517824806704-9040b037703b?q=80&w=2070"  class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="...">
                            </div>
                        </div>
                        <!-- Slider indicators -->
                        <div class="absolute z-30 flex -translate-x-1/2 bottom-5 left-1/2 space-x-3 rtl:space-x-reverse">
                            <button type="button" class="w-3 h-3 rounded-full" aria-current="true" aria-label="Slide 1" data-carousel-slide-to="0"></button>
                            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 2" data-carousel-slide-to="1"></button>
                            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 3" data-carousel-slide-to="2"></button>
                            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 4" data-carousel-slide-to="3"></button>
                            <button type="button" class="w-3 h-3 rounded-full" aria-current="false" aria-label="Slide 5" data-carousel-slide-to="4"></button>
                        </div>
                        <!-- Slider controls -->
                        <button type="button" class="absolute top-0 start-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-prev>
                            <span class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 1 1 5l4 4"/>
                                </svg>
                                <span class="sr-only">Previous</span>
                            </span>
                        </button>
                        <button type="button" class="absolute top-0 end-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-next>
                            <span class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
                                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 9 4-4-4-4"/>
                                </svg>
                                <span class="sr-only">Next</span>
                            </span>
                        </button>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-info-circle mr-2 text-gray-500 dark:text-gray-400"></i> Informations Clés
                        </h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-4">
                            
                            <%-- Colonne de gauche pour la description --%>
                            <div class="md:col-span-2">
                                <h4 class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">Description de l'équipement</h4>
                                <div class="p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                    <p class="text-gray-800 dark:text-gray-200  text-sm leading-relaxed">
                                        <c:out value="${listingDetails.item.description}"/>
                                    </p>
                                </div>
                            </div>
                            
                            <div class="md:col-span-1 space-y-4">
                                
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 p-2 bg-green-100 dark:bg-green-900/30 rounded-lg mr-3">
                                        <i class="fas fa-tag fa-fw text-green-600 dark:text-green-400"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Prix par jour</p>
                                        <p class="font-bold text-lg text-gray-900 dark:text-white">
                                            <fmt:formatNumber value="${listingDetails.item.pricePerDay}" type="currency" currencySymbol="MAD"/>
                                        </p>
                                    </div>
                                </div>
                                
                                <div class="flex items-start">
                                    <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                        <i class="fas fa-toggle-on fa-fw text-blue-600 dark:text-blue-400"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Statut</p>
                                        <c:set var="status" value="${listingDetails.listing.status}"/>
                                        <span class="badge ${status == 'active' ? 'badge-success' : (status == 'archived' ? 'badge-warning' : 'badge-danger')}">
                                            <c:out value="${fn:toUpperCase(fn:substring(status, 0, 1))}${fn:toLowerCase(fn:substring(status, 1, -1))}"/>
                                        </span>
                                    </div>
                                </div>

                                <div class="flex items-start">
                                    <div class="flex-shrink-0 p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg mr-3">
                                        <i class="fas fa-calendar-alt fa-fw text-purple-600 dark:text-purple-400"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-gray-500 dark:text-gray-400">Disponibilité</p>
                                        <p class="font-semibold text-gray-800 dark:text-gray-200">
                                            <c:choose>
                                                <c:when test="${not empty listingDetails.listing.startDate}">
                                                    <c:out value="${listingDetails.listing.startDate}"/> - <c:out value="${listingDetails.listing.endDate}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    Non spécifiée
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </div>

                </div>

                <div class="space-y-6">
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-user-tie mr-2 text-gray-500 dark:text-gray-400"></i> Partenaire
                        </h2>
                        <div class="flex items-center mb-4">
                             <c:choose>
                                <c:when test="${not empty fn:trim(listingDetails.partner.avatarUrl)}"><img class="w-12 h-12 rounded-full object-cover mr-4" src="${pageContext.request.contextPath}/uploads/${listingDetails.partner.avatarUrl}" alt="Avatar"></c:when>
                                <c:otherwise><img class="w-12 h-12 rounded-full object-cover mr-4" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut"></c:otherwise>
                            </c:choose>
                            <div>
                                <p class="font-medium"><c:out value="${listingDetails.partner.firstName} ${listingDetails.partner.lastName}"/></p>
                                <p class="text-sm text-gray-500 dark:text-gray-400"><c:out value="${listingDetails.partner.email}"/></p>
                            </div>
                        </div>
                                        <button onclick="showUserDetails(${listingDetails.partner.id})" 
                                                class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                                            <i class="fas fa-user-cog mr-2"></i> Gérer ce partenaire
                                        </button>                
                    </div>
                    <div class="space-y-3">
                        
                        <c:if test="${listingDetails.listing.status != 'active'}">
                            <form action="${pageContext.request.contextPath}/admin/listings/update-status" method="POST">
                                <input type="hidden" name="listingId" value="${listingDetails.listing.id}">
                                <input type="hidden" name="newStatus" value="active">
                                <button type="submit" class="w-full flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                                    <i class="fas fa-check-circle mr-2"></i> Activer
                                </button>
                            </form>
                        </c:if>

                        <c:if test="${listingDetails.listing.status == 'active'}">
                            <form action="${pageContext.request.contextPath}/admin/listings/update-status" method="POST">
                                <input type="hidden" name="listingId" value="${listingDetails.listing.id}">
                                <input type="hidden" name="newStatus" value="archived">
                                <button type="submit" class="w-full flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-gray-800 bg-yellow-400 hover:bg-yellow-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-400 transition-colors">
                                    <i class="fas fa-archive mr-2"></i> Archiver
                                </button>
                            </form>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/admin/listings/delete" method="POST" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer définitivement cette annonce ?');">
                            <input type="hidden" name="listingId" value="${listingDetails.listing.id}">
                            <button type="submit" class="w-full flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors">
                                <%-- Correction du nom de l'icône --%>
                                <i class="fas fa-trash-can mr-2"></i> Supprimer
                            </button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/admin_user_details_modal.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
</body>
</html>