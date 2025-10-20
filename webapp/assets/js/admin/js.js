const userButtons = document.querySelectorAll("button .fas.fa-eye"); // Select eye icons within buttons
const userDetailModal = document.getElementById("user-detail-modal");
const closeUserModal = document.getElementById("close-user-modal");
const cancelUserDetails = document.getElementById("cancel-user-details");

userButtons.forEach((button) => {
  button.parentElement.addEventListener("click", (e) => {
    e.preventDefault();
    userDetailModal.classList.remove("hidden");
    document.body.classList.add("overflow-hidden");
  });
});

closeUserModal?.addEventListener("click", () => {
  userDetailModal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

cancelUserDetails?.addEventListener("click", () => {
  userDetailModal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

userDetailModal?.addEventListener("click", (e) => {
  if (e.target === userDetailModal) {
    userDetailModal.classList.add("hidden");
    document.body.classList.remove("overflow-hidden");
  }
});

const mobileMenuButton = document.getElementById("mobile-menu-button");
const mobileMenu = document.getElementById("mobile-menu");

mobileMenuButton?.addEventListener("click", () => {
  mobileMenu.classList.toggle("hidden");
});

const userMenuButton = document.getElementById("user-menu-button");
const userDropdown = document.getElementById("user-dropdown");

userMenuButton?.addEventListener("click", () => {
  userDropdown.classList.toggle("hidden");
});

document.addEventListener("click", (e) => {
  if (
    userMenuButton &&
    !userMenuButton.contains(e.target) &&
    userDropdown &&
    !userDropdown.contains(e.target)
  ) {
    userDropdown.classList.add("hidden");
  }

  if (
    statusFilterButton &&
    !statusFilterButton.contains(e.target) &&
    !statusFilterDropdown.contains(e.target)
  ) {
    statusFilterDropdown.classList.add("hidden");
  }

  if (
    sortFilterButton &&
    !sortFilterButton.contains(e.target) &&
    !sortFilterDropdown.contains(e.target)
  ) {
    sortFilterDropdown.classList.add("hidden");
  }

  if (
    cityFilterButton &&
    !cityFilterButton.contains(e.target) &&
    !cityFilterDropdown.contains(e.target)
  ) {
    cityFilterDropdown.classList.add("hidden");
  }
});

const mobileSidebarToggle = document.getElementById("mobile-sidebar-toggle");
const mobileSidebar = document.getElementById("mobile-sidebar");
const closeMobileSidebar = document.getElementById("close-mobile-sidebar");
const mobileSidebarOverlay = document.getElementById("mobile-sidebar-overlay");

mobileSidebarToggle?.addEventListener("click", () => {
  mobileSidebar.classList.toggle("-translate-x-full");
  mobileSidebarOverlay.classList.toggle("hidden");
  document.body.classList.toggle("overflow-hidden");
});

closeMobileSidebar?.addEventListener("click", () => {
  mobileSidebar.classList.add("-translate-x-full");
  mobileSidebarOverlay.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});
document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.querySelector('input[name="search"]');
  const searchForm = document.querySelector("form");

  let searchTimeout;
  searchInput.addEventListener("input", function () {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
      searchForm.submit();
    }, 500);
  });

  const resetBtn = document.querySelector("");
  resetBtn.addEventListener("click", function (e) {
    e.preventDefault();
    searchInput.value = "";
    searchForm.submit();
  });

  if (searchInput) {
    new Awesomplete(searchInput, {
      minChars: 2,
      autoFirst: true,
      list: [],
      filter: function (text, input) {
        return Awesomplete.FILTER_CONTAINS(text, input.match(/[^,]*$/)[0]);
      },
      replace: function (text) {
        this.input.value = text;
      },
    });

    searchInput.addEventListener("input", function () {
      if (this.value.length < 2) return;

      fetch(`/api/partners/suggest?q=$1`)
        .then((response) => response.json())
        .then((data) => {
          const awesomplete = Awesomplete.$[this];
          awesomplete.list = data;
          awesomplete.evaluate();
        });
    });
  }
});
mobileSidebarOverlay?.addEventListener("click", () => {
  mobileSidebar.classList.add("-translate-x-full");
  mobileSidebarOverlay.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

document.querySelectorAll(".sidebar-link").forEach((link) => {
  link.addEventListener("click", function (e) {
    sidebarLinks.forEach((el) => el.classList.remove("active"));
    this.classList.add("active");

    if (this.getAttribute("href").startsWith("#")) {
      e.preventDefault();
    }
  });
});
const sidebarLinks = document.querySelectorAll(".sidebar-link");

sidebarLinks.forEach((link) => {
  link.addEventListener("click", () => {
    sidebarLinks.forEach((el) => el.classList.remove("active"));

    link.classList.add("active");
  });
});

const statusFilterButton = document.getElementById("status-filter-button");
const statusFilterDropdown = document.getElementById("status-filter-dropdown");
const sortFilterButton = document.getElementById("sort-filter-button");
const sortFilterDropdown = document.getElementById("sort-filter-dropdown");
const cityFilterButton = document.getElementById("city-filter-button");
const cityFilterDropdown = document.getElementById("city-filter-dropdown");

statusFilterButton?.addEventListener("click", () => {
  statusFilterDropdown.classList.toggle("hidden");
  sortFilterDropdown.classList.add("hidden");
  cityFilterDropdown.classList.add("hidden");
});

const statusOptions = statusFilterDropdown?.querySelectorAll(".option");
statusOptions?.forEach((option) => {
  option.addEventListener("click", () => {
    statusOptions.forEach((opt) => opt.classList.remove("active"));
    option.classList.add("active");
    statusFilterButton.querySelector(
      "span"
    ).textContent = `Statut: ${option.textContent}`;
    statusFilterDropdown.classList.add("hidden");
  });
});

sortFilterButton?.addEventListener("click", () => {
  sortFilterDropdown.classList.toggle("hidden");
  statusFilterDropdown.classList.add("hidden");
  cityFilterDropdown.classList.add("hidden");
});

const sortOptions = sortFilterDropdown?.querySelectorAll(".option");
sortOptions?.forEach((option) => {
  option.addEventListener("click", () => {
    sortOptions.forEach((opt) => opt.classList.remove("active"));
    option.classList.add("active");
    sortFilterButton.querySelector(
      "span"
    ).textContent = `Trier par ${option.textContent}`;
    sortFilterDropdown.classList.add("hidden");
  });
});
document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.querySelector('input[name="search"]');
  const searchForm = document.querySelector("form");

  let searchTimeout;

  searchInput?.addEventListener("input", function () {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
      searchForm.submit();
    }, 500);
  });
});
cityFilterButton?.addEventListener("click", () => {
  cityFilterDropdown.classList.toggle("hidden");
  statusFilterDropdown.classList.add("hidden");
  sortFilterDropdown.classList.add("hidden");
});

const cityOptions = cityFilterDropdown?.querySelectorAll(".option");
cityOptions?.forEach((option) => {
  option.addEventListener("click", () => {
    cityOptions.forEach((opt) => opt.classList.remove("active"));
    option.classList.add("active");
    cityFilterButton.querySelector(
      "span"
    ).textContent = `Ville: ${option.textContent}`;
    cityFilterDropdown.classList.add("hidden");
  });
});

const advancedFiltersToggle = document.getElementById(
  "advanced-filters-toggle"
);
const advancedFilters = document.getElementById("advanced-filters");
const filterActions = document.getElementById("filter-actions");
const chevronIcon = advancedFiltersToggle?.querySelector(".fa-chevron-down");

advancedFiltersToggle?.addEventListener("click", () => {
  advancedFilters.classList.toggle("hidden");
  filterActions.classList.toggle("hidden");
  chevronIcon.classList.toggle("rotate-180");
});

const partnerViewButtons = document.querySelectorAll("button .fas.fa-eye");
const partnerDetailModal = document.getElementById("partner-detail-modal");
const closePartnerModal = document.getElementById("close-partner-modal");
const cancelPartnerDetails = document.getElementById("cancel-partner-details");

partnerViewButtons.forEach((button) => {
  button.parentElement.addEventListener("click", (e) => {
    e.preventDefault();
    partnerDetailModal.classList.remove("hidden");
    document.body.classList.add("overflow-hidden");
  });
});

closePartnerModal?.addEventListener("click", () => {
  partnerDetailModal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

cancelPartnerDetails?.addEventListener("click", () => {
  partnerDetailModal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

partnerDetailModal?.addEventListener("click", (e) => {
  if (e.target === partnerDetailModal) {
    partnerDetailModal.classList.add("hidden");
    document.body.classList.remove("overflow-hidden");
  }
});

const adminTabs = document.querySelectorAll(".admin-tab");

adminTabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    adminTabs.forEach((el) => el.classList.remove("active"));

    tab.classList.add("active");
  });
});
async function showUserDetails(userId) {
  try {
    openModal();

    const response = await fetch(`/admin/users/1/details`);
    if (!response.ok) throw new Error("Erreur réseau");
    const data = await response.json();

    if (data.error) return alert(data.error);

    const user = data.user;
    fillUserInfo(user);
    handlePartnerSections(user, data);
    console.log(data);
    fillReservations(data.reservations);
  } catch (error) {
    console.error("Erreur lors du chargement des détails:", error);
    alert("Erreur lors du chargement des détails");
  }
}

function openModal() {
  const modal = document.getElementById("user-detail-modal");
  modal.classList.remove("hidden");
  document.body.classList.add("overflow-hidden");
}

function closeModal() {
  document.getElementById("user-detail-modal").classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
}

function fillUserInfo(user) {
  const fullName = `saad`;
  document.getElementById("user-avatar").src = user.avatar_url
    ? `/${user.avatar_url}`
    : ``;

  document.getElementById("user-fullname").textContent = fullName;
  document.getElementById("user-fullname-text").textContent = fullName;
  document.getElementById("user-email").textContent = user.email;
  document.getElementById("user-phone").textContent = user.phone_number;
  document.getElementById("user-address").textContent = user.address;
  document.getElementById("user-city").textContent =
    user.city_name || "Non spécifié";
  document.getElementById("user-created-at").textContent = new Date(
    user.created_at
  ).toLocaleDateString();
  document.getElementById("user-active-toggle").checked = user.is_active;
  document.getElementById("user-id").textContent = user.id;

  const isPartner = user.role === "partner";
  document.getElementById("user-role").textContent = isPartner
    ? "Partenaire"
    : "Client";

  const roleBadge = document.getElementById("user-role-badge");
  if (isPartner) {
    roleBadge.className = "badge badge-success mr-2";
    roleBadge.textContent = "Partenaire";
  } else {
    roleBadge.className = "badge badge-info mr-2";
    roleBadge.textContent = "Client";
  }

  const statusBadge = document.getElementById("user-status-badge");
  statusBadge.className = user.is_active
    ? "badge badge-success"
    : "badge badge-danger";
  statusBadge.textContent = user.is_active ? "Activé" : "Désactivé";

  togglePartnerSections(isPartner);
}

function togglePartnerSections(isPartner) {
  [
    "partner-info-container",
    "partner-stats-container",
    "partner-equipment-section",
  ].forEach((id) => {
    document.getElementById(id).classList.toggle("hidden", !isPartner);
  });
  document
    .getElementById("toggle-partner-btn")
    .classList.toggle("hidden", isPartner);
}

