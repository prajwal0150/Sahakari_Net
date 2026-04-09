package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.LoanRepayment;
import com.sahakarinet.sahakari.SahakariNet.utils.DateUtil;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class LoanRepaymentDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    /** Generate repayment schedule rows when a loan is disbursed */
    public boolean createSchedule(int loanId, double emi, int months) {
        String sql = "INSERT INTO loan_repayments (loan_id, instalment_no, due_date, due_amount) VALUES (?,?,?,?)";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            java.sql.Date base = DateUtil.today();
            for (int i = 1; i <= months; i++) {
                java.sql.Date due = DateUtil.addMonths(base, i);
                ps.setInt(1, loanId);
                ps.setInt(2, i);
                ps.setDate(3, due);
                ps.setDouble(4, emi);
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<LoanRepayment> getByLoanId(int loanId) {
        List<LoanRepayment> list = new ArrayList<>();
        String sql = "SELECT lr.*, m.full_name AS member_name, m.phone AS member_phone " +
                "FROM loan_repayments lr " +
                "JOIN loans l ON lr.loan_id = l.id " +
                "JOIN members m ON l.member_id = m.id " +
                "WHERE lr.loan_id = ? ORDER BY lr.instalment_no ASC";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, loanId);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapLR(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public LoanRepayment findNextDue(int loanId) {
        String sql = "SELECT lr.*, m.full_name AS member_name, m.phone AS member_phone " +
                "FROM loan_repayments lr " +
                "JOIN loans l ON lr.loan_id = l.id " +
                "JOIN members m ON l.member_id = m.id " +
                "WHERE lr.loan_id = ? AND lr.paid_amount = 0 ORDER BY lr.due_date ASC LIMIT 1";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, loanId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapLR(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean recordPayment(int repaymentId, double amount) {
        String sql = "UPDATE loan_repayments SET paid_amount = ?, paid_date = NOW(), is_defaulted = FALSE WHERE id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setInt(2, repaymentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Mark overdue instalments as defaulted */
    public void updateDefaulters() {
        String sql = "UPDATE loan_repayments SET is_defaulted = TRUE " +
                "WHERE due_date < CURDATE() AND paid_amount = 0 AND is_defaulted = FALSE";
        try (Statement st = conn().createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<LoanRepayment> getDefaulters() {
        updateDefaulters();
        List<LoanRepayment> list = new ArrayList<>();
        String sql = "SELECT lr.*, m.full_name AS member_name, m.phone AS member_phone " +
                "FROM loan_repayments lr " +
                "JOIN loans l ON lr.loan_id = l.id " +
                "JOIN members m ON l.member_id = m.id " +
                "WHERE lr.is_defaulted = TRUE ORDER BY lr.due_date ASC";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next())
                list.add(mapLR(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countPaid(int loanId) {
        String sql = "SELECT COUNT(*) FROM loan_repayments WHERE loan_id = ? AND paid_amount > 0";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, loanId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private LoanRepayment mapLR(ResultSet rs) throws SQLException {
        LoanRepayment lr = new LoanRepayment();
        lr.setId(rs.getInt("id"));
        lr.setLoanId(rs.getInt("loan_id"));
        lr.setInstalmentNo(rs.getInt("instalment_no"));
        lr.setDueDate(rs.getDate("due_date"));
        lr.setDueAmount(rs.getDouble("due_amount"));
        lr.setPaidAmount(rs.getDouble("paid_amount"));
        lr.setPaidDate(rs.getTimestamp("paid_date"));
        lr.setDefaulted(rs.getBoolean("is_defaulted"));
        try {
            lr.setMemberName(rs.getString("member_name"));
        } catch (SQLException ignored) {
        }
        try {
            lr.setMemberPhone(rs.getString("member_phone"));
        } catch (SQLException ignored) {
        }
        return lr;
    }
}
