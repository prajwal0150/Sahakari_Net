package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;
import com.sahakarinet.sahakari.SahakariNet.utils.session;

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

        try {
            Integer memberIdObj = session.getMemberId(req);
            if (memberIdObj == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }
            int memberId = memberIdObj;
            String page = req.getParameter("page");
            if (page == null)
                page = "dashboard";

            switch (page) {
                case "dashboard": {
                    req.setAttribute("member", memberDAO.findById(memberId));
                    req.setAttribute("savings", saDAO.getByMemberId(memberId));
                    req.setAttribute("recentTx", txDAO.getRecent(memberId, 5));
                    req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/Views/member/dashboard.jsp").forward(req, res);
                    break;
                }
                case "savings": {
                    req.setAttribute("savings", saDAO.getByMemberId(memberId));
                    req.setAttribute("txHistory", txDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/Views/member/saving.jsp").forward(req, res);
                    break;
                }
                case "transactions": {
                    req.setAttribute("transactions", txDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/Views/member/transaction.jsp").forward(req, res);
                    break;
                }
                case "apply-loan": {
                    req.getRequestDispatcher("/Views/member/apply_loan.jsp").forward(req, res);
                    break;
                }
                case "my-loans": {
                    req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/Views/member/my_loan.jsp").forward(req, res);
                    break;
                }
                case "repayment-schedule": {
                    String loanIdParam = req.getParameter("loanId");
                    if (loanIdParam == null || loanIdParam.isBlank()) {
                        res.sendRedirect(req.getContextPath() + "/member?page=my-loans");
                        break;
                    }
                    int loanId;
                    try {
                        loanId = Integer.parseInt(loanIdParam);
                    } catch (NumberFormatException ex) {
                        res.sendRedirect(req.getContextPath() + "/member?page=my-loans");
                        break;
                    }

                    var loan = loanDAO.findById(loanId);
                    if (loan == null || loan.getMemberId() != memberId) {
                        res.sendRedirect(req.getContextPath() + "/member?page=my-loans");
                        return;
                    }

                    req.setAttribute("loan", loan);
                    req.setAttribute("schedule", lrDAO.getByLoanId(loanId));
                    req.getRequestDispatcher("/Views/member/repayment.jsp").forward(req, res);
                    break;
                }
                case "profile": {
                    req.setAttribute("member", memberDAO.findById(memberId));
                    req.setAttribute("savings", saDAO.getByMemberId(memberId));
                    req.getRequestDispatcher("/Views/member/profile.jsp").forward(req, res);
                    break;
                }
                default:
                    res.sendRedirect(req.getContextPath() + "/member");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/member?error=Something went wrong");
        }
    }
}