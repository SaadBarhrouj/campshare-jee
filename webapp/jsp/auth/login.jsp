<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Connexion - CampShare</title>
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
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
      rel="stylesheet"
    />
    <style>
      button:focus {
        outline: none !important;
        box-shadow: 0 0 0 2px rgba(45, 95, 43, 0.5);
      }

      input::placeholder {
        padding-left: 0;
      }

      .footer-link {
        display: inline-flex;
        align-items: center;
        padding: 0.5rem 1rem;
        border-radius: 0.375rem;
        transition: all 0.2s ease;
        font-weight: 500;
      }

      .footer-link:hover {
        background-color: rgba(45, 95, 43, 0.1);
      }

      .dark .footer-link:hover {
        background-color: rgba(79, 121, 66, 0.2);
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .fade-in {
        animation: fadeIn 0.5s ease-out forwards;
      }

      button:active {
        transform: scale(0.98);
      }
    </style>
  </head>
  <body
    class="font-sans antialiased text-gray-800 dark:text-gray-200 bg-gray-100 dark:bg-gray-900 min-h-screen flex flex-col justify-center py-12 px-4 sm:px-6 lg:px-8"
  >
    <div
      class="max-w-md mx-auto bg-white dark:bg-gray-800 rounded-lg shadow-md p-8 transition-all duration-300 fade-in"
    >
      <!-- Logo -->
      <div class="flex justify-center mb-6">
        <div class="flex items-center">
          <span class="text-forest dark:text-meadow text-3xl font-extrabold"
            >Camp<span class="text-sunlight">Share</span>
        </div>
      </div>

      <!-- Title -->
      <h2
        class="text-center text-2xl font-bold mb-8 text-gray-800 dark:text-white"
      >
        Connexion à votre compte
      </h2>

      <!-- Login Form -->
      <form id="login-form" class="space-y-6" action="login" method="post">
        <!-- Email Field -->
        <div>
          <label
            for="email"
            class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
            >Adresse email</label
          >
          <div class="relative">
            <div
              class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none"
            >
              <i class="fas fa-envelope text-gray-400"></i>
            </div>
            <input
              type="email"
              id="email"
              name="email"
              required
              class="pl-10 block w-full rounded-md border-gray-300 dark:border-gray-600 shadow-sm focus:border-forest focus:ring-forest dark:bg-gray-700 dark:text-white text-base py-3 px-4"
              placeholder="votre@email.com"
            />
          </div>
        </div>

        <!-- Password Field -->
        <div>
          <div class="flex items-center justify-between">
            <label
              for="password"
              class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
              >Mot de passe</label
            >
            <a
              href="#"
              class="text-sm font-medium text-forest dark:text-meadow hover:text-opacity-80 dark:hover:text-opacity-80 transition duration-150"
            >
              Mot de passe oublié ?
            </a>
          </div>
          <div class="relative">
            <div
              class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none"
            >
              <i class="fas fa-lock text-gray-400"></i>
            </div>
            <input
              type="password"
              id="password"
              name="password"
              required
              class="pl-10 block w-full rounded-md border-gray-300 dark:border-gray-600 shadow-sm focus:border-forest focus:ring-forest dark:bg-gray-700 dark:text-white text-base py-3 px-4"
              placeholder="Votre mot de passe"
            />
            <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
              <button
                type="button"
                id="toggle-password"
                class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 focus:outline-none"
              >
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>
        </div>

        <!-- Login Button -->
        <div>
          <button
            type="submit"
            id="login-btn"
            class="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-sunlight hover:bg-amber-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sunlight transition duration-150"
          >
            <i class="fas fa-sign-in-alt mr-2"></i>
            Se connecter
          </button>
        </div>
      </form>

      <!-- Sign Up and Home Links -->
      <div
        class="mt-8 flex flex-col sm:flex-row justify-center items-center space-y-3 sm:space-y-0 sm:space-x-4"
      >
        <a
          href="${pageContext.request.contextPath}/register"
          class="footer-link text-forest dark:text-meadow hover:text-opacity-90 dark:hover:text-opacity-90"
        >
          <i class="fas fa-user-plus mr-2"></i>
          Créer un compte
        </a>
        <a
          href="${pageContext.request.contextPath}/"
          class="footer-link text-gray-600 dark:text-gray-400 hover:text-forest dark:hover:text-meadow"
        >
          <i class="fas fa-home mr-2"></i>
          Retour à l'accueil
        </a>
      </div>
    </div>

    <!-- Script for password visibility toggle and form handling -->
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Password visibility toggle
        const togglePassword = document.getElementById("toggle-password");
        const passwordInput = document.getElementById("password");

        togglePassword.addEventListener("click", function () {
          const type =
            passwordInput.getAttribute("type") === "password"
              ? "text"
              : "password";
          passwordInput.setAttribute("type", type);

          // Toggle eye icon
          const icon = this.querySelector("i");
          if (type === "text") {
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
          } else {
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
          }
        });
      });
    </script>
  </body>
</html>
