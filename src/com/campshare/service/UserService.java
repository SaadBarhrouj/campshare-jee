package com.campshare.service;

import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dao.impl.UserDAOImpl;
import com.campshare.model.User;
import com.campshare.util.PasswordUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class UserService {

    private UserDAO userDAO = new UserDAOImpl();

    public User loginUser(String email, String plainPassword) {
        User user = userDAO.findByEmail(email);

        if (user == null || !user.isActive()) {
            return null;
        }

        if (PasswordUtils.checkPassword(plainPassword, user.getPassword())) {
            return user;
        } else {
            return null;
        }
    }

    public List<String> registerUser(User user, String plainPassword, String passwordConfirmation) {
        List<String> errors = new ArrayList<>();

        if (user.getFirstName() == null || user.getFirstName().trim().isEmpty()) {
            errors.add("Le prénom est requis.");
        }
        if (user.getLastName() == null || user.getLastName().trim().isEmpty()) {
            errors.add("Le nom est requis.");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            errors.add("Le pseudonyme est requis.");
        } else if (userDAO.findByUsername(user.getUsername()) != null) {
            errors.add("Ce pseudonyme est déjà utilisé.");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            errors.add("L'email est requis.");
        } else if (!isValidEmail(user.getEmail())) {
            errors.add("Format d'email invalide.");
        } else if (userDAO.findByEmail(user.getEmail()) != null) {
            errors.add("Cet email est déjà enregistré.");
        }
        if (user.getPhoneNumber() == null || user.getPhoneNumber().trim().isEmpty()) {
            errors.add("Le numéro de téléphone est requis.");
        }
        if (user.getAddress() == null || user.getAddress().trim().isEmpty()) {
            errors.add("L'adresse est requise.");
        }
        if (user.getCityId() <= 0) {
            errors.add("La ville est requise.");
        }
        if (plainPassword == null || plainPassword.isEmpty()) {
            errors.add("Le mot de passe est requis.");
        } else if (!plainPassword.equals(passwordConfirmation)) {
            errors.add("Les mots de passe ne correspondent pas.");
        } else if (!isValidPassword(plainPassword)) {
            errors.add(
                    "Le mot de passe doit contenir au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial.");
        }

        if (!errors.isEmpty()) {
            return errors;
        }

        String hashedPassword = PasswordUtils.hashPassword(plainPassword);
        user.setPassword(hashedPassword);

        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("client");
        }
        user.setActive(true);

        try {
            userDAO.save(user);
            return errors;
        } catch (RuntimeException e) {
            e.printStackTrace();
            errors.add("Erreur lors de l'enregistrement de l'utilisateur : " + e.getMessage());
            return errors;
        }
    }

    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }

    public User getUserById(long id) {
        return userDAO.findById(id);
    }

    public void updateUserStatus(long userId, boolean isActive) {
        userDAO.updateStatus(userId, isActive);
    }

    public long getUserCountByRole(String role) {
        return userDAO.countByRole(role);
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        Pattern pattern = Pattern.compile(emailRegex);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }

    private boolean isValidPassword(String password) {
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
        Pattern pattern = Pattern.compile(passwordRegex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }

    public List<User> getRecentPartners(int limit) {
        return userDAO.findRecentByRole("partner", limit);
    }

    public List<User> getRecentClients(int limit) {
        return userDAO.findRecentByRole("client", limit);
    }

    public boolean changeAdminPassword(long userId, String currentPasswordPlain, String newPasswordPlain,
            String confirmPassword) {
        User currentUser = userDAO.findById(userId);
        if (currentUser == null) {
            System.err.println("changeAdminPassword: Utilisateur non trouvé pour ID " + userId);
            return false;
        }

        if (!PasswordUtils.checkPassword(currentPasswordPlain, currentUser.getPassword())) {
            System.err.println("changeAdminPassword: Ancien mot de passe incorrect pour ID " + userId);
            return false;
        }

        if (newPasswordPlain == null || newPasswordPlain.isEmpty()) {
            System.err.println("changeAdminPassword: Le nouveau mot de passe ne peut pas être vide pour ID " + userId);
            return false;
        }

        if (!isValidPassword(newPasswordPlain)) {
            System.err.println(
                    "changeAdminPassword: Le nouveau mot de passe ne respecte pas les critères de complexité pour ID "
                            + userId);

            return false;
        }
        if (!newPasswordPlain.equals(confirmPassword)) {
            System.err
                    .println("changeAdminPassword: Les nouveaux mots de passe ne correspondent pas pour ID " + userId);
            return false;
        }

        String newHashedPassword = PasswordUtils.hashPassword(newPasswordPlain);

        boolean updateSuccess = userDAO.updateUserPassword(userId, newHashedPassword);
        if (!updateSuccess) {
            System.err.println("changeAdminPassword: Échec de la mise à jour BDD pour ID " + userId);
        }
        return updateSuccess;
    }

    public List<String> validateAdminInfo(String firstName, String lastName, String email) {
        List<String> errors = new ArrayList<>();

        if (firstName == null || firstName.trim().isEmpty()) {
            errors.add("Le prénom est requis.");
        }

        if (lastName == null || lastName.trim().isEmpty()) {
            errors.add("Le nom est requis.");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.add("L'email est requis.");
        } else if (!isValidEmail(email)) {
            errors.add("Format d'email invalide.");
        }

        return errors;
    }

    public boolean updateAdminInfo(long userId, String firstName, String lastName, String email, String avatarUrl) {
        User user = new User();
        user.setId(userId);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setAvatarUrl(avatarUrl);

        return userDAO.updateUserProfile(user);
    }

    public List<User> getPaginatedUsers(String role, String searchQuery, String status, String sortBy, int limit,
            int offset) {
        return userDAO.findAndPaginateUsers(role, searchQuery, status, sortBy, limit, offset);
    }

    public int countTotalUsers(String role, String searchQuery, String status) {
        return userDAO.countUsers(role, searchQuery, status);
    }
}