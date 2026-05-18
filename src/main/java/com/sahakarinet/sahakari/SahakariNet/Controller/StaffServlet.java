package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.dao.StaffDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.LoanRepaymentDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.SavingsAccount;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.TransactionDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.UserDao;
import com.sahakarinet.sahakari.SahakariNet.utils.ValidationUtil;
import com.sahakarinet.sahakari.SahakariNet.utils.SessionUtil;

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

    private Member resolveMemberSearch(String query) {
        if (query == null || query.isBlank()) {
            return null;
        }

        String trimmed = query.trim();
        List<Member> found = memberDAO.search(trimmed);
        if (found.isEmpty()) {
            return null;
        }

        for (Member member : found) {
            if (matchesExactly(member.getFullName(), trimmed)
                    || matchesExactly(member.getPhone(), trimmed)
                    || matchesExactly(member.getCitizenshipNo(), trimmed)) {
                return member;
            }
        }

        if (found.size() == 1) {
            return found.get(0);
        }

        return null;
    }

    private boolean matchesExactly(String value, String query) {
        return value != null && value.trim().equalsIgnoreCase(query);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            String page = req.getParameter("page");
            if (page == null)
                page = "dashboard";

            switch (page) {
                case "dashboard": {
                    Integer userIdObj = SessionUtil.getUserId(req);
                    int uid = 0;
                    if (userIdObj != null) {
                        uid = userIdObj;
                    }
                    req.setAttribute("todayCount", txDAO.countTodayByStaff(uid));
                    req.setAttribute("totalMembers", memberDAO.countByStatus("APPROVED"));
                    req.setAttribute("activeLoans", loanDAO.countByStatus("DISBURSED"));
                    req.setAttribute("recentTx", txDAO.getAll().stream().limit(10).toList());
                    req.getRequestDispatcher("/Views/staff/dashboard.jsp").forward(req, res);
                    break;
                }
                case "search": {
                    String q = req.getParameter("q");
                    String memberId = req.getParameter("memberId");
                    List<Member> members = (q != null && !q.isBlank())
                            ? memberDAO.search(q)
                            : List.of();
                    Member selectedMember = null;
                    if (memberId != null && !memberId.isBlank()) {
                        try {
                            selectedMember = memberDAO.findById(Integer.parseInt(memberId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    }
                    req.setAttribute("members", members);
                    req.setAttribute("q", q);
                    req.setAttribute("selectedMember", selectedMember);
                    req.setAttribute("searchMemberHistory",
                            selectedMember != null ? txDAO.getRecent(selectedMember.getId(), 20) : List.of());
                    req.getRequestDispatcher("/Views/staff/search_member.jsp").forward(req, res);
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

                    SavingsAccount savings = saDAO.getByMemberId(memberId);
                    if (savings == null) {
                        // create default savings account row if missing
                        saDAO.createAccount(memberId);
                        savings = saDAO.getByMemberId(memberId);
                    }
                    req.setAttribute("savings", savings);
                    req.setAttribute("loans", loanDAO.getByMemberId(memberId));
                    req.setAttribute("recentTx", txDAO.getRecent(memberId, 10));
                    req.getRequestDispatcher("/Views/staff/member_detail.jsp").forward(req, res);
                    break;
                }
                case "deposit": {
                    String q = req.getParameter("q");
                    String memberId = req.getParameter("memberId");
                    Member selectedMember = null;
                    List<Member> memberSearchMembers = List.of();

                    if (memberId != null && !memberId.isBlank()) {
                        try {
                            int mId = Integer.parseInt(memberId);
                            selectedMember = memberDAO.findById(mId);
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    } else if (q != null && !q.isBlank()) {
                        selectedMember = resolveMemberSearch(q);
                        if (selectedMember == null) {
                            memberSearchMembers = memberDAO.search(q.trim());
                        }
                    }

                    req.setAttribute("q", q);
                    req.setAttribute("memberSearchMembers", memberSearchMembers);
                    if (selectedMember != null) {
                        req.setAttribute("member", selectedMember);

                        SavingsAccount savings = saDAO.getByMemberId(selectedMember.getId());
                        if (savings == null) {
                            saDAO.createAccount(selectedMember.getId());
                            savings = saDAO.getByMemberId(selectedMember.getId());
                        }
                        req.setAttribute("savings", savings);
                    }

                    req.setAttribute("depositHistory",
                            selectedMember != null
                                    ? txDAO.getByTypeAndMemberWithLimit("DEPOSIT", selectedMember.getId(), 20)
                                    : txDAO.getByTypeWithLimit("DEPOSIT", 20));
                    req.getRequestDispatcher("/Views/staff/deposit.jsp").forward(req, res);
                    break;
                }
                case "withdrawal": {
                    String q = req.getParameter("q");
                    String memberId = req.getParameter("memberId");
                    Member selectedMember = null;
                    List<Member> memberSearchMembers = List.of();

                    if (memberId != null && !memberId.isBlank()) {
                        try {
                            int mId = Integer.parseInt(memberId);
                            selectedMember = memberDAO.findById(mId);
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    } else if (q != null && !q.isBlank()) {
                        selectedMember = resolveMemberSearch(q);
                        if (selectedMember == null) {
                            memberSearchMembers = memberDAO.search(q.trim());
                        }
                    }

                    req.setAttribute("q", q);
                    req.setAttribute("memberSearchMembers", memberSearchMembers);
                    if (selectedMember != null) {
                        req.setAttribute("member", selectedMember);

                        SavingsAccount savings = saDAO.getByMemberId(selectedMember.getId());
                        if (savings == null) {
                            saDAO.createAccount(selectedMember.getId());
                            savings = saDAO.getByMemberId(selectedMember.getId());
                        }
                        req.setAttribute("savings", savings);
                    }

                    req.setAttribute("withdrawalHistory",
                            selectedMember != null
                                    ? txDAO.getByTypeAndMemberWithLimit("WITHDRAWAL", selectedMember.getId(), 20)
                                    : txDAO.getByTypeWithLimit("WITHDRAWAL", 20));
                    req.getRequestDispatcher("/Views/staff/withdrawal.jsp").forward(req, res);
                    break;
                }
                case "loan-disburse": {
                    String loanId = req.getParameter("loanId");
                    String memberId = req.getParameter("memberId");
                    Member selectedMember = null;
                    if (loanId != null) {
                        try {
                            req.setAttribute("loan", loanDAO.findById(Integer.parseInt(loanId)));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid loanId
                        }
                    }
                    if (memberId != null && !memberId.isBlank()) {
                        try {
                            selectedMember = memberDAO.findById(Integer.parseInt(memberId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    }

                    List<com.sahakarinet.sahakari.SahakariNet.model.Loan> approvedLoans = loanDAO
                            .getByStatus("APPROVED");
                    if (selectedMember != null) {
                        int selectedMemberId = selectedMember.getId();
                        approvedLoans = approvedLoans.stream()
                                .filter(l -> l.getMemberId() == selectedMemberId)
                                .toList();
                    }

                    req.setAttribute("selectedMember", selectedMember);
                    req.setAttribute("approvedLoans", approvedLoans);
                    req.setAttribute("loanDisburseHistory",
                            selectedMember != null
                                    ? txDAO.getByTypeAndMemberWithLimit("LOAN_DISBURSE", selectedMember.getId(), 20)
                                    : txDAO.getByTypeWithLimit("LOAN_DISBURSE", 20));
                    req.getRequestDispatcher("/Views/staff/loan_disbure.jsp").forward(req, res);
                    break;
                }
                case "repayment": {
                    String memberId = req.getParameter("memberId");
                    String q = req.getParameter("q");
                    Member selectedMember = null;
                    List<Member> memberSearchMembers = List.of();
                    if (memberId != null) {
                        try {
                            selectedMember = memberDAO.findById(Integer.parseInt(memberId));
                        } catch (NumberFormatException ex) {
                            // Ignore invalid memberId
                        }
                    } else {
                        if (q != null && !q.isBlank()) {
                            selectedMember = resolveMemberSearch(q);
                            if (selectedMember == null) {
                                memberSearchMembers = memberDAO.search(q.trim());
                            }
                        }
                    }

                    req.setAttribute("q", q);
                    req.setAttribute("memberSearchMembers", memberSearchMembers);

                    if (selectedMember != null) {
                        req.setAttribute("member", selectedMember);
                        List<com.sahakarinet.sahakari.SahakariNet.model.Loan> loans = loanDAO
                                .getByMemberId(selectedMember.getId());
                        req.setAttribute("loans", loans);

                        java.util.Map<Integer, Object> nextDueByLoan = new java.util.HashMap<>();
                        for (com.sahakarinet.sahakari.SahakariNet.model.Loan loan : loans) {
                            if ("DISBURSED".equals(loan.getStatus())) {
                                nextDueByLoan.put(loan.getId(), lrDAO.findNextDue(loan.getId()));
                            }
                        }
                        req.setAttribute("nextDueByLoan", nextDueByLoan);
                    }

                    req.setAttribute("repaymentHistory",
                            selectedMember != null
                                    ? txDAO.getByTypeAndMemberWithLimit("LOAN_REPAYMENT", selectedMember.getId(), 20)
                                    : txDAO.getByTypeWithLimit("LOAN_REPAYMENT", 20));

                    req.getRequestDispatcher("/Views/staff/repayment.jsp").forward(req, res);
                    break;
                }
                case "profile": {
                    Integer userIdObj = SessionUtil.getUserId(req);
                    int uid = 0;
                    if (userIdObj != null) {
                        uid = userIdObj;
                    }
                    req.setAttribute("staff", staffDAO.findByUserId(uid));
                    req.getRequestDispatcher("/Views/staff/profile.jsp").forward(req, res);
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

                Integer userIdObj = SessionUtil.getUserId(req);
                if (userIdObj == null) {
                    res.sendRedirect(ctx + "/login.jsp");
                    break;
                }

                int userId = userIdObj;
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