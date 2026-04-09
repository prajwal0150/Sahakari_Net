package com.sahakarinet.sahakari.SahakariNet.utils;

public class InterestCalculator {
    /**
     * Calculate monthly EMI using reducing balance formula.
     * Formula: EMI = P × r × (1+r)^n / ((1+r)^n - 1)
     * P = principal, r = monthly interest rate, n = months
     */
    public static double calculateEMI(double principal, double annualRatePercent, int months) {
        double r = annualRatePercent / 100.0 / 12.0; // monthly rate
        if (r == 0) return principal / months;
        double power = Math.pow(1 + r, months);
        return Math.round((principal * r * power / (power - 1)) * 100.0) / 100.0;
    }

    /**
     * Calculate simple interest for savings.
     * Interest = Principal × Rate × Time(years)
     */
    public static double calculateSavingsInterest(double balance, double annualRatePercent, int months) {
        return Math.round((balance * annualRatePercent / 100.0 * months / 12.0) * 100.0) / 100.0;
    }

    /**
     * Calculate total repayment amount for a loan.
     */
    public static double calculateTotalRepayment(double principal, double annualRatePercent, int months) {
        return Math.round(calculateEMI(principal, annualRatePercent, months) * months * 100.0) / 100.0;
    }
}
