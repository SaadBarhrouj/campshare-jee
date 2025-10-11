package com.campshare.dto;

import java.time.LocalDate;

public class DailyRegistrationStatsDTO {
  private LocalDate date;
  private String role;
  private int count;

  public LocalDate getDate() {
    return date;
  }

  public void setDate(LocalDate date) {
    this.date = date;
  }

  public String getRole() {
    return role;
  }

  public void setRole(String role) {
    this.role = role;
  }

  public int getCount() {
    return count;
  }

  public void setCount(int count) {
    this.count = count;
  }
}