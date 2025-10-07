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

  const openSidebar = () => {
    if (mobileSidebar && mobileSidebarOverlay) {
      mobileSidebar.classList.remove("-translate-x-full");
      mobileSidebarOverlay.classList.remove("hidden");
    }
  };

  const closeSidebar = () => {
    if (mobileSidebar && mobileSidebarOverlay) {
      mobileSidebar.classList.add("-translate-x-full");
      mobileSidebarOverlay.classList.add("hidden");
    }
  };

  if (mobileSidebarToggle)
    mobileSidebarToggle.addEventListener("click", openSidebar);
  if (closeMobileSidebar)
    closeMobileSidebar.addEventListener("click", closeSidebar);
  if (mobileSidebarOverlay)
    mobileSidebarOverlay.addEventListener("click", closeSidebar);

  const tabs = document.querySelectorAll(".admin-tab");
  const tabContents = document.querySelectorAll(".tab-content");

  tabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      const target = tab.getAttribute("data-tab");

      tabs.forEach((t) => t.classList.remove("active"));
      tab.classList.add("active");

      tabContents.forEach((content) => {
        if (content.id === target + "-content") {
          content.classList.remove("hidden");
        } else {
          content.classList.add("hidden");
        }
      });
    });
  });
});
