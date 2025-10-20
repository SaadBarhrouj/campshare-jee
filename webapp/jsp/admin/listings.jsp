<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 


<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <title>Gestion des Annonces - Admin</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css"
    />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              forest: "#2D5F2B",
              meadow: "#4F7942",
              earth: "#8B7355",
              wood: "#D2B48C",
              sky: "#5D9ECE",
              water: "#1E7FCB",
              sunlight: "#FFAA33",
              admin: {
                primary: "#1E40AF",
                secondary: "#3B82F6",
                accent: "#60A5FA",
                light: "#DBEAFE",
                dark: "#1E3A8A",
              },
            },
          },
        },
        darkMode: "class",
      };

      if (
        window.matchMedia &&
        window.matchMedia("(prefers-color-scheme: dark)").matches
      ) {
        document.documentElement.classList.add("dark");
      }
      window
        .matchMedia("(prefers-color-scheme: dark)")
        .addEventListener("change", (event) => {
          if (event.matches) {
            document.documentElement.classList.add("dark");
          } else {
            document.documentElement.classList.remove("dark");
          }
        });
    </script>
  </head>

  <body
    class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col">

      <jsp:include page="includes/admin_header.jsp"></jsp:include>

      <jsp:include page="includes/admin_sidebar.jsp">
        <jsp:param name="activePage" value="listings" />
      </jsp:include>

      <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
          <div class="py-8 px-4 md:px-8 pb-0">

        <c:if test="${param.deleteSuccess == 'true'}">
            <div id="alert-success" class="flex items-center p-4 mb-6 text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400" role="alert">
                <i class="fas fa-check-circle"></i>
                <span class="sr-only">Success</span>
                <div class="ms-3 text-sm font-medium">
                    L'annonce a été supprimée avec succès !
                </div>
                <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-green-50 text-green-500 rounded-lg focus:ring-2 focus:ring-green-400 p-1.5 hover:bg-green-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-success" aria-label="Close">
                    <span class="sr-only">Close</span>
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </c:if>

            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
                    <div>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Gestion des Annonces</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Liste de toutes les annonces de la plateforme.</p>
                    </div>
                </div>

                 
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8 justify-center">                   

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 ">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-admin-light dark:bg-admin-dark mr-4">
                                <i class="fas fa-user text-admin-primary dark:text-admin-secondary"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Total Annonces</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white">
                                        <c:out value="${pageStats.total}"/>
                                    </h3>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-green-100 dark:bg-green-900/30 mr-4">
                                <i class="fas fa-check-circle text-green-600 dark:text-green-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Annonces Actives</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white"><c:out value="${pageStats.active}"/></h3>
                                    
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    (<fmt:formatNumber value="${pageStats.activePercentage}" maxFractionDigits="0"/>% du total)
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-3 rounded-full bg-yellow-100 dark:bg-yellow-900/30 mr-4">
                                <i class="fas fa-archive text-yellow-600 dark:text-yellow-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-500 dark:text-gray-400 text-sm">Annonces Archivées</p>
                                <div class="flex items-center">
                                    <h3 class="text-2xl font-bold text-gray-900 dark:text-white"><c:out value="${pageStats.archived}"/></h3>
                                </div>
                                <p class="text-gray-600 dark:text-gray-400 text-xs mt-1">
                                    (<fmt:formatNumber value="${pageStats.archivedPercentage}" maxFractionDigits="0"/>% du total)
                                </p>
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm mb-8 p-5">
                    <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-4 md:space-y-0">
                        <div class="flex-1">
                        <form action="" method="GET">
                            <div class="relative">
                                <input 
                                    type="text" 
                                    name="search" 
                                    placeholder="Rechercher par nom, email ou ville..." 
                                    class="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-admin-primary dark:focus:ring-admin-secondary text-sm"
                                    value=""
                                >
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-search text-gray-400 dark:text-gray-500"></i>
                                    </div>
                                    </div>
                        </form>
                            </div>
                        
                        <div class="relative inline-block text-left" id="status-filter-container">
                            <button id="status-filter-button" class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                                <span>Statut: Tous</span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                            <div id="status-filter-dropdown" class="filter-dropdown right-0 hidden">
                                <div class="option active" data-value="all">Tous les statuts</div>
                                <div class="option" data-value="active">Actifs</div>
                                <div class="option" data-value="inactive">Inactifs</div>
                         
                            </div>
                        </div>
                        

                        <div class="relative inline-block text-left" id="sort-filter-container">
                            <button id="sort-filter-button" class="inline-flex justify-between items-center w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary">
                                <span>Trier par 
                                    
                                </span>
                                <i class="fas fa-chevron-down ml-2"></i>
                            </button>
                            <div id="sort-filter-dropdown" class="filter-dropdown right-0 hidden w-full">
                                <div class="flex flex-col">
                                    <a href="" 
                                    class="option block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Plus récents
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Plus anciens
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nom (A-Z)
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nom (Z-A)
                                    </a>
                                    <a href="" 
                                    class="option  block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                                        Nombre de réservations
                                    </a>
                                </div>
                            </div>
                        </div>
                          
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    
                    <c:forEach var="listing" items="${listings}">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden flex flex-col">
                            
                            <div class="h-48 bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                                <i class="fas fa-image fa-3x text-gray-400 dark:text-gray-500"></i>
                            </div>
                            
                            <div class="p-5 flex flex-col flex-grow">
                                <div class="flex justify-between items-start mb-2">
                                    <h3 class="font-bold text-lg text-gray-900 dark:text-white leading-tight">
                                        <a href="#" class="hover:text-admin-secondary transition-colors">
                                            <c:if test="${not empty listing.item}">
                                                <c:out value="${listing.item.title}"/>
                                            </c:if>                            
                                        </a>
                                    </h3>
                                    <c:set var="status" value="${listing.status}"/>
                                    <span class="px-2.5 py-0.5 rounded-full text-xs font-medium 
                                        ${status == 'active' ? 'bg-green-100 text-green-800 dark:bg-green-900/20 dark:text-green-400' : ''}
                                        ${status == 'archived' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/20 dark:text-yellow-400' : ''}
                                        ${status == 'expired' ? 'bg-red-100 text-red-800 dark:bg-red-900/20 dark:text-red-400' : ''}
                                    ">
                                        <c:out value="${fn:toUpperCase(fn:substring(status, 0, 1))}${fn:toLowerCase(fn:substring(status, 1, -1))}"/>
                                    </span>
                                </div>

                                <%-- Information sur le Partenaire --%>
                                <div class="flex items-center text-sm text-gray-500 dark:text-gray-400 mb-4">
                                    <c:choose>
                                        <c:when test="${not empty fn:trim(listing.item.partner.avatarUrl)}">
                                            <img class="h-6 w-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/uploads/${listing.item.partner.avatarUrl}" alt="Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="h-6 w-6 rounded-full object-cover mr-2" src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                        </c:otherwise>
                                    </c:choose>
                                    <span>Proposé par 
                                        <button 
                                            type="button" 
                                            onclick="showUserDetails(${listing.item.partner.id})" 
                                            class="font-medium text-admin-secondary hover:underline"
                                        >
                                            <c:out value="${listing.item.partner.firstName} ${listing.item.partner.lastName}"/>
                                        </button>
                                    </span>
                                </div>

                                <%-- Détails : Prix et Période --%>
                                <div class="grid grid-cols-2 gap-4 text-sm mb-4">
                                    <div>
                                        <p class="text-gray-500 dark:text-gray-400">Prix / jour</p>
                                        <p class="font-semibold text-gray-800 dark:text-gray-200">
                                            <fmt:formatNumber value="${listing.item.pricePerDay}" type="currency" currencySymbol="MAD"/>
                                        </p>
                                    </div>
                                    <div>
                                        <p class="text-gray-500 dark:text-gray-400">Disponibilité</p>
                                        <p class="font-semibold text-gray-800 dark:text-gray-200">
                                           <c:out value="${listing.startDate}"/>
                                              - <c:out value="${listing.endDate}"/>
                                        </p>
                                    </div>
                                </div>

                                <div class="mt-auto pt-4 border-t border-gray-200 dark:border-gray-700 flex justify-between items-center">
                                    <p class="text-xs text-gray-500 dark:text-gray-400">
                                        Créée le: <fmt:formatDate value="${listing.createdAt}" pattern="dd MMM yyyy"/>
                                    </p>

                                        <div class="flex items-center space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/listings/details?id=${listing.id}" 
                                            class="p-2 rounded-md text-admin-primary bg-admin-light hover:bg-blue-200 dark:text-admin-accent dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors" 
                                            title="Voir les détails">
                                                <i class="fas fa-eye"></i>
                                            </a>

                                            <a href="#" 
                                            class="p-2 rounded-md text-yellow-600 bg-yellow-100 hover:bg-yellow-200 dark:text-yellow-400 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors" 
                                            title="Modifier">
                                                <i class="fas fa-pencil-alt"></i>
                                            </a>

                                            <form action="${pageContext.request.contextPath}/admin/listings/delete" method="POST" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer définitivement cette annonce ?');">
                                                <input type="hidden" name="listingId" value="${listing.id}">
                                                <button type="submit" 
                                                        class="p-2 rounded-md text-red-600 bg-red-100 hover:bg-red-200 dark:text-red-400 dark:bg-gray-700 dark:hover:bg-gray-600 transition-colors" 
                                                        title="Supprimer">
                                                    <i class="fas fa-trash-can"></i>
                                                </button>
                                            </form>
                                        </div>
                            
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty listings}">
                    <div class="text-center py-16 text-gray-500">
                        <i class="fas fa-box-open fa-3x mb-4"></i>
                        <h3 class="text-xl font-semibold">Aucune annonce trouvée</h3>
                        <p>Il n'y a actuellement aucune annonce à afficher.</p>
                    </div>
                </c:if>
      </main>
    </div>


    <jsp:include page="includes/admin_user_details_modal.jsp" />
            
    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
    
</body>
</html>
