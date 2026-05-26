package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.Member;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MemberDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    public boolean registerMember(Member m) {
        String sql = "INSERT INTO members (user_id, full_name, date_of_birth, gender, phone, address, citizenship_no, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, m.getUserId());
            ps.setString(2, m.getFullName());
            ps.setString(3, m.getDateOfBirth());
            ps.setString(4, m.getGender());
            ps.setString(5, m.getPhone());
            ps.setString(6, m.getAddress());
            ps.setString(7, m.getCitizenshipNo());
            ps.setString(8, "PENDING");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Member findByUserId(int userId) {
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id WHERE m.user_id = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapMember(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Member findById(int id) {
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id WHERE m.id = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapMember(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Member> getAll() {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id ORDER BY m.joined_date DESC";
        try (Connection connection = conn();
                Statement st = connection.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            while (rs.next())
                list.add(mapMember(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Member> getPending() {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id WHERE m.status = 'PENDING' ORDER BY m.joined_date ASC";
        try (Connection connection = conn();
                Statement st = connection.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            while (rs.next())
                list.add(mapMember(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Member> search(String keyword) {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id " +
                "WHERE m.full_name LIKE ? OR m.phone LIKE ? OR m.citizenship_no LIKE ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapMember(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean approve(int memberId) {
        String sql = "UPDATE members SET status = 'APPROVED' WHERE id = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean reject(int memberId) {
        String sql = "UPDATE members SET status = 'REJECTED' WHERE id = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean citizenshipExists(String no) {
        String sql = "SELECT COUNT(*) FROM members WHERE citizenship_no = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, no);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean fullNameExists(String fullName) {
        String sql = "SELECT COUNT(*) FROM members WHERE LOWER(full_name) = LOWER(?)";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean phoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM members WHERE phone = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addressExists(String address) {
        String sql = "SELECT COUNT(*) FROM members WHERE LOWER(address) = LOWER(?)";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, address);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM members WHERE status = ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Member mapMember(ResultSet rs) throws SQLException {
        Member m = new Member();
        m.setId(rs.getInt("id"));
        m.setUserId(rs.getInt("user_id"));
        m.setFullName(rs.getString("full_name"));
        m.setDateOfBirth(rs.getString("date_of_birth"));
        m.setGender(rs.getString("gender"));
        m.setPhone(rs.getString("phone"));
        m.setAddress(rs.getString("address"));
        m.setCitizenshipNo(rs.getString("citizenship_no"));
        m.setStatus(rs.getString("status"));
        m.setJoinedDate(rs.getTimestamp("joined_date"));
        try {
            m.setUsername(rs.getString("username"));
        } catch (SQLException ignored) {
        }
        return m;
    }
}
