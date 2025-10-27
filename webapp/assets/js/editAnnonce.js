    document.addEventListener('DOMContentLoaded', function() {
        // Gestion des options premium
        const isPremiumCheckbox = document.getElementById('is_premium');
        const premiumOptionsContainer = document.getElementById('premium-options');
        const premiumOptionCards = document.querySelectorAll('.premium-option-card');
        const premiumTypeInput = document.getElementById('premium_type');
        
        // Afficher/masquer les options premium
        if (isPremiumCheckbox) {
            isPremiumCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    premiumOptionsContainer.style.display = 'block';
                } else {
                    premiumOptionsContainer.style.display = 'none';
                    premiumTypeInput.value = '';
                }
            });
        }
        
        // Sélection d'une option premium
        premiumOptionCards.forEach(card => {
            card.addEventListener('click', function() {
                // Désélectionner toutes les options
                premiumOptionCards.forEach(c => {
                    c.classList.remove('border-forest', 'dark:border-meadow', 'bg-green-50', 'dark:bg-green-900/10');
                    c.classList.add('border-gray-200', 'dark:border-gray-700');
                });
                
                // Sélectionner l'option cliquée
                this.classList.remove('border-gray-200', 'dark:border-gray-700');
                this.classList.add('border-forest', 'dark:border-meadow', 'bg-green-50', 'dark:bg-green-900/10');
                
                // Mettre à jour la valeur dans le champ caché
                const premiumType = this.getAttribute('data-premium-type');
                premiumTypeInput.value = premiumType;
            });
        });
        
        // Initialisation de la carte
        let map, marker;
        initMap();
        
        function initMap() {
            // Vérifier si la carte est déjà initialisée
            if (map) return;
            
            // Coordonnées par défaut (Maroc) ou coordonnées existantes
            const lat = document.getElementById('latitude').value || 31.7917;
            const lng = document.getElementById('longitude').value || -7.0926;
            const defaultZoom = lat && lng && lat != 31.7917 ? 12 : 5;
            
            // Créer la carte
            map = L.map('map-container').setView([lat, lng], defaultZoom);
            
            // Ajouter la couche de tuiles OpenStreetMap
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                maxZoom: 19
            }).addTo(map);
            
            // Ajouter un marqueur si des coordonnées sont déjà définies
            if (lat && lng && lat != 31.7917) {
                marker = L.marker([lat, lng]).addTo(map);
            }
            
            // Gérer le clic sur la carte
            map.on('click', function(e) {
                // Mettre à jour les coordonnées dans les champs
                document.getElementById('latitude').value = e.latlng.lat.toFixed(6);
                document.getElementById('longitude').value = e.latlng.lng.toFixed(6);
                
                // Ajouter ou déplacer le marqueur
                if (marker) {
                    marker.setLatLng(e.latlng);
                } else {
                    marker = L.marker(e.latlng).addTo(map);
                }
            });
            
            // Récupérer la position de l'utilisateur si aucune position n'est définie
            if ((!lat || !lng || lat == 31.7917) && navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function(position) {
                        // Mettre à jour la vue de la carte
                        const userLat = position.coords.latitude;
                        const userLng = position.coords.longitude;
                        map.setView([userLat, userLng], 12);
                    },
                    function(error) {
                        // Gérer les erreurs
                        console.log('Erreur de géolocalisation:', error.message);
                    }
                );
            }
            
            // Redimensionner la carte après son chargement
            setTimeout(() => {
                map.invalidateSize();
            }, 100);
        }
        
        // Événement quand on sélectionne une ville
        const citySelect = document.getElementById('city_id');
        if (citySelect) {
            citySelect.addEventListener('change', function() {
                if (!map) return;
                
                const selectedCity = this.options[this.selectedIndex].text;
                if (selectedCity && selectedCity !== 'Sélectionnez une ville') {
                    // Utiliser l'API de géocodage pour trouver les coordonnées de la ville
                    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(selectedCity)},Maroc`)
                        .then(response => response.json())
                        .then(data => {
                            if (data && data.length > 0) {
                                const lat = parseFloat(data[0].lat);
                                const lng = parseFloat(data[0].lon);
                                
                                // Mettre à jour la vue de la carte
                                map.setView([lat, lng], 12);
                            }
                        })
                        .catch(error => {
                            console.error('Erreur lors de la géolocalisation de la ville:', error);
                        });
                }
            });
        }
    });