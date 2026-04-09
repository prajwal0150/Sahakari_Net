package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/member")
public class MemberServlet extends HttpServlet {

    private MemberDao memberDAO = new MemberDao();
    private SavingAcountDao saDAO = new SavingAcountDao();
    private TransactionDao txDAO = new TransactionDao();
    private LoanDao loanDAO = new LoanDao();
    private LoanRepaymentDao lrDAO = new LoanRepaymentDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        int memberId = (int) session.getAttribute("memberId");
        String page = req.getParameter("page");
        if (page == null)
            page = "dashboard";

        switch (page) {
            case "dashboard": {
                req.setAttribute("member", memberDAO.findById(memberId));
                req.setAttribute("savings", saDAO.getByMemberId(memberId));
                req.setAttribute("recentTx", txDAO.getRecent(memberId, 5));
                req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                req.getRequestDispatcher("/views/member/dashboard.jsp").forward(req, res);
                break;
            }
            case "savings": {
                req.setAttribute("savings", saDAO.getByMemberId(memberId));
                req.setAttribute("txHistory", txDAO.getByMemberId(memberId));
                req.getRequestDispatcher("/views/member/saving.jsp").forward(req, res);
                break;
            }
            case "transactions": {
                req.setAttribute("transactions", txDAO.getByMemberId(memberId));
                req.getRequestDispatcher("/views/member/transaction.jsp").forward(req, res);
                break;
            }
            case "apply-loan": {
                req.getRequestDispatcher("/views/member/apply_loan.jsp").forward(req, res);
                break;
            }
            case "my-loans": {
                req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                req.getRequestDispatcher("/views/member/my_loan.jsp").forward(req, res);
                break;
            }
            case "repayment-schedule": {
                int loanId = Integer.parseInt(req.getParameter("loanId"));
                req.setAttribute("loan", loanDAO.findById(loanId));
                req.setAttribute("schedule", lrDAO.getByLoanId(loanId));
                req.getRequestDispatcher("/views/member/repayment.jsp").forward(req, res);
                break;
            }
            case "profile": {
                req.setAttribute("member", memberDAO.findById(memberId));
                req.setAttribute("savings", saDAO.getByMemberId(memberId));
                req.getRequestDispatcher("/views/member/profile.jsp").forward(req, res);
                break;
            }
            default:
                res.sendRedirect(req.getContextPath() + "/member");
        }
    }
}