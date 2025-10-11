<%@ page language="java" contentType="text-html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestion des Réservations - CampShare Admin</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/admin/admin_base.css"
    />
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body
    class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col"
  >
    <div class="flex flex-col md:flex-row pt-16">
      <jsp:include page="includes/admin_sidebar.jsp">
        <jsp:param name="activePage" value="reservations" />
      </jsp:include>

      <main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900">
        <div class="py-8 px-4 md:px-8">
          <h1 class="text-3xl font-bold">Hello from Réservations</h1>
          <p>Cette page est en cours de construction.</p>
        </div>
      </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
  </body>
</html>
