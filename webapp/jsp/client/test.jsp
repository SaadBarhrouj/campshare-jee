<main class="flex-1 md:ml-64 bg-gray-50 dark:bg-gray-900 min-h-screen">
    <div class="py-8 px-4 md:px-8">
        <!-- Dashboard header -->
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-gray-900 dark:text-white">Tableau de bord</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Bienvenue, ${user.username} ! Voici un resume de vos reservations.</p>
            </div>
         
        </div>
        
        <!-- Stats cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <!-- Stats card 1 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-blue-100 dark:bg-blue-900 mr-4">
                        <i class="fas fa-shopping-cart text-blue-600 dark:text-blue-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Total reservations</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalReservations}</h3>
                        
                    </div>
                </div>
            </div>
            
            <!-- Stats card 2 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-green-100 dark:bg-green-900 mr-4">
                        <i class="fas fa-money-bill-wave text-green-600 dark:text-green-400"></i>
                    </div>
                    <div>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">Montant total depense</p>
                        <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${totalDepense}</h3>
                      
                    </div>
                </div>
            </div>
            
            <!-- Stats card 3 -->
            <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm p-6">
                <div class="flex items-center">
                    <div class="p-3 rounded-full bg-yellow-100 dark:bg-yellow-900 mr-4">
                        <i class="fas fa-star text-yellow-600 dark:text-yellow-400"></i>
                    </div>
                <div>
                    <p class="text-gray-500 dark:text-gray-400 text-sm">Note moyenne</p>

                    <c:choose>
                        <c:when test="${note_moyenne != null and note_moyenne != 0}">
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">${noteMoyenne}</h3>
                        </c:when>
                        <c:otherwise>
                            <h3 class="text-2xl font-bold text-gray-900 dark:text-white">Non note</h3>
                        </c:otherwise>
                    </c:choose>
                </div>

                </div>
            </div>
        </div>
        

        <!-- My reservations section -->
        <div class="mb-8">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mes reservations</h2>
                <a href="{{ route('HomeClient.reservations') }}" data-target = "allRes" class=" sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                    Voir toutes mes réservations
                </a>
            </div>
            


        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="res" items="${reservations}">
                        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                            <div class="relative h-40">
                                <img src="${res.image.url}" alt="Image" class="w-full h-full object-cover" />
                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                                
                                <%
                                    java.util.Map<String, String> statusMap = new java.util.HashMap<>();
                                    statusMap.put("pending", "En attente");
                                    statusMap.put("confirmed", "Confirmée");
                                    statusMap.put("ongoing", "En cours");
                                    statusMap.put("canceled", "Annulée");
                                    statusMap.put("completed", "Terminée");
                                    request.setAttribute("statusMap", statusMap);
                                %>

                                
                                <div class="absolute top-4 left-4">
                                    <span class="bg-gray-400 text-white text-xs px-2 py-1 rounded-full">
                                        <c:out value="${statusMap[res.status]}"/>
                                    </span>
                                </div>
                                
                                <div class="absolute bottom-4 left-4 right-4">
                                    <h3 class="text-white font-bold text-lg truncate"><c:out value="${res.item.title}"/></h3>
                                    <p class="text-gray-200 text-sm"><c:out value="${fn:substring(res.item.description, 0, 150)}"/></p>
                                </div>
                            </div>
                            
                            <div class="p-4">
                                <div class="flex items-start mb-4">
                                    <c:if test="${not empty res.partner}">
                                        <a href="#">
                                            <img src="${res.partner.avatarUrl}" alt="image" class="w-8 h-8 rounded-full object-cover mr-3"/>
                                        </a>
                                        <div>
                                            <a href="#">
                                                <p class="font-medium text-gray-900 dark:text-white"><c:out value="${res.partner.username}"/></p>
                                            </a>
                                            <div class="flex items-center text-sm">
                                                <c:if test="${res.partnerAvgRating != null}">
                                                    <c:set var="fullStars" value="${res.partnerAvgRating.intValue()}"/>
                                                    <c:set var="hasHalfStar" value="${res.partnerAvgRating - fullStars >= 0.5}"/>
                                                    
                                                    <div class="flex text-amber-400 mr-1">
                                                        <c:forEach var="i" begin="0" end="${fullStars - 1}">
                                                            <i class="fas fa-star"></i>
                                                        </c:forEach>
                                                        <c:if test="${hasHalfStar}">
                                                            <i class="fas fa-star-half-alt"></i>
                                                        </c:if>
                                                        <c:forEach var="i" begin="0" end="${4 - fullStars - (hasHalfStar ? 1 : 0)}">
                                                            <i class="far fa-star"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <span class="text-gray-600 dark:text-gray-400">
                                                        <fmt:formatNumber value="${res.partnerAvgRating}" type="number" maxFractionDigits="1"/>
                                                    </span>
                                                </c:if>
                                                <c:if test="${res.partnerAvgRating == null}">
                                                    <div class="text-sm text-gray-500">No ratings yet</div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div class="bg-gray-50 dark:bg-gray-700/50 rounded p-3 mb-4">
                                    <div class="flex justify-between text-sm mb-1">
                                        <span class="text-gray-600 dark:text-gray-400">Date</span>
                                        <span class="font-medium text-gray-900 dark:text-white">
                                            <fmt:formatDate value="${res.startDate}" pattern="yyyy-MM-dd"/> - 
                                            <fmt:formatDate value="${res.endDate}" pattern="yyyy-MM-dd"/>
                                        </span>
                                    </div>
                                    <div class="flex justify-between text-sm mb-1">
                                        <span class="text-gray-600 dark:text-gray-400">Prix</span>
                                        <span class="font-medium text-gray-900 dark:text-white">${res.montantPaye} MAD</span>
                                    </div>
                                </div>
                                
                                <c:if test="${res.status eq 'pending'}">
                                    <button onclick="cancelReservation(${res.id})"
                                            class="px-3 py-1.5 border border-red-300 dark:border-red-800 text-red-700 dark:text-red-400 text-sm rounded-md hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors flex-1">
                                        <i class="fas fa-times mr-2"></i> Annuler
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="rounded-lg shadow-sm overflow-hidden">
                        <p class="mx-8 text-sm text-gray-600 dark:text-gray-400">Vous n'avez aucune réservation.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

     
        


       
        
        <!-- Equipment recommendations -->
        <div class="mb-8">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Équipements recommandés</h2>
                <a href="{{ route('HomeClient.equips') }}" data-target = "allSim" class=" sidebar-link text-forest dark:text-meadow hover:underline text-sm font-medium">
                    Voir plus de recommandations
                </a>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <!-- Recommendation 1 -->
                @forelse($similarListings as $item)
                <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
                    
                    <a href="{{ route('client.listings.show', $item->lis_id) }}">
                    <div class="relative h-48">
                        <img src="{{ $item->image_url }}" alt="Image" 
                             class="w-full h-full object-cover" />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                        <div class="absolute bottom-4 left-4 right-4">
                            <h3 class="text-white font-bold text-lg truncate">{{$item->listing_title}}</h3>
                            <p class="text-gray-200 text-sm">{{$item->category_name}}</p>
                        </div>
                    </div>
                    <div class="p-4">
                        <div class="flex justify-between items-center mb-3">
                            <div>
                                <span class="font-bold text-lg text-gray-900 dark:text-white">{{$item->price_per_day}} MAD</span>
                                <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                            </div>
                            <div class="flex items-center text-sm">
                                @if($item->review_count)
                                    @php
                                        $rating = $item->avg_rating;
                                        $fullStars = floor($rating);
                                        $hasHalfStar = ($rating - $fullStars) >= 0.5;
                                    @endphp
                                    
                                    <div class="flex items-center">
                                        <div class="flex text-amber-400 mr-1">
                                            @for ($i = 0; $i < $fullStars; $i++)
                                                <i class="fas fa-star"></i>
                                            @endfor
                                            
                                            @if ($hasHalfStar)
                                                <i class="fas fa-star-half-alt"></i>
                                            @endif
                                            
                                            @for ($i = 0; $i < (5 - $fullStars - ($hasHalfStar ? 1 : 0)); $i++)
                                                <i class="far fa-star"></i>
                                            @endfor
                                        </div>
                                        <span class="text-gray-600 dark:text-gray-400">
                                            {{ number_format($rating, 1) }}
                                            <span class="text-xs text-gray-400 ml-1">({{ $item->review_count }})</span>
                                        </span>
                                    </div>
                                @else
                                    <div class="text-sm text-gray-500">No ratings yet</div>
                                @endif
                            </div>
                        </div>
                        
                        <div class="text-sm mb-3">
                            <span class="text-gray-600 dark:text-gray-300">
                                Dispo. du {{ \Carbon\Carbon::parse($item->start_date)->format('d M') }} 
                                au {{ \Carbon\Carbon::parse($item->end_date)->format('d M') }}
                            </span>                        </div>
                        
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-600 dark:text-gray-300">
                                <span class="font-medium text-green-800 dark:text-green-600">
                                    <i class="fas fa-map-marker-alt mr-1"></i> 
                                    {{$item->city_name}}
                                </span>
                            </div>
                            <a href="{{ route('client.listings.show', $item->lis_id) }}" class="px-3 py-1.5 bg-forest hover:bg-green-700 text-white text-sm rounded-md transition-colors">
                                Voir les détails
                            </a>
                        </div>
                    </div>
                    </a>
                </div>
                @empty
                @foreach($liss as $lis)
                <div class="equipment-card bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
                    
                    <a href="{{ route('client.listings.show', $lis->id) }}">
                    <div class="relative h-48">
                        <img src="{{ $lis->item?->images?->first() ? asset($lis->item->images->first()->url) : asset('images/item-default.jpg') }}" alt="Image" 
                             class="w-full h-full object-cover" />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                        <div class="absolute bottom-4 left-4 right-4">
                            <h3 class="text-white font-bold text-lg truncate">{{$lis->item->title}}</h3>
                            <p class="text-gray-200 text-sm">{{$lis->item->category->name}}</p>
                        </div>
                    </div>
                    <div class="p-4">
                        <div class="flex justify-between items-center mb-3">
                            <div>
                                <span class="font-bold text-lg text-gray-900 dark:text-white">{{$lis->item->price_per_day}} MAD</span>
                                <span class="text-gray-600 dark:text-gray-300 text-sm">/jour</span>
                            </div>
                            <div class="flex items-center text-sm">
                                @if($lis->item->averageRating() !=0)
                                    @php
                                        $rating = $lis->item->averageRating();
                                        $fullStars = floor($rating);
                                        $hasHalfStar = ($rating - $fullStars) >= 0.5;
                                    @endphp
                                    
                                    <div class="flex items-center">
                                        <div class="flex text-amber-400 mr-1">
                                            @for ($i = 0; $i < $fullStars; $i++)
                                                <i class="fas fa-star"></i>
                                            @endfor
                                            
                                            @if ($hasHalfStar)
                                                <i class="fas fa-star-half-alt"></i>
                                            @endif
                                            
                                            @for ($i = 0; $i < (5 - $fullStars - ($hasHalfStar ? 1 : 0)); $i++)
                                                <i class="far fa-star"></i>
                                            @endfor
                                        </div>
                                    </div>
                                @else
                                    <div class="text-sm text-gray-500">No ratings yet</div>
                                @endif
                            </div>
                        </div>
                        
                        <div class="text-sm mb-3">
                            <span class="text-gray-600 dark:text-gray-300">
                                Dispo. du {{ \Carbon\Carbon::parse($lis->start_date)->format('d M') }} 
                                au {{ \Carbon\Carbon::parse($lis->end_date)->format('d M') }}
                            </span>                        </div>
                        
                        <div class="flex items-center justify-between">
                            <div class="text-sm text-gray-600 dark:text-gray-300">
                                <span class="font-medium text-green-800 dark:text-green-600">
                                    <i class="fas fa-map-marker-alt mr-1"></i> 
                                    {{$lis->city->name}}
                                </span>
                            </div>
                            <a href="{{ route('client.listings.show', $lis->id) }}" class="px-3 py-1.5 bg-forest hover:bg-green-700 text-white text-sm rounded-md transition-colors">
                                Voir les détails
                            </a>
                        </div>
                    </div>
                    </a>
                </div>
                @endforeach
                @endforelse
                
            </div>
        </div>
    </div>
</main>