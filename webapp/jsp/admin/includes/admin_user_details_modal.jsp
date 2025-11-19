<%@ page pageEncoding="UTF-8" %>
<div id="fullscreen-image-modal" class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-[60] hidden" onclick="hideFullScreenImage()">
    <div class="relative p-4" onclick="event.stopPropagation()">
        <button onclick="hideFullScreenImage()" class="absolute -top-2 -right-2 w-10 h-10 rounded-full bg-white text-black text-2xl flex items-center justify-center shadow-lg">&times;</button>
        <img id="fullscreen-image-content" src="" alt="Image CIN" class="max-w-screen-lg max-h-[80vh] rounded-lg">
    </div>
</div>

<div id="user-detail-modal" class="fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50 hidden transition-opacity duration-300">
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] flex flex-col transform transition-all duration-300 scale-95">

        <div class="p-5 border-b dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 flex items-start justify-between rounded-t-lg">
            <div class="flex items-center">
                <div class="relative">
                    <img id="modal-user-avatar" src="" alt="Avatar" class="w-16 h-16 rounded-full object-cover mr-4 ring-4 ring-white dark:ring-gray-700" />
                    <span id="modal-user-status-indicator" class="absolute bottom-1 right-4 block w-4 h-4 rounded-full border-2 border-white dark:border-gray-800"></span>
                </div>
                <div>
                    <h3 id="modal-user-fullname" class="text-xl font-bold text-gray-900 dark:text-white"></h3>
                    <span id="modal-user-role-badge" class="badge"></span>
                    <span id="modal-user-id-hidden" class="hidden"></span>
                </div>
            </div>
            <button id="close-user-modal" class="p-2 rounded-full text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-600 hover:text-gray-600 dark:hover:text-white transition-colors">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <div class="p-6 overflow-y-auto">
            <h4 class="font-semibold text-lg mb-4 text-gray-800 dark:text-gray-200">Informations Personnelles</h4>
            <ul class="space-y-4">
                
                <li class="flex items-center text-sm">
                    <i class="fas fa-envelope w-5 text-center text-gray-400 mr-4"></i>
                    <span class="text-gray-600 dark:text-gray-400">Email</span>
                    <span id="modal-user-email" class="ml-auto font-medium text-gray-900 dark:text-gray-100 break-all text-right"></span>
                </li>

                <li class="flex items-center text-sm">
                    <i class="fas fa-phone w-5 text-center text-gray-400 mr-4"></i>
                    <span class="text-gray-600 dark:text-gray-400">Téléphone</span>
                    <span id="modal-user-phone" class="ml-auto font-medium text-gray-900 dark:text-gray-100"></span>
                </li>

                <li class="flex items-center text-sm">
                    <i class="fas fa-calendar-alt w-5 text-center text-gray-400 mr-4"></i>
                    <span class="text-gray-600 dark:text-gray-400">Membre depuis</span>
                    <span id="modal-user-created-at" class="ml-auto font-medium text-gray-900 dark:text-gray-100"></span>
                </li>

                <li class="flex items-center justify-between text-sm">
                    <div class="flex items-center">
                        <i class="fas fa-user-check w-5 text-center text-gray-400 mr-4"></i>
                        <span class="text-gray-600 dark:text-gray-400">Statut</span>
                    </div>

                    <span id="modal-user-status-badge" class="badge"></span>
                </li>

            </ul>
            <div class="mt-2 border-t dark:border-gray-700 pt-6">
                <h4 class="font-semibold text-lg  text-gray-800 dark:text-gray-200">Documents d'Identité</h4>
                
                <div id="modal-cin-container" class=" flex space-x-2">
                </div>
            </div>
        </div>


        <div class="p-5 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 rounded-b-lg">
            <h4 class="font-semibold text-gray-900 dark:text-white text-lg mb-4 flex items-center">
                <i class="fas fa-cogs mr-2 text-gray-500 dark:text-gray-400"></i> Actions Administratives
            </h4>
            <div class="flex items-center justify-between">
                <label class="flex items-center cursor-pointer">
                    <span class="text-gray-700 dark:text-gray-300 mr-3">Compte Actif</span>
                    <div class="relative">
                        <input type="checkbox" id="modal-user-active-toggle" class="sr-only peer" />
                        <div class="block bg-gray-200 dark:bg-gray-600 w-14 h-8 rounded-full peer-checked:bg-admin-secondary"></div>
                        <div class="dot absolute left-1 top-1 bg-white dark:bg-gray-200 w-6 h-6 rounded-full transition-transform peer-checked:translate-x-full"></div>
                    </div>
                </label>
                <button id="modal-save-changes" class="btn btn-primary inline-flex items-center">
                    <i class="fas fa-save mr-2"></i> Sauvegarder
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function showFullScreenImage(src) {
        document.getElementById('fullscreen-image-content').src = src;
        document.getElementById('fullscreen-image-modal').classList.remove('hidden');
    }
    function hideFullScreenImage() {
        document.getElementById('fullscreen-image-modal').classList.add('hidden');
        document.getElementById('fullscreen-image-content').src = ""; 
    }
    document.addEventListener('keydown', function(event) {
        if (event.key === "Escape") {
            hideFullScreenImage();
        }
    });
</script>