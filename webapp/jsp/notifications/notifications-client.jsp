<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CampShare - Notifications Client</title>

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
    <!-- Main content -->
    <main class="flex-1 pt-16 bg-gray-50 dark:bg-gray-900 min-h-screen">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Header with breadcrumbs -->
            <div class="mb-8">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                    <div>
                        <nav class="flex mb-3" aria-label="Breadcrumb">
                            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                                <li class="inline-flex items-center">
                                    <a href="${pageContext.request.contextPath}/client/dashboard" class="inline-flex items-center text-sm font-medium text-gray-600 dark:text-gray-400 hover:text-forest dark:hover:text-meadow">
                                        <i class="fas fa-tachometer-alt mr-2"></i>
                                        Tableau de Bord Client
                                    </a>
                                </li>
                                <li aria-current="page">
                                    <div class="flex items-center">
                                        <i class="fas fa-chevron-right text-gray-400 mx-2 text-xs"></i>
                                        <span class="text-sm font-medium text-gray-500 dark:text-gray-300">Notifications</span>
                                    </div>
                                </li>
                            </ol>
                        </nav>
                        <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Mes Notifications</h1>
                        <p class="text-gray-600 dark:text-gray-400 mt-1">Consultez vos notifications liées à vos réservations et aux annonces.</p>
                    </div>

                    <div class="mt-4 md:mt-0 flex space-x-2">
                        <button id="mark-all-read" class="inline-flex items-center px-4 py-2 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700 rounded-md shadow-sm transition-colors">
                            <i class="fas fa-check-double mr-2"></i>
                            Tout marquer comme lu
                        </button>
                        <button id="delete-selected" class="inline-flex items-center px-4 py-2 border border-red-300 dark:border-red-700 text-red-700 dark:text-red-400 bg-white dark:bg-gray-800 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-md shadow-sm transition-colors">
                            <i class="fas fa-trash-alt mr-2"></i>
                            Supprimer sélection
                        </button>
                    </div>
                </div>
            </div>

            <!-- Notifications container -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden mb-8">
                <!-- Filters -->
                <div class="border-b border-gray-200 dark:border-gray-700 p-5">
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                        <div class="flex items-center space-x-2">
                            <label class="custom-checkbox text-sm font-medium text-gray-700 dark:text-gray-300">
                                <input type="checkbox" id="select-all">
                                <span class="checkmark"></span>
                                Tout sélectionner
                            </label>

                            <span class="text-gray-400 dark:text-gray-500 mx-1">|</span>

                            <div id="notification-counter" class="text-sm text-gray-600 dark:text-gray-400">
                            </div>
                        </div>

                        <div class="flex items-center space-x-2">
                            <label for="filter-select" class="text-sm font-medium text-gray-700 dark:text-gray-300 mr-2">Filtrer par</label>
                            <select id="filter-select" class="py-2 px-3 border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 rounded-md shadow-sm text-sm text-gray-700 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-forest dark:focus:ring-meadow focus:border-forest dark:focus:border-meadow">
                                <option value="all">Toutes</option>
                                <option value="unread">Non lues</option>
                                <option value="review_object">Avis Objet</option>
                                <option value="review_partner">Avis Partenaire</option>
                                <option value="accepted_reservation">Résa. Acceptée</option>
                                <option value="rejected_reservation">Résa. Refusée</option>
                                <option value="added_listing">Annonce Ajoutée</option>
                                <option value="updated_listing">Annonce MàJ</option>
                            </select>
                        </div>
                    </div>
                </div>

                <form id="notifications-form" method="post" action="${pageContext.request.contextPath}/client/notifications">
                    <input type="hidden" name="action" id="action-input" value="">
                    <input type="hidden" name="singleId" id="single-id-input" value="">

                    <div class="divide-y divide-gray-200 dark:divide-gray-700 max-h-[600px] overflow-y-auto" id="notifications-list">
                        <c:if test="${empty notifications}">
                            <div class="p-6 text-center text-gray-500 dark:text-gray-400">
                                Vous n'avez aucune notification pour le moment.
                            </div>
                        </c:if>

                        <c:forEach var="notification" items="${notifications}">
                            <c:set var="isReviewNotification"
                                   value="${notification.type == 'review_object' or notification.type == 'review_partner' or notification.type == 'review_client'}"/>

                            <!-- Default styles -->
                            <c:set var="iconClass" value="fa-info-circle"/>
                            <c:set var="bgColorClass" value="bg-gray-100 dark:bg-gray-700"/>
                            <c:set var="textColorClass" value="text-gray-500 dark:text-gray-400"/>
                            <c:set var="tagText" value="Système"/>
                            <c:set var="tagBgClass" value="bg-gray-100 dark:bg-gray-700"/>
                            <c:set var="tagTextColorClass" value="text-gray-800 dark:text-gray-300"/>
                            <c:set var="titleText" value="${notification.type}"/>

                            <c:choose>
                                <c:when test="${notification.type == 'accepted_reservation'}">
                                    <c:set var="iconClass" value="fa-calendar-check"/>
                                    <c:set var="bgColorClass" value="bg-green-100 dark:bg-green-800"/>
                                    <c:set var="textColorClass" value="text-green-500 dark:text-green-300"/>
                                    <c:set var="tagText" value="Réservation"/>
                                    <c:set var="tagBgClass" value="bg-green-100 dark:bg-green-800"/>
                                    <c:set var="tagTextColorClass" value="text-green-800 dark:text-green-300"/>
                                    <c:set var="titleText" value="Réservation Acceptée"/>
                                </c:when>
                                <c:when test="${notification.type == 'rejected_reservation'}">
                                    <c:set var="iconClass" value="fa-calendar-times"/>
                                    <c:set var="bgColorClass" value="bg-red-100 dark:bg-red-800"/>
                                    <c:set var="textColorClass" value="text-red-500 dark:text-red-300"/>
                                    <c:set var="tagText" value="Réservation"/>
                                    <c:set var="tagBgClass" value="bg-red-100 dark:bg-red-800"/>
                                    <c:set var="tagTextColorClass" value="text-red-800 dark:text-red-300"/>
                                    <c:set var="titleText" value="Réservation Refusée"/>
                                </c:when>
                                <c:when test="${notification.type == 'added_listing' or notification.type == 'updated_listing'}">
                                    <c:set var="iconClass" value="fa-bullhorn"/>
                                    <c:set var="bgColorClass" value="bg-indigo-100 dark:bg-indigo-800"/>
                                    <c:set var="textColorClass" value="text-indigo-500 dark:text-indigo-300"/>
                                    <c:set var="tagText" value="Annonce"/>
                                    <c:set var="tagBgClass" value="bg-indigo-100 dark:bg-indigo-800"/>
                                    <c:set var="tagTextColorClass" value="text-indigo-800 dark:text-indigo-300"/>
                                    <c:choose>
                                        <c:when test="${notification.type == 'added_listing'}">
                                            <c:set var="titleText" value="Nouvelle Annonce"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="titleText" value="Annonce Mise à Jour"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${notification.type == 'review_object' or notification.type == 'review_partner' or notification.type == 'review_client'}">
                                    <c:set var="iconClass" value="fa-star"/>
                                    <c:set var="bgColorClass" value="bg-yellow-100 dark:bg-yellow-800"/>
                                    <c:set var="textColorClass" value="text-yellow-500 dark:text-yellow-300"/>
                                    <c:set var="tagText" value="Évaluation"/>
                                    <c:set var="tagBgClass" value="bg-yellow-100 dark:bg-yellow-800"/>
                                    <c:set var="tagTextColorClass" value="text-yellow-800 dark:text-yellow-300"/>
                                    <c:set var="titleText" value="Demande d'évaluation"/>
                                </c:when>
                            </c:choose>

                            <div class="notification-item flex p-5 ${!notification.read ? 'bg-blue-50 dark:bg-blue-900/20' : ''}"
                                 data-type="${notification.type}"
                                 data-read="${notification.read ? 'true' : 'false'}"
                                 data-id="${notification.id}">

                                <div class="flex-shrink-0 self-start pt-1">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="notification-checkbox" name="selectedIds" value="${notification.id}">
                                        <span class="checkmark"></span>
                                    </label>
                                </div>

                                <div class="flex flex-1 ml-3">
                                    <div class="flex-shrink-0 mr-4">
                                        <div class="w-10 h-10 rounded-full ${bgColorClass} flex items-center justify-center ${textColorClass}">
                                            <i class="fas ${iconClass}"></i>
                                        </div>
                                    </div>

                                    <div class="flex-1">
                                        <div class="flex items-start justify-between mb-1">
                                            <h3 class="font-medium text-gray-900 dark:text-white flex items-center">
                                                ${titleText}
                                                <span class="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${tagBgClass} ${tagTextColorClass}">
                                                    ${tagText}
                                                </span>
                                                <c:if test="${!notification.read}">
                                                    <span class="unread-indicator" title="Non lue"></span>
                                                </c:if>
                                            </h3>
                                            <span class="text-sm text-gray-500 dark:text-gray-400 whitespace-nowrap">
                                                <fmt:formatDate value="${notification.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>

                                        <p class="text-gray-600 dark:text-gray-300">
                                            ${notification.message}
                                        </p>

                                        <div class="mt-3 flex items-center flex-wrap gap-x-4 gap-y-1">
                                            <!-- Lien vers l'annonce pour les notifications liées à une annonce -->
                                            <c:if test="${!isReviewNotification and notification.listingId != null}">
                                                <a href="${pageContext.request.contextPath}/partner/AnnonceDetails?listing_id=${notification.listingId}" class="text-sm text-forest dark:text-meadow hover:underline">
                                                    <i class="fas fa-eye mr-1"></i> Voir l'annonce
                                                </a>
                                            </c:if>

                                            <!-- Pour le moment, pas de lien vers le formulaire d'évaluation -->

                                            <c:if test="${!notification.read}">
                                                <button type="button"
                                                        class="text-sm text-gray-600 dark:text-gray-400 hover:underline btn-mark-read"
                                                        data-id="${notification.id}">
                                                    <i class="fas fa-check mr-1"></i> Marquer comme lu
                                                </button>
                                            </c:if>
                                            <button type="button"
                                                    class="text-sm text-red-600 dark:text-red-400 hover:underline ml-auto btn-delete"
                                                    data-id="${notification.id}">
                                                <i class="fas fa-trash mr-1"></i> Supprimer
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </form>

            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <jsp:include page="/jsp/common/footer.jsp" />

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const filterSelect = document.getElementById("filter-select");
        const notificationCounter = document.getElementById("notification-counter");
        const notificationsList = document.getElementById("notifications-list");
        const selectAllCheckbox = document.getElementById("select-all");
        const form = document.getElementById("notifications-form");
        const actionInput = document.getElementById("action-input");
        const singleIdInput = document.getElementById("single-id-input");
        const markAllReadBtn = document.getElementById("mark-all-read");
        const deleteSelectedBtn = document.getElementById("delete-selected");

        function getNotificationItems() {
          return Array.from(notificationsList.querySelectorAll(".notification-item"));
        }

        function getItemCheckboxes() {
          return Array.from(document.querySelectorAll(".notification-checkbox"));
        }

        function updateCounter() {
          const items = getNotificationItems();
          let visibleCount = 0;
          let unreadCount = 0;
          items.forEach((item) => {
            if (item.style.display === "none") return;
            visibleCount++;
            if (item.getAttribute("data-read") === "false") {
              unreadCount++;
            }
          });

          if (visibleCount === 0) {
            notificationCounter.textContent = "Aucune notification.";
          } else if (unreadCount > 0) {
            notificationCounter.textContent =
              visibleCount + " notifications (" + unreadCount + " non lues)";
          } else {
            notificationCounter.textContent = visibleCount + " notifications";
          }
        }

        function applyFilter() {
          const filter = filterSelect.value;
          const items = getNotificationItems();

          items.forEach((item) => {
            const type = item.getAttribute("data-type");
            const isRead = item.getAttribute("data-read") === "true";
            let show = true;

            if (filter === "unread") {
              show = !isRead;
            } else if (filter !== "all") {
              show = type === filter;
            }

            item.style.display = show ? "" : "none";
          });

          updateCounter();
        }

        if (filterSelect) {
          filterSelect.addEventListener("change", applyFilter);
        }

        if (selectAllCheckbox) {
          selectAllCheckbox.addEventListener("change", function () {
            const checked = selectAllCheckbox.checked;
            getItemCheckboxes().forEach((cb) => {
              const item = cb.closest(".notification-item");
              if (item && item.style.display !== "none") {
                cb.checked = checked;
              }
            });
          });
        }

        if (markAllReadBtn) {
          markAllReadBtn.addEventListener("click", function () {
            actionInput.value = "markAllRead";
            singleIdInput.value = "";
            form.submit();
          });
        }

        if (deleteSelectedBtn) {
          deleteSelectedBtn.addEventListener("click", function () {
            const anyChecked = getItemCheckboxes().some((cb) => cb.checked);
            if (!anyChecked) {
              alert("Veuillez sélectionner au moins une notification à supprimer.");
              return;
            }
            if (!confirm("Supprimer les notifications sélectionnées ?")) {
              return;
            }
            actionInput.value = "deleteSelected";
            singleIdInput.value = "";
            form.submit();
          });
        }

        notificationsList.addEventListener("click", function (e) {
          const markBtn = e.target.closest(".btn-mark-read");
          const deleteBtn = e.target.closest(".btn-delete");

          if (markBtn) {
            const id = markBtn.getAttribute("data-id");
            actionInput.value = "markRead";
            singleIdInput.value = id;
            form.submit();
          } else if (deleteBtn) {
            const id = deleteBtn.getAttribute("data-id");
            if (!confirm("Supprimer cette notification ?")) {
              return;
            }
            actionInput.value = "deleteOne";
            singleIdInput.value = id;
            form.submit();
          }
        });

        applyFilter();
      });
    </script>

</body>
</html>