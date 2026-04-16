package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.dao.StaffDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
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
    private LoanRepaymentDao lrDAO = new LoanRepaymentDao();
    private SavingAcountDao saDAO = new SavingAcountDao();
    private StaffDao staffDAO = new StaffDao();
    private UserDao userDAO = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            String page = req.getParameter("page");
            if (page == null)
                page = "dashboard";

            switch (page) {
                case "dashboard": {
                    HttpSession session = req.getSession(false);
                    Object userIdObj = session != null ? session.getAttribute("userId") : null;
                    int uid = 0;
                    if (userIdObj instanceof Number) {
                        uid = ((Number) userIdObj).intValue();
                    }
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
                    String idParam = req.getParameter("id");
                    int memberId;
                    try {
                        memberId = Integer.parseInt(idParam);
                    } catch (NumberFormatException ex) {
                        res.sendRedirect(req.getContextPath() + "/staff?page=search");
                        break;
                    }
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
                        try {
                            int mId = Integer.parseInt(memberId);
                            req.setAttribute("member", memberDAO.findById(mId));
                            req.setAttribute("savings", saDAO.getByMemberId(mId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    }
                    req.getRequestDispatcher("/views/staff/deposit.jsp").forward(req, res);
                    break;
                }
                case "withdrawal": {
                    String memberId = req.getParameter("memberId");
                    if (memberId != null) {
                        try {
                            int mId = Integer.parseInt(memberId);
                            req.setAttribute("member", memberDAO.findById(mId));
                            req.setAttribute("savings", saDAO.getByMemberId(mId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    }
                    req.getRequestDispatcher("/views/staff/withdrawal.jsp").forward(req, res);
                    break;
                }
                case "loan-disburse": {
                    String loanId = req.getParameter("loanId");
                    if (loanId != null) {
                        try {
                            req.setAttribute("loan", loanDAO.findById(Integer.parseInt(loanId)));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid loanId
                        }
                    }
                    req.setAttribute("approvedLoans", loanDAO.getByStatus("APPROVED"));
                    req.getRequestDispatcher("/views/staff/loan_disbure.jsp").forward(req, res);
                    break;
                }
                case "repayment": {
                    String memberId = req.getParameter("memberId");
                    Member selectedMember = null;
                    if (memberId != null) {
                        try {
                            selectedMember = memberDAO.findById(Integer.parseInt(memberId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    } else {
                        String q = req.getParameter("q");
                        if (q != null && !q.isBlank()) {
                            List<Member> found = memberDAO.search(q.trim());
                            if (!found.isEmpty()) {
                                selectedMember = found.get(0);
                            }
                        }
                    }

                    if (selectedMember != null) {
                        req.setAttribute("member", selectedMember);
                        var loans = loanDAO.getByMemberId(selectedMember.getId());
                        req.setAttribute("loans", loans);

                        java.util.Map<Integer, Object> nextDueByLoan = new java.util.HashMap<>();
                        for (var loan : loans) {
                            if ("DISBURSED".equals(loan.getStatus())) {
                                nextDueByLoan.put(loan.getId(), lrDAO.findNextDue(loan.getId()));
                            }
                        }
                        req.setAttribute("nextDueByLoan", nextDueByLoan);
                    }

                    req.getRequestDispatcher("/views/staff/repayment.jsp").forward(req, res);
                    break;
                }
                case "profile": {
                    HttpSession session = req.getSession(false);
                    Object userIdObj = session != null ? session.getAttribute("userId") : null;
                    int uid = 0;
                    if (userIdObj instanceof Number) {
                        uid = ((Number) userIdObj).intValue();
                    }
                    req.setAttribute("staff", staffDAO.findByUserId(uid));
                    req.getRequestDispatcher("/views/staff/profile.jsp").forward(req, res);
                    break;
                }
                default:
                    res.sendRedirect(req.getContextPath() + "/staff");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/staff?error=Something went wrong");
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