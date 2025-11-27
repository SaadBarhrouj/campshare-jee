========================================================================
PROJET : Plateforme CampShare (JEE)
MODULE : Technologie d’Entreprise
ÉCOLE  : ENSA Tétouan
ANNÉE  : 2025/2026
========================================================================

MEMBRES DU GROUPE :
1. BARHROUJ Saad       <saad.barhrouj@etu.uae.ac.ma>
2. EL HAUARI Mohamed   <elhauari.imohamed@etu.uae.ac.ma>
3. EL ABIDA Rajae      <elabida.rajae@etu.uae.ac.ma>
4. MAROUN Ilias        <maroun.ilias@etu.uae.ac.ma>

========================================================================
1. PRÉREQUIS TECHNIQUES
========================================================================
Pour exécuter ce projet, assurez-vous d'avoir installé :
- Java Development Kit (JDK) : Version 21 (Obligatoire pour supporter les Text Blocks).
- Serveur d'application : Apache Tomcat 9 ou 10.
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
Si votre mot de passe MySQL local n'est pas vide, veuillez le modifier ici :
Fichier : src/main/java/com/campshare/utils/DatabaseManager.java
Ligne   : private static final String PASSWORD = ""; // Mettre votre mot de passe

========================================================================
3. CONFIGURATION DU DOSSIER D'IMAGES (TRÈS IMPORTANT)
========================================================================
L'application utilise le dossier utilisateur ("user.home") pour stocker les images
(photos des équipements + dossiers 'avatars' et 'cin').

Un dossier complet nommé "campshare_uploads" est fourni dans cette archive ZIP.

INSTRUCTION :
Veuillez copier/coller le dossier "campshare_uploads" fourni à la racine 
de votre dossier utilisateur principal.

Chemin final attendu sur votre PC :
- Windows : C:\Users\VotreNom\campshare_uploads\
- Mac/Linux : /home/VotreNom/campshare_uploads/

Vérification :
À l'intérieur de ce dossier sur votre disque, vous devez voir :
1. Les images (ex: tente_1_a.jpg, sac_3_a.jpg...)
2. Le dossier "avatars" (contenant les photos de profil)
3. Le dossier "cin" (contenant les documents d'identité)

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
3. Configurez le "Build Path" pour utiliser le JDK 21.
4. Ajoutez le projet au serveur et cliquez sur "Run".

L'application sera accessible à l'adresse : 
http://localhost:8080/CampShare/

========================================================================
5. SCÉNARIOS DE TEST & IDENTIFIANTS
========================================================================
Les mots de passe sont stockés sous forme hachée (cryptée) dans la base de données.
Cependant, pour permettre la correction, le mot de passe ci-dessous est valide 
pour tous les comptes de test fournis.

MOT DE PASSE UNIVERSEL (À saisir au login) : password#123

A. COMPTE ADMINISTRATEUR (Accès complet Dashboard)
   - Email : saad.admin@campshare.com
   - Mot de passe : password#123

B. COMPTE PARTENAIRE (Propriétaire d'équipements)
   - Email : zineb.saidi@email.com
   - Mot de passe : password#123

C. COMPTE CLIENT (Locataire)
   - Email : ayoub.belkadi@email.com
   - Mot de passe : password#123

========================================================================
FIN DU README
========================================================================
