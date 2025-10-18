package com.campshare.model;

import java.util.Date;

public class Reservation {
    private long id;
    private Date startDate;
    private Date endDate;
    private String status;
    private boolean deliveryOption;
    private long clientId;
    private long partnerId;
    private long listingId;
    private Date createdAt;
    //////////////////////

    private User client;  
    private User partner;  
    private Listing listing;


    


    public User getClient() { return client; }
    public void setClient(User client) { this.client = client; }

    public User getPartner() { return partner; }
    public void setPartner(User partner) { this.partner = partner; }

    public Listing getListing() { return listing; }
    public void setListing(Listing listing) { this.listing = listing; }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}