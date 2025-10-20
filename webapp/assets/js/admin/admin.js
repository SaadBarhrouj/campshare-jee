async function showUserDetails(userId) {
  try {
    openModal();

    const response = await fetch(`/webapp/api/admin/user-details?id=${userId}`);

    if (!response.ok) {
      throw new Error(`Erreur réseau: ${response.statusText}`);
    }
    const data = await response.json();

    if (data.error) {
      alert(data.error);
      closeModal();
      return;
    }

    fillModalWithData(data);
  } catch (error) {
    console.error(
      "Erreur lors du chargement des détails de l'utilisateur:",
      error
    );
    alert("Impossible de charger les détails de l'utilisateur.");
    closeModal();
  }
}

function openModal() {
  const modal = document.getElementById("user-detail-modal");
  if (modal) modal.classList.remove("hidden");
  document.body.classList.add("overflow-hidden");
}

function closeModal() {
  const modal = document.getElementById("user-detail-modal");
  if (modal) modal.classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
}

function fillModalWithData(data) {
  const user = data.user;
  const fullName = `${user.firstName || ""} ${user.lastName || ""}`;

  document.getElementById("modal-user-avatar").src = user.avatarUrl
    ? `/webapp${user.avatarUrl}`
    : "https://i.pravatar.cc/150";
  document.getElementById("modal-user-fullname").textContent = fullName;
  document.getElementById("modal-user-email").textContent = user.email || "N/A";
  document.getElementById("modal-user-phone").textContent =
    user.phoneNumber || "N/A";

  const createdAt = new Date(user.createdAt).toLocaleDateString("fr-FR", {
    day: "2-digit",
    month: "long",
    year: "numeric",
  });
  document.getElementById("modal-user-created-at").textContent = createdAt;

  const roleBadge = document.getElementById("modal-user-role-badge");
  if (user.role === "partner") {
    roleBadge.className = "badge badge-success";
    roleBadge.textContent = "Partenaire";
  } else {
    roleBadge.className = "badge badge-info";
    roleBadge.textContent = "Client";
  }

  const statusBadge = document.getElementById("modal-user-status-badge");
  if (user.isActive) {
    statusBadge.className = "badge badge-success";
    statusBadge.textContent = "Actif";
  } else {
    statusBadge.className = "badge badge-danger";
    statusBadge.textContent = "Inactif";
  }

  document.getElementById("modal-user-id-hidden").textContent = user.id;
  document.getElementById("modal-user-active-toggle").checked = user.isActive;
}

document.addEventListener("DOMContentLoaded", function () {
  const userMenuButton = document.getElementById("user-menu-button");
  const userDropdown = document.getElementById("user-dropdown");

  if (userMenuButton && userDropdown) {
    userMenuButton.addEventListener("click", function () {
      userDropdown.classList.toggle("hidden");
    });

    document.addEventListener("click", function (event) {
      if (
        !userMenuButton.contains(event.target) &&
        !userDropdown.contains(event.target)
      ) {
        userDropdown.classList.add("hidden");
      }
    });
  }

  const mobileMenuButton = document.getElementById("mobile-menu-button");
  const mobileMenu = document.getElementById("mobile-menu");

  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener("click", function () {
      mobileMenu.classList.toggle("hidden");
    });
  }

  const mobileSidebarToggle = document.getElementById("mobile-sidebar-toggle");
  const mobileSidebar = document.getElementById("mobile-sidebar");
  const closeMobileSidebar = document.getElementById("close-mobile-sidebar");
  const mobileSidebarOverlay = document.getElementById(
    "mobile-sidebar-overlay"
  );

  const openMobileSidebar = () => {
    if (mobileSidebar && mobileSidebarOverlay) {
      mobileSidebar.classList.remove("-translate-x-full");
      mobileSidebarOverlay.classList.remove("hidden");
    }
  };

  const closeMobileSidebarFunc = () => {
    if (mobileSidebar && mobileSidebarOverlay) {
      mobileSidebar.classList.add("-translate-x-full");
      mobileSidebarOverlay.classList.add("hidden");
    }
  };

  if (mobileSidebarToggle)
    mobileSidebarToggle.addEventListener("click", openMobileSidebar);
  if (closeMobileSidebar)
    closeMobileSidebar.addEventListener("click", closeMobileSidebarFunc);
  if (mobileSidebarOverlay)
    mobileSidebarOverlay.addEventListener("click", closeMobileSidebarFunc);

  const tabs = document.querySelectorAll(".admin-tab");
  const tabContents = document.querySelectorAll(".tab-content");

  tabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      const target = tab.getAttribute("data-tab");

      tabs.forEach((t) => t.classList.remove("active"));
      tab.classList.add("active");

      tabContents.forEach((content) => {
        content.id === target + "-content"
          ? content.classList.remove("hidden")
          : content.classList.add("hidden");
      });
    });
  });

  const userDetailModal = document.getElementById("user-detail-modal");
  const closeUserModalButton = document.getElementById("close-user-modal");

  if (closeUserModalButton) {
    closeUserModalButton.addEventListener("click", closeModal);
  }

  if (userDetailModal) {
    userDetailModal.addEventListener("click", (event) => {
      if (event.target === userDetailModal) {
        closeModal();
      }
    });
  }

   const saveButton = document.getElementById("modal-save-changes");

   if (saveButton) {
     saveButton.addEventListener("click", async () => {
       const userId = document.getElementById(
         "modal-user-id-hidden"
       ).textContent;

       const newIsActiveStatus = document.getElementById(
         "modal-user-active-toggle"
       ).checked;

       if (!userId) {
         alert("Erreur : ID de l'utilisateur non trouvé.");
         return;
       }

       try {
         const response = await fetch(
           `/webapp/api/admin/toggle-user-status?id=${userId}`,
           {
             method: "POST",
             headers: {
               "Content-Type": "application/json",
             },
             body: JSON.stringify({ isActive: newIsActiveStatus }),
           }
         );

         if (!response.ok) {
           throw new Error("La mise à jour du statut a échoué.");
         }

         alert("Le statut du partenaire a été mis à jour avec succès !");
         closeModal();
         location.reload(); 
       } catch (error) {
         console.error("Erreur lors de la mise à jour du statut:", error);
         alert(error.message);
       }
     });
   }
});
