package com.campshare.dto;

public class AdminDashboardStatsDTO {

  private long totalUsers;
  private long totalClients;
  private long totalPartners;
  private long totalListings;
  private long totalReservations;

  public long getTotalUsers() {
    return totalUsers;
  }

  public void setTotalUsers(long totalUsers) {
    this.totalUsers = totalUsers;
  }

  public long getTotalClients() {
    return totalClients;
  }

  public void setTotalClients(long totalClients) {
    this.totalClients = totalClients;
  }

  public long getTotalPartners() {
    return totalPartners;
  }

  public void setTotalPartners(long totalPartners) {
    this.totalPartners = totalPartners;
  }

  public long getTotalListings() {
    return totalListings;
  }

  public void setTotalListings(long totalListings) {
    this.totalListings = totalListings;
  }

  public long getTotalReservations() {
    return totalReservations;
  }

  public void setTotalReservations(long totalReservations) {
    this.totalReservations = totalReservations;
  }
}