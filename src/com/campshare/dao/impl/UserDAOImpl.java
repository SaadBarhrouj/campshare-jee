package com.campshare.dao.impl;

import com.campshare.dao.interfaces.UserDAO;
import com.campshare.dto.DailyRegistrationStatsDTO;
import com.campshare.model.User;
import com.campshare.util.DatabaseManager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche de l'utilisateur par email: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par email.", e);
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche de l'utilisateur par username: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par username.", e);
        }
        return null;
    }

    @Override
    public List<DailyRegistrationStatsDTO> getDailyRegistrationStats(int days) {
        List<DailyRegistrationStatsDTO> stats = new ArrayList<>();

        String sql = "SELECT DATE(created_at) as registration_date, role, COUNT(*) as count " +
                "FROM users " +
                "WHERE created_at >= CURDATE() - INTERVAL ? DAY " +
                "GROUP BY registration_date, role " +
                "ORDER BY registration_date DESC";

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, days - 1);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    DailyRegistrationStatsDTO dto = new DailyRegistrationStatsDTO();
                    dto.setDate(rs.getDate("registration_date").toLocalDate());
                    dto.setRole(rs.getString("role"));
                    dto.setCount(rs.getInt("count"));
                    stats.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    @Override
    public void save(User user) {
        String sql = "INSERT INTO users (first_name, last_name, username, email, password, phone_number, address, role, avatar_url, cin_recto, cin_verso, is_subscriber, is_active, city_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getUsername());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPassword());
            pstmt.setString(6, user.getPhoneNumber());
            pstmt.setString(7, user.getAddress());
            pstmt.setString(8, user.getRole());
            pstmt.setString(9, user.getAvatarUrl());
            pstmt.setString(10, user.getCinRecto());
            pstmt.setString(11, user.getCinVerso());
            pstmt.setBoolean(12, user.isSubscriber());
            pstmt.setBoolean(13, user.isActive());
            pstmt.setLong(14, user.getCityId());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("La création de l'utilisateur a échoué, aucune ligne affectée.");
            }
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("La création de l'utilisateur a échoué, aucun ID généré.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de l'enregistrement de l'utilisateur: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de l'enregistrement de l'utilisateur.", e);
        }
    }

    @Override
    public long countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public long countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<User> findByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche des utilisateurs par rôle: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par rôle.", e);
        }
        return users;
    }

    @Override
    public User findById(long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la recherche de l'utilisateur par ID: " + e.getMessage());
            throw new RuntimeException("Erreur de base de données lors de la recherche par ID.", e);
        }
        return null;
    }

    @Override
    public void updateStatus(long userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, isActive);
            pstmt.setLong(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du statut de l'utilisateur.", e);
        }
    }

    @Override
    public long countByRoleAndStatus(String role, boolean isActive) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ? AND is_active = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, role);
            pstmt.setBoolean(2, isActive);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<User> findRecentByRole(String role, int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC LIMIT ?";

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, role);
            pstmt.setInt(2, limit);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        user.setCinRecto(rs.getString("cin_recto"));
        user.setCinVerso(rs.getString("cin_verso"));
        user.setSubscriber(rs.getBoolean("is_subscriber"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCityId(rs.getLong("city_id"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    @Override
    public void updateRole(long userId, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newRole);
            pstmt.setLong(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la mise à jour du rôle de l'utilisateur.", e);
        }
    }
    public boolean updateUserProfile(User user) {
        if (user == null || user.getId() <= 0 || user.getFirstName() == null || user.getLastName() == null
                || user.getEmail() == null) {
            System.err.println("updateUserProfile: Données utilisateur invalides.");
            return false;
        }

        String sql = "UPDATE users SET first_name = ?, last_name = ?, email = ? , avatar_url = ? WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getAvatarUrl());
            pstmt.setLong(5, user.getId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println("Erreur SQL lors de la mise à jour du profil utilisateur (ID: " + user.getId() + "): "
                    + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserPassword(long userId, String newHashedPassword) {
        if (userId <= 0 || newHashedPassword == null || newHashedPassword.isEmpty()) {
            System.err.println("updateUserPassword: ID utilisateur ou mot de passe invalide.");
            return false;
        }

        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newHashedPassword);
            pstmt.setLong(2, userId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err.println(
                    "Erreur SQL lors de la mise à jour du mot de passe (ID: " + userId + "): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserAvatar(long userId, String avatarUrl) {
        if (userId <= 0 || avatarUrl == null || avatarUrl.isEmpty()) {
            System.err.println("updateUserAvatar: ID utilisateur ou URL d'avatar invalide.");
            return false;
        }

        String sql = "UPDATE users SET avatar_url = ? WHERE id = ?";
        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, avatarUrl);
            pstmt.setLong(2, userId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            System.err
                    .println("Erreur SQL lors de la mise à jour de l'avatar (ID: " + userId + "): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<User> findAndPaginateUsers(String role, String searchQuery, String status, String sortBy, int limit,
            int offset) {
        List<User> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE role = ? ");
        List<Object> params = new ArrayList<>();
        params.add(role);

        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ?) ");
            String searchLike = "%" + searchQuery + "%";
            params.add(searchLike);
            params.add(searchLike);
            params.add(searchLike);
        }

        if (status != null && !status.equals("all")) {
            sql.append("AND is_active = ? ");
            params.add(status.equals("active") ? 1 : 0);
        }

        switch (sortBy) {
            case "name_asc":
                sql.append("ORDER BY first_name ASC, last_name ASC ");
                break;
            case "name_desc":
                sql.append("ORDER BY first_name DESC, last_name DESC ");
                break;
            case "oldest":
                sql.append("ORDER BY created_at ASC ");
                break;
            default: 
                sql.append("ORDER BY created_at DESC ");
                break;
        }

        sql.append("LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                ps.setObject(i++, param);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs)); 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public int countUsers(String role, String searchQuery, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role = ? ");
        List<Object> params = new ArrayList<>();
        params.add(role);

        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql.append("AND (first_name LIKE ? OR last_name LIKE ? OR email LIKE ?) ");
            String searchLike = "%" + searchQuery + "%";
            params.add(searchLike);
            params.add(searchLike);
            params.add(searchLike);
        }

        if (status != null && !status.equals("all")) {
            sql.append("AND is_active = ? ");
            params.add(status.equals("active") ? 1 : 0);
        }

        try (Connection conn = DatabaseManager.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                ps.setObject(i++, param);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}