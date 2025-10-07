    // Modal controls
    const addEquipmentButton = document.getElementById('add-equipment-button');
    const addFirstEquipment = document.getElementById('add-first-equipment');
    const searchInput = document.getElementById('search-input');
    const categoryFilter = document.getElementById('category-filter');
    const priceFilter = document.getElementById('price-filter');
    const sortByFilter = document.getElementById('sort-by');
    const applyFilterButton = document.getElementById('apply-filter');
    const addEquipmentModal = document.getElementById('add-equipment-modal');
    const editEquipmentModal = document.getElementById('edit-equipment-modal');
    const deleteEquipmentModal = document.getElementById('delete-equipment-modal');
    const deleteAllModal = document.getElementById('delete-all-modal');
    const detailsModal = document.getElementById('equipment-details-modal');

    // Close buttons
    const closeAddModal = document.getElementById('close-add-modal');
    const closeEditModal = document.getElementById('close-edit-modal');
    const closeDeleteModal = document.getElementById('close-delete-modal');
    const closeDeleteAllModal = document.getElementById('close-delete-all-modal');
    const closeDetailsModal = document.getElementById('close-details-modal');

    // Cancel buttons
    const cancelAdd = document.getElementById('cancel-add');
    const cancelEdit = document.getElementById('cancel-edit');
    const cancelDelete = document.getElementById('cancel-delete');
    const cancelDeleteAll = document.getElementById('cancel-delete-all');

    // Forms
    const addEquipmentForm = document.getElementById('add-equipment-form');
    const editEquipmentForm = document.getElementById('edit-equipment-form');
    const deleteEquipmentForm = document.getElementById('delete-equipment-form');
    const deleteAllForm = document.getElementById('delete-all-form');

    // Edit buttons
    const editButtons = document.querySelectorAll('.edit-equipment-btn');
    const deleteButtons = document.querySelectorAll('.delete-equipment-btn');
    const viewDetailsButtons = document.querySelectorAll('.view-details-btn');
    const deleteAllButton = document.getElementById('delete-all-button');

    // Image upload
    const imageInput = document.getElementById('images');
    const editImageInput = document.getElementById('edit-images');
    const imagePreviewContainer = document.getElementById('image-preview-container');
    const editImagePreviewContainer = document.getElementById('edit-image-preview-container');
    const imageDropArea = document.getElementById('image-drop-area');
    const editImageDropArea = document.getElementById('edit-image-drop-area');

    // Show Add Equipment Modal
    if (addEquipmentButton) {
        addEquipmentButton.addEventListener('click', () => {
            addEquipmentModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        });
    }

    if (addFirstEquipment) {
        addFirstEquipment.addEventListener('click', () => {
            addEquipmentModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        });
    }

    // Close Add Equipment Modal
    if (closeAddModal) {
        closeAddModal.addEventListener('click', () => {
            addEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    if (cancelAdd) {
        cancelAdd.addEventListener('click', () => {
            addEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // Show Edit Equipment Modal
    editButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            
            const id = button.getAttribute('data-id');
            const title = button.getAttribute('data-title');
            const description = button.getAttribute('data-description');
            const price = button.getAttribute('data-price');
            const category = button.getAttribute('data-category');
            
            document.getElementById('edit-equipment-id').value = id;
            document.getElementById('edit-title').value = title;
            document.getElementById('edit-description').value = description;
            document.getElementById('edit-price_per_day').value = price;
            document.getElementById('edit-category_id').value = category;
            
            // Vider les conteneurs d'images
            const currentImagesContainer = document.getElementById('current-images-container');
            currentImagesContainer.innerHTML = '<div class="col-span-4 text-center py-4"><i class="fas fa-spinner fa-spin mr-2"></i> Chargement des images...</div>';
            document.getElementById('edit-image-preview-container').innerHTML = '';
            
            // Chargement des images existantes depuis l'API
            fetch(`/partenaire/equipements/${id}/details`)
                .then(response => response.json())
                .then(data => {
                    currentImagesContainer.innerHTML = '';
                    
                    // Si l'équipement a des images, les afficher
                    if (data.equipment.images && data.equipment.images.length > 0) {
                        // Pour chaque image, créer un élément d'aperçu
                        data.equipment.images.forEach(image => {
                            const imgContainer = document.createElement('div');
                            imgContainer.className = 'relative';
                            imgContainer.dataset.imageId = image.id;
                            
                            const img = document.createElement('img');
                            img.src = `/${image.url}`;
                            img.alt = data.equipment.title;
                            img.className = 'w-full h-32 object-cover rounded-md';
                            imgContainer.appendChild(img);
                            
                            // Ajouter un bouton de suppression
                            const removeBtn = document.createElement('button');
                            removeBtn.type = 'button';
                            removeBtn.className = 'absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center';
                            removeBtn.innerHTML = '<i class="fas fa-times text-xs"></i>';
                            
                            // Créer un champ caché pour marquer les images à supprimer
                            const hiddenInput = document.createElement('input');
                            hiddenInput.type = 'hidden';
                            hiddenInput.name = 'keep_images[]';
                            hiddenInput.value = image.id;
                            imgContainer.appendChild(hiddenInput);
                            
                            // Gérer la suppression d'image
                            removeBtn.addEventListener('click', function() {
                                // Changer le nom du champ pour indiquer la suppression
                                hiddenInput.name = 'delete_images[]';
                                
                                // Ajouter une classe pour griser visuellement l'image
                                imgContainer.classList.add('opacity-30');
                                
                                // Remplacer le bouton de suppression par un bouton d'annulation
                                this.innerHTML = '<i class="fas fa-undo text-xs"></i>';
                                this.classList.remove('bg-red-500');
                                this.classList.add('bg-green-500');
                                
                                // Fonction pour restaurer l'image
                                this.addEventListener('click', function() {
                                    hiddenInput.name = 'keep_images[]';
                                    imgContainer.classList.remove('opacity-30');
                                    this.innerHTML = '<i class="fas fa-times text-xs"></i>';
                                    this.classList.remove('bg-green-500');
                                    this.classList.add('bg-red-500');
                                }, { once: true });
                            });
                            
                            imgContainer.appendChild(removeBtn);
                            currentImagesContainer.appendChild(imgContainer);
                        });
                    } else {
                        currentImagesContainer.innerHTML = '<div class="col-span-4 text-center py-4 text-gray-500 dark:text-gray-400">Aucune image existante</div>';
                    }
                })
                .catch(error => {
                    console.error('Erreur lors du chargement des images:', error);
                    currentImagesContainer.innerHTML = '<div class="col-span-4 text-center py-4 text-red-500">Erreur lors du chargement des images</div>';
                });
            
            // Set form action
            const form = document.getElementById('edit-equipment-form');
            form.action = `/partenaire/equipements/${id}`;
            
            editEquipmentModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        });
    });

    // Close Edit Equipment Modal
    if (closeEditModal) {
        closeEditModal.addEventListener('click', () => {
            editEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    if (cancelEdit) {
        cancelEdit.addEventListener('click', () => {
            editEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // Gestionnaire pour les boutons de suppression
    document.querySelectorAll('.delete-equipment-btn').forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            
            const id = button.getAttribute('data-id');
            const title = button.getAttribute('data-title');
            
            // Mettre à jour le modal de suppression
            document.getElementById('delete-equipment-name').textContent = title;
            const form = document.getElementById('delete-equipment-form');
            form.action = `/partenaire/equipements/${id}`;
            
            // Afficher le modal de suppression
            deleteEquipmentModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        });
    });

    // Gestionnaire pour le formulaire de suppression
    if (deleteEquipmentForm) {
        deleteEquipmentForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const formData = new FormData();
            formData.append('_method', 'DELETE');
            formData.append('_token', document.querySelector('meta[name="csrf-token"]').content);
            
            try {
                const response = await fetch(deleteEquipmentForm.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                if (response.ok) {
                    // Fermer le modal
                    deleteEquipmentModal.classList.add('hidden');
                    document.body.classList.remove('overflow-hidden');
                    
                    // Rafraîchir la page
                    window.location.reload();
                } else {
                    const data = await response.json();
                    throw new Error(data.message || 'Erreur lors de la suppression');
                }
            } catch (error) {
                console.error('Erreur:', error);
                alert('Une erreur est survenue lors de la suppression de l\'équipement');
            }
        });
    }

    // Gestionnaires pour fermer le modal de suppression
    if (closeDeleteModal) {
        closeDeleteModal.addEventListener('click', () => {
            deleteEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    if (cancelDelete) {
        cancelDelete.addEventListener('click', () => {
            deleteEquipmentModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // Ajouter l'attribut data-id aux cartes d'équipement
    document.querySelectorAll('.equipment-card').forEach(card => {
        const deleteBtn = card.querySelector('.delete-equipment-btn');
        if (deleteBtn) {
            const id = deleteBtn.getAttribute('data-id');
            card.setAttribute('data-id', id);
        }
    });

    // Show Delete All Equipment Modal
    if (deleteAllButton) {
        deleteAllButton.addEventListener('click', () => {
            deleteAllModal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
        });
    }

    // Close Delete All Equipment Modal
    if (closeDeleteAllModal) {
        closeDeleteAllModal.addEventListener('click', () => {
            deleteAllModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    if (cancelDeleteAll) {
        cancelDeleteAll.addEventListener('click', () => {
            deleteAllModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // View Equipment Details
    viewDetailsButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            
            const id = button.getAttribute('data-id');
            
            // Afficher le modal avec indicateur de chargement
            const modal = document.getElementById('equipment-details-modal');
            modal.classList.remove('hidden');
            document.body.classList.add('overflow-hidden');
            
            // Initialiser les éléments avec des indicateurs de chargement
            document.getElementById('detail-title').textContent = 'Chargement...';
            document.getElementById('detail-price').textContent = '...';
            document.getElementById('detail-category').textContent = '...';
            document.getElementById('detail-description').textContent = 'Chargement des informations...';
            document.getElementById('detail-annonces-count').textContent = '...';
            document.getElementById('detail-active-annonces').textContent = '...';
            document.getElementById('detail-reservations-count').textContent = '...';
            document.getElementById('detail-completed-reservations').textContent = '...';
            document.getElementById('detail-avg-rating').textContent = '...';
            document.getElementById('detail-review-count').textContent = '...';
            document.getElementById('detail-revenue').textContent = '...';
            document.getElementById('detail-reviews-summary').textContent = 'Chargement...';
            
            // Vider le conteneur d'images et afficher un placeholder
            const imageSlider = document.getElementById('detail-image-slider');
            imageSlider.innerHTML = `
                <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                    <i class="fas fa-sync fa-spin text-5xl text-gray-400 dark:text-gray-500"></i>
                </div>
            `;
            
            // Charger les données détaillées de l'équipement
            fetch(`/partenaire/equipements/${id}/details`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur lors du chargement des détails');
                    }
                    return response.json();
                })
                .then(data => {
                    // Mettre à jour les informations de base
                    const equipment = data.equipment;
                    const stats = data.stats;
                    
                    document.getElementById('detail-title').textContent = equipment.title;
                    document.getElementById('detail-price').textContent = `${equipment.price_per_day} MAD/jour`;
                    document.getElementById('detail-category').textContent = equipment.category ? equipment.category.name : 'Non catégorisé';
                    document.getElementById('detail-description').textContent = equipment.description || 'Aucune description';
                    
                    // Statistiques
                    document.getElementById('detail-annonces-count').textContent = stats.annonces_count;
                    document.getElementById('detail-active-annonces').textContent = `${stats.active_annonce_count} actives`;
                    document.getElementById('detail-reservations-count').textContent = stats.reservations_count;
                    document.getElementById('detail-completed-reservations').textContent = `${stats.completed_reservations_count} terminées`;
                    document.getElementById('detail-revenue').textContent = `${stats.revenue.toLocaleString()} MAD`;
                    
                    // Avis
                    const avgRating = equipment.reviews && equipment.reviews.length > 0 
                        ? equipment.reviews.reduce((sum, review) => sum + review.rating, 0) / equipment.reviews.length 
                        : 0;
                    document.getElementById('detail-avg-rating').textContent = avgRating.toFixed(1);
                    document.getElementById('detail-review-count').textContent = `${equipment.reviews ? equipment.reviews.length : 0} avis`;
                    document.getElementById('detail-reviews-summary').textContent = equipment.reviews && equipment.reviews.length > 0 
                        ? `${equipment.reviews.length} avis` 
                        : 'Aucun avis';
                    
                    // Images
                    imageSlider.innerHTML = '';
                    
                    // Créer le carousel d'images
                    if (equipment.images && equipment.images.length > 0) {
                        // Conteneur pour les indicateurs
                        const imageDots = document.createElement('div');
                        imageDots.className = 'flex justify-center mt-2 space-x-2';
                        imageDots.id = 'detail-image-dots';
                        
                        // Ajouter chaque image au slider
                        equipment.images.forEach((image, index) => {
                            // Créer la diapositive d'image
                            const imgDiv = document.createElement('div');
                            imgDiv.className = 'w-full h-64 flex-shrink-0 snap-center relative';
                            imgDiv.setAttribute('data-index', index);
                            imgDiv.innerHTML = `
                                <img src="/${image.url}" alt="${equipment.title}" class="w-full h-full object-cover">
                                <div class="absolute bottom-2 right-2 bg-black bg-opacity-50 text-white text-xs px-2 py-1 rounded-full">
                                    ${index + 1}/${equipment.images.length}
                                </div>
                            `;
                            imageSlider.appendChild(imgDiv);
                            
                            // Créer l'indicateur (point) pour cette image
                            const dot = document.createElement('button');
                            dot.className = `w-3 h-3 rounded-full ${index === 0 ? 'bg-forest dark:bg-meadow' : 'bg-gray-300 dark:bg-gray-600'}`;
                            dot.setAttribute('data-index', index);
                            dot.addEventListener('click', () => {
                                // Faire défiler jusqu'à cette image
                                const imgElement = imageSlider.querySelector(`[data-index="${index}"]`);
                                if (imgElement) {
                                    imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                }
                                
                                // Mettre à jour les indicateurs
                                imageDots.querySelectorAll('button').forEach(btn => {
                                    btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                    btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                });
                                dot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                dot.classList.add('bg-forest', 'dark:bg-meadow');
                            });
                            imageDots.appendChild(dot);
                        });
                        
                        // Ajouter les indicateurs sous le slider
                        const sliderContainer = imageSlider.closest('.bg-gray-100, .dark\\:bg-gray-700');
                        sliderContainer.appendChild(imageDots);
                        
                        // Ajouter des contrôles de navigation (boutons précédent/suivant)
                        const prevButton = document.createElement('button');
                        prevButton.className = 'absolute left-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                        prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
                        prevButton.addEventListener('click', () => {
                            // Trouver l'image visible actuelle
                            const scrollPosition = imageSlider.scrollLeft;
                            const imgWidth = imageSlider.offsetWidth;
                            const currentIndex = Math.round(scrollPosition / imgWidth);
                            
                            // Calculer l'index de l'image précédente
                            const prevIndex = (currentIndex - 1 + equipment.images.length) % equipment.images.length;
                            
                            // Faire défiler jusqu'à l'image précédente
                            const imgElement = imageSlider.querySelector(`[data-index="${prevIndex}"]`);
                            if (imgElement) {
                                imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                
                                // Mettre à jour les indicateurs
                                imageDots.querySelectorAll('button').forEach(btn => {
                                    btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                    btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                });
                                const activeDot = imageDots.querySelector(`[data-index="${prevIndex}"]`);
                                if (activeDot) {
                                    activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                }
                            }
                        });
                        
                        const nextButton = document.createElement('button');
                        nextButton.className = 'absolute right-2 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white rounded-full p-2 hover:bg-opacity-70 transition-opacity z-10';
                        nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
                        nextButton.addEventListener('click', () => {
                            // Trouver l'image visible actuelle
                            const scrollPosition = imageSlider.scrollLeft;
                            const imgWidth = imageSlider.offsetWidth;
                            const currentIndex = Math.round(scrollPosition / imgWidth);
                            
                            // Calculer l'index de l'image suivante
                            const nextIndex = (currentIndex + 1) % equipment.images.length;
                            
                            // Faire défiler jusqu'à l'image suivante
                            const imgElement = imageSlider.querySelector(`[data-index="${nextIndex}"]`);
                            if (imgElement) {
                                imgElement.scrollIntoView({ behavior: 'smooth', inline: 'center' });
                                
                                // Mettre à jour les indicateurs
                                imageDots.querySelectorAll('button').forEach(btn => {
                                    btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                    btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                                });
                                const activeDot = imageDots.querySelector(`[data-index="${nextIndex}"]`);
                                if (activeDot) {
                                    activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                    activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                                }
                            }
                        });
                        
                        // Ajouter les boutons de navigation directement au slider
                        sliderContainer.appendChild(prevButton);
                        sliderContainer.appendChild(nextButton);
                        sliderContainer.style.position = 'relative';
                        
                        // Détecter le changement d'image lors du défilement
                        imageSlider.addEventListener('scroll', () => {
                            // Calculer l'index de l'image actuellement visible
                            const scrollPosition = imageSlider.scrollLeft;
                            const imgWidth = imageSlider.offsetWidth;
                            const currentIndex = Math.round(scrollPosition / imgWidth);
                            
                            // Mettre à jour les indicateurs
                            imageDots.querySelectorAll('button').forEach(btn => {
                                btn.classList.remove('bg-forest', 'dark:bg-meadow');
                                btn.classList.add('bg-gray-300', 'dark:bg-gray-600');
                            });
                            const activeDot = imageDots.querySelector(`[data-index="${currentIndex}"]`);
                            if (activeDot) {
                                activeDot.classList.remove('bg-gray-300', 'dark:bg-gray-600');
                                activeDot.classList.add('bg-forest', 'dark:bg-meadow');
                            }
                        });
                    } else {
                        // Add placeholder if no images
                        const placeholderDiv = document.createElement('div');
                        placeholderDiv.className = 'w-full h-64 bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center';
                        placeholderDiv.innerHTML = '<i class="fas fa-campground text-5xl text-gray-400 dark:text-gray-500"></i>';
                        imageSlider.appendChild(placeholderDiv);
                    }
                    
                    // Lien pour créer une annonce
                    const createAnnonceLink = document.getElementById('detail-create-annonce-link');
                    createAnnonceLink.href = `/partenaire/annonces/create/${equipment.id}`;
                    
                    // Avis
                    const reviewsContainer = document.getElementById('detail-reviews-container');
                    const noReviewsMessage = document.getElementById('no-reviews-message');
                    
                    // Clear previous reviews
                    reviewsContainer.innerHTML = '';
                    
                    if (!equipment.reviews || equipment.reviews.length === 0) {
                        reviewsContainer.appendChild(noReviewsMessage);
                    } else {
                        equipment.reviews.forEach(review => {
                            const reviewDiv = document.createElement('div');
                            reviewDiv.className = 'bg-gray-50 dark:bg-gray-700 p-4 rounded-lg';
                            
                            // Create stars
                            let stars = '';
                            for (let i = 0; i < 5; i++) {
                                if (i < review.rating) {
                                    stars += '<i class="fas fa-star text-amber-400"></i>';
                                } else {
                                    stars += '<i class="far fa-star text-amber-400"></i>';
                                }
                            }
                            
                            const reviewerName = review.reviewer ? review.reviewer.username || 'Utilisateur' : 'Utilisateur';

                            const reviewerAvata = "{{ asset('') }}";
                            const reviewerAvatar = reviewerAvata + review.reviewer.avatar_url;
                            
                            const reviewDate = new Date(review.created_at).toLocaleDateString('fr-FR');
                            
                            reviewDiv.innerHTML = `
                                <div class="flex items-center mb-2">
                                    <img src="${reviewerAvatar}" alt="${reviewerName}" class="w-8 h-8 rounded-full mr-2">
                                    <div>
                                        <div class="font-medium text-gray-900 dark:text-white">${reviewerName}</div>
                                        <div class="text-xs text-gray-500 dark:text-gray-400">${reviewDate}</div>
                                    </div>
                                </div>
                                <div class="flex mb-2">
                                    ${stars}
                                </div>
                                <p class="text-gray-700 dark:text-gray-300">${review.comment || 'Aucun commentaire'}</p>
                            `;
                            
                            reviewsContainer.appendChild(reviewDiv);
                        });
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    // Afficher un message d'erreur
                    document.getElementById('detail-title').textContent = 'Erreur de chargement';
                    document.getElementById('detail-description').textContent = 'Une erreur est survenue lors du chargement des détails de l\'équipement. Veuillez réessayer.';
                    
                    // Vider le conteneur d'images et afficher une icône d'erreur
                    imageSlider.innerHTML = `
                        <div class="w-full h-full bg-gray-200 dark:bg-gray-700 flex-shrink-0 snap-center flex items-center justify-center">
                            <i class="fas fa-exclamation-triangle text-5xl text-red-500"></i>
                        </div>
                    `;
                });
        });
    });

    // Close Details Modal
    if (closeDetailsModal) {
        closeDetailsModal.addEventListener('click', () => {
            detailsModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        });
    }

    // Image upload
    if (imageInput) {
        imageInput.addEventListener('change', function() {
            handleFileSelect(this.files, imagePreviewContainer);
        });
    }

    if (editImageInput) {
        editImageInput.addEventListener('change', function() {
            handleFileSelect(this.files, editImagePreviewContainer);
        });
    }

    function handleFileSelect(files, previewContainer) {
        // Ne pas vider le conteneur pour permettre l'ajout de plusieurs lots d'images
        // previewContainer.innerHTML = '';
        
        // Limiter à maximum 5 images au total
        const maxFiles = 5;
        const currentImages = previewContainer.querySelectorAll('.relative').length;
        const maxNewImages = maxFiles - currentImages;
        
        if (maxNewImages <= 0) {
            const errorDiv = previewContainer.id === 'image-preview-container' 
                ? document.getElementById('image-count-error') 
                : document.getElementById('edit-image-count-error');
            
            if (errorDiv) {
                errorDiv.textContent = "Maximum 5 images autorisées. Veuillez supprimer des images avant d'en ajouter d'autres.";
                errorDiv.classList.remove('hidden');
            }
            return;
        }
        
        const filesToProcess = files.length > maxNewImages ? Array.from(files).slice(0, maxNewImages) : files;
        
        for (let i = 0; i < filesToProcess.length; i++) {
            const file = filesToProcess[i];
            
            if (!file.type.match('image.*')) {
                continue;
            }
            
            const reader = new FileReader();
            
            reader.onload = function(e) {
                const imgContainer = document.createElement('div');
                imgContainer.className = 'relative';
                
                const img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'w-full h-32 object-cover rounded-md';
                imgContainer.appendChild(img);
                
                const removeBtn = document.createElement('button');
                removeBtn.className = 'absolute top-1 right-1 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center';
                removeBtn.innerHTML = '<i class="fas fa-times text-xs"></i>';
                removeBtn.addEventListener('click', function() {
                    imgContainer.remove();
                    
                    // Masquer le message d'erreur après la suppression
                    const errorDiv = previewContainer.id === 'image-preview-container' 
                        ? document.getElementById('image-count-error') 
                        : document.getElementById('edit-image-count-error');
                    
                    if (errorDiv) {
                        errorDiv.classList.add('hidden');
                    }
                });
                imgContainer.appendChild(removeBtn);
                
                previewContainer.appendChild(imgContainer);
            };
            
            reader.readAsDataURL(file);
        }
        
        // Afficher message d'erreur si dépassement
        const errorDiv = previewContainer.id === 'image-preview-container' 
            ? document.getElementById('image-count-error') 
            : document.getElementById('edit-image-count-error');
        
        if (files.length > maxNewImages && errorDiv) {
            errorDiv.textContent = `Vous ne pouvez ajouter que ${maxNewImages} image(s) supplémentaire(s). Seules les ${maxNewImages} premières ont été sélectionnées.`;
            errorDiv.classList.remove('hidden');
        } else if (errorDiv) {
            errorDiv.classList.add('hidden');
        }
    }

    // Drag and drop for images
    if (imageDropArea) {
        setupDragDrop(imageDropArea, imageInput, imagePreviewContainer);
    }

    if (editImageDropArea) {
        setupDragDrop(editImageDropArea, editImageInput, editImagePreviewContainer);
    }

    function setupDragDrop(dropArea, fileInput, previewContainer) {
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight() {
            dropArea.classList.add('border-forest', 'dark:border-meadow');
        }
        
        function unhighlight() {
            dropArea.classList.remove('border-forest', 'dark:border-meadow');
        }
        
        dropArea.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            
            // Au lieu de simplement remplacer les fichiers, créons un FileList personnalisé 
            // qui inclut à la fois les fichiers existants et les nouveaux fichiers
            if (fileInput.files && fileInput.files.length > 0) {
                // Créer un nouvel objet FormData pour combiner les fichiers
                const formData = new FormData();
                
                // Ajouter les fichiers existants
                Array.from(fileInput.files).forEach(file => {
                    formData.append('images[]', file);
                });
                
                // Ajouter les nouveaux fichiers
                Array.from(files).forEach(file => {
                    formData.append('images[]', file);
                });
                
                // Note: Nous ne pouvons pas directement modifier fileInput.files
                // mais nous pouvons traiter les fichiers sélectionnés individuellement
                handleFileSelect(files, previewContainer);
            } else {
                // S'il n'y a pas de fichiers existants, utilisez simplement les nouveaux
                fileInput.files = files;
                handleFileSelect(files, previewContainer);
            }
        }
    }

    if (addEquipmentForm) {
        addEquipmentForm.addEventListener('submit', function(e) {
            const imageCount = imagePreviewContainer.querySelectorAll('.relative').length;
            const errorDiv = document.getElementById('image-count-error');
            
            if (imageCount < 1 || imageCount > 5) {
                e.preventDefault();
                errorDiv.textContent = imageCount < 1 
                    ? "Veuillez sélectionner au moins 1 image."
                    : "Veuillez sélectionner au maximum 5 images.";
                errorDiv.classList.remove('hidden');
                return false;
            } else {
                errorDiv.classList.add('hidden');
            }
            
            // Créer un DataTransfer pour stocker les images à envoyer
            if (imageCount > 0) {
                // Nous devons préparer les images à envoyer via le formulaire
                // Cette étape est gérée automatiquement par le navigateur
                // car les prévisualisations sont simplement des représentations visuelles
                // Les fichiers originaux sont toujours attachés à l'élément input
                
                // Si la validation passe, nous pouvons soumettre le formulaire
                return true;
            }
        });
    }

    if (editEquipmentForm) {
        editEquipmentForm.addEventListener('submit', function(e) {
            const currentImagesContainer = document.getElementById('current-images-container');
            const newImagesPreviewContainer = document.getElementById('edit-image-preview-container');
            
            // Compter les images conservées (non marquées pour suppression)
            const keptImagesCount = currentImagesContainer.querySelectorAll('input[name="keep_images[]"]').length;
            
            // Compter les nouvelles images
            const newImagesCount = newImagesPreviewContainer.querySelectorAll('.relative').length;
            
            // Nombre total d'images
            const totalImagesCount = keptImagesCount + newImagesCount;
            
            const errorDiv = document.getElementById('edit-image-count-error');
            
            // Vérifier si des images ont été sélectionnées ou si des images préexistantes sont présentes
            if (totalImagesCount < 1 || totalImagesCount > 5) {
                e.preventDefault();
                errorDiv.textContent = totalImagesCount < 1 
                    ? "Vous devez conserver au moins 1 image. Veuillez ajouter une image ou annuler la suppression."
                    : "Le nombre total d'images ne peut pas dépasser 5. Veuillez en supprimer ou en ajouter moins.";
                errorDiv.classList.remove('hidden');
                return false;
            } else {
                errorDiv.classList.add('hidden');
            }
            
            // Si la validation passe, nous pouvons soumettre le formulaire
            return true;
        });
    }
