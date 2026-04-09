package com.sahakarinet.sahakari.SahakariNet.model;


import java.sql.Date;
import java.sql.Timestamp;

public class LoanRepayment {
    private int id;
    private int loanId;
    private int instalmentNo;
    private Date dueDate;
    private double dueAmount;
    private double paidAmount;
    private Timestamp paidDate;
    private boolean defaulted;
    // Joined fields
    private String memberName;
    private String memberPhone;

    public LoanRepayment() {}

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getLoanId() { return loanId; } public void setLoanId(int l) { this.loanId = l; }
    public int getInstalmentNo() { return instalmentNo; } public void setInstalmentNo(int i) { this.instalmentNo = i; }
    public Date getDueDate() { return dueDate; } public void setDueDate(Date d) { this.dueDate = d; }
    public double getDueAmount() { return dueAmount; } public void setDueAmount(double d) { this.dueAmount = d; }
    public double getPaidAmount() { return paidAmount; } public void setPaidAmount(double p) { this.paidAmount = p; }
    public Timestamp getPaidDate() { return paidDate; } public void setPaidDate(Timestamp p) { this.paidDate = p; }
    public boolean isDefaulted() { return defaulted; } public void setDefaulted(boolean d) { this.defaulted = d; }
    public String getMemberName() { return memberName; } public void setMemberName(String n) { this.memberName = n; }
    public String getMemberPhone() { return memberPhone; } public void setMemberPhone(String p) { this.memberPhone = p; }
}