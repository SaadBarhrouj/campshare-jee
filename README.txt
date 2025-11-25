========================================================================
PROJET : Plateforme CampShare (JEE)
MODULE : Technologie d’Entreprise
ÉCOLE  : ENSA Tétouan
ANNÉE  : 2025/2026
========================================================================

MEMBRES DU GROUPE :
1. BARHROUJ Saad
2. [Nom Étudiant 2]
3. [Nom Étudiant 3]
4. [Nom Étudiant 4]

========================================================================
1. PRÉREQUIS TECHNIQUES
========================================================================
Pour exécuter ce projet, assurez-vous d'avoir installé :
- Java Development Kit (JDK) : Version 1.8 ou supérieure.
- Serveur d'application : Apache Tomcat 9.
- Base de données : MySQL (Version 5.7 ou 8.0).
- Navigateur Web : Chrome, Firefox ou Edge.

Les bibliothèques nécessaires (MySQL Connector, JSTL, jBcrypt, Gson, etc.) 
sont déjà incluses dans le dossier : /src/main/webapp/WEB-INF/lib/

========================================================================
2. CONFIGURATION DE LA BASE DE DONNÉES
========================================================================
1. Ouvrez votre gestionnaire MySQL (phpMyAdmin, Workbench ou Terminal).
2. Créez une base de données vide nommée : campshare_db
3. Importez le fichier SQL fourni : "campshare_db_full.sql".
   (Ce fichier contient la structure des tables ET les données de test).

IMPORTANT - CONNEXION JDBC :
Si votre mot de passe MySQL n'est pas vide, veuillez le modifier dans le code :
Fichier : src/main/java/com/campshare/utils/DatabaseManager.java
Ligne   : private static final String PASSWORD = ""; // Mettre votre mot de passe ici

========================================================================
3. CONFIGURATION DU DOSSIER D'IMAGES (UPLOADS)
========================================================================
Le projet stocke les images (avatars, CIN, équipements) en dehors du dossier 
de déploiement pour éviter leur suppression lors des redémarrages serveur.

1. Créez un dossier nommé "campshare_uploads" sur votre disque (ex: C:/campshare_uploads).
2. Vérifiez le chemin configuré dans la classe utilitaire :
   Fichier : src/main/java/com/campshare/utils/FileUploadUtil.java
   Variable : UPLOAD_DIR

Note : Le fichier SQL fourni contient des liens vers des images. Pour que les 
avatars de test s'affichent, copiez le contenu du dossier "ressources_images" 
fourni dans votre dossier "campshare_uploads".

========================================================================
4. INSTALLATION ET DÉMARRAGE
========================================================================
Méthode 1 : Déploiement WAR (Classique)
1. Exportez le projet en fichier .WAR.
2. Placez le fichier dans le dossier "webapps" de Tomcat.
3. Lancez Tomcat (bin/startup.bat).

Méthode 2 : Via IDE (Eclipse / IntelliJ / VS Code)
1. Importez le projet en tant que "Dynamic Web Project".
2. Ajoutez le serveur Tomcat à l'IDE.
3. Ajoutez le projet au serveur et cliquez sur "Run".

L'application sera accessible à l'adresse : 
http://localhost:8080/CampShare/

========================================================================
5. SCÉNARIOS DE TEST & IDENTIFIANTS
========================================================================
La base de données est pré-remplie avec des comptes fonctionnels.

A. COMPTE ADMINISTRATEUR (Accès complet Dashboard, Gestion Utilisateurs)
   - Email : admin@campshare.com
   - Mot de passe : [Mettre le mot de passe ici, ex: admin123]

B. COMPTE PARTENAIRE (Propriétaire d'équipements)
   - Email : partner@email.com
   - Mot de passe : [Mettre le mot de passe ici]
   - Données : Possède 3 annonces actives et 2 réservations en attente.

C. COMPTE CLIENT (Locataire)
   - Email : client@email.com
   - Mot de passe : [Mettre le mot de passe ici]
   - Données : A effectué une réservation récente.

========================================================================
FIN DU README
========================================================================