<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Admin</title>

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
    <style>
        dt { font-weight: 500; }
        dd { margin-left: 0; }
    </style>
</head>
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 bg-gray-50 dark:bg-gray-900 min-h-screen flex flex-col">

    <jsp:include page="includes/admin_header.jsp"></jsp:include>
    <jsp:include page="includes/admin_sidebar.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <main class="flex-1 md:ml-64 min-h-screen">
        <div class="py-8 px-4 md:px-8">

            <c:if test="${not empty successMessage}">
                <div id="alert-success" class="flex items-center p-4 mb-6 text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400" role="alert">
                    <i class="fas fa-check-circle"></i>
                    <span class="sr-only">Success</span>
                    <div class="ms-3 text-sm font-medium">
                        <c:out value="${successMessage}"/>
                    </div>
                    <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-green-50 text-green-500 rounded-lg focus:ring-2 focus:ring-green-400 p-1.5 hover:bg-green-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-green-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-success" aria-label="Close">
                        <span class="sr-only">Close</span>
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <c:remove var="successMessage" scope="session"/>

            </c:if>

            <c:if test="${not empty errorMessage}">
                <div id="alert-danger" class="flex items-center p-4 mb-6 text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400" role="alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span class="sr-only">Error</span>
                    <div class="ms-3 text-sm font-medium">
                        <c:out value="${errorMessage}"/>
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
                    <li aria-current="page">
                        <div class="flex items-center">
                            <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                            <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2 dark:text-gray-400">Mon Profil</span>
                        </div>
                    </li>
                </ol>
            </nav>

            <div class="flex justify-between items-center mb-8">
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Mon Profil</h1>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                <div class="lg:col-span-2 space-y-6">

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6 relative">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-user-edit mr-2 text-gray-500 dark:text-gray-400"></i> Informations Personnelles
                        </h2>

                        <div id="info-view-mode">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                
                                <div>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                            <i class="fas fa-user fa-fw text-blue-600 dark:text-blue-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">Prénom</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200">
                                                <c:out value="${adminProfile.firstName}"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                            <i class="fas fa-user fa-fw text-blue-600 dark:text-blue-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">Nom</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200">
                                                <c:out value="${adminProfile.lastName}"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="md:col-span-2">
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-green-100 dark:bg-green-900/30 rounded-lg mr-3">
                                            <i class="fas fa-envelope fa-fw text-green-600 dark:text-green-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">Email</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200">
                                                <c:out value="${adminProfile.email}"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <div class="md:col-span-2">
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg mr-3">
                                            <i class="fas fa-at fa-fw text-purple-600 dark:text-purple-400"></i>
                                        </div>
                                        <div>
                                            <p class="text-xs text-gray-500 dark:text-gray-400">Nom d'utilisateur</p>
                                            <p class="font-semibold text-gray-800 dark:text-gray-200">
                                                <c:out value="${adminProfile.username}"/>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="absolute top-4 right-4" id="info-view-buttons">
                                <button type="button" onclick="toggleEditInfo(true)" class="text-admin-secondary hover:text-admin-primary dark:text-admin-accent dark:hover:text-admin-secondary text-sm font-medium">
                                    <i class="fas fa-pencil-alt mr-1"></i> Modifier
                                </button>
                            </div>
                        </div>

                        <div id="info-edit-mode" class="hidden">
                            <form action="${pageContext.request.contextPath}/admin/profile" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="updateInfo">
                                
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label for="edit-firstName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Prénom</label>
                                        <div class="flex items-start">
                                            <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                                <i class="fas fa-user fa-fw text-blue-600 dark:text-blue-400"></i>
                                            </div>
                                            <div class="flex-1">
                                                <input type="text" id="edit-firstName" name="firstName" class="form-input w-full text-base" value="<c:out value='${adminProfile.firstName}'/>" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div>
                                        <label for="edit-lastName" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Nom</label>
                                        <div class="flex items-start">
                                            <div class="flex-shrink-0 p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
                                                <i class="fas fa-user fa-fw text-blue-600 dark:text-blue-400"></i>
                                            </div>
                                            <div class="flex-1">
                                                <input type="text" id="edit-lastName" name="lastName" class="form-input w-full text-base" value="<c:out value='${adminProfile.lastName}'/>" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="md:col-span-2">
                                        <label for="edit-email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Email</label>
                                        <div class="flex items-start">
                                            <div class="flex-shrink-0 p-2 bg-green-100 dark:bg-green-900/30 rounded-lg mr-3">
                                                <i class="fas fa-envelope fa-fw text-green-600 dark:text-green-400"></i>
                                            </div>
                                            <div class="flex-1">
                                                <input type="email" id="edit-email" name="email" class="form-input w-full text-base" value="<c:out value='${adminProfile.email}'/>" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="md:col-span-2">
                                        <label for="edit-username" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Nom d'utilisateur</label>
                                        <div class="flex items-start">
                                            <div class="flex-shrink-0 p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg mr-3">
                                                <i class="fas fa-at fa-fw text-purple-600 dark:text-purple-400"></i>
                                            </div>
                                            <div class="flex-1">
                                                <input type="text" id="edit-username" class="form-input w-full text-base bg-gray-100 dark:bg-gray-700 cursor-not-allowed" value="<c:out value='${adminProfile.username}'/>" readonly disabled>
                                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Non modifiable</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="md:col-span-2">
                                    <label for="edit-avatar" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                                        Changer l'avatar (Facultatif)
                                    </label>
                                    <div class="flex items-start">
                                        <div class="flex-shrink-0 p-2 bg-gray-100 dark:bg-gray-900/30 rounded-lg mr-3">
                                            <i class="fas fa-image fa-fw text-gray-600 dark:text-gray-400"></i>
                                        </div>
                                        <div class="flex-1">
                                            <input type="file" id="edit-avatar" name="avatar" class="form-input w-full text-base" accept="image/png, image/jpeg">
                                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Laissez vide pour conserver l'avatar actuel.</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-6 flex justify-end gap-3" id="info-edit-buttons">
                                    <button type="button" onclick="toggleEditInfo(false)" class="flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                                        Annuler
                                    </button>
                                    <button type="submit" class="flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors">
                                        <i class="fas fa-save mr-2"></i> Enregistrer
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-key mr-2 text-gray-500 dark:text-gray-400"></i> Sécurité
                        </h2>
                        
                        <div class="flex items-start">
                            <div class="flex-shrink-0 p-2 bg-red-100 dark:bg-red-900/30 rounded-lg mr-3">
                                <i class="fas fa-lock fa-fw text-red-600 dark:text-red-400"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">Changez votre mot de passe régulièrement pour sécuriser votre compte.</p>
                                <form action="${pageContext.request.contextPath}/admin/profile" method="POST">
                                 <input type="hidden" name="action" value="changePassword">
                                <button type="button" data-modal-target="password-modal" data-modal-toggle="password-modal"
                                        class="flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-admin-secondary hover:bg-admin-primary focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                                    <i class="fas fa-lock mr-2"></i> Changer le mot de passe
                                </button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="space-y-6">
                    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                        <h2 class="text-lg font-semibold text-gray-900 dark:text-white mb-4 flex items-center">
                            <i class="fas fa-image mr-2 text-gray-500 dark:text-gray-400"></i> Avatar
                        </h2>
                        
                        <div class="flex flex-col items-center">
                            <c:choose>
                                <c:when test="${not empty adminProfile.avatarUrl}">
                                    <img class="w-32 h-32 rounded-full object-cover mb-4 ring-2 ring-offset-2 ring-admin-secondary dark:ring-offset-gray-800"
                                         src="${pageContext.request.contextPath}/uploads/${adminProfile.avatarUrl}" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <img class="w-32 h-32 rounded-full object-cover mb-4 ring-2 ring-offset-2 ring-gray-300 dark:ring-offset-gray-800"
                                         src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar par défaut">
                                </c:otherwise>
                            </c:choose>
                        
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>

    <div id="password-modal" tabindex="-1" aria-hidden="true" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-[60] justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
        <div class="relative p-4 w-full max-w-md max-h-full">
            <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
                    <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
                        Changer le mot de passe
                    </h3>
                    <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="password-modal">
                        <i class="fas fa-times"></i>
                        <span class="sr-only">Fermer la modale</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/profile" method="POST" class="p-4 md:p-5">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="grid gap-4 mb-4 grid-cols-1">
                        <div>
                            <label for="modal-currentPassword" class="form-label block mb-2">Mot de passe actuel</label>
                            <input type="password" id="modal-currentPassword" name="currentPassword" class="form-input w-full text-base" required autocomplete="current-password">
                        </div>
                        <div>
                            <label for="modal-newPassword" class="form-label block mb-2">Nouveau mot de passe</label>
                            <input type="password" id="modal-newPassword" name="newPassword" class="form-input w-full text-base" required minlength="8" placeholder="Minimum 8 caractères" autocomplete="new-password">
                        </div>
                        <div>
                            <label for="modal-confirmPassword" class="form-label block mb-2">Confirmer le nouveau mot de passe</label>
                            <input type="password" id="modal-confirmPassword" name="confirmPassword" class="form-input w-full text-base" required minlength="6" autocomplete="new-password">
                        </div>
                    </div>
                    <div class="flex justify-end gap-3 border-t dark:border-gray-600 pt-4 mt-4">
                        <button type="button" data-modal-hide="password-modal" class="flex items-center justify-center px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                            Annuler
                        </button>
                        <button type="submit" class="flex items-center justify-center px-4 py-2 text-sm font-medium rounded-md text-white bg-admin-secondary hover:bg-admin-primary focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-admin-primary dark:focus:ring-admin-secondary transition-colors">
                            <i class="fas fa-lock mr-2"></i> Enregistrer le mot de passe
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>

    <script>
        function toggleEditInfo(isEditing) {
            const viewModeDiv = document.getElementById('info-view-mode');
            const editModeDiv = document.getElementById('info-edit-mode');

            if (!viewModeDiv || !editModeDiv) {
                console.error("Éléments 'info-view-mode' ou 'info-edit-mode' non trouvés !");
                return;
            }

            if (isEditing) {
                viewModeDiv.classList.add('hidden');
                editModeDiv.classList.remove('hidden');
            } else {
                viewModeDiv.classList.remove('hidden');
                editModeDiv.classList.add('hidden');
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            toggleEditInfo(false); 
        });
    </script>

</body>
</html>