package com.sahakarinet.sahakari.SahakariNet.model.dao;

import com.sahakarinet.sahakari.SahakariNet.model.Transaction;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class TransactionDao {
    private Connection conn() throws SQLException {
        return DbConnection.getConnection();
    }

    public boolean addTransaction(Transaction t) {
        String sql = "INSERT INTO transactions (member_id, type, amount, balance_after, description, loan_id, recorded_by) VALUES (?,?,?,?,?,?,?)";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, t.getMemberId());
            ps.setString(2, t.getType());
            ps.setDouble(3, t.getAmount());
            ps.setDouble(4, t.getBalanceAfter());
            ps.setString(5, t.getDescription());
            if (t.getLoanId() != null)
                ps.setInt(6, t.getLoanId());
            else
                ps.setNull(6, Types.INTEGER);
            ps.setInt(7, t.getRecordedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Transaction> getByMemberId(int memberId) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id WHERE t.member_id = ? ORDER BY t.transaction_date DESC";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getAll() {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id ORDER BY t.transaction_date DESC LIMIT 200";
        try (Connection connection = conn();
                Statement st = connection.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            while (rs.next())
                list.add(mapTx(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getLatest(int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getRecent(int memberId, int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id WHERE t.member_id = ? ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getByType(String type) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id WHERE t.type = ? ORDER BY t.transaction_date DESC LIMIT 50";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getByTypeWithLimit(String type, int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id WHERE t.type = ? ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getByTypeAndMemberWithLimit(String type, int memberId, int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT t.*, m.full_name AS member_name, u.username AS recorded_by_name " +
                "FROM transactions t JOIN members m ON t.member_id = m.id " +
                "JOIN users u ON t.recorded_by = u.id " +
                "WHERE t.type = ? AND t.member_id = ? ORDER BY t.transaction_date DESC LIMIT ?";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setInt(2, memberId);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapTx(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTodayByStaff(int staffUserId) {
        String sql = "SELECT COUNT(*) FROM transactions WHERE recorded_by = ? AND DATE(transaction_date) = CURDATE()";
        try (Connection connection = conn(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Transaction mapTx(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setId(rs.getInt("id"));
        t.setMemberId(rs.getInt("member_id"));
        t.setType(rs.getString("type"));
        t.setAmount(rs.getDouble("amount"));
        t.setBalanceAfter(rs.getDouble("balance_after"));
        t.setDescription(rs.getString("description"));
        t.setRecordedBy(rs.getInt("recorded_by"));
        t.setTransactionDate(rs.getTimestamp("transaction_date"));
        try {
            t.setMemberName(rs.getString("member_name"));
        } catch (SQLException ignored) {
        }
        try {
            t.setRecordedByName(rs.getString("recorded_by_name"));
        } catch (SQLException ignored) {
        }
        int loanId = rs.getInt("loan_id");
        if (!rs.wasNull())
            t.setLoanId(loanId);
        return t;
    }
}
