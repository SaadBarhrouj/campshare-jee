<div
  id="user-detail-modal"
  class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden"
>
  <div
    class="bg-white dark:bg-gray-800 rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] flex flex-col"
  >
    <div class="p-5 border-b flex items-center justify-between">
      <div class="flex items-center">
        <img
          id="modal-user-avatar"
          src=""
          alt="Avatar"
          class="w-12 h-12 rounded-full object-cover mr-4"
        />
        <div>
          <h3 id="modal-user-fullname" class="text-xl font-bold"></h3>
          <span id="modal-user-role-badge" class="badge"></span>

          <span id="modal-user-id-hidden" class="hidden"></span>
        </div>
      </div>
      <button id="close-user-modal" class="text-gray-500 hover:text-gray-700">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <div class="p-5 overflow-y-auto">
      <h4 class="font-semibold text-lg mb-3">Informations personnelles</h4>
      <div class="space-y-2 text-sm">
        <div class="flex justify-between">
          <span class="text-gray-600">Email:</span>
          <span id="modal-user-email" class="font-medium"></span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-600">Téléphone:</span>
          <span id="modal-user-phone" class="font-medium"></span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-600">Inscrit le:</span>
          <span id="modal-user-created-at" class="font-medium"></span>
        </div>
        <div class="flex justify-between">
          <span class="text-gray-600">Statut:</span>
          <span id="modal-user-status-badge" class="badge"></span>
        </div>
      </div>
    </div>

    <div
      class="p-5 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700/50 rounded-b-lg"
    >
      <h4 class="font-semibold text-gray-900 dark:text-white text-lg mb-3">
        Actions Administratives
      </h4>
      <div class="flex items-center justify-between">
        <label class="flex items-center cursor-pointer">
          <span class="text-gray-700 dark:text-gray-300 mr-3"
            >Compte Actif</span
          >
          <div class="relative">
            <input
              type="checkbox"
              id="modal-user-active-toggle"
              class="sr-only peer"
            />
            <div
              class="block bg-gray-200 dark:bg-gray-600 w-14 h-8 rounded-full peer-checked:bg-admin-primary"
            ></div>
            <div
              class="dot absolute left-1 top-1 bg-white dark:bg-gray-200 w-6 h-6 rounded-full transition-transform peer-checked:translate-x-full"
            ></div>
          </div>
        </label>
        <button
          id="modal-save-changes"
          class="px-4 py-2 bg-admin-primary hover:bg-admin-dark text-white rounded-md text-sm shadow-sm"
        >
          Sauvegarder
        </button>
      </div>
    </div>
  </div>
</div>
