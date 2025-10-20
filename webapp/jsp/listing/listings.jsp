<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Toutes les annonces - CampShare</title>

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
    </script>
  </head>
  <body class="bg-gray-100">
    <jsp:include page="/jsp/common/header.jsp" />

    <main class="container mx-auto px-4 py-24">
      <h1 class="text-3xl font-bold text-gray-800 mb-8">
        Explorer le Matériel
      </h1>
    </main>
    <jsp:include page="/jsp/common/footer.jsp" />
  </body>
</html>
