package com.sahakarinet.sahakari.SahakariNet.model;


import java.sql.Timestamp;

public class SavingsAccount {
    private int id;
    private int memberId;
    private double balance;
    private double shareCapital;
    private double interestRate;
    private Timestamp lastUpdated;
    private String memberName;

    public SavingsAccount() {}

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getMemberId() { return memberId; } public void setMemberId(int m) { this.memberId = m; }
    public double getBalance() { return balance; } public void setBalance(double b) { this.balance = b; }
    public double getShareCapital() { return shareCapital; } public void setShareCapital(double s) { this.shareCapital = s; }
    public double getInterestRate() { return interestRate; } public void setInterestRate(double r) { this.interestRate = r; }
    public Timestamp getLastUpdated() { return lastUpdated; } public void setLastUpdated(Timestamp t) { this.lastUpdated = t; }
    public String getMemberName() { return memberName; } public void setMemberName(String n) { this.memberName = n; }
}