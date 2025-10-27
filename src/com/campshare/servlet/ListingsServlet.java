package com.campshare.servlet;

import com.campshare.model.Listing;
import com.campshare.service.ListingService;
import com.campshare.service.CategoryService;
import com.campshare.service.CityService;
import com.campshare.service.ItemService;
import com.campshare.service.ImageService;
import com.campshare.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.campshare.model.Category;
import com.campshare.model.City;
import com.campshare.model.Item;
import com.campshare.model.Image;
import com.campshare.model.User;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;



public class ListingsServlet extends HttpServlet {

    private ListingService listingService = new ListingService();
    private CategoryService categoryService = new CategoryService();
    private CityService cityService = new CityService();
    private ItemService itemService = new ItemService();
    private ImageService imageService = new ImageService();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String city = request.getParameter("city");
        String priceRange = request.getParameter("price_range");
        String sort = request.getParameter("sort");

        // Get all categories and cities for filters
        List<Category> categories = categoryService.getAllCategories();
        
        List<City> cities = cityService.getAllCities();

        // Get listings based on filters
        List<Listing> listings = getFilteredListings(search, category, city, priceRange, sort);

        // Create enhanced listing data with related objects
        List<Map<String, Object>> enhancedListings = createEnhancedListings(listings);

        // Get listings count
        long listingsCount = listings.size();

        // Set attributes for JSP
        request.setAttribute("listings", enhancedListings);
        request.setAttribute("listingsCount", listingsCount);
        request.setAttribute("categories", categories);
        request.setAttribute("cities", cities);
        request.setAttribute("search", search);
        request.setAttribute("category", category);
        request.setAttribute("city", city);
        request.setAttribute("priceRange", priceRange);
        request.setAttribute("sort", sort != null ? sort : "latest");

        request.getRequestDispatcher("/jsp/listing/listings.jsp").forward(request, response);
    }

    private List<Listing> getFilteredListings(String search, String category, String city, String priceRange, String sort) {
        List<Listing> listings = new ArrayList<>();

        // Apply filters
        if (search != null && !search.trim().isEmpty()) {
            listings = listingService.searchListingsByTitle(search);
        } else if (category != null && !category.trim().isEmpty() && city != null && !city.trim().isEmpty()) {
            // Find category and city IDs
            long categoryId = findCategoryIdByName(category);
            long cityId = findCityIdByName(city);
            if (categoryId > 0 && cityId > 0) {
                listings = listingService.getListingsByCityAndCategory(cityId, categoryId);
            }
        } else if (category != null && !category.trim().isEmpty()) {
            long categoryId = findCategoryIdByName(category);
            if (categoryId > 0) {
                listings = listingService.getListingsByCategoryId(categoryId);
            }
        } else if (city != null && !city.trim().isEmpty()) {
            long cityId = findCityIdByName(city);
            if (cityId > 0) {
                listings = listingService.getListingsByCityId(cityId);
            }
        } else {
            listings = listingService.getActiveListings();
        }

        // Apply price range filter
        if (priceRange != null && !priceRange.trim().isEmpty()) {
            listings = filterByPriceRange(listings, priceRange);
        }

        // Apply sorting
        if (sort != null && !sort.trim().isEmpty()) {
            listings = sortListings(listings, sort);
        }

        return listings;
    }

    private long findCategoryIdByName(String categoryName) {
        List<Category> categories = categoryService.getAllCategories();
        for (Category cat : categories) {
            if (cat.getName().equals(categoryName)) {
                return cat.getId();
            }
        }
        return 0;
    }

    private long findCityIdByName(String cityName) {
        List<City> cities = cityService.getAllCities();
        for (City city : cities) {
            if (city.getName().equals(cityName)) {
                return city.getId();
            }
        }
        return 0;
    }

    private List<Listing> filterByPriceRange(List<Listing> listings, String priceRange) {
        List<Listing> filteredListings = new ArrayList<>();
        
        for (Listing listing : listings) {
            Item item = itemService.getItemById(listing.getItemId());
            if (item != null) {
                double price = item.getPricePerDay();
                
                switch (priceRange) {
                    case "0-50":
                        if (price >= 0 && price <= 50) {
                            filteredListings.add(listing);
                        }
                        break;
                    case "50-100":
                        if (price > 50 && price <= 100) {
                            filteredListings.add(listing);
                        }
                        break;
                    case "100-200":
                        if (price > 100 && price <= 200) {
                            filteredListings.add(listing);
                        }
                        break;
                    case "200+":
                        if (price > 200) {
                            filteredListings.add(listing);
                        }
                        break;
                }
            }
        }
        
        return filteredListings;
    }

    private List<Listing> sortListings(List<Listing> listings, String sort) {
        if (listings == null || listings.isEmpty() || sort == null || sort.trim().isEmpty()) {
            return listings;
        }

        // Create a copy so we don't mutate the original list reference
        List<Listing> sorted = new ArrayList<>(listings);

        switch (sort) {
            case "latest":
                // Newest first by created_at (nulls last)
                sorted.sort((a, b) -> {
                    if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                    if (a.getCreatedAt() == null) return 1;
                    if (b.getCreatedAt() == null) return -1;
                    return b.getCreatedAt().compareTo(a.getCreatedAt());
                });
                break;
            case "oldest":
                // Oldest first by created_at (nulls last)
                sorted.sort((a, b) -> {
                    if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                    if (a.getCreatedAt() == null) return 1;
                    if (b.getCreatedAt() == null) return -1;
                    return a.getCreatedAt().compareTo(b.getCreatedAt());
                });
                break;
            case "price_asc":
            case "price_desc": {
                // Sort by Item.price_per_day; build a small cache to avoid repeated DAO calls
                Map<Long, Item> itemCache = new HashMap<>();
                java.util.function.Function<Long, Item> getItem = (itemId) -> {
                    if (itemId == null) return null;
                    Item cached = itemCache.get(itemId);
                    if (cached != null) return cached;
                    Item fetched = itemService.getItemById(itemId);
                    if (fetched != null) itemCache.put(itemId, fetched);
                    return fetched;
                };

                java.util.Comparator<Listing> byPrice = (a, b) -> {
                    Item ia = getItem.apply(a.getItemId());
                    Item ib = getItem.apply(b.getItemId());
                    double pa = ia != null ? ia.getPricePerDay() : Double.MAX_VALUE;
                    double pb = ib != null ? ib.getPricePerDay() : Double.MAX_VALUE;
                    return Double.compare(pa, pb);
                };

                if ("price_desc".equals(sort)) {
                    byPrice = byPrice.reversed();
                }
                sorted.sort(byPrice);
                break;
            }
            default:
                // Unknown sort -> do nothing
                break;
        }

        return sorted;
    }

    private List<Map<String, Object>> createEnhancedListings(List<Listing> listings) {
        List<Map<String, Object>> enhancedListings = new ArrayList<>();
        
        for (Listing listing : listings) {
            Map<String, Object> enhancedListing = new HashMap<>();
            
            // Get related data
            Item item = itemService.getItemById(listing.getItemId());
            Category category = item != null ? categoryService.getCategoryById(item.getCategoryId()) : null;
            City city = cityService.getAllCities().stream()
                    .filter(c -> c.getId() == listing.getCityId())
                    .findFirst()
                    .orElse(null);
            User partner = item != null ? userService.getUserById(item.getPartnerId()) : null;
            Image firstImage = item != null ? imageService.getFirstImageByItemId(item.getId()) : null;
            
            ListingService service = new ListingService();
            ListingService.ListingViewModel vm = service.getListingDetails(listing.getId());
            

            // Build enhanced listing
            enhancedListing.put("listing", listing);
            enhancedListing.put("item", item);
            enhancedListing.put("category", category);
            enhancedListing.put("city", city);
            enhancedListing.put("partner", partner);
            enhancedListing.put("firstImage", firstImage);


            
            enhancedListing.put("reviewCount", vm.reviewCount);
            enhancedListing.put("averageRating", vm.averageRating);
            
            enhancedListings.add(enhancedListing);
        }
        
        return enhancedListings;
    }

}