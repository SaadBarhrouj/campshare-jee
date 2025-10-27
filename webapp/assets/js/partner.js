    document.addEventListener('DOMContentLoaded', function() {
        // Variables
        const form = document.getElementById('listing-form');
        const formSteps = document.querySelectorAll('.form-step');
        const stepIndicators = document.querySelectorAll('.step-indicator');
        const progressBar = document.querySelector('.progress-bar');
        let currentStep = 1;
        
        // Fonction pour aller à une étape spécifique
        function goToStep(step) {
            // Masquer toutes les étapes
            formSteps.forEach(formStep => {
                formStep.classList.remove('active');
                formStep.style.display = 'none';
            });
            
            // Afficher l'étape actuelle
            const activeStep = document.getElementById(`step-${step}`);
            if (activeStep) {
                activeStep.classList.add('active');
                activeStep.style.display = 'block';
            }
            
            // Mettre à jour les indicateurs d'étape
            stepIndicators.forEach(indicator => {
                const indicatorStep = parseInt(indicator.dataset.step);
                indicator.classList.remove('active');
                
                if (indicatorStep === step) {
                    indicator.classList.add('active');
                    indicator.querySelector('span').classList.add('font-medium', 'text-forest', 'dark:text-meadow');
                } else if (indicatorStep < step) {
                    indicator.classList.add('completed');
                    indicator.querySelector('span').classList.remove('font-medium', 'text-forest', 'dark:text-meadow');
                } else {
                    indicator.classList.remove('completed');
                    indicator.querySelector('span').classList.remove('font-medium', 'text-forest', 'dark:text-meadow');
                }
            });
            
            // Mettre à jour la barre de progression
            const progressPercentage = ((step - 1) / (formSteps.length - 1)) * 100;
            progressBar.style.width = `${progressPercentage}%`;
            
            // Faire défiler vers le haut
            window.scrollTo({ top: 0, behavior: 'smooth' });
            
            // Mettre à jour l'étape actuelle
            currentStep = step;
            
            // Si on passe à l'étape de la carte, initialiser la carte
            if (step === 2) {
                initMap();
            }
        }
        
        // Initialisation : afficher uniquement la première étape
        goToStep(1);
        
        // Événement pour le bouton "Continuer vers Disponibilité"
        const nextToStep2Button = document.getElementById('next-to-step-2');
        if (nextToStep2Button) {
            nextToStep2Button.addEventListener('click', function() {
                goToStep(2);
            });
        }
        
        // Événement pour le bouton "Retour" (étape 2 vers étape 1)
        const backToStep1Button = document.getElementById('back-to-step-1');
        if (backToStep1Button) {
            backToStep1Button.addEventListener('click', function() {
                goToStep(1);
            });
        }
        
        // Événement pour le bouton "Continuer vers Options"
        const nextToStep3Button = document.getElementById('next-to-step-3');
        if (nextToStep3Button) {
            nextToStep3Button.addEventListener('click', function() {
                goToStep(3);
            });
        }
        
        // Événement pour le bouton "Retour" (étape 3 vers étape 2)
        const backToStep2Button = document.getElementById('back-to-step-2');
        if (backToStep2Button) {
            backToStep2Button.addEventListener('click', function() {
                goToStep(2);
            });
        }
        
        // Événement pour le bouton "Continuer vers Publication"
        const nextToStep4Button = document.getElementById('next-to-step-4');
        if (nextToStep4Button) {
            nextToStep4Button.addEventListener('click', function() {
                    goToStep(4);
                updateRecapitulatif();
            });
        }
        
        // Événement pour le bouton "Retour" (étape 4 vers étape 3)
        const backToStep3Button = document.getElementById('back-to-step-3');
        if (backToStep3Button) {
            backToStep3Button.addEventListener('click', function() {
                goToStep(3);
            });
        }
        
        // Gestion des options premium
        const isPremiumCheckbox = document.getElementById('is_premium');
        const premiumOptions = document.getElementById('premium-options');
        const premiumOptionCards = document.querySelectorAll('.premium-option');
        
        // Afficher/masquer les options premium en fonction de la case à cocher
        isPremiumCheckbox.addEventListener('change', function() {
            if (this.checked) {
                premiumOptions.style.display = 'block';
                // Sélectionner la première option par défaut
                if (premiumOptionCards.length > 0) {
                    premiumOptionCards[0].click();
                }
            } else {
                premiumOptions.style.display = 'none';
                // Désélectionner toutes les options
                document.querySelectorAll('.premium-radio').forEach(radio => {
                    radio.checked = false;
                });
                premiumOptionCards.forEach(card => {
                    card.classList.remove('border-forest', 'dark:border-meadow', 'bg-green-50', 'dark:bg-green-900/10');
                });
            }
        });
        
        // Sélection d'une option premium
        premiumOptionCards.forEach(card => {
            card.addEventListener('click', function() {
                // Désélectionner toutes les options
                premiumOptionCards.forEach(c => {
                    c.classList.remove('border-forest', 'dark:border-meadow', 'bg-green-50', 'dark:bg-green-900/10');
                });
                
                // Sélectionner l'option cliquée
                this.classList.add('border-forest', 'dark:border-meadow', 'bg-green-50', 'dark:bg-green-900/10');
                
                // Cocher le radio button correspondant
                const radio = this.querySelector('.premium-radio');
                radio.checked = true;
            });
        });
        
        // Fonction pour mettre à jour le récapitulatif
        function updateRecapitulatif() {
            // Récupérer les valeurs
            const startDate = document.getElementById('start_date').value;
            const endDate = document.getElementById('end_date').value;
            const cityId = document.getElementById('city_id').value;
            const cityName = document.getElementById('city_id').options[document.getElementById('city_id').selectedIndex].text;
            const latitude = document.getElementById('latitude').value;
            const longitude = document.getElementById('longitude').value;
            
            // Options de livraison
            let deliveryOption = '';
            if (document.getElementById('delivery_option_pickup').checked) {
                deliveryOption = 'Récupération sur place uniquement';
            } else if (document.getElementById('delivery_option_delivery').checked) {
                deliveryOption = 'Livraison uniquement';
            } else if (document.getElementById('delivery_option_both').checked) {
                deliveryOption = 'Récupération sur place ou livraison';
            }
            
            // Options premium
            let premiumOption = 'Aucune option premium sélectionnée';
            if (document.getElementById('is_premium').checked) {
                const selectedPremium = document.querySelector('input[name="premium_type"]:checked');
                if (selectedPremium) {
                    const premiumOptionDiv = selectedPremium.closest('.premium-option');
                    const premiumType = selectedPremium.value;
                    const premiumPrice = premiumOptionDiv.dataset.price;
                    premiumOption = `Mise en avant (${premiumType}) -- ${premiumPrice} MAD seront payés pour promouvoir cette annonce`;
                } else {
                    premiumOption = 'Option premium sélectionnée mais non spécifiée';
                }
            }
            
            // Mettre à jour le récapitulatif
            document.getElementById('recap-equipment-title').textContent = document.querySelector('.title').textContent;
            document.getElementById('recap-equipment-price').textContent = document.querySelector('.priceperday').textContent;
            
            document.getElementById('recap-dates').textContent = `Du ${formatDate(startDate)} au ${formatDate(endDate)}`;
            
            let locationText = cityName;
            if (latitude && longitude) {
                locationText += ` (Position GPS: ${latitude}, ${longitude})`;
            }
            document.getElementById('recap-location').textContent = locationText;
            
            document.getElementById('recap-delivery').textContent = deliveryOption;
            
        }
        
        function formatDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleDateString('fr-FR');
        }
        

        const publishButton = document.getElementById('publish-button');
        
        publishButton.addEventListener('click', function(e) {
            
            // Soumettre le formulaire si tout est valide
            form.submit();
        });

        
        // Initialisation de la carte
        let map, marker;
        
        function initMap() {
            // Vérifier si la carte est déjà initialisée
            if (map) return;
            
            // Coordonnées par défaut (Maroc)
            const defaultLat = 31.7917;
            const defaultLng = -7.0926;
            const defaultZoom = 5;
            
            // Créer la carte
            map = L.map('map-container').setView([defaultLat, defaultLng], defaultZoom);
            
            // Ajouter la couche de tuiles OpenStreetMap
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                maxZoom: 19
            }).addTo(map);
            
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
            
            // Récupérer la position de l'utilisateur si disponible
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    function(position) {
                        // Mettre à jour la vue de la carte
                        const userLat = position.coords.latitude;
                        const userLng = position.coords.longitude;
                        map.setView([userLat, userLng], 12);
                        
                        // Ajouter un marqueur pour la position de l'utilisateur
                        if (marker) {
                            marker.setLatLng([userLat, userLng]);
                        } else {
                            marker = L.marker([userLat, userLng]).addTo(map);
                        }
                        
                        // Mettre à jour les champs
                        document.getElementById('latitude').value = userLat.toFixed(6);
                        document.getElementById('longitude').value = userLng.toFixed(6);
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
                                
                                // Ne pas ajouter automatiquement de marqueur ni mettre à jour les coordonnées
                                // car l'utilisateur doit cliquer pour définir l'emplacement exact
                            }
                        })
                        .catch(error => {
                            console.error('Erreur lors de la géolocalisation de la ville:', error);
                        });
                }
            });
        }
    });
