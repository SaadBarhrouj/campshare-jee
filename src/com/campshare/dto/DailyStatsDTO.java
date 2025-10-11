package com.campshare.dto;

import java.time.LocalDate;

public class DailyStatsDTO {

    private LocalDate date;
    private long count;

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        this.count = count;
    }
}