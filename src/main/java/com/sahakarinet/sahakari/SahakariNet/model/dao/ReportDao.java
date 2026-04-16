package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    /** Monthly deposits summary — last 6 months */
    public List<Map<String, Object>> monthlySavings() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(MIN(transaction_date),'%b %Y') AS month, " +
                "SUM(amount) AS total FROM transactions " +
                "WHERE type='DEPOSIT' AND transaction_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                "GROUP BY YEAR(transaction_date), MONTH(transaction_date) " +
                "ORDER BY YEAR(transaction_date), MONTH(transaction_date) ASC";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("month", rs.getString("month"));
                row.put("total", rs.getDouble("total"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Loan recovery rate — disbursed vs collected */
    public Map<String, Object> loanRecovery() {
        Map<String, Object> data = new LinkedHashMap<>();
        String sql = "SELECT " +
                "SUM(l.amount) AS total_disbursed, " +
                "SUM(lr.paid_amount) AS total_collected, " +
                "COUNT(DISTINCT l.id) AS total_loans " +
                "FROM loans l " +
                "LEFT JOIN loan_repayments lr ON l.id = lr.loan_id " +
                "WHERE l.status IN ('DISBURSED','CLOSED')";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                double disbursed = rs.getDouble("total_disbursed");
                double collected = rs.getDouble("total_collected");
                data.put("totalDisbursed", disbursed);
                data.put("totalCollected", collected);
                data.put("totalLoans", rs.getInt("total_loans"));
                data.put("recoveryRate", disbursed > 0 ? Math.round(collected / disbursed * 100) : 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    /** Interest earned on savings — all time */
    public double totalInterestEarned() {
        String sql = "SELECT SUM(amount) FROM transactions WHERE type='INTEREST_CREDIT'";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /** Dashboard stats */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new LinkedHashMap<>();
        try (Statement st = conn().createStatement()) {
            ResultSet rs;
            rs = st.executeQuery("SELECT COUNT(*) FROM members WHERE status='APPROVED'");
            if (rs.next())
                stats.put("totalMembers", rs.getInt(1));
            rs = st.executeQuery("SELECT COUNT(*) FROM members WHERE status='PENDING'");
            if (rs.next())
                stats.put("pendingApprovals", rs.getInt(1));
            rs = st.executeQuery("SELECT COALESCE(SUM(balance),0) FROM savings_accounts");
            if (rs.next())
                stats.put("totalSavings", rs.getDouble(1));
            rs = st.executeQuery("SELECT COUNT(*) FROM loans WHERE status='DISBURSED'");
            if (rs.next())
                stats.put("activeLoans", rs.getInt(1));
            rs = st.executeQuery("SELECT COUNT(*) FROM loan_repayments WHERE is_defaulted=TRUE");
            if (rs.next())
                stats.put("defaulters", rs.getInt(1));
            rs = st.executeQuery("SELECT COALESCE(SUM(amount),0) FROM loans WHERE status IN ('DISBURSED','CLOSED')");
            if (rs.next())
                stats.put("totalDisbursed", rs.getDouble(1));
            rs = st.executeQuery("SELECT COUNT(*) FROM loans WHERE status='PENDING'");
            if (rs.next())
                stats.put("pendingLoans", rs.getInt(1));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
