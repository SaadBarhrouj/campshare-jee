package com.campshare.model;

import java.sql.Timestamp;
import java.util.List;

public class Item {
    private long id;
    private long partnerId;
    private String title;
    private String description;
    private double pricePerDay;
    private long categoryId;
    private Timestamp createdAt;

    // Relationships
    private List<Review> reviews;
    private List<Image> images;   
    private Category category;
    private User partner; 

    // Default Constructor
    public Item() {}

    // Parameterized Constructor
    public Item(long id, long partnerId, String title, String description, double pricePerDay, long categoryId, Timestamp createdAt) {
        this.id = id;
        this.partnerId = partnerId;
        this.title = title;
        this.description = description;
        this.pricePerDay = pricePerDay;
        this.categoryId = categoryId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Relationship Getters and Setters
    public void setImages(List<Image> images) {
        this.images = images;
    }
    public List<Image> getImages() {
        return images;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
    public Category getCategory() {
        return category;
    }

    public void setReviews(List<Review> reviews) {
        this.reviews = reviews;
    }

    public List<Review> getReviews() {
        return reviews;
    }

    public User getPartner() {
        return partner;
    }
    public void setPartner(User partner) {
        this.partner = partner;
    }

    // Business logic methods
    public boolean hasImages() {
        return images != null && !images.isEmpty();
    }

    public boolean hasReviews() {
        return reviews != null && !reviews.isEmpty();
    }

    public double getAverageRating() {
        if (reviews == null || reviews.isEmpty()) return 0.0;
        return reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }

    public int getReviewCount() {
        return reviews != null ? reviews.size() : 0;
    }

    // toString
    @Override
    public String toString() {
        return "Item{" +
                "id=" + id +
                ", partnerId=" + partnerId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", pricePerDay=" + pricePerDay +
                ", categoryId=" + categoryId +
                ", createdAt=" + createdAt +
                '}';
    }
}
