package com.campshare.model;

public class Image {
  private long id;
  private long itemId;
  private String url;

  public Image() {
  }

  public Image(long id, long itemId, String url) {
    this.id = id;
    this.itemId = itemId;
    this.url = url;
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

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  @Override
  public String toString() {
    return "Image{" +
        "id=" + id +
        ", itemId=" + itemId +
        ", url='" + url + '\'' +
        '}';
  }
}