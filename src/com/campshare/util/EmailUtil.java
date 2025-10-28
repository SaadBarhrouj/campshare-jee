package com.campshare.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

  private static final String SMTP_HOST = "smtp.gmail.com";
  private static final String SMTP_PORT = "587";
  private static final String EMAIL_USERNAME = "saad.barhrouj@etu.uae.ac.ma";
  private static final String EMAIL_PASSWORD = "zcylvfbzkkiaeteba";

  public static boolean sendEmail(String toAddress, String subject, String htmlBody) {
    Properties properties = new Properties();

    properties.put("mail.smtp.host", SMTP_HOST);
    properties.put("mail.smtp.port", SMTP_PORT);
    properties.put("mail.smtp.auth", "true");
    properties.put("mail.smtp.starttls.enable", "true");
    properties.put("mail.debug", "true");
    properties.put("mail.smtp.address.strict", "false");
    properties.put("mail.smtp.from", EMAIL_USERNAME);
    properties.put("mail.smtp.localhost", "localhost");

    Session session = Session.getInstance(properties, new Authenticator() {
      @Override
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
      }
    });

    session.setDebug(true);

    try {
      System.out.println("[EmailUtil] 1. Création MimeMessage...");
      Message message = new MimeMessage(session);

      System.out.println("[EmailUtil] 2. Définition de l'expéditeur (From)...");
      message.setFrom(new InternetAddress(EMAIL_USERNAME, false));

      System.out.println("[EmailUtil] 3. Définition du destinataire (To)...");
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress, false));

      System.out.println("[EmailUtil] 4. Définition du sujet...");
      message.setSubject(subject);

      System.out.println("[EmailUtil] 5. Définition du contenu...");
      message.setContent(htmlBody, "text/html; charset=utf-8");

      System.out.println("[EmailUtil] 6. Avant Transport.send()...");
      Transport.send(message);
      System.out.println("[EmailUtil] 7. Après Transport.send().");

      System.out.println("Email envoyé avec succès à " + toAddress);
      return true;

    } catch (MessagingException e) {
      System.err.println("Erreur lors de l'envoi de l'email à " + toAddress + ": " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }

  private static String escapeHtml(String input) {
    if (input == null)
      return "";
    return input.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
  }

  public static String formatClientReviewRequestEmail(
      String clientName, long reservationId, String itemName, String partnerName,
      String reviewObjectUrl, String reviewPartnerUrl) {

    String template = "<!DOCTYPE html>\n" +
        "<html lang=\"fr\">\n" +
        "<head>\n" +
        "    <meta charset=\"UTF-8\">\n" +
        "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
        "    <title>Votre avis compte - CampShare</title>\n" +
        "    <style>\n" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #4a5568; margin: 0; padding: 0; background-color: #f7fafc; }\n"
        +
        "        .email-container { max-width: 600px; margin: 20px auto; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }\n"
        +
        "        .email-header { background-color: #166534; color: #ffffff; padding: 25px 20px; text-align: center; }\n"
        +
        "        .email-header h1 { margin: 0; font-size: 24px; font-weight: bold; }\n" +
        "        .email-content { padding: 30px; }\n" +
        "        .email-content h2 { color: #166534; margin-top: 0; font-size: 20px; }\n" +
        "        .email-content p { margin-bottom: 15px; font-size: 16px; }\n" +
        "        .button-container { text-align: center; margin-top: 20px; margin-bottom: 15px; }\n" +
        "        .button { background-color: #FFAA33; color: #ffffff !important; padding: 12px 25px; text-decoration: none !important; border-radius: 5px; font-size: 16px; font-weight: bold; display: inline-block; margin: 5px 0; }\n"
        +
        "        .button:hover { background-color: #dd8e23; }\n" +
        "        .email-footer { background-color: #edf2f7; padding: 20px; text-align: center; font-size: 12px; color: #718096; border-top: 1px solid #e2e8f0; }\n"
        +
        "        .email-footer a { color: #166534; text-decoration: none; }\n" +
        "    </style>\n" +
        "</head>\n" +
        "<body>\n" +
        "    <div class=\"email-container\">\n" +
        "        <div class=\"email-header\">\n" +
        "            <h1>CampShare - Partagez votre expérience !</h1>\n" +
        "        </div>\n" +
        "        <div class=\"email-content\">\n" +
        "            <h2>Bonjour %s,</h2>\n" +
        "            <p>Votre réservation #%d pour l'équipement <strong>\"%s\"</strong> avec le partenaire <strong>%s</strong> s'est récemment terminée.</p>\n"
        +
        "            <p>Pour nous aider à améliorer CampShare et à guider les autres membres, nous vous serions reconnaissants de prendre quelques instants pour partager votre avis :</p>\n"
        +
        "            <div class=\"button-container\">\n" +
        "                <a href=\"%s\" class=\"button\">Évaluer l'équipement \"%s\"</a>\n" +
        "            </div>\n" +
        "            <div class=\"button-container\" style=\"margin-top: 10px;\">\n" +
        "                <a href=\"%s\" class=\"button\">Évaluer le partenaire %s</a>\n" +
        "            </div>\n" +
        "            <p>Vos retours sont précieux !</p>\n" +
        "        </div>\n" +
        "        <div class=\"email-footer\">\n" +
        "            Ceci est un e-mail automatique, merci de ne pas y répondre.<br>\n" +
        "            © 2024 CampShare. Tous droits réservés. <br>\n" +
        "            CampShare est un service de ParentCo.\n" +
        "        </div>\n" +
        "    </div>\n" +
        "</body>\n" +
        "</html>";

    return String.format(template,
        escapeHtml(clientName),
        reservationId,
        escapeHtml(itemName),
        escapeHtml(partnerName),
        reviewObjectUrl,
        escapeHtml(itemName),
        reviewPartnerUrl,
        escapeHtml(partnerName));
  }

  public static String formatPartnerReviewRequestEmail(
      String partnerName, long reservationId, String itemName, String clientName, String reviewClientUrl) {

    String template = "<!DOCTYPE html>\n" +
        "<html lang=\"fr\">\n" +
        "<head>\n" +
        "    <meta charset=\"UTF-8\">\n" +
        "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
        "    <title>Évaluez votre client - CampShare</title>\n" +
        "    <style>\n" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #4a5568; margin: 0; padding: 0; background-color: #f7fafc; }\n"
        +
        "        .email-container { max-width: 600px; margin: 20px auto; background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }\n"
        +
        "        .email-header { background-color: #166534; color: #ffffff; padding: 25px 20px; text-align: center; }\n"
        +
        "        .email-header h1 { margin: 0; font-size: 24px; font-weight: bold; }\n" +
        "        .email-content { padding: 30px; }\n" +
        "        .email-content h2 { color: #166534; margin-top: 0; font-size: 20px; }\n" +
        "        .email-content p { margin-bottom: 15px; font-size: 16px; }\n" +
        "        .button-container { text-align: center; margin-top: 25px; margin-bottom: 20px; }\n" +
        "        .button { background-color: #FFAA33; color: #ffffff !important; padding: 12px 25px; text-decoration: none !important; border-radius: 5px; font-size: 16px; font-weight: bold; display: inline-block; }\n"
        +
        "        .button:hover { background-color: #dd8e23; }\n" +
        "        .email-footer { background-color: #edf2f7; padding: 20px; text-align: center; font-size: 12px; color: #718096; border-top: 1px solid #e2e8f0; }\n"
        +
        "        .email-footer a { color: #166534; text-decoration: none; }\n" +
        "    </style>\n" +
        "</head>\n" +
        "<body>\n" +
        "    <div class=\"email-container\">\n" +
        "        <div class=\"email-header\">\n" +
        "            <h1>CampShare - Évaluation de votre locataire</h1>\n" +
        "        </div>\n" +
        "        <div class=\"email-content\">\n" +
        "            <h2>Bonjour %s,</h2>\n" +
        "            <p>La location de votre équipement <strong>\"%s\"</strong> (Réservation #%d) par le client <strong>%s</strong> s'est récemment terminée.</p>\n"
        +
        "            <p>Pour aider notre communauté de partenaires et de clients, pourriez-vous prendre un instant pour évaluer votre expérience avec %s ?</p>\n"
        +
        "            <div class=\"button-container\">\n" +
        "                <a href=\"%s\" class=\"button\">Évaluer le client %s</a>\n" +
        "            </div>\n" +
        "            <p>Vos retours sont importants pour maintenir une plateforme de confiance.</p>\n" +
        "        </div>\n" +
        "        <div class=\"email-footer\">\n" +
        "            Ceci est un e-mail automatique, merci de ne pas y répondre.<br>\n" +
        "            © 2024 CampShare. Tous droits réservés. <br>\n" +
        "            CampShare est un service de ParentCo.\n" +
        "        </div>\n" +
        "    </div>\n" +
        "</body>\n" +
        "</html>";

    return String.format(template,
        escapeHtml(partnerName),
        escapeHtml(itemName),
        reservationId,
        escapeHtml(clientName),
        escapeHtml(clientName),
        reviewClientUrl,
        escapeHtml(clientName));
  }
}