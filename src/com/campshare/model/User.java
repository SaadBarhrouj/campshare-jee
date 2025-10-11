package com.campshare.model;

import java.sql.Timestamp;

public class User {

    private long id;
    private String firstName;
    private String lastName;
    private String username;
    private String email;
    private String password; 
    private String phoneNumber;
    private String address;
    private String role;
    private String avatarUrl;
    private String cinRecto;
    private String cinVerso;
    private boolean isSubscriber;
    private boolean isActive;
    private long cityId;
    private Timestamp createdAt;
    private double avgRating;
    private int reviewCount;

    public User() {}

    public double getAvgRating() {
        return avgRating;
    }
    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }
    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    public String getCinRecto() { return cinRecto; }
    public void setCinRecto(String cinRecto) { this.cinRecto = cinRecto; }
    public String getCinVerso() { return cinVerso; }
    public void setCinVerso(String cinVerso) { this.cinVerso = cinVerso; }
    public boolean isSubscriber() { return isSubscriber; }
    public void setSubscriber(boolean subscriber) { isSubscriber = subscriber; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public long getCityId() { return cityId; }
    public void setCityId(long cityId) { this.cityId = cityId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}