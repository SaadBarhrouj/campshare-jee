<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier : <c:out value="${listing.item.title}"/></title>
    
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

            <c:if test="${param.updateSuccess == 'true'}">
                <div id="alert-success" class="flex items-center p-4 mb-6 text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <span class="sr-only">Success</span>
                    <div class="ms-3 text-sm font-medium">
                        Annonce mise à jour avec succès !
                    </div>
                    <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-green-50 text-green-500 rounded-lg focus:ring-2 focus:ring-green-400 p-1.5 hover:bg-green-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-success" aria-label="Close">
                        <span class="sr-only">Close</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </c:if>

            <c:if test="${param.updateFailed == 'true'}">
                <div id="alert-danger" class="flex items-center p-4 mb-6 text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400" role="alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span class="sr-only">Error</span>
                    <div class="ms-3 text-sm font-medium">
                        Échec de la mise à jour. Veuillez réessayer.
                    </div>
                    <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-red-50 text-red-500 rounded-lg focus:ring-2 focus:ring-red-400 p-1.5 hover:bg-red-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-danger" aria-label="Close">
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
                    <li>
                        <div class="flex items-center">
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                            <a href="${pageContext.request.contextPath}/admin/listings/details?id=${listing.id}" class="ml-1 text-sm font-medium text-gray-700 hover:text-admin-secondary md:ml-2 dark:text-gray-400 dark:hover:text-white">Détails</a>
                        </div>
                    </li>
                    <li aria-current="page">
                        <div class="flex items-center">
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                            <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2 dark:text-gray-400">Modifier</span>
                        </div>
                    </li>
                </ol>
            </nav>

            <div class="flex justify-between items-center mb-8">
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Modifier l'annonce</h1>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <div class="lg:col-span-2 space-y-6">
                    
                    <form action="${pageContext.request.contextPath}/admin/listings/edit" method="POST" class="space-y-6">
                        <input type="hidden" name="listingId" value="${listing.id}">
                        <input type="hidden" name="itemId" value="${listing.item.id}">

                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                                <i class="fas fa-cog mr-2 text-gray-500 dark:text-gray-400"></i> Détails de l'équipement
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="md:col-span-2">
                                    <label for="title" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Titre</label>
                                    <input type="text" id="title" name="title" class="form-input w-full text-base" value="<c:out value='${listing.item.title}'/>" required>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label for="description" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Description</label>
                                    <div class="p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
                                        <textarea id="description" name="description" rows="4" class="w-full bg-transparent border-0 resize-none focus:outline-none text-sm text-gray-800 dark:text-gray-200" required><c:out value='${listing.item.description}'/></textarea>
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="pricePerDay" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Prix par jour</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-green-100 dark:bg-green-900/30 rounded-lg mr-3">
                                            <i class="fas fa-tag fa-fw text-green-600 dark:text-green-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <input type="number" step="0.01" id="pricePerDay" name="pricePerDay" class="form-input w-full text-base" value="${listing.item.pricePerDay}" required>
                                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Montant en MAD</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="categoryId" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Catégorie</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                            <i class="fas fa-list fa-fw text-blue-600 dark:text-blue-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <select id="categoryId" name="categoryId" class="form-select w-full text-base" required>
                                                <c:forEach var="cat" items="${allCategories}">
                                                    <option value="${cat.id}" ${cat.id == listing.item.category.id ? 'selected' : ''}>
                                                        <c:out value="${cat.name}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                            <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                                <i class="fas fa-calendar-alt mr-2 text-gray-500 dark:text-gray-400"></i> Paramètres de l'annonce
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="startDate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Date de début</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg mr-3">
                                            <i class="fas fa-calendar-plus fa-fw text-purple-600 dark:text-purple-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <fmt:formatDate value="${listing.startDate}" pattern="yyyy-MM-dd" var="formattedStartDate" />
                                            <input type="date" id="startDate" name="startDate" class="form-input w-full text-base" value="${formattedStartDate}" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="endDate" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Date de fin</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg mr-3">
                                            <i class="fas fa-calendar-minus fa-fw text-purple-600 dark:text-purple-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <fmt:formatDate value="${listing.endDate}" pattern="yyyy-MM-dd" var="formattedEndDate" />
                                            <input type="date" id="endDate" name="endDate" class="form-input w-full text-base" value="${formattedEndDate}" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <label for="cityId" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Ville</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-yellow-100 dark:bg-yellow-900/30 rounded-lg mr-3">
                                            <i class="fas fa-map-marker-alt fa-fw text-yellow-600 dark:text-yellow-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <select id="cityId" name="cityId" class="form-select w-full text-base" required>
                                                <c:forEach var="city" items="${allCities}">
                                                    <option value="${city.id}" ${city.id == listing.city.id ? 'selected' : ''}>
                                                        <c:out value="${city.name}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Options</label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-indigo-100 dark:bg-indigo-900/30 rounded-lg mr-3">
                                            <i class="fas fa-truck fa-fw text-indigo-600 dark:text-indigo-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <label class="flex items-center cursor-pointer">
                                                <input type="checkbox" id="deliveryOption" name="deliveryOption" value="true" class="form-checkbox text-admin-secondary" ${listing.deliveryOption ? 'checked' : ''}>
                                                <span class="ms-2 text-sm text-gray-700 dark:text-gray-300">Option de livraison disponible</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="flex justify-end gap-3">
                            <a href="${pageContext.request.contextPath}/admin/listings/details?id=${listing.id}" 
                               class="flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                                Annuler
                            </a>
                            
                            <button type="submit" 
                                    class="flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                                <i class="fas fa-save mr-2"></i> Enregistrer les modifications
                            </button>
                        </div>
                    </form>
                </div>

                <div class="space-y-6">
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-user-tie mr-2 text-gray-500 dark:text-gray-400"></i> Partenaire
                        </h2>
                        <div class="flex items-center mb-4">
                            <c:choose>
                                <c:when test="${not empty fn:trim(listing.item.partner.avatarUrl)}">
                                    <img class="w-12 h-12 rounded-full object-cover mr-4" src="${pageContext.request.contextPath}/uploads/${listing.item.partner.avatarUrl}" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <img class="w-12 h-12 rounded-full object-cover mr-4" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <p class="font-medium"><c:out value="${listing.item.partner.firstName} ${listing.item.partner.lastName}"/></p>
                                <p class="text-sm text-gray-500 dark:text-gray-400"><c:out value="${listing.item.partner.email}"/></p>
                            </div>
                        </div>
                        <button onclick="showUserDetails(${listing.item.partner.id})" 
                                class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                            <i class="fas fa-user-cog mr-2"></i> Gérer ce partenaire
                        </button>
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