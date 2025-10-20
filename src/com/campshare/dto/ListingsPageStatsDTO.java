package com.campshare.dto;

public class ListingsPageStatsDTO {
  private long total;
  private long active;
  private long archived;
  private double activePercentage;
  private double archivedPercentage;

  public long getTotal() {
    return total;
  }

  public long getActive() {
    return active;
  }

  public long getArchived() {
    return archived;
  }

  public double getActivePercentage() {
    return activePercentage;
  }

  public double getArchivedPercentage() {
    return archivedPercentage;
  }

  public void setTotal(long total) {
    this.total = total;
  }

  public void setActive(long active) {
    this.active = active;
  }

  public void setArchived(long archived) {
    this.archived = archived;
  }

  public void setActivePercentage(double activePercentage) {
    this.activePercentage = activePercentage;
  }

  public void setArchivedPercentage(double archivedPercentage) {
    this.archivedPercentage = archivedPercentage;
  }
}