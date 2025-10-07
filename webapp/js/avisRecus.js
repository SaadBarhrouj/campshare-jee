    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded - script running');
        
        function FilterRequest1() {
            console.log('filtersFormulaireAvis called');
            
            const form = document.getElementById('filtersFormulaireAvis');
            if (!form) {
                console.error('Form not found!');
                return;
            }
            const selectedStatus = document.getElementById('selected-status').value;
            form.querySelector('[name="type"]').value = selectedStatus;
            
            // Verify CSRF token exists
            const csrfToken = document.querySelector('meta[name="csrf-token"]');
            if (!csrfToken) {
                console.error('CSRF token meta tag not found!');
                return;
            }
            
            var formData = new FormData(form);
            
            
            // Log form data for debugging
            for (let [key, value] of formData.entries()) {
                console.log(`${key}: ${value}`);
            }
            
            fetch('{{ route("Avis.filter") }}', {  
                method: 'POST',
                headers: {
                    'X-CSRF-TOKEN': csrfToken.content
                },
                body: formData  
            })
            .then(response => {
                if (!response.ok) {
                    console.log(response);
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log("Response data:", data);
                
                if (data.success) {
                    const container = document.getElementById("Avis");
                    if (!container) {
                        console.error('Avis container not found!');
                        return;
                    }
                    
                    container.innerHTML = "";
                    
                    if (data.Avis && data.Avis.length > 0) {
                        data.Avis.forEach(avi => {
                            const rating = avi.rating;
                            const fullStars = Math.floor(rating);
                            const hasHalfStar = rating - fullStars >= 0.5;
                            
                            let starsHtml = '';
                            for (let i = 0; i < fullStars; i++) {
                                starsHtml += '<i class="fas fa-star"></i>';
                            }
                            if (hasHalfStar) {
                                starsHtml += '<i class="fas fa-star-half-alt"></i>';
                            }

                            const fullUrl = "{{ asset('') }}" + avi.avatar_url;

                            container.innerHTML += `
                            <div class="px-6 py-4">
                                <div class="flex flex-col lg:flex-row lg:items-start">
                                    <div class="flex-grow grid grid-cols-1 lg:grid-cols-9 gap-3 mb-4 lg:mb-0">
                                        <div class="col-span-2">
                                            <div class="flex gap-2 items-center content-center mb-4 lg:mb-0 lg:mr-6 w-full lg:w-auto">
                                                <div class="flex items-center content-center w-12">
                                                    <img src="${fullUrl}"
                                                        alt="${avi.username}" 
                                                        class="w-12 h-12 rounded-full object-cover" />
                                                </div>
                                                <div class="lg:block mt-2 pb-2">
                                                    <h3 class="font-medium text-gray-900 dark:text-white">${avi.username}</h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Note reçue</p>
                                            <div class="flex items-center text-sm">
                                                <i class="fas fa-star text-amber-400 mr-1"></i>
                                                <span >${rating.toFixed(1)}</span>
                                            </div>
                                        </div>
                                        <div class="col-span-4">
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Commentaire</p>
                                            <p class="font-medium text-gray-900 dark:text-white">${avi.comment || 'No comment'}</p>
                                        </div>
                                        <div>
                                            ${avi.object_title ? `
                                                <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Sur l'équipement</p>
                                                <p class="font-medium text-gray-900 dark:text-white">${avi.object_title}</p>
                                            ` : `
                                                <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Pour partenaire</p>
                                            `}
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">Date</p>
                                            <p class="font-medium text-gray-900 dark:text-white">${new Date(avi.created_at).toLocaleDateString()}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>`;
                        });
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }

    const form = document.getElementById('filtersFormulaireAvis');
    if (form) {
        form.addEventListener('change', FilterRequest1);
        form.addEventListener('input', FilterRequest1);
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            FilterRequest1();
        });
        document.querySelectorAll('.filter-chip').forEach(button => {
            button.addEventListener('click', function() {
            document.getElementById('selected-status').value = this.value;
            document.querySelectorAll('.filter-chip').forEach(btn => btn.classList.remove('active'));
            FilterRequest1();
        });
});
        
        // Initial load
    } else {
        console.error('Form element with ID "formulaire1-filters" not found!');
    }
});