function handlePartnerSections(user, data) {
  if (user.role !== "partner") return;

  document.getElementById("user-equipments-count").textContent =
    data.equipments_count || 0;

  const tbody = document.querySelector("#partner-equipments tbody");
  tbody.innerHTML = "";
  if (data.items && data.items.length > 0) {
    data.items.forEach((eq) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                <td></td>
                <td></td>
                <td> MAD</td>
                <td>
                    <button onclick="window.location.href=''" 
                            class="p-1 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-300 hover:bg-blue-200 dark:hover:bg-blue-800 transition shadow-md hover:scale-105">
                        <i class="fas fa-eye"></i>
                    </button>
                </td>
            `;
      tbody.appendChild(row);
    });
  } else {
    tbody.innerHTML =
      '<tr><td colspan="5" class="text-center py-4">Aucun équipement</td></tr>';
  }

  document.getElementById(
    "view-all-equipments"
  ).href = `/admin/partners/1/equipments`;
}

function fillReservations(reservations) {
  console.log(reservations);
  const tbody = document.querySelector("#user-reservations tbody");
  tbody.innerHTML = "";

  if (reservations && reservations.length > 0) {
    document.getElementById("user-reservations-count").textContent =
      reservations.length;

    reservations.forEach((res) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                <td></td>
                <td></td>
                <td> </td>
                <td></td>
                <td>${res.delivery_option == 0 ? "Non" : "Oui"}</td>
                <td><span class="badge ${getStatusBadgeClass(
                  res.status
                )}">${getStatusText(res.status)}</span></td>
            `;
      tbody.appendChild(row);
    });
  } else {
    document.getElementById("user-reservations-count").textContent = "0";
    tbody.innerHTML =
      '<tr><td colspan="6" class="text-center py-4">Aucune réservation</td></tr>';
  }
}

// Bascule du statut partenaire/client
document
  .getElementById("toggle-partner-btn")
  .addEventListener("click", async () => {
    const userId = document.getElementById("user-id").textContent;

    if (
      !confirm(
        "Voulez-vous vraiment retirer le statut de partenaire à cet utilisateur ?"
      )
    )
      return;

    try {
      const response = await fetch(`/admin/users/${userId}/toggle-partner`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')
            .content,
          Accept: "application/json",
        },
      });

      const data = await response.json();
      if (!response.ok)
        throw new Error(data.message || "Erreur lors de la modification");

      alert(data.message || "Statut modifié avec succès");
      showUserDetails(userId);
    } catch (error) {
      console.error("Erreur toggle-partner:", error);
      alert(error.message || "Erreur lors de la modification");
    }
  });

// Activation/désactivation utilisateur
document
  .getElementById("save-user-details")
  .addEventListener("click", async () => {
    const userId = document.getElementById("user-id").textContent;
    const newIsActive = document.getElementById("user-active-toggle").checked
      ? 1
      : 0;

    if (!userId) return alert("ID utilisateur manquant");

    if (
      !confirm(
        `Voulez-vous vraiment ${
          newIsActive ? "activer" : "désactiver"
        } cet utilisateur ?`
      )
    )
      return;

    try {
      const response = await fetch(`/admin/users/${userId}/toggle-activation`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')
            .content,
          Accept: "application/json",
        },
        body: JSON.stringify({ is_active: newIsActive }),
      });

      const data = await response.json();
      if (!response.ok)
        throw new Error(data.message || `Erreur HTTP ${response.status}`);

      // Mettre à jour l'interface utilisateur
      document.getElementById("user-status-badge").className = data.is_active
        ? "badge badge-success"
        : "badge badge-danger";
      document.getElementById("user-active-toggle").checked = data.is_active;

      setTimeout(closeModal, 1000);
    } catch (error) {
      console.error("Erreur:", error);
      alert(`Échec de l'opération: ${error.message}`);
    }
  });

function getStatusBadgeClass(status) {
  return (
    {
      confirmed: "badge-success",
      pending: "badge-warning",
      cancelled: "badge-danger",
      completed: "badge-info",
    }[status] || "badge-neutral"
  );
}

function getStatusText(status) {
  return (
    {
      confirmed: "Confirmée",
      pending: "En attente",
      cancelled: "Annulée",
      completed: "Terminée",
    }[status] || status
  );
}

document
  .getElementById("equipment-tab")
  .addEventListener("click", async function () {
    // Activer l'onglet
    document.querySelectorAll(".admin-tab").forEach((tab) => {
      tab.classList.remove("active");
    });
    this.classList.add("active");

    // Masquer les autres sections
    document.getElementById("recent-users-section").classList.add("hidden");
    document
      .getElementById("recent-equipments-section")
      .classList.remove("hidden");

    // Charger les équipements
    try {
      const response = await fetch("/admin/recent-equipments");
      if (!response.ok) throw new Error("Erreur réseau");
      const equipments = await response.json();

      const tbody = document.getElementById("equipments-table-body");
      tbody.innerHTML = "";

      if (equipments.length === 0) {
        tbody.innerHTML =
          '<tr><td colspan="5" class="text-center py-4">Aucun équipement récent</td></tr>';
        return;
      }

      equipments.forEach((equipment) => {
        const row = document.createElement("tr");
        row.className =
          "border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/50";
        row.innerHTML = `
            <td class="py-4 pl-6 font-medium text-gray-900 dark:text-white">${equipment.title}</td>
            <td class="py-4"></td>
            <td class="py-4"> MAD</td>
            <td class="py-4"></td>
            <td class="py-4 pr-6"></td>
        `;
        tbody.appendChild(row);
      });
    } catch (error) {
      console.error("Erreur:", error);
      document.getElementById("equipments-table-body").innerHTML =
        '<tr><td colspan="5" class="text-center py-4 text-red-500">Erreur de chargement</td></tr>';
    }
  });

document
  .getElementById("reservations-tab")
  .addEventListener("click", async function () {
    // Activer l'onglet
    document.querySelectorAll(".admin-tab").forEach((tab) => {
      tab.classList.remove("active");
    });
    this.classList.add("active");

    // Masquer les autres sections
    document.getElementById("recent-users-section").classList.add("hidden");
    document
      .getElementById("recent-equipments-section")
      .classList.add("hidden");
    document
      .getElementById("recent-reservations-section")
      .classList.remove("hidden");

    // Charger les réservations
    try {
      const response = await fetch("/admin/recent-reservations", {
        headers: {
          "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')
            .content,
          Accept: "application/json",
        },
      });

      if (!response.ok) throw new Error("Erreur réseau");
      const reservations = await response.json();

      const tbody = document.getElementById("reservations-table-body");
      tbody.innerHTML = "";

      if (reservations.length === 0) {
        tbody.innerHTML =
          '<tr><td colspan="6" class="text-center py-4">Aucune réservation récente</td></tr>';
        return;
      }

      reservations.forEach((reservation) => {
        const row = document.createElement("tr");
        row.className =
          "border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/50";
        row.innerHTML = `
                <td class="py-4 pl-6"></td>
                <td class="py-4"></td>
                <td class="py-4"></td>
                <td class="py-4"> </td>
                <td class="py-4 pr-6"><span class="badge test-status</span></td>
            `;
        tbody.appendChild(row);
      });
    } catch (error) {
      console.error("Erreur:", error);
      document.getElementById("reservations-table-body").innerHTML =
        '<tr><td colspan="5" class="text-center py-4 text-red-500">Erreur de chargement</td></tr>';
    }
  });

const cinImages = document.querySelectorAll(
  'img[alt="CIN Recto"], img[alt="CIN Verso"]'
);
const imageModal = document.getElementById("image-modal");
const modalImageContent = document.getElementById("modal-image-content");
const closeImageModal = document.getElementById("close-image-modal");

cinImages.forEach((img) => {
  img.addEventListener("click", () => {
    modalImageContent.src = img.src;
    modalImageContent.alt = img.alt;
    imageModal.classList.remove("hidden");
    document.body.classList.add("overflow-hidden");
  });
});

closeImageModal.addEventListener("click", () => {
  imageModal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
});

imageModal.addEventListener("click", (e) => {
  if (e.target === imageModal) {
    imageModal.classList.add("hidden");
    document.body.classList.remove("overflow-hidden");
  }
});
