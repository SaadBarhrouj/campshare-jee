<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    java.util.Map<String, String> statusMap = new java.util.HashMap<>();
    statusMap.put("pending", "En attente");
    statusMap.put("confirmed", "Confirmée");
    statusMap.put("ongoing", "En cours");
    statusMap.put("canceled", "Annulée");
    statusMap.put("completed", "Terminée");
    request.setAttribute("statusMap", statusMap);
%>

<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    <c:choose>
        <c:when test="${not empty reservations}">
            <c:forEach var="res" items="${reservations}">
                <div class="bg-white dark:bg-gray-800 rounded-lg shadow-sm overflow-hidden">
                    <div class="relative h-40">
                        <img src="${pageContext.request.contextPath}/images/items/${res.listing.item.images.get(0).url}" 
                             alt="Image" class="w-full h-full object-cover" />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                        
                        <div class="absolute top-4 left-4">
                            <span class="bg-gray-400 text-white text-xs px-2 py-1 rounded-full">
                                <c:out value="${statusMap[res.status]}" />
                            </span>
                        </div>
                        <div class="absolute bottom-4 left-4 right-4">
                            <h3 class="text-white font-bold text-lg truncate">
                                <c:out value="${res.listing.item.title}" />
                            </h3>
                            <p class="text-gray-200 text-sm">
                                <c:choose>
                                    <c:when test="${fn:length(res.listing.item.description) > 150}">
                                        <c:out value="${fn:substring(res.listing.item.description, 0, 150)}..." />
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${res.listing.item.description}" />
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    
                    <div class="p-4">
                        <div class="flex items-start mb-4">
                            <c:if test="${not empty res.partner}">
                                <img src="${pageContext.request.contextPath}/images/avatars/${res.partner.avatarUrl}" 
                                     alt="image" class="w-8 h-8 rounded-full object-cover mr-3" />
                                <div>
                                    <p class="font-medium text-gray-900 dark:text-white">
                                        <c:out value="${res.partner.username}" />
                                    </p>
                                    <div class="flex items-center text-sm">
                                        <c:choose>
                                            <c:when test="${res.partner.avgRating != null and res.partner.avgRating != 0}">
                                                <c:set var="rating" value="${res.partner.avgRating}" />
                                                <c:set var="fullStars" value="${Math.floor(rating)}" />
                                                <c:set var="hasHalfStar" value="${(rating - fullStars) ge 0.5}" />
                                                <c:set var="emptyStars" value="${5 - fullStars - (hasHalfStar ? 1 : 0)}" />
                                                
                                                <div class="flex text-amber-400 mr-1">
                                                    <c:forEach begin="0" end="${fullStars - 1}" var="i">
                                                        <i class="fas fa-star"></i>
                                                    </c:forEach>
                                                    <c:if test="${hasHalfStar}">
                                                        <i class="fas fa-star-half-alt"></i>
                                                    </c:if>
                                                    <c:forEach begin="0" end="${emptyStars - 1}" var="i">
                                                        <i class="far fa-star"></i>
                                                    </c:forEach>
                                                </div>
                                                <span class="ml-1 text-gray-600 dark:text-gray-400 text-sm">
                                                    <fmt:formatNumber value="${rating}" maxFractionDigits="1"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-sm text-gray-500">No ratings yet</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="bg-gray-50 dark:bg-gray-700/50 rounded p-3 mb-4">
                            <div class="flex justify-between text-sm mb-1">
                                <span class="text-gray-600 dark:text-gray-400">Date</span>
                                <span class="font-medium text-gray-900 dark:text-white">
                                    <fmt:formatDate value="${res.startDate}" pattern="yyyy-MM-dd" /> -
                                    <fmt:formatDate value="${res.endDate}" pattern="yyyy-MM-dd" />
                                </span>
                            </div>
                            <div class="flex justify-between text-sm mb-1">
                                <span class="text-gray-600 dark:text-gray-400">Prix</span>
                                    <fmt:parseDate value="${res.startDate}" pattern="yyyy-MM-dd" var="startDate" />
                                    <fmt:parseDate value="${res.endDate}" pattern="yyyy-MM-dd" var="endDate" />

                                    <c:set var="diffDays" value="${(endDate.time - startDate.time) / (1000 * 60 * 60 * 24)}" />
                                    
                                    <c:set var="montantTotal" value="${res.listing.item.pricePerDay * diffDays}" />

                                <span class="font-medium text-gray-900 dark:text-white">
                                    ${montantTotal} MAD
                                </span>
                            </div>
                        </div>
                        
                        <c:if test="${res.status eq 'pending'}">
                            <button onclick="cancelReservation(${res.id})"
                                    class="px-3 py-1.5 border border-red-300 dark:border-red-800 text-red-700 
                                           dark:text-red-400 text-sm rounded-md hover:bg-red-50 
                                           dark:hover:bg-red-900/20 transition-colors flex-1">
                                <i class="fas fa-times mr-2"></i> Annuler
                            </button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="rounded-lg shadow-sm overflow-hidden col-span-2">
                <p class="mx-8 text-sm text-gray-600 dark:text-gray-400">
                    Aucune réservation trouvée pour ce statut.
                </p>
            </div>
        </c:otherwise>
    </c:choose>
</div>