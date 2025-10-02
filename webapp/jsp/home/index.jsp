<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bienvenue</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col items-center justify-center">

    <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-800 mb-8">
            Bienvenue sur CampShare
        </h1>

        <div class="space-x-4">
            
            <a href="${pageContext.request.contextPath}/login"
               class="inline-block bg-blue-500 text-white font-bold py-3 px-6 rounded-lg hover:bg-blue-600 transition duration-300">
                Se connecter
            </a>
            
            <a href="${pageContext.request.contextPath}/register"
               class="inline-block bg-green-500 text-white font-bold py-3 px-6 rounded-lg hover:bg-green-600 transition duration-300">
                S'inscrire
            </a>

        </div>
    </div>

</body>
</html>