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
    private MemberDao memberDAO = new MemberDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            String action = req.getParameter("action");
            String ctx = req.getContextPath();
            HttpSession session = req.getSession(false);
            Object staffIdObj = session != null ? session.getAttribute("userId") : null;
            if (!(staffIdObj instanceof Number)) {
                res.sendRedirect(ctx + "/login.jsp");
                return;
            }
            int staffId = ((Number) staffIdObj).intValue();

            if (action == null || action.isBlank()) {
                res.sendRedirect(ctx + "/staff");
                return;
            }

            switch (action) {
                case "deposit": {
                    int memberId;
                    double amount;
                    try {
                        memberId = Integer.parseInt(req.getParameter("memberId"));
                        amount = Double.parseDouble(req.getParameter("amount"));
                    } catch (NumberFormatException ex) {
                        res.sendRedirect(ctx + "/staff?page=deposit&error=invalidInput");
                        return;
                    }

                    if (amount <= 0) {
                        res.sendRedirect(ctx + "/staff?page=deposit&memberId=" + memberId + "&error=invalidAmount");
                        return;
                    }

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
                    int memberId;
                    double amount;
                    try {
                        memberId = Integer.parseInt(req.getParameter("memberId"));
                        amount = Double.parseDouble(req.getParameter("amount"));
                    } catch (NumberFormatException ex) {
                        res.sendRedirect(ctx + "/staff?page=withdrawal&error=invalidInput");
                        return;
                    }

                    if (amount <= 0) {
                        req.setAttribute("error", "Withdrawal amount must be greater than zero.");
                        req.setAttribute("member", memberDAO.findById(memberId));
                        req.setAttribute("savings", saDAO.getByMemberId(memberId));
                        req.getRequestDispatcher("/views/staff/withdrawal.jsp").forward(req, res);
                        return;
                    }

                    String desc = req.getParameter("description");
                    double current = saDAO.getBalance(memberId);

                    if (amount > current) {
                        req.setAttribute("error", "Insufficient balance. Current: Rs. " + current);
                        req.setAttribute("member", memberDAO.findById(memberId));
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
                    int repaymentId;
                    int loanId;
                    int memberId;
                    double amount;
                    try {
                        repaymentId = Integer.parseInt(req.getParameter("repaymentId"));
                        loanId = Integer.parseInt(req.getParameter("loanId"));
                        memberId = Integer.parseInt(req.getParameter("memberId"));
                        amount = Double.parseDouble(req.getParameter("amount"));
                    } catch (NumberFormatException ex) {
                        res.sendRedirect(ctx + "/staff?page=repayment&error=invalidInput");
                        return;
                    }

                    if (amount <= 0) {
                        res.sendRedirect(ctx + "/staff?page=repayment&memberId=" + memberId + "&error=invalidAmount");
                        return;
                    }

                    var repayment = lrDAO.findById(repaymentId);
                    if (repayment == null || repayment.getLoanId() != loanId) {
                        res.sendRedirect(
                                ctx + "/staff?page=repayment&memberId=" + memberId + "&error=invalidRepayment");
                        return;
                    }

                    if (repayment.getPaidAmount() > 0) {
                        res.sendRedirect(ctx + "/staff?page=repayment&memberId=" + memberId + "&error=alreadyPaid");
                        return;
                    }

                    if (amount > repayment.getDueAmount()) {
                        res.sendRedirect(
                                ctx + "/staff?page=repayment&memberId=" + memberId + "&error=amountExceedsDue");
                        return;
                    }

                    lrDAO.recordPayment(repaymentId, amount);

                    // Check if all instalments paid → close loan
                    var loan = loanDAO.findById(loanId);
                    if (loan == null) {
                        res.sendRedirect(ctx + "/staff?page=repayment&memberId=" + memberId + "&error=loanNotFound");
                        return;
                    }

                    if (loan.getMemberId() != memberId) {
                        res.sendRedirect(
                                ctx + "/staff?page=repayment&memberId=" + memberId + "&error=loanMemberMismatch");
                        return;
                    }

                    int total = loan.getDurationMonths();
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
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/staff?error=Operation failed");
        }
    }
}