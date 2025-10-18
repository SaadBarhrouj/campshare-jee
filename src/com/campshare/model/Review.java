package com.campshare.model;

import java.sql.Timestamp;

public class Review {
    private long id;
    private long reservationId;
    private int rating;
    private String comment;
    private boolean isVisible;
    private String type; // "forObject", "forClient", "forPartner"
    private long reviewerId;
    private long revieweeId;
    private long itemId;
    private Timestamp createdAt;

    private User reviewer;  
    private User reviewee;  
    private Item item;
    private Reservation reservation;

    public Reservation getReservation() {
        return reservation;
    }
    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public User getReviewer() {
        return reviewer;
    }

    public void setReviewer(User reviewer) {
        this.reviewer = reviewer;
    }



    // Reviewee
    public User getReviewee() {
        return reviewee;
    }

    public void setReviewee(User reviewee) {
        this.reviewee = reviewee;
    }

    // Item
    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    // Default constructor
    public Review() {
    }

    // Parameterized constructor
    public Review(long id, long reservationId, int rating, String comment, boolean isVisible, String type,
                  long reviewerId, long revieweeId, long itemId, Timestamp createdAt) {
        this.id = id;
        this.reservationId = reservationId;
        this.rating = rating;
        this.comment = comment;
        this.isVisible = isVisible;
        this.type = type;
        this.reviewerId = reviewerId;
        this.revieweeId = revieweeId;
        this.itemId = itemId;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getReservationId() {
        return reservationId;
    }

    public void setReservationId(long reservationId) {
        this.reservationId = reservationId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public boolean isVisible() {
        return isVisible;
    }

    public void setVisible(boolean visible) {
        isVisible = visible;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public long getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(long reviewerId) {
        this.reviewerId = reviewerId;
    }

    public long getRevieweeId() {
        return revieweeId;
    }

    public void setRevieweeId(long revieweeId) {
        this.revieweeId = revieweeId;
    }

    public long getItemId() {
        return itemId;
    }

    public void setItemId(long itemId) {
        this.itemId = itemId;
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
        return "Review{" +
                "id=" + id +
                ", reservationId=" + reservationId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", isVisible=" + isVisible +
                ", type='" + type + '\'' +
                ", reviewerId=" + reviewerId +
                ", revieweeId=" + revieweeId +
                ", itemId=" + itemId +
                ", createdAt=" + createdAt +
                '}';
    }
}
