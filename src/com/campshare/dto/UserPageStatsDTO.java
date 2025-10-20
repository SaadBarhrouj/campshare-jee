package com.campshare.dto;

public class UserPageStatsDTO {
  private long total;
  private long active;
  private long inactive;
  private double activePercentage;
  private double inactivePercentage;

  public long getTotal() {
    return total;
  }

  public void setTotal(long total) {
    this.total = total;
  }

  public long getActive() {
    return active;
  }

  public void setActive(long active) {
    this.active = active;
  }

  public long getInactive() {
    return inactive;
  }

  public void setInactive(long inactive) {
    this.inactive = inactive;
  }

  public double getActivePercentage() {
    return activePercentage;
  }

  public void setActivePercentage(double activePercentage) {
    this.activePercentage = activePercentage;
  }

  public double getInactivePercentage() {
    return inactivePercentage;
  }

  public void setInactivePercentage(double inactivePercentage) {
    this.inactivePercentage = inactivePercentage;
  }
}