package com.campshare.model;

import java.sql.Timestamp;

public class Notification {
    private long id;
    private long userId;
    private String type; 
    private String message;
    private boolean isRead;
    private Long listingId;     
    private Long reservationId;  
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(long id, long userId, String type, String message, boolean isRead,
                        Long listingId, Long reservationId, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.type = type;
        this.message = message;
        this.isRead = isRead;
        this.listingId = listingId;
        this.reservationId = reservationId;
        this.createdAt = createdAt;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public Long getListingId() {
        return listingId;
    }

    public void setListingId(Long listingId) {
        this.listingId = listingId;
    }

    public Long getReservationId() {
        return reservationId;
    }

    public void setReservationId(Long reservationId) {
        this.reservationId = reservationId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    
    @Override
    public String toString() {
        return "Notification{" +
                "id=" + id +
                ", userId=" + userId +
                ", type='" + type + '\'' +
                ", message='" + message + '\'' +
                ", isRead=" + isRead +
                ", listingId=" + listingId +
                ", reservationId=" + reservationId +
                ", createdAt=" + createdAt +
                '}';
    }
}