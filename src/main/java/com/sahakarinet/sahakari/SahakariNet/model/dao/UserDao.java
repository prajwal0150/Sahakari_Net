package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;
import com.sahakarinet.sahakari.SahakariNet.utils.PasswordUtil;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class UserDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    private void ensureStaffProfilesTable(Connection c) throws SQLException {
        String ddl = "CREATE TABLE IF NOT EXISTS staff_profiles ("
                + "user_id INT PRIMARY KEY, "
                + "full_name VARCHAR(120) NOT NULL, "
                + "phone VARCHAR(20) NOT NULL, "
                + "permanent_address VARCHAR(255) NOT NULL, "
                + "temporary_address VARCHAR(255) NOT NULL, "
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                + "CONSTRAINT fk_staff_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
                + ")";
        try (Statement st = c.createStatement()) {
            st.execute(ddl);
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapUser(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Returns new user ID or -1 on failure */
    public int createUser(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, role, is_active) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = conn().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            ps.setBoolean(5, user.isActive());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next())
                return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET is_active = TRUE WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deactivateUser(int userId) {
        String sql = "UPDATE users SET is_active = FALSE WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getStaffUsers() {
        List<User> staffUsers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'STAFF' ORDER BY id DESC";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                staffUsers.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffUsers;
    }

    public void ensureDefaultAdmin() {
        if (usernameExists("admin"))
            return;

        User admin = new User();
        admin.setUsername("admin");
        admin.setEmail("admin@sahakarinet.local");
        admin.setPasswordHash(PasswordUtil.hash("admin123"));
        admin.setRole("ADMIN");
        admin.setActive(true);
        createUser(admin);
    }

    public boolean verifyAndUpgradePassword(User user, String plainPassword) {
        if (user == null || plainPassword == null)
            return false;

        String stored = user.getPasswordHash();
        if (stored == null || stored.isBlank())
            return false;

        // Current format: BCrypt hash
        if (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$")) {
            return PasswordUtil.verify(plainPassword, stored);
        }

        // Legacy format: plain-text value in DB, upgrade transparently after successful
        // login
        if (plainPassword.equals(stored)) {
            String newHash = PasswordUtil.hash(plainPassword);
            if (updatePasswordHash(user.getId(), newHash)) {
                user.setPasswordHash(newHash);
            }
            return true;
        }
        return false;
    }

    public User findByEmailOrPhone(String identifier) {
        String sql = "SELECT DISTINCT u.* FROM users u "
                + "LEFT JOIN members m ON m.user_id = u.id "
                + "LEFT JOIN staff_profiles sp ON sp.user_id = u.id "
                + "WHERE u.email = ? OR m.phone = ? OR sp.phone = ? "
                + "ORDER BY u.id DESC LIMIT 1";

        try (Connection c = conn()) {
            ensureStaffProfilesTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, identifier);
                ps.setString(2, identifier);
                ps.setString(3, identifier);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapUser(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean resetPasswordByIdentifier(String identifier, String plainPassword) {
        User user = findByEmailOrPhone(identifier);
        if (user == null) {
            return false;
        }
        return updatePasswordHash(user.getId(), PasswordUtil.hash(plainPassword));
    }

    public boolean updatePasswordForUser(int userId, String plainPassword) {
        return updatePasswordHash(userId, PasswordUtil.hash(plainPassword));
    }

    private boolean updatePasswordHash(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
