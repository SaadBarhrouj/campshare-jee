package com.campshare.servlet;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class ImageServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    String userHome = System.getProperty("user.home");
    String uploadDirectory = userHome + File.separator + "campshare_uploads" + File.separator;

    String filename = request.getPathInfo();
    if (filename != null && filename.startsWith("/")) {
      filename = filename.substring(1);
    }

    if (filename == null || filename.isEmpty() || filename.contains("..")) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier invalide.");
      return;
    }

    File imageFile = new File(uploadDirectory, filename);

    if (!imageFile.exists() || imageFile.isDirectory()) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
      return;
    }

    response.setContentType(getServletContext().getMimeType(imageFile.getName()));
    response.setHeader("Cache-Control", "public, max-age=2592000");

    try (FileInputStream in = new FileInputStream(imageFile);
        ServletOutputStream out = response.getOutputStream()) {
      byte[] buffer = new byte[4096];
      int bytesRead;
      while ((bytesRead = in.read(buffer)) != -1) {
        out.write(buffer, 0, bytesRead);
      }
    }
  }
}