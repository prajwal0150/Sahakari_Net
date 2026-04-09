package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.SavingsAccount;
import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}
