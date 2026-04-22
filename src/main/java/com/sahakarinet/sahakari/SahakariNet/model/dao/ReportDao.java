package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
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

    /** Monthly savings movement summary — last 6 months */
    public List<Map<String, Object>> monthlySavings() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(MIN(transaction_date),'%b %Y') AS month, " +
                "COALESCE(SUM(CASE WHEN type='DEPOSIT' THEN amount ELSE 0 END),0) AS deposits, " +
                "COALESCE(SUM(CASE WHEN type='WITHDRAWAL' THEN amount ELSE 0 END),0) AS withdrawals, " +
                "COALESCE(SUM(CASE WHEN type='INTEREST_CREDIT' THEN amount ELSE 0 END),0) AS interests, " +
                "(COALESCE(SUM(CASE WHEN type='DEPOSIT' THEN amount ELSE 0 END),0) + " +
                " COALESCE(SUM(CASE WHEN type='INTEREST_CREDIT' THEN amount ELSE 0 END),0) - " +
                " COALESCE(SUM(CASE WHEN type='WITHDRAWAL' THEN amount ELSE 0 END),0)) AS net " +
                "FROM transactions " +
                "WHERE type IN ('DEPOSIT','WITHDRAWAL','INTEREST_CREDIT') " +
                "AND transaction_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                "GROUP BY YEAR(transaction_date), MONTH(transaction_date) " +
                "ORDER BY YEAR(transaction_date), MONTH(transaction_date) ASC";
        try (Statement st = conn().createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("month", rs.getString("month"));
                row.put("deposits", rs.getDouble("deposits"));
                row.put("withdrawals", rs.getDouble("withdrawals"));
                row.put("interests", rs.getDouble("interests"));
                row.put("net", rs.getDouble("net"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Loan recovery rate — due vs collected */
    public Map<String, Object> loanRecovery(String period) {
        Map<String, Object> data = new LinkedHashMap<>();
        String normalizedPeriod = period == null ? "all" : period.trim().toLowerCase();

        String disbursedSql = "SELECT COALESCE(SUM(amount),0) AS total_disbursed, COUNT(*) AS total_loans " +
                "FROM loans WHERE status IN ('DISBURSED','CLOSED')";

        String periodCondition;
        switch (normalizedPeriod) {
            case "month":
                periodCondition = " AND lr.due_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') " +
                        "AND lr.due_date < DATE_ADD(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH)";
                break;
            case "6m":
                periodCondition = " AND lr.due_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)";
                break;
            default:
                periodCondition = "";
                normalizedPeriod = "all";
                break;
        }

        String dueCollectedSql = "SELECT " +
                "COALESCE(SUM(lr.due_amount),0) AS total_due, " +
                "COALESCE(SUM(CASE WHEN lr.paid_date IS NOT NULL THEN lr.paid_amount ELSE 0 END),0) AS total_collected "
                +
                "FROM loan_repayments lr " +
                "JOIN loans l ON l.id = lr.loan_id " +
                "WHERE l.status IN ('DISBURSED','CLOSED')" + periodCondition;

        try (Connection connection = conn();
                Statement disbursedSt = connection.createStatement();
                ResultSet disbursedRs = disbursedSt.executeQuery(disbursedSql);
                PreparedStatement dueCollectedPs = connection.prepareStatement(dueCollectedSql);
                ResultSet dueCollectedRs = dueCollectedPs.executeQuery()) {

            double disbursed = 0.0;
            int totalLoans = 0;
            if (disbursedRs.next()) {
                disbursed = disbursedRs.getDouble("total_disbursed");
                totalLoans = disbursedRs.getInt("total_loans");
            }

            double due = 0.0;
            double collected = 0.0;
            if (dueCollectedRs.next()) {
                due = dueCollectedRs.getDouble("total_due");
                collected = dueCollectedRs.getDouble("total_collected");
            }

            double remaining = Math.max(due - collected, 0);
            long recoveryRate = due > 0 ? Math.round(collected / due * 100) : 0;

            data.put("totalDisbursed", disbursed);
            data.put("totalLoans", totalLoans);
            data.put("totalDue", due);
            data.put("totalCollected", collected);
            data.put("remainingDue", remaining);
            data.put("recoveryRate", recoveryRate);
            data.put("period", normalizedPeriod);
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
