package com.campshare.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Listing {
  private long id;
  private long itemId;
  private String status; 
  private Date startDate;
  private Date endDate;
  private long cityId;
  private Double longitude;
  private Double latitude;
  private boolean deliveryOption;
  private Timestamp createdAt;

  private Item item; 
  private City city;

  public void setCity(City city) {
    this.city = city;
  }

  public City getCity() {
    return city;
  }

  public void setItem(Item item) {
    this.item = item;
  }

  public Item getItem() {
    return item;
  }

  public Listing() {
  }

  public Listing(long id, long itemId, String status, Date startDate, Date endDate, long cityId,
      Double longitude, Double latitude, boolean deliveryOption, Timestamp createdAt) {
    this.id = id;
    this.itemId = itemId;
    this.status = status;
    this.startDate = startDate;
    this.endDate = endDate;
    this.cityId = cityId;
    this.longitude = longitude;
    this.latitude = latitude;
    this.deliveryOption = deliveryOption;
    this.createdAt = createdAt;
  }

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public long getItemId() {
    return itemId;
  }

  public void setItemId(long itemId) {
    this.itemId = itemId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  public long getCityId() {
    return cityId;
  }

  public void setCityId(long cityId) {
    this.cityId = cityId;
  }

  public Double getLongitude() {
    return longitude;
  }

  public void setLongitude(Double longitude) {
    this.longitude = longitude;
  }

  public Double getLatitude() {
    return latitude;
  }

  public void setLatitude(Double latitude) {
    this.latitude = latitude;
  }

  public boolean isDeliveryOption() {
    return deliveryOption;
  }

  public void setDeliveryOption(boolean deliveryOption) {
    this.deliveryOption = deliveryOption;
  }

  public Timestamp getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
    this.createdAt = createdAt;
  }

  @Override
  public String toString() {
    return "Listing{" +
        "id=" + id +
        ", itemId=" + itemId +
        ", status='" + status + '\'' +
        ", startDate=" + startDate +
        ", endDate=" + endDate +
        ", cityId=" + cityId +
        ", longitude=" + longitude +
        ", latitude=" + latitude +
        ", deliveryOption=" + deliveryOption +
        ", createdAt=" + createdAt +
        '}';
  }
}