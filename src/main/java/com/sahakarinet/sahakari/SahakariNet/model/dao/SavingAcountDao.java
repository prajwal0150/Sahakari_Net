package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.SavingsAccount;
import com.sahakarinet.sahakari.SahakariNet.utils.InterestCalculator;
import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SavingAcountDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    public boolean createAccount(int memberId) {
        String sql = "INSERT INTO savings_accounts (member_id, balance, share_capital, interest_rate) VALUES (?, 0, 0, 8.0)";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public SavingsAccount getByMemberId(int memberId) {
        String sql = "SELECT sa.*, m.full_name AS member_name FROM savings_accounts sa " +
                "JOIN members m ON sa.member_id = m.id WHERE sa.member_id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SavingsAccount s = new SavingsAccount();
                s.setId(rs.getInt("id"));
                s.setMemberId(rs.getInt("member_id"));
                s.setBalance(rs.getDouble("balance"));
                s.setShareCapital(rs.getDouble("share_capital"));
                s.setInterestRate(rs.getDouble("interest_rate"));
                s.setLastUpdated(rs.getTimestamp("last_updated"));
                s.setMemberName(rs.getString("member_name"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public double getBalance(int memberId) {
        String sql = "SELECT balance FROM savings_accounts WHERE member_id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public boolean deposit(int memberId, double amount) {
        String sql = "UPDATE savings_accounts SET balance = balance + ?, last_updated = NOW() WHERE member_id = ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setInt(2, memberId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean withdraw(int memberId, double amount) {
        String sql = "UPDATE savings_accounts SET balance = balance - ?, last_updated = NOW() WHERE member_id = ? AND balance >= ?";
        try (PreparedStatement ps = conn().prepareStatement(sql)) {
            ps.setDouble(1, amount);
            ps.setInt(2, memberId);
            ps.setDouble(3, amount);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int creditMonthlyInterestForAll(int recordedByUserId) {
        String eligibleSql = "SELECT sa.member_id, sa.balance, sa.interest_rate " +
                "FROM savings_accounts sa " +
                "JOIN members m ON m.id = sa.member_id " +
                "WHERE m.status = 'APPROVED' AND sa.balance > 0";
        String alreadyCreditedSql = "SELECT COUNT(*) FROM transactions " +
                "WHERE member_id = ? AND type = 'INTEREST_CREDIT' " +
                "AND YEAR(transaction_date) = YEAR(CURDATE()) " +
                "AND MONTH(transaction_date) = MONTH(CURDATE())";
        String updateSavingsSql = "UPDATE savings_accounts SET balance = ?, last_updated = NOW() WHERE member_id = ?";
        String insertTxSql = "INSERT INTO transactions (member_id, type, amount, balance_after, description, loan_id, recorded_by) "
                +
                "VALUES (?, 'INTEREST_CREDIT', ?, ?, ?, NULL, ?)";

        try (Connection connection = conn()) {
            connection.setAutoCommit(false);

            int creditedCount = 0;
            List<Integer> memberIds = new ArrayList<>();
            List<Double> balances = new ArrayList<>();
            List<Double> rates = new ArrayList<>();

            try (PreparedStatement eligiblePs = connection.prepareStatement(eligibleSql);
                    ResultSet rs = eligiblePs.executeQuery()) {
                while (rs.next()) {
                    memberIds.add(rs.getInt("member_id"));
                    balances.add(rs.getDouble("balance"));
                    rates.add(rs.getDouble("interest_rate"));
                }
            }

            try (PreparedStatement alreadyCreditedPs = connection.prepareStatement(alreadyCreditedSql);
                    PreparedStatement updateSavingsPs = connection.prepareStatement(updateSavingsSql);
                    PreparedStatement insertTxPs = connection.prepareStatement(insertTxSql)) {

                for (int i = 0; i < memberIds.size(); i++) {
                    int memberId = memberIds.get(i);
                    double balance = balances.get(i);
                    double rate = rates.get(i);

                    alreadyCreditedPs.setInt(1, memberId);
                    try (ResultSet rs = alreadyCreditedPs.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            continue;
                        }
                    }

                    double interestAmount = InterestCalculator.calculateSavingsInterest(balance, rate, 1);
                    if (interestAmount <= 0) {
                        continue;
                    }

                    double newBalance = Math.round((balance + interestAmount) * 100.0) / 100.0;

                    updateSavingsPs.setDouble(1, newBalance);
                    updateSavingsPs.setInt(2, memberId);
                    updateSavingsPs.executeUpdate();

                    insertTxPs.setInt(1, memberId);
                    insertTxPs.setDouble(2, interestAmount);
                    insertTxPs.setDouble(3, newBalance);
                    insertTxPs.setString(4, "Monthly savings interest credit");
                    insertTxPs.setInt(5, recordedByUserId);
                    insertTxPs.executeUpdate();

                    creditedCount++;
                }
            }

            connection.commit();
            return creditedCount;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }
}
