package com.sahakarinet.sahakari.SahakariNet.model;


import java.sql.Timestamp;

public class Loan {
    private int id;
    private int memberId;
    private double amount;
    private String purpose;
    private String status; // PENDING, APPROVED, REJECTED, DISBURSED, CLOSED
    private double interestRate;
    private int durationMonths;
    private double monthlyEmi;
    private Timestamp appliedDate;
    private Timestamp approvedDate;
    private Timestamp disbursedDate;
    private Integer approvedBy;
    // Joined fields
    private String memberName;
    private String memberPhone;
    private String approvedByName;

    public Loan() {}

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getMemberId() { return memberId; } public void setMemberId(int m) { this.memberId = m; }
    public double getAmount() { return amount; } public void setAmount(double a) { this.amount = a; }
    public String getPurpose() { return purpose; } public void setPurpose(String p) { this.purpose = p; }
    public String getStatus() { return status; } public void setStatus(String s) { this.status = s; }
    public double getInterestRate() { return interestRate; } public void setInterestRate(double r) { this.interestRate = r; }
    public int getDurationMonths() { return durationMonths; } public void setDurationMonths(int d) { this.durationMonths = d; }
    public double getMonthlyEmi() { return monthlyEmi; } public void setMonthlyEmi(double e) { this.monthlyEmi = e; }
    public Timestamp getAppliedDate() { return appliedDate; } public void setAppliedDate(Timestamp t) { this.appliedDate = t; }
    public Timestamp getApprovedDate() { return approvedDate; } public void setApprovedDate(Timestamp t) { this.approvedDate = t; }
    public Timestamp getDisbursedDate() { return disbursedDate; } public void setDisbursedDate(Timestamp t) { this.disbursedDate = t; }
    public Integer getApprovedBy() { return approvedBy; } public void setApprovedBy(Integer a) { this.approvedBy = a; }
    public String getMemberName() { return memberName; } public void setMemberName(String n) { this.memberName = n; }
    public String getMemberPhone() { return memberPhone; } public void setMemberPhone(String p) { this.memberPhone = p; }
    public String getApprovedByName() { return approvedByName; } public void setApprovedByName(String n) { this.approvedByName = n; }
}