<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampShare - Mes Réservations</title>

    <!-- Styles / Scripts -->

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    

    <link rel="icon" href="{{ asset('images/favicon_io/favicon.ico') }}" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="180x180" href="{{ asset('images/favicon_io/apple-touch-icon.png') }}">
    <link rel="icon" type="image/png" sizes="32x32" href="{{ asset('images/favicon_io/favicon-32x32.png') }}">
    <link rel="icon" type="image/png" sizes="16x16" href="{{ asset('images/favicon_io/favicon-16x16.png') }}">
    <link rel="manifest" href="{{ asset('images/favicon_io/site.webmanifest') }}">
    <link rel="mask-icon" href="{{ asset('images/favicon_io/safari-pinned-tab.svg') }}" color="#5bbad5">
    <meta name="msapplication-TileColor" content="#da532c">
    <meta name="theme-color" content="#ffffff">
    <meta name="description" content="CampShare - Louez facilement le matériel de camping dont vous avez besoin
    directement entre particuliers.">
    <meta name="keywords" content="camping, location, matériel, aventure, plein air, partage, communauté">

    <script src="https://cdn.tailwindcss.com"></script>
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
    

</head>
<body class="font-sans antialiased text-gray-800 dark:text-gray-200 dark:bg-gray-900 min-h-screen flex flex-col">
<jsp:include page="components/sidebar.jsp" />
<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
    <div class="py-8 px-4 md:px-8">
        <!-- Dashboard header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Mes reservations</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Voici un résumé de vos réservations, leurs status, dates...</p>
            </div>
            
        </div>

        <div class="mt-4 mb-8 md:mt-0 flex space-x-3 justify-end items-center">
            <!-- Status Filter Dropdown -->
            <label class="block text-gray-700 dark:text-gray-300">Statut de réservation</label>
            <select id="statusFilter" class="flex items-center px-4 py-2 bg-white dark:bg-gray-700 rounded-md border border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-600 transition-all w-46">
                <option value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'selected' : ''}>Tous les statuts</option>
                <option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>En attente</option>
                <option value="confirmed" ${selectedStatus == 'confirmed' ? 'selected' : ''}>Confirmé</option>
                <option value="ongoing" ${selectedStatus == 'ongoing' ? 'selected' : ''}>En cours</option>
                <option value="completed" ${selectedStatus == 'completed' ? 'selected' : ''}>Terminée</option>
                <option value="canceled" ${selectedStatus == 'canceled' ? 'selected' : ''}>Annulé</option>
            </select>
        </div>

        
        <!-- Reservations Grid -->
        <div id="reservations-container">
            <jsp:include page="components/reservations-grid.jsp" />
        </div>
<script>
    function cancelReservation(reservationId) {
    if (confirm('Êtes-vous sûr de vouloir annuler cette réservation ?')) {
        fetch(`/client/reservations/cancel/${reservationId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                //alert(data.message);
                // Recharger les réservations
                document.getElementById('statusFilter').dispatchEvent(new Event('change'));
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Une erreur est survenue');
        });
    }
}
</script>
        </div>
    </div>
</main>

<!-- AJAX Script for Status Filter -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const statusFilter = document.getElementById('statusFilter');
    const container = document.getElementById('reservations-container');

    function ensureNoResultsElement() {
        let el = container.querySelector('#no-results');
        if (!el) {
            el = document.createElement('div');
            el.id = 'no-results';
            el.className = 'rounded-lg shadow-sm overflow-hidden col-span-2 text-center py-8 text-gray-600 dark:text-gray-400';
            el.textContent = 'Aucune réservation trouvée pour ce statut.';
            const grid = container.querySelector('#reservations-grid');
            if (grid) grid.appendChild(el);
        }
        return el;
    }

    function filterReservations(selected) {
        const grid = container.querySelector('#reservations-grid');
        if (!grid) return;
        const cards = grid.querySelectorAll('.reservation-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const status = (card.getAttribute('data-status') || '').toLowerCase();
            const show = selected === 'all' || selected === '' || status === selected;
            card.style.display = show ? '' : 'none';
            if (show) visibleCount++;
        });

        const noResults = ensureNoResultsElement();
        noResults.style.display = visibleCount === 0 ? '' : 'none';
    }

    if (statusFilter) {
        // Initial state
        filterReservations(statusFilter.value || 'all');

        statusFilter.addEventListener('change', function() {
            filterReservations(this.value);
        });
    }
});
</script>

</body>
</html>