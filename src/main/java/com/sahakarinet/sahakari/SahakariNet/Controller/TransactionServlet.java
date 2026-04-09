package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Transaction;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/transaction")
public class TransactionServlet extends HttpServlet {

    private SavingAcountDao saDAO = new SavingAcountDao();
    private TransactionDao txDAO = new TransactionDao();
    private LoanRepaymentDao lrDAO = new LoanRepaymentDao();
    private LoanDao loanDAO = new LoanDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String ctx = req.getContextPath();
        int staffId = (int) req.getSession().getAttribute("userId");

        switch (action) {
            case "deposit": {
                int memberId = Integer.parseInt(req.getParameter("memberId"));
                double amount = Double.parseDouble(req.getParameter("amount"));
                String desc = req.getParameter("description");

                saDAO.deposit(memberId, amount);
                double balanceAfter = saDAO.getBalance(memberId);

                Transaction tx = new Transaction();
                tx.setMemberId(memberId);
                tx.setType("DEPOSIT");
                tx.setAmount(amount);
                tx.setBalanceAfter(balanceAfter);
                tx.setDescription(desc != null ? desc : "Savings deposit");
                tx.setRecordedBy(staffId);
                txDAO.addTransaction(tx);

                res.sendRedirect(ctx + "/staff?page=member-detail&id=" + memberId + "&msg=deposited");
                break;
            }

            case "withdraw": {
                int memberId = Integer.parseInt(req.getParameter("memberId"));
                double amount = Double.parseDouble(req.getParameter("amount"));
                String desc = req.getParameter("description");
                double current = saDAO.getBalance(memberId);

                if (amount > current) {
                    req.setAttribute("error", "Insufficient balance. Current: Rs. " + current);
                    req.setAttribute("member", new MemberDao().findById(memberId));
                    req.setAttribute("savings", saDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/views/staff/withdrawal.jsp").forward(req, res);
                    return;
                }

                saDAO.withdraw(memberId, amount);
                double balanceAfter = saDAO.getBalance(memberId);

                Transaction tx = new Transaction();
                tx.setMemberId(memberId);
                tx.setType("WITHDRAWAL");
                tx.setAmount(amount);
                tx.setBalanceAfter(balanceAfter);
                tx.setDescription(desc != null ? desc : "Savings withdrawal");
                tx.setRecordedBy(staffId);
                txDAO.addTransaction(tx);

                res.sendRedirect(ctx + "/staff?page=member-detail&id=" + memberId + "&msg=withdrawn");
                break;
            }

            case "repayment": {
                int repaymentId = Integer.parseInt(req.getParameter("repaymentId"));
                int loanId = Integer.parseInt(req.getParameter("loanId"));
                int memberId = Integer.parseInt(req.getParameter("memberId"));
                double amount = Double.parseDouble(req.getParameter("amount"));

                lrDAO.recordPayment(repaymentId, amount);

                // Check if all instalments paid → close loan
                int total = loanDAO.findById(loanId).getDurationMonths();
                int paid = lrDAO.countPaid(loanId);
                if (paid >= total)
                    loanDAO.closeLoan(loanId);

                Transaction tx = new Transaction();
                tx.setMemberId(memberId);
                tx.setType("LOAN_REPAYMENT");
                tx.setAmount(amount);
                tx.setBalanceAfter(saDAO.getBalance(memberId));
                tx.setDescription("Loan #" + loanId + " repayment");
                tx.setLoanId(loanId);
                tx.setRecordedBy(staffId);
                txDAO.addTransaction(tx);

                res.sendRedirect(ctx + "/staff?page=repayment&memberId=" + memberId + "&msg=repaid");
                break;
            }

            default:
                res.sendRedirect(ctx + "/staff");
        }
    }
}