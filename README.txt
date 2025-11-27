========================================================================
PROJET : Plateforme CampShare (JEE)
MODULE : Technologie d’Entreprise
ÉCOLE  : ENSA Tétouan
ANNÉE  : 2025/2026
========================================================================

MEMBRES DU GROUPE :
1. BARHROUJ Saad        <saad.barhrouj@etu.uae.ac.ma>
2. EL HAUARI Mohamed    <elhauari.imohamed@etu.uae.ac.ma>
3. EL ABIDA Rajae       <elabida.rajae@etu.uae.ac.ma>
4. MAROUN Ilias         <maroun.ilias@etu.uae.ac.ma>

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
   (Ce fichier contient la structure complète des tables ET les données de test).

IMPORTANT - CONNEXION JDBC :
Si votre mot de passe MySQL local n'est pas vide, veuillez le modifier ici :
Fichier : src/main/java/com/campshare/util/DatabaseManager.java
Ligne   : private static final String DB_PASSWORD = ""; // Mettre votre mot de passe

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
1. Exportez le projet en fichier .WAR nommé "webapp.war".
2. Placez le fichier dans le dossier "webapps" de Tomcat.
3. Lancez Tomcat (bin/startup.bat).

Méthode 2 : Via IDE (Eclipse / VS Code)
1. Importez le projet (Dynamic Web Project).
2. Ajoutez le projet au serveur Tomcat configuré.
3. Lancez le serveur.

L'application sera accessible à l'adresse : 
http://localhost:8080/webapp/

========================================================================
5. SCÉNARIOS DE TEST & FONCTIONNALITÉS CLÉS
========================================================================
Les mots de passe sont stockés sous forme cryptée. 
Pour faciliter la correction, un mot de passe universel est utilisé.

MOT DE PASSE UNIVERSEL : password#123

A. RÔLE ADMINISTRATEUR (Vue globale)
   - Email : saad.admin@campshare.com
   - Fonctionnalités à tester :
     * Dashboard : Visualisation des statistiques graphiques dynamiques.
     * Gestion : Gestion complète des clients, partenaires, annonces, réservations et avis.
     * Profil : Consultation et modification du profil administrateur.

B. RÔLE PARTENAIRE (Offre d'équipement)
   - Email : zineb.saidi@email.com
   - Fonctionnalités à tester :
     * Annonces : Poster et gérer ses équipements.
     * Réservations : Traiter (Accepter/Refuser) les demandes entrantes.
     * Évaluation : Noter les clients après une location terminée.

C. RÔLE CLIENT (Recherche et Location)
   - Email : ayoub.belkadi@email.com
   - Fonctionnalités à tester :
     * Exploration : Accéder au catalogue complet via le bouton "Explorer matériel" en page d'accueil.
     * Détails : Consulter la fiche technique et les photos d'une annonce.
     * Réservation : Effectuer une demande de réservation sur une annonce.
     * Évaluation : Laisser un avis sur l'équipement et le partenaire.
     * Profil : Gestion du profil personnel et consultation de l'historique.

========================================================================
6. AUTOMATISATION & TÂCHES DE FOND (CRON JOB)
========================================================================
L'application intègre un listener (Tâche automatique) qui vérifie l'état des
réservations à chaque démarrage du serveur (ou périodiquement).

Fonctionnement :
Le système détecte les réservations dont la date de fin est passée mais 
qui sont encore au statut "Confirmed". Il les passe automatiquement 
au statut "Completed" et génère les notifications pour demander les avis.

TESTER CETTE FONCTIONNALITÉ :
Si vous voyez des réservations expirées mais non complétées dans la base :
1. Redémarrez simplement le serveur Tomcat.
2. Connectez-vous : vous verrez que les statuts sont passés à "Completed".
3. Les utilisateurs concernés auront reçu une notification "Évaluer l'équipement".

========================================================================
FIN DU README
========================================================================
