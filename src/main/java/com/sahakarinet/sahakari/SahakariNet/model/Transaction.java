package com.sahakarinet.sahakari.SahakariNet.model;


import java.sql.Timestamp;

public class Transaction {
    private int id;
    private int memberId;
    private String type; // DEPOSIT, WITHDRAWAL, LOAN_DISBURSE, LOAN_REPAYMENT, INTEREST_CREDIT
    private double amount;
    private double balanceAfter;
    private String description;
    private Integer loanId;
    private int recordedBy;
    private Timestamp transactionDate;
    // Joined fields
    private String memberName;
    private String recordedByName;

    public Transaction() {}

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getMemberId() { return memberId; } public void setMemberId(int m) { this.memberId = m; }
    public String getType() { return type; } public void setType(String t) { this.type = t; }
    public double getAmount() { return amount; } public void setAmount(double a) { this.amount = a; }
    public double getBalanceAfter() { return balanceAfter; } public void setBalanceAfter(double b) { this.balanceAfter = b; }
    public String getDescription() { return description; } public void setDescription(String d) { this.description = d; }
    public Integer getLoanId() { return loanId; } public void setLoanId(Integer l) { this.loanId = l; }
    public int getRecordedBy() { return recordedBy; } public void setRecordedBy(int r) { this.recordedBy = r; }
    public Timestamp getTransactionDate() { return transactionDate; } public void setTransactionDate(Timestamp t) { this.transactionDate = t; }
    public String getMemberName() { return memberName; } public void setMemberName(String n) { this.memberName = n; }
    public String getRecordedByName() { return recordedByName; } public void setRecordedByName(String n) { this.recordedByName = n; }
}