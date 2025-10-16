package com.campshare.dto;

import com.campshare.model.Item;
import com.campshare.model.Listing;
import com.campshare.model.User;

public class ListingInfoDTO {

  private Listing listing;
  private Item item;
  private User partner;

  public Listing getListing() {
    return listing;
  }

  public void setListing(Listing listing) {
    this.listing = listing;
  }

  public Item getItem() {
    return item;
  }

  public void setItem(Item item) {
    this.item = item;
  }

  public User getPartner() {
    return partner;
  }

  public void setPartner(User partner) {
    this.partner = partner;
  }
}