package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Loan;
import com.sahakarinet.sahakari.SahakariNet.model.Transaction;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;
import com.sahakarinet.sahakari.SahakariNet.utils.InterestCalculator;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/loan")
public class LoanServlet extends HttpServlet {

    private LoanDao loanDAO = new LoanDao();
    private LoanRepaymentDao lrDAO = new LoanRepaymentDao();
    private TransactionDao txDAO = new TransactionDao();
    private SavingAcountDao saDAO = new SavingAcountDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String ctx = req.getContextPath();
        HttpSession session = req.getSession();

        switch (action) {
            // Member applies for a loan
            case "apply": {
                int memberId = (int) session.getAttribute("memberId");
                double amount = Double.parseDouble(req.getParameter("amount"));
                String purpose = req.getParameter("purpose");
                int months = Integer.parseInt(req.getParameter("durationMonths"));
                double rate = 12.0; // default annual rate

                double emi = InterestCalculator.calculateEMI(amount, rate, months);

                Loan loan = new Loan();
                loan.setMemberId(memberId);
                loan.setAmount(amount);
                loan.setPurpose(purpose);
                loan.setInterestRate(rate);
                loan.setDurationMonths(months);
                loan.setMonthlyEmi(emi);

                int loanId = loanDAO.applyLoan(loan);
                if (loanId > 0) {
                    res.sendRedirect(ctx + "/member?page=my-loans&msg=applied");
                } else {
                    req.setAttribute("error", "Loan application failed.");
                    req.getRequestDispatcher("/views/member/apply_loan.jsp").forward(req, res);
                }
                break;
            }

            // Staff disburses an approved loan
            case "disburse": {
                int loanId = Integer.parseInt(req.getParameter("loanId"));
                int staffId = (int) session.getAttribute("userId");
                Loan loan = loanDAO.findById(loanId);

                if (loan != null && "APPROVED".equals(loan.getStatus())) {
                    loanDAO.disburse(loanId);
                    lrDAO.createSchedule(loanId, loan.getMonthlyEmi(), loan.getDurationMonths());

                    // Record transaction
                    Transaction tx = new Transaction();
                    tx.setMemberId(loan.getMemberId());
                    tx.setType("LOAN_DISBURSE");
                    tx.setAmount(loan.getAmount());
                    tx.setBalanceAfter(saDAO.getBalance(loan.getMemberId()));
                    tx.setDescription("Loan #" + loanId + " disbursed");
                    tx.setLoanId(loanId);
                    tx.setRecordedBy(staffId);
                    txDAO.addTransaction(tx);
                }
                res.sendRedirect(ctx + "/staff?page=loan-disburse&msg=disbursed");
                break;
            }

            default:
                res.sendRedirect(ctx + "/member");
        }
    }
}