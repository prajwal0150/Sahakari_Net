package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.dao.StaffDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.UserDao;
import com.sahakarinet.sahakari.SahakariNet.utils.ValidationUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff")
public class StaffServlet extends HttpServlet {

    private MemberDao memberDAO = new MemberDao();
    private TransactionDao txDAO = new TransactionDao();
    private LoanDao loanDAO = new LoanDao();
    private SavingAcountDao saDAO = new SavingAcountDao();
    private StaffDao staffDAO = new StaffDao();
    private UserDao userDAO = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String page = req.getParameter("page");
        if (page == null)
            page = "dashboard";

        switch (page) {
            case "dashboard": {
                int uid = (int) req.getSession().getAttribute("userId");
                req.setAttribute("todayCount", txDAO.countTodayByStaff(uid));
                req.setAttribute("totalMembers", memberDAO.countByStatus("APPROVED"));
                req.setAttribute("activeLoans", loanDAO.countByStatus("DISBURSED"));
                req.setAttribute("recentTx", txDAO.getAll().stream().limit(10).toList());
                req.getRequestDispatcher("/views/staff/dashboard.jsp").forward(req, res);
                break;
            }
            case "search": {
                String q = req.getParameter("q");
                List<Member> members = (q != null && !q.isBlank())
                        ? memberDAO.search(q)
                        : List.of();
                req.setAttribute("members", members);
                req.setAttribute("q", q);
                req.getRequestDispatcher("/views/staff/search_member.jsp").forward(req, res);
                break;
            }
            case "member-detail": {
                int memberId = Integer.parseInt(req.getParameter("id"));
                Member member = memberDAO.findById(memberId);
                req.setAttribute("member", member);
                req.setAttribute("savings", saDAO.getByMemberId(memberId));
                req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                req.setAttribute("recentTx", txDAO.getRecent(memberId, 10));
                req.getRequestDispatcher("/views/staff/member_detail.jsp").forward(req, res);
                break;
            }
            case "deposit": {
                String memberId = req.getParameter("memberId");
                if (memberId != null) {
                    req.setAttribute("member", memberDAO.findById(Integer.parseInt(memberId)));
                    req.setAttribute("savings", saDAO.getByMemberId(Integer.parseInt(memberId)));
                }
                req.getRequestDispatcher("/views/staff/deposit.jsp").forward(req, res);
                break;
            }
            case "withdrawal": {
                String memberId = req.getParameter("memberId");
                if (memberId != null) {
                    req.setAttribute("member", memberDAO.findById(Integer.parseInt(memberId)));
                    req.setAttribute("savings", saDAO.getByMemberId(Integer.parseInt(memberId)));
                }
                req.getRequestDispatcher("/views/staff/withdrawal.jsp").forward(req, res);
                break;
            }
            case "loan-disburse": {
                String loanId = req.getParameter("loanId");
                if (loanId != null)
                    req.setAttribute("loan", loanDAO.findById(Integer.parseInt(loanId)));
                req.setAttribute("approvedLoans", loanDAO.getByStatus("APPROVED"));
                req.getRequestDispatcher("/views/staff/loan_disbure.jsp").forward(req, res);
                break;
            }
            case "repayment": {
                String memberId = req.getParameter("memberId");
                if (memberId != null) {
                    req.setAttribute("member", memberDAO.findById(Integer.parseInt(memberId)));
                    req.setAttribute("loans", loanDAO.getByMemberId(Integer.parseInt(memberId)));
                }
                req.getRequestDispatcher("/views/staff/repayment.jsp").forward(req, res);
                break;
            }
            case "profile": {
                int uid = (int) req.getSession().getAttribute("userId");
                req.setAttribute("staff", staffDAO.findByUserId(uid));
                req.getRequestDispatcher("/views/staff/profile.jsp").forward(req, res);
                break;
            }
            default:
                res.sendRedirect(req.getContextPath() + "/staff");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String ctx = req.getContextPath();

        if (action == null) {
            res.sendRedirect(ctx + "/staff");
            return;
        }

        switch (action) {
            case "update-password": {
                String currentPassword = req.getParameter("currentPassword");
                String newPassword = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");

                if (currentPassword == null || currentPassword.isBlank()
                        || newPassword == null || newPassword.isBlank()
                        || confirmPassword == null || confirmPassword.isBlank()) {
                    res.sendRedirect(ctx + "/staff?page=profile&error=missingFields");
                    break;
                }

                if (!newPassword.equals(confirmPassword)) {
                    res.sendRedirect(ctx + "/staff?page=profile&error=passwordMismatch");
                    break;
                }

                if (!ValidationUtil.isValidPassword(newPassword.trim())) {
                    res.sendRedirect(ctx + "/staff?page=profile&error=invalidPassword");
                    break;
                }

                Object userIdObj = req.getSession(false) != null ? req.getSession(false).getAttribute("userId") : null;
                if (!(userIdObj instanceof Number)) {
                    res.sendRedirect(ctx + "/login.jsp");
                    break;
                }

                int userId = ((Number) userIdObj).intValue();
                User user = userDAO.findById(userId);
                if (user == null || !userDAO.verifyAndUpgradePassword(user, currentPassword.trim())) {
                    res.sendRedirect(ctx + "/staff?page=profile&error=currentPasswordInvalid");
                    break;
                }

                boolean updated = userDAO.updatePasswordForUser(userId, newPassword.trim());
                if (updated) {
                    res.sendRedirect(ctx + "/staff?page=profile&msg=password-updated");
                } else {
                    res.sendRedirect(ctx + "/staff?page=profile&error=updateFailed");
                }
                break;
            }

            default:
                res.sendRedirect(ctx + "/staff");
        }
    }
}