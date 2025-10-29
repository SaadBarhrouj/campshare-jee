package com.campshare.service;

import com.campshare.dao.impl.ListingDAOImpl;
import com.campshare.dao.impl.ItemDAOImpl;
import com.campshare.dao.impl.CityDAOImpl;
import com.campshare.dao.impl.CategoryDAOImpl;
import com.campshare.dao.impl.ImageDAOImpl;
import com.campshare.dao.impl.ReviewDAOImpl;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.dao.interfaces.ListingDAO;
import com.campshare.dao.interfaces.ItemDAO;
import com.campshare.dao.interfaces.CityDAO;
import com.campshare.dao.interfaces.CategoryDAO;
import com.campshare.dao.interfaces.ImageDAO;
import com.campshare.dao.interfaces.ReviewDAO;
import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dto.ListingsPageStatsDTO;
import com.campshare.model.Category;
import com.campshare.model.City;
import com.campshare.model.Image;
import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.Review;
import com.campshare.model.User;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ListingService {
  private ListingDAO listingDAO = new ListingDAOImpl();
  private ItemDAO itemDAO = new ItemDAOImpl();
  private CityDAO cityDAO = new CityDAOImpl();
  private CategoryDAO categoryDAO = new CategoryDAOImpl();
  private ImageDAO imageDAO = new ImageDAOImpl();
  private ReviewDAO reviewDAO = new ReviewDAOImpl();
  private UserDAO userDAO = new UserDAOImpl();

  public static class ListingViewModel {
    public Listing listing;
    public Item item;
    public Category category;
    public City city;
    public User partner;
    public Image firstImage;
    public List<Review> reviews;
    public long reviewCount;
    public double averageRating;
    public Map<Integer, Integer> ratingPercentages;

    // Expose getters for JSP EL property access
    public Listing getListing() { return listing; }
    public Item getItem() { return item; }
    public Category getCategory() { return category; }
    public City getCity() { return city; }
    public User getPartner() { return partner; }
    public Image getFirstImage() { return firstImage; }
    public List<Review> getReviews() { return reviews; }
    public long getReviewCount() { return reviewCount; }
    public double getAverageRating() { return averageRating; }
    public Map<Integer, Integer> getRatingPercentages() { return ratingPercentages; }
  }

  public List<ListingViewModel> getAllListingsWithRelations() {
    System.out.println("ListingService: Starting getAllListingsWithRelations");
    
    List<Listing> listings = listingDAO.findAll();
    System.out.println("ListingService: Found " + (listings != null ? listings.size() : 0) + " raw listings");
    
    List<ListingViewModel> result = new ArrayList<>();

    // Preload cities for quick map
    Map<Long, City> cityCache = new HashMap<>();
    try {
      for (City c : cityDAO.findAll()) {
        cityCache.put(c.getId(), c);
      }
      System.out.println("ListingService: Loaded " + cityCache.size() + " cities into cache");
    } catch (Exception e) {
      System.err.println("ListingService: Error loading cities: " + e.getMessage());
    }

    for (Listing l : listings) {
      System.out.println("ListingService: Processing listing ID " + l.getId());
      ListingViewModel vm = new ListingViewModel();
      vm.listing = l;

      // Item + relationships
      Item item = fetchItemById(l.getItemId());
      vm.item = item;
      if (item != null) {
        System.out.println("ListingService: Found item " + item.getId() + " for listing " + l.getId());
        // Get category
        vm.category = categoryDAO.findById(item.getCategoryId());
        
        // Get partner
        vm.partner = fetchPartnerById(item.getPartnerId());
        
        // Get first image
        vm.firstImage = imageDAO.findFirstByItemId(item.getId());
        
        // Get review data
        vm.reviews = reviewDAO.findByItemId(item.getId());
        vm.reviewCount = reviewDAO.countByItemId(item.getId());
        vm.averageRating = reviewDAO.getAverageRatingByItemId(item.getId());
        vm.ratingPercentages = calculateRatingPercentages(vm.reviews);
      } else {
        System.out.println("ListingService: No item found for listing " + l.getId());
      }

      // City
      vm.city = cityCache.get(l.getCityId());

      result.add(vm);
    }
    System.out.println("ListingService: Returning " + result.size() + " processed listings");
    return result;
  }

  public ListingViewModel getListingDetails(long listingId) {
    Listing l = listingDAO.findById(listingId);
    if (l == null) return null;
    ListingViewModel vm = new ListingViewModel();
    vm.listing = l;
    vm.city = getCityById(l.getCityId());
    Item item = fetchItemById(l.getItemId());
    vm.item = item;
    if (item != null) {
      vm.category = categoryDAO.findById(item.getCategoryId());
      vm.partner = fetchPartnerById(item.getPartnerId());
      vm.firstImage = imageDAO.findFirstByItemId(item.getId());
      
      // Get review data
      vm.reviews = reviewDAO.findByItemId(item.getId());
      vm.reviewCount = reviewDAO.countByItemId(item.getId());
      vm.averageRating = reviewDAO.getAverageRatingByItemId(item.getId());
      vm.ratingPercentages = calculateRatingPercentages(vm.reviews);
    }
    return vm;
  }

  private Item fetchItemById(long itemId) {
    try {
      Item item = itemDAO.findById(itemId);
      if (item == null) {
        System.out.println("ListingService: No item found for ID " + itemId);
      }
      return item;
    } catch (Exception e) {
      System.err.println("ListingService: Error fetching item " + itemId + ": " + e.getMessage());
      return null;
    }
  }

  private User fetchPartnerById(long partnerId) {
    try {
      User partner = userDAO.findById(partnerId);
      if (partner == null) {
        System.out.println("ListingService: No partner found for ID " + partnerId);
      }
      return partner;
    } catch (Exception e) {
      System.err.println("ListingService: Error fetching partner " + partnerId + ": " + e.getMessage());
      return null;
    }
  }

  private City getCityById(long cityId) {
    // CityDAO has only findAll. Fallback to cache via findAll above or direct simple map here
    for (City c : cityDAO.findAll()) {
      if (c.getId() == cityId) return c;
    }
    return null;
  }

  private Map<Integer, Integer> calculateRatingPercentages(List<Review> reviews) {
    Map<Integer, Integer> percentages = new LinkedHashMap<>();
    
    // Initialize all ratings to 0
    for (int i = 1; i <= 5; i++) {
      percentages.put(i, 0);
    }
    
    if (reviews == null || reviews.isEmpty()) {
      return percentages;
    }
    
    // Count ratings
    Map<Integer, Integer> ratingCounts = new HashMap<>();
    for (Review review : reviews) {
      int rating = review.getRating();
      ratingCounts.put(rating, ratingCounts.getOrDefault(rating, 0) + 1);
    }
    
    // Calculate percentages
    int totalReviews = reviews.size();
    for (int i = 1; i <= 5; i++) {
      int count = ratingCounts.getOrDefault(i, 0);
      int percentage = totalReviews > 0 ? Math.round((count * 100.0f) / totalReviews) : 0;
      percentages.put(i, percentage);
    }
    
    return percentages;
  }



  public List<Listing> getAllListings() {
        return listingDAO.findAll();
    }

    public Listing getListingById(long id) {
        return listingDAO.findById(id);
    }

    public long getListingsCount() {
        return listingDAO.countAll();
    }

    public List<Listing> getListingsByCityId(long cityId) {
        return listingDAO.findByCityId(cityId);
    }

    public List<Listing> getListingsByStatus(String status) {
        return listingDAO.findByStatus(status);
    }

    public List<Listing> getListingsByItemId(long itemId) {
        return listingDAO.findByItemId(itemId);
    }

    public List<Listing> getActiveListings() {
        return listingDAO.findActiveListings();
    }

    public List<Listing> getListingsByCategoryId(long categoryId) {
        return listingDAO.findByCategoryId(categoryId);
    }

    public List<Listing> getListingsByPriceRange(double minPrice, double maxPrice) {
        return listingDAO.findByPriceRange(minPrice, maxPrice);
    }

    public List<Listing> searchListingsByTitle(String searchTerm) {
        return listingDAO.searchByTitle(searchTerm);
    }

    public List<Listing> getListingsByCityAndCategory(long cityId, long categoryId) {
        return listingDAO.findByCityAndCategory(cityId, categoryId);
    }








    public List<Listing> getRecentListings(int limit) {
    return listingDAO.findRecent(limit);
  }


  public Listing getListingDetailsById(long listingId) {
    return listingDAO.findInfoById(listingId);
  }

  public boolean updateListingStatus(long listingId, String newStatus) {
    return listingDAO.updateStatus(listingId, newStatus);
  }

  public boolean deleteListing(long listingId) {
    return listingDAO.delete(listingId);
  }

  public ListingsPageStatsDTO getListingPageStats() {
    ListingsPageStatsDTO stats = new ListingsPageStatsDTO();

    long total = listingDAO.countAll();
    long active = listingDAO.countAllActive();
    long archived = listingDAO.countAllArchived();

    stats.setTotal(total);
    stats.setActive(active);
    stats.setArchived(archived);

    if (total > 0) {
      stats.setActivePercentage(((double) active / total) * 100.0);
      stats.setArchivedPercentage(((double) archived / total) * 100.0);
    } else {
      stats.setActivePercentage(0.0);
      stats.setArchivedPercentage(0.0);
    }

    return stats;
  }

  public List<ListingViewModel> getPartnerListingsWithRelations(long partnerId) {
    System.out.println("ListingService: Starting getPartnerListingsWithRelations for partner " + partnerId);
    
    List<Listing> listings = listingDAO.findByPartnerId(partnerId);
    System.out.println("ListingService: Found " + (listings != null ? listings.size() : 0) + " raw listings for partner");
    
    List<ListingViewModel> result = new ArrayList<>();

    // Preload cities for quick map
    Map<Long, City> cityCache = new HashMap<>();
    try {
      for (City c : cityDAO.findAll()) {
        cityCache.put(c.getId(), c);
      }
      System.out.println("ListingService: Loaded " + cityCache.size() + " cities into cache");
    } catch (Exception e) {
      System.err.println("ListingService: Error loading cities: " + e.getMessage());
    }

    for (Listing l : listings) {
      System.out.println("ListingService: Processing listing ID " + l.getId());
      ListingViewModel vm = new ListingViewModel();
      vm.listing = l;

      // Item + relationships
      Item item = fetchItemById(l.getItemId());
      vm.item = item;
      if (item != null) {
        System.out.println("ListingService: Found item " + item.getId() + " for listing " + l.getId());
        // Get category
        vm.category = categoryDAO.findById(item.getCategoryId());
        
        // Get partner
        vm.partner = fetchPartnerById(item.getPartnerId());
        
        // Get first image
        vm.firstImage = imageDAO.findFirstByItemId(item.getId());
        
        // Get review data
        vm.reviews = reviewDAO.findByItemId(item.getId());
        vm.reviewCount = reviewDAO.countByItemId(item.getId());
        vm.averageRating = reviewDAO.getAverageRatingByItemId(item.getId());
        vm.ratingPercentages = calculateRatingPercentages(vm.reviews);
      } else {
        System.out.println("ListingService: No item found for listing " + l.getId());
      }

      // City
      vm.city = cityCache.get(l.getCityId());

      result.add(vm);
    }
    System.out.println("ListingService: Returning " + result.size() + " processed listings for partner");
    return result;
  }
}