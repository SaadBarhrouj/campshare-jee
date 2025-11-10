package com.campshare.dto;

import com.campshare.model.Review;

public class ReviewsDTO {
  private Review reviewFromClient;
  private Review reviewFromPartner;

  public Review getReviewFromClient() {
    return reviewFromClient;
  }

  public void setReviewFromClient(Review reviewFromClient) {
    this.reviewFromClient = reviewFromClient;
  }

  public Review getReviewFromPartner() {
    return reviewFromPartner;
  }

  public void setReviewFromPartner(Review reviewFromPartner) {
    this.reviewFromPartner = reviewFromPartner;
  }
}