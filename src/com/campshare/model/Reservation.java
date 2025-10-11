package com.campshare.model;

import java.sql.Timestamp;
import java.time.LocalDate;

public class Reservation {

  private long id;
  private LocalDate startDate;
  private LocalDate endDate;
  private String status;
  private boolean deliveryOption;
  private long clientId;
  private long partnerId;
  private long listingId;
  private Timestamp createdAt;

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public LocalDate getStartDate() {
    return startDate;
  }

  public void setStartDate(LocalDate startDate) {
    this.startDate = startDate;
  }

  public LocalDate getEndDate() {
    return endDate;
  }

  public void setEndDate(LocalDate endDate) {
    this.endDate = endDate;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public boolean isDeliveryOption() {
    return deliveryOption;
  }

  public void setDeliveryOption(boolean deliveryOption) {
    this.deliveryOption = deliveryOption;
  }

  public long getClientId() {
    return clientId;
  }

  public void setClientId(long clientId) {
    this.clientId = clientId;
  }

  public long getPartnerId() {
    return partnerId;
  }

  public void setPartnerId(long partnerId) {
    this.partnerId = partnerId;
  }

  public long getListingId() {
    return listingId;
  }

  public void setListingId(long listingId) {
    this.listingId = listingId;
  }

  public Timestamp getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }
}