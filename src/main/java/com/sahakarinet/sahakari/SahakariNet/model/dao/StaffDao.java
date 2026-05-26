package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.Staff;
import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StaffDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    private void ensureStaffProfileTable(Connection c) throws SQLException {
        String ddl = "CREATE TABLE IF NOT EXISTS staff_profiles ("
                + "user_id INT PRIMARY KEY, "
                + "full_name VARCHAR(120) NOT NULL, "
                + "gender VARCHAR(20) NOT NULL, "
                + "phone VARCHAR(20) NOT NULL, "
                + "citizenship_no VARCHAR(50), "
                + "permanent_address VARCHAR(255) NOT NULL, "
                + "temporary_address VARCHAR(255) NOT NULL, "
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                + "CONSTRAINT fk_staff_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
                + ")";
        try (Statement st = c.createStatement()) {
            st.execute(ddl);
            try {
                st.execute("ALTER TABLE staff_profiles ADD COLUMN citizenship_no VARCHAR(50)");
            } catch (SQLException ignored) {
                // Column already exists or DB does not support this alter syntax.
            }
        }
    }

    public int registerStaff(Staff staff) {
        String sql = "INSERT INTO users (username, email, password_hash, role, is_active) VALUES (?,?,?,?,?)";
        String profileSql = "INSERT INTO staff_profiles (user_id, full_name, gender, phone, citizenship_no, permanent_address, temporary_address) VALUES (?,?,?,?,?,?,?)";

        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            c.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, staff.getUsername());
                ps.setString(2, staff.getEmail());
                ps.setString(3, staff.getPasswordHash());
                ps.setString(4, "STAFF");
                ps.setBoolean(5, staff.isActive());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        userId = keys.getInt(1);
                    }
                }
            }

            if (userId <= 0) {
                c.rollback();
                return -1;
            }

            try (PreparedStatement profilePs = c.prepareStatement(profileSql)) {
                profilePs.setInt(1, userId);
                profilePs.setString(2, staff.getFullName());
                profilePs.setString(3, staff.getGender());
                profilePs.setString(4, staff.getPhone());
                profilePs.setString(5, staff.getCitizenshipNo());
                profilePs.setString(6, staff.getPermanentAddress());
                profilePs.setString(7, staff.getTemporaryAddress());
                profilePs.executeUpdate();
            }

            c.commit();
            return userId;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Staff findByUserId(int userId) {
        String sql = "SELECT u.id, u.username, u.email, u.password_hash, u.is_active, u.created_at, "
                + "sp.full_name, sp.gender, sp.phone, sp.citizenship_no, sp.permanent_address, sp.temporary_address "
                + "FROM users u LEFT JOIN staff_profiles sp ON sp.user_id = u.id "
                + "WHERE u.id = ? AND u.role = 'STAFF'";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapStaff(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Staff> getAll() {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.email, u.password_hash, u.is_active, u.created_at, "
                + "sp.full_name, sp.gender, sp.phone, sp.citizenship_no, sp.permanent_address, sp.temporary_address "
                + "FROM users u LEFT JOIN staff_profiles sp ON sp.user_id = u.id "
                + "WHERE u.role = 'STAFF' ORDER BY u.id DESC";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    staffList.add(mapStaff(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'STAFF'";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean fullNameExists(String fullName) {
        String sql = "SELECT COUNT(*) FROM staff_profiles WHERE LOWER(full_name) = LOWER(?)";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, fullName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean phoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM staff_profiles WHERE phone = ?";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, phone);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addressExists(String address) {
        String sql = "SELECT COUNT(*) FROM staff_profiles WHERE LOWER(permanent_address) = LOWER(?) OR LOWER(temporary_address) = LOWER(?)";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, address);
                ps.setString(2, address);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean citizenshipExists(String citizenshipNo) {
        String sql = "SELECT COUNT(*) FROM staff_profiles WHERE citizenship_no = ?";
        try (Connection c = conn()) {
            ensureStaffProfileTable(c);
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, citizenshipNo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Staff mapStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setUserId(rs.getInt("id"));
        staff.setUsername(rs.getString("username"));
        staff.setEmail(rs.getString("email"));
        staff.setPasswordHash(rs.getString("password_hash"));
        staff.setActive(rs.getBoolean("is_active"));
        staff.setCreatedAt(rs.getTimestamp("created_at"));
        staff.setFullName(rs.getString("full_name"));
        staff.setGender(rs.getString("gender"));
        staff.setPhone(rs.getString("phone"));
        staff.setCitizenshipNo(rs.getString("citizenship_no"));
        staff.setPermanentAddress(rs.getString("permanent_address"));
        staff.setTemporaryAddress(rs.getString("temporary_address"));
        return staff;
    }
}
