package com.campshare.model;

import java.sql.Timestamp;

public class Item {
    private long id;
    private long partnerId;
    private String title;
    private String description;
    private double pricePerDay;
    private long categoryId;
    private Timestamp createdAt;

    // Default constructor
    public Item() {
    }

    // Parameterized constructor
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
