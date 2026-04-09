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
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
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
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapMember(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Member findById(int id) {
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id WHERE m.id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapMember(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Member> getAll() {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT m.*, u.username FROM members m JOIN users u ON m.user_id = u.id ORDER BY m.joined_date DESC";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
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
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
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
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapMember(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean approve(int memberId) {
        String sql = "UPDATE members SET status = 'APPROVED' WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean reject(int memberId) {
        String sql = "UPDATE members SET status = 'REJECTED' WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean citizenshipExists(String no) {
        String sql = "SELECT COUNT(*) FROM members WHERE citizenship_no = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, no);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM members WHERE status = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
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
