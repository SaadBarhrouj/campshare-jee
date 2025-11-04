<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CampShare - Partner Profile</title>

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/app.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/styles.css"
    />

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
      integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />

    <link
      rel="icon"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon.ico"
      type="image/x-icon"
    />
    <link
      rel="apple-touch-icon"
      sizes="180x180"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/apple-touch-icon.png"
    />
    <link
      rel="icon"
      type="image/png"
      sizes="32x32"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon-32x32.png"
    />
    <link
      rel="icon"
      type="image/png"
      sizes="16x16"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/favicon-16x16.png"
    />
    <link
      rel="manifest"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/site.webmanifest"
    />
    <link
      rel="mask-icon"
      href="${pageContext.request.contextPath}/assets/images/favicon_io/safari-pinned-tab.svg"
      color="#5bbad5"
    />

    <meta name="msapplication-TileColor" content="#da532c" />
    <meta name="theme-color" content="#ffffff" />
    <meta
      name="description"
      content="CampShare - Louez facilement le matériel de camping dont vous avez besoin directement entre particuliers."
    />
    <meta
      name="keywords"
      content="camping, location, matériel, aventure, plein air, partage, communauté"
    />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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

<body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900">
    

    <!-- Header -->
    <jsp:include page="/jsp/common/header.jsp" />

    <!-- Main Content -->
    <main class="pt-16">
        <!-- Partner Profile Header -->
        <section class="bg-gray-50 dark:bg-gray-800 py-10 md:py-24 border-b border-gray-200 dark:border-gray-700">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col md:flex-row items-start md:items-center">
                    <!-- Profile Image -->
                    <div class="relative mb-6 md:mb-0 md:mr-8">
                        <div class="w-24 h-24 md:w-32 md:h-32 rounded-full overflow-hidden border-4 border-white dark:border-gray-700 shadow-md">
                            <c:choose>
                                <c:when test="${not empty partner.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}/${partner.avatarUrl}"
                                         alt="${partner.username}"
                                         class="w-full h-full object-cover" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/images/items/test1.jpg"
                                         alt="${partner.username}"
                                         class="w-full h-full object-cover" />
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="absolute -bottom-2 -right-2 bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center border-2 border-white dark:border-gray-700">
                            <i class="fas fa-check"></i>
                        </div>
                    </div>
                    
                    <!-- Profile Info -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-20">
                        <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-4">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900 dark:text-white flex items-center">
                                    ${partner.username}
                                    <span class="ml-3 text-sm font-medium px-2 py-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-md">
                                        Partenaire depuis <fmt:formatDate value="${partner.createdAt}" pattern="yyyy"/>
                                    </span>
                                </h1>
                                <div class="mt-2 flex items-center text-gray-600 dark:text-gray-300">
                                    <i class="fas fa-map-marker-alt mr-2 text-gray-400"></i>
                                    <span><c:out value="${city != null ? city.name : 'City'}"/>, Maroc</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Statistics -->
                        <div class="flex gap-6 flex-nowrap">
                            <div class="flex flex-col items-center">
                                <c:choose>
                                    <c:when test="${partnerReviewCount > 0}">
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">${partnerAvgRating}</div>
                                        <div class="flex text-amber-400 mt-1">
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">(${partnerReviewCount} avis)</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-2xl font-bold text-gray-900 dark:text-white">Non noté</div>
                                        <div class="flex text-amber-400 mt-1">
                                            <i class="far fa-star"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="flex flex-col items-center">
                                <div class="text-2xl font-bold text-gray-900 dark:text-white">${listingsCount}</div>
                                <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">Annonces publiées</div>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Tabs Navigation -->
        <section class="border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 sticky top-16 z-30">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex overflow-x-auto scrollbar-hide">
                    <button id="tab-equipment1" class="tab-active px-4 py-4 font-medium text-lg whitespace-nowrap">
                        Équipements disponibles (${listingsCount})
                    </button>
                    <button id="tab-reviews1" class="px-4 py-4 font-medium text-lg text-gray-500 dark:text-gray-400 whitespace-nowrap">
                        Avis (${partnerReviewCount})
                    </button>
                </div>
            </div>
        </section>
        
        <!-- Equipment Section -->
        <section id="equipment-section1" class="py-10">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Équipements proposés par ${partner.username}</h2>
                </div>
                
                <!-- Equipment Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                    <c:choose>
                    <c:when test="${not empty listings}">
                    <c:forEach var="vm" items="${listings}">
                        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden transform transition duration-300 hover:shadow-md hover:-translate-y-1 relative">
                            <div class="absolute top-4 left-4 z-10 bg-forest text-white rounded-full px-3 py-1 font-medium text-xs flex items-center">
                                ${vm.category != null ? vm.category.name : ''}
                            </div>
                            <a href="${pageContext.request.contextPath}/listing?id=${vm.listing.id}">
                                <div class="relative h-48">
                                    <img src="${vm.firstImage != null ? pageContext.request.contextPath.concat('/').concat(vm.firstImage.url) : pageContext.request.contextPath.concat('/assets/images/items/test1.jpg')}" alt="image" class="w-full h-full object-cover" />
                                </div>
                                <div class="p-4">
                                    <div class="flex justify-between items-start mb-2">
                                        <div>
                                            <h3 class="font-bold text-gray-900 dark:text-white">${vm.item.title}</h3>
                                            <p class="text-sm text-gray-500 dark:text-gray-400">Catégorie - ${vm.category != null ? vm.category.name : ''}</p>
                                        </div>
                                        <div class="flex items-center text-sm flex-nowrap">
                                            <i class="fas fa-star text-amber-400 mr-1"></i>
                                            <span class="flex flex-nowrap">${vm.averageRating} <span class="text-gray-500 dark:text-gray-400">(${vm.reviewCount})</span></span>
                                        </div>
                                    </div>
                                    
                                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-300 mb-2">
                                        <i class="fas fa-user mr-1 text-gray-400"></i>
                                        <a href="${pageContext.request.contextPath}/partner-profile?id=${vm.partner.id}" class="hover:text-forest dark:hover:text-sunlight">${vm.partner.username}</a>
                                    </div>
                                    
                                    <div class="flex items-center text-sm text-gray-600 dark:text-gray-300 mb-2">
                                        <i class="fas fa-map-marker-alt mr-1 text-gray-400"></i>
                                        <span>${vm.city != null ? vm.city.name : ''}, Maroc</span>
                                    </div>
                                    
                                    <div class="text-sm mb-3">
                                        <span class="text-gray-600 dark:text-gray-300">Disponible du <fmt:formatDate value="${vm.listing.startDate}" pattern="yyyy-MM-dd"/> au <fmt:formatDate value="${vm.listing.endDate}" pattern="yyyy-MM-dd"/></span>
                                    </div>
                                    
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <span class="font-bold text-lg text-gray-900 dark:text-white">${vm.item.pricePerDay} MAD</span>
                                            <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/listing?id=${vm.listing.id}" class="inline-block">
                                            <button class="px-4 py-2 bg-forest hover:bg-green-700 text-white rounded-md transition-colors shadow-sm">
                                                Voir détails
                                            </button>
                                        </a>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-500">Aucun annonce publiée encore.</p>
                    </c:otherwise>
                    </c:choose>
                    
                </div>
            </div>
        </section>
        
        
        <!-- Reviews Section -->
        <section id="reviews-section1" class="py-10 hidden">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex items-center justify-between mb-8">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">Avis des utilisateurs sur ce partenaire</h2>
                </div>
                
                <!-- Review Stats -->
                <c:if test="${partnerReviewCount > 0}">
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 mb-8">
                        <div class="flex flex-col md:flex-row md:items-center">
                            <div class="flex flex-col items-center mr-8 mb-6 md:mb-0">
                                <div class="text-5xl font-bold text-gray-900 dark:text-white">${partnerAvgRating}</div>
                                <div class="flex text-amber-400 text-xl mt-2">
                                    <i class="fas fa-star"></i>
                                </div>
                                <div class="text-sm text-gray-500 dark:text-gray-400 mt-1">${partnerReviewCount} avis</div>
                            </div>
                            
                            <div class="flex-1 grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <div class="flex items-center mb-2">
                                        <div class="w-24 font-medium text-gray-700 dark:text-gray-300">5 étoiles</div>
                                        <div class="flex-1 h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                                            <div class="h-full bg-amber-400 rounded-full" style="width: ${partnerRatingPercentages[5]}%"></div>
                                        </div>
                                        <div class="w-12 text-right text-gray-500 dark:text-gray-400 text-sm">${partnerRatingPercentages[5]}%</div>
                                    </div>
                                    <div class="flex items-center mb-2">
                                        <div class="w-24 font-medium text-gray-700 dark:text-gray-300">4 étoiles</div>
                                        <div class="flex-1 h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                                            <div class="h-full bg-amber-400 rounded-full" style="width: ${partnerRatingPercentages[4]}%"></div>
                                        </div>
                                        <div class="w-12 text-right text-gray-500 dark:text-gray-400 text-sm">${partnerRatingPercentages[4]}%</div>
                                    </div>
                                    <div class="flex items-center mb-2">
                                        <div class="w-24 font-medium text-gray-700 dark:text-gray-300">3 étoiles</div>
                                        <div class="flex-1 h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                                            <div class="h-full bg-amber-400 rounded-full" style="width: ${partnerRatingPercentages[3]}%"></div>
                                        </div>
                                        <div class="w-12 text-right text-gray-500 dark:text-gray-400 text-sm">${partnerRatingPercentages[3]}%</div>
                                    </div>
                                </div>
                                
                                <div>
                                    <div class="flex items-center mb-2">
                                        <div class="w-24 font-medium text-gray-700 dark:text-gray-300">2 étoiles</div>
                                        <div class="flex-1 h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                                            <div class="h-full bg-amber-400 rounded-full" style="width: ${partnerRatingPercentages[2]}%"></div>
                                        </div>
                                        <div class="w-12 text-right text-gray-500 dark:text-gray-400 text-sm">${partnerRatingPercentages[2]}%</div>
                                    </div>
                                    <div class="flex items-center mb-2">
                                        <div class="w-24 font-medium text-gray-700 dark:text-gray-300">1 étoile</div>
                                        <div class="flex-1 h-3 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
                                            <div class="h-full bg-amber-400 rounded-full" style="width: ${partnerRatingPercentages[1]}%"></div>
                                        </div>
                                        <div class="w-12 text-right text-gray-500 dark:text-gray-400 text-sm">${partnerRatingPercentages[1]}%</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                
                <!-- Review List -->
                <div class="space-y-6">

                    <c:choose>
                    <c:when test="${not empty partnerReviews}">
                    <c:forEach var="review" items="${partnerReviews}" varStatus="vs">
                        <div class="review-item ${vs.index >= 3 ? 'hidden' : ''}">
                            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                                <div class="flex justify-between items-start">
                                    <div class="flex">
                                        <div class="mr-4">
                                            <a href="${pageContext.request.contextPath}/client-profile?id=${review.reviewer.id}">
                                                <img src="${review.reviewer != null && review.reviewer.avatarUrl != null ? pageContext.request.contextPath.concat('/').concat(review.reviewer.avatarUrl) : pageContext.request.contextPath.concat('/assets/images/users/image4.png')}" 
                                                     alt="${review.reviewer != null ? review.reviewer.username : ''}" 
                                                     class="w-12 h-12 rounded-full object-cover" />
                                            </a>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/client-profile?id=${review.reviewer.id}" class="font-bold text-gray-900 dark:text-white hover:text-forest dark:hover:text-meadow">${review.reviewer != null ? review.reviewer.username : ''}</a>
                                            <div class="flex items-center space-x-2 mt-1">
                                                <div class="flex text-amber-400">
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <i class="${i <= review.rating ? 'fas' : 'far'} fa-star text-sm"></i>
                                                    </c:forEach>
                                                </div>
                                                <span class="text-gray-500 dark:text-gray-400 text-sm"><fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd"/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4">
                                    <p class="text-gray-600 dark:text-gray-300"> ${review.comment} </p>
                                </div>

                            </div>
                        </div>

                    </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-500">Ce partenaire n'a pas encore reçu d'avis.</p>
                    </c:otherwise>
                    </c:choose>
                    

                </div>
            </div>
        </section>
    </main>
    
    <!-- Footer -->
    <jsp:include page="/jsp/common/footer.jsp" />

    <script>

        // Tab switching
        const tabEquipment = document.getElementById('tab-equipment1');
        const tabReviews1 = document.getElementById('tab-reviews1');
        const equipmentSection = document.getElementById('equipment-section1');
        const reviewsSection1 = document.getElementById('reviews-section1');

        tabEquipment.addEventListener('click', () => {
            // Update tab styles
            tabEquipment.classList.add('tab-active');
            tabReviews1.classList.remove('tab-active');
            tabReviews1.classList.add('text-gray-500', 'dark:text-gray-400');
            
            // Show/hide sections
            equipmentSection.classList.remove('hidden');
            reviewsSection1.classList.add('hidden');
        });

        tabReviews1.addEventListener('click', () => {
            // Update tab styles
            tabReviews1.classList.add('tab-active');
            tabReviews1.classList.remove('text-gray-500', 'dark:text-gray-400');
            tabEquipment.classList.remove('tab-active');
            
            // Show/hide sections
            reviewsSection1.classList.remove('hidden');
            equipmentSection.classList.add('hidden');
        });
    
    </script>
</body>
</html>