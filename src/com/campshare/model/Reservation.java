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
    
    private User partner; 
    private Item item;
    private Listing listing;
    private Image image;
    private City city;
    private double montantPaye;
    private Category category;
    public double getMontantPaye() {
        return montantPaye;
    }

    public void setMontantPaye(double montantPaye) {
        this.montantPaye = montantPaye;
    }

    public User getPartner() {
        return partner;
    }
    public void setPartner(User partner) {
        this.partner = partner;
    }

    public Item getItem() {
        return item;
    }
    public void setItem(Item item) {
        this.item = item;
    }
    public Listing getListing() {
        return listing;
    }

    public void setListing(Listing listing) {
        this.listing = listing;
    }

    public Image getImage() {
        return image;
    }
    public void setImage(Image image) {
        this.image = image;
    }
    public City getCity() {
        return city;
    }
    public void setCity(City city) {
        this.city = city;
    }
    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isDeliveryOption() { return deliveryOption; }
    public void setDeliveryOption(boolean deliveryOption) { this.deliveryOption = deliveryOption; }

    public long getClientId() { return clientId; }
    public void setClientId(long clientId) { this.clientId = clientId; }

    public long getPartnerId() { return partnerId; }
    public void setPartnerId(long partnerId) { this.partnerId = partnerId; }

    public long getListingId() { return listingId; }
    public void setListingId(long listingId) { this.listingId = listingId; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
