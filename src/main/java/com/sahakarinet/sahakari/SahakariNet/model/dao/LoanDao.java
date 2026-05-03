package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.Loan;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class LoanDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    public int applyLoan(Loan loan) {
        String sql = "INSERT INTO loans (member_id, amount, purpose, status, interest_rate, duration_months, monthly_emi) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, loan.getMemberId());
            ps.setDouble(2, loan.getAmount());
            ps.setString(3, loan.getPurpose());
            ps.setString(4, "PENDING");
            ps.setDouble(5, loan.getInterestRate());
            ps.setInt(6, loan.getDurationMonths());
            ps.setDouble(7, loan.getMonthlyEmi());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next())
                return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Loan findById(int id) {
        String sql = "SELECT l.*, m.full_name AS member_name, m.phone AS member_phone, " +
                "u.username AS approved_by_name FROM loans l " +
                "JOIN members m ON l.member_id = m.id " +
                "LEFT JOIN users u ON l.approved_by = u.id WHERE l.id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapLoan(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Loan> getAll() {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, m.full_name AS member_name, m.phone AS member_phone, " +
                "u.username AS approved_by_name FROM loans l " +
                "JOIN members m ON l.member_id = m.id " +
                "LEFT JOIN users u ON l.approved_by = u.id ORDER BY l.applied_date DESC";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next())
                list.add(mapLoan(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Loan> getByMemberId(int memberId) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, m.full_name AS member_name, m.phone AS member_phone, " +
                "u.username AS approved_by_name FROM loans l " +
                "JOIN members m ON l.member_id = m.id " +
                "LEFT JOIN users u ON l.approved_by = u.id WHERE l.member_id = ? ORDER BY l.applied_date DESC";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapLoan(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Loan> getByStatus(String status) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT l.*, m.full_name AS member_name, m.phone AS member_phone, " +
                "u.username AS approved_by_name FROM loans l " +
                "JOIN members m ON l.member_id = m.id " +
                "LEFT JOIN users u ON l.approved_by = u.id WHERE l.status = ? ORDER BY l.applied_date DESC";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapLoan(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean approve(int loanId, int adminUserId) {
        String sql = "UPDATE loans SET status = 'APPROVED', approved_by = ?, approved_date = NOW() WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, adminUserId);
            ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean reject(int loanId, int adminUserId) {
        String sql = "UPDATE loans SET status = 'REJECTED', approved_by = ? WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, adminUserId);
            ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean disburse(int loanId) {
        String sql = "UPDATE loans SET status = 'DISBURSED', disbursed_date = NOW() WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean closeLoan(int loanId) {
        String sql = "UPDATE loans SET status = 'CLOSED' WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM loans WHERE status = ?";
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

    private Loan mapLoan(ResultSet rs) throws SQLException {
        Loan l = new Loan();
        l.setId(rs.getInt("id"));
        l.setMemberId(rs.getInt("member_id"));
        l.setAmount(rs.getDouble("amount"));
        l.setPurpose(rs.getString("purpose"));
        l.setStatus(rs.getString("status"));
        l.setInterestRate(rs.getDouble("interest_rate"));
        l.setDurationMonths(rs.getInt("duration_months"));
        l.setMonthlyEmi(rs.getDouble("monthly_emi"));
        l.setAppliedDate(rs.getTimestamp("applied_date"));
        l.setApprovedDate(rs.getTimestamp("approved_date"));
        l.setDisbursedDate(rs.getTimestamp("disbursed_date"));
        int ab = rs.getInt("approved_by");
        if (!rs.wasNull())
            l.setApprovedBy(ab);
        try {
            l.setMemberName(rs.getString("member_name"));
        } catch (SQLException ignored) {
        }
        try {
            l.setMemberPhone(rs.getString("member_phone"));
        } catch (SQLException ignored) {
        }
        try {
            l.setApprovedByName(rs.getString("approved_by_name"));
        } catch (SQLException ignored) {
        }
        return l;
    }
}
