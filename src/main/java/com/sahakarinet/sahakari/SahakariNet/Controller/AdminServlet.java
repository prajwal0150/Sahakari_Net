package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Loan;
import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.Staff;
import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.dao.*;
import com.sahakarinet.sahakari.SahakariNet.utils.PasswordUtil;
import com.sahakarinet.sahakari.SahakariNet.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

// updated
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private MemberDao memberDAO = new MemberDao();
    private LoanDao loanDAO = new LoanDao();
    private ReportDao reportDAO = new ReportDao();
    private UserDao userDAO = new UserDao();
    private LoanRepaymentDao repaymentDAO = new LoanRepaymentDao();
    private TransactionDao transactionDAO = new TransactionDao();
    private SavingAcountDao savingAccountDAO = new SavingAcountDao();
    private StaffDao staffDAO = new StaffDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String page = req.getParameter("page");
        if (page == null)
            page = "dashboard";

        String ctx = req.getContextPath();

        try {
            switch (page) {
                case "dashboard": {
                    Map<String, Object> stats = reportDAO.getDashboardStats();
                    req.setAttribute("stats", stats);
                    req.setAttribute("staffCount", staffDAO.getAll().size());
                    req.setAttribute("pendingLoans", loanDAO.getByStatus("PENDING"));
                    req.setAttribute("pendingMembers", memberDAO.getPending());
                    req.setAttribute("recentTransactions", transactionDAO.getAll());
                    req.setAttribute("severeDefaulters", repaymentDAO.countOverdueDefaulters(90));
                    req.getRequestDispatcher("/Views/admin/dashboard.jsp").forward(req, res);
                    break;
                }

                case "members": {
                    String q = req.getParameter("q");
                    List<Member> members = (q != null && !q.isBlank())
                            ? memberDAO.search(q)
                            : memberDAO.getAll();

                    req.setAttribute("members", members != null ? members : Collections.emptyList());
                    req.setAttribute("q", q);
                    req.getRequestDispatcher("/Views/admin/member.jsp").forward(req, res);
                    break;
                }

                case "member-detail": {
                    String idParam = req.getParameter("id");
                    if (idParam != null) {
                        int id = Integer.parseInt(idParam);
                        Member member = memberDAO.findById(id);
                        req.setAttribute("member", member);
                        req.getRequestDispatcher("/Views/admin/member_detail.jsp").forward(req, res);
                    } else {
                        res.sendRedirect(ctx + "/admin?page=members");
                    }
                    break;
                }

                case "member-approval": {
                    List<Member> pending = memberDAO.getPending();
                    req.setAttribute("pending", pending != null ? pending : Collections.emptyList());
                    req.getRequestDispatcher("/Views/admin/member_approval.jsp").forward(req, res);
                    break;
                }

                case "loans": {
                    String status = req.getParameter("status");
                    List<Loan> loans = (status != null && !status.isBlank())
                            ? loanDAO.getByStatus(status)
                            : loanDAO.getAll();

                    req.setAttribute("loans", loans != null ? loans : Collections.emptyList());
                    req.setAttribute("filterStatus", status);
                    req.getRequestDispatcher("/Views/admin/loan.jsp").forward(req, res);
                    break;
                }

                case "loan-detail": {
                    String idParam = req.getParameter("id");
                    if (idParam != null) {
                        int id = Integer.parseInt(idParam);
                        Loan loan = loanDAO.findById(id);
                        req.setAttribute("loan", loan);
                        req.getRequestDispatcher("/Views/admin/loan_detail.jsp").forward(req, res);
                    } else {
                        res.sendRedirect(ctx + "/admin?page=loans");
                    }
                    break;
                }

                case "defaulters": {
                    List<?> defaulters = repaymentDAO.getDefaulters();
                    req.setAttribute("defaulters", defaulters != null ? defaulters : Collections.emptyList());
                    req.getRequestDispatcher("/Views/admin/defaulter.jsp").forward(req, res);
                    break;
                }

                case "transactions": {
                    List<?> trans = transactionDAO.getAll();
                    req.setAttribute("transactions", trans != null ? trans : Collections.emptyList());
                    req.getRequestDispatcher("/Views/admin/transaction.jsp").forward(req, res);
                    break;
                }

                case "staff": {
                    req.setAttribute("staffList", staffDAO.getAll());
                    req.getRequestDispatcher("/Views/admin/staff.jsp").forward(req, res);
                    break;
                }

                default:
                    res.sendRedirect(ctx + "/admin");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(ctx + "/admin?error=Something went wrong");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String ctx = req.getContextPath();

        if (action == null) {
            res.sendRedirect(ctx + "/admin");
            return;
        }

        try {
            switch (action) {
                case "approve-member": {
                    String memberIdParam = req.getParameter("memberId");

                    if (memberIdParam != null) {
                        int memberId = Integer.parseInt(memberIdParam);
                        Member m = memberDAO.findById(memberId);

                        if (m != null) {
                            memberDAO.approve(memberId);
                            userDAO.activateUser(m.getUserId());

                            savingAccountDAO.createAccount(memberId);
                        }
                    }

                    res.sendRedirect(ctx + "/admin?page=member-approval&msg=success");
                    break;
                }

                case "reject-member": {
                    String memberIdParam = req.getParameter("memberId");

                    if (memberIdParam != null) {
                        int memberId = Integer.parseInt(memberIdParam);
                        memberDAO.reject(memberId);
                    }

                    res.sendRedirect(ctx + "/admin?page=member-approval&msg=rejected");
                    break;
                }

                case "approve-loan": {
                    String loanIdParam = req.getParameter("loanId");

                    HttpSession session = req.getSession(false);

                    if (loanIdParam != null && session != null) {
                        int loanId = Integer.parseInt(loanIdParam);
                        Object userIdObj = session.getAttribute("userId");

                        if (userIdObj instanceof Number) {
                            int adminId = ((Number) userIdObj).intValue();
                            loanDAO.approve(loanId, adminId);
                            res.sendRedirect(ctx + "/admin?page=loan-detail&id=" + loanId);
                        } else {
                            res.sendRedirect(ctx + "/admin?page=loans&error=invalidRequest");
                        }
                    } else {
                        res.sendRedirect(ctx + "/admin?page=loans&error=invalidRequest");
                    }
                    break;
                }

                case "reject-loan": {
                    String loanIdParam = req.getParameter("loanId");

                    HttpSession session = req.getSession(false);

                    if (loanIdParam != null && session != null) {
                        int loanId = Integer.parseInt(loanIdParam);
                        Object userIdObj = session.getAttribute("userId");

                        if (userIdObj instanceof Number) {
                            int adminId = ((Number) userIdObj).intValue();
                            loanDAO.reject(loanId, adminId);
                            res.sendRedirect(ctx + "/admin?page=loans&msg=rejected");
                        } else {
                            res.sendRedirect(ctx + "/admin?page=loans&error=invalidRequest");
                        }
                    } else {
                        res.sendRedirect(ctx + "/admin?page=loans&error=invalidRequest");
                    }
                    break;
                }

                case "create-staff": {
                    String fullName = req.getParameter("fullName");
                    String gender = req.getParameter("gender");
                    String email = req.getParameter("email");
                    String phone = req.getParameter("phone");
                    String password = req.getParameter("password");
                    String permanentAddress = req.getParameter("permanentAddress");
                    String temporaryAddress = req.getParameter("temporaryAddress");

                    if (fullName == null || fullName.isBlank() || email == null || email.isBlank()
                            || gender == null || gender.isBlank()
                            || phone == null || phone.isBlank()
                            || password == null || password.isBlank()
                            || permanentAddress == null || permanentAddress.isBlank()
                            || temporaryAddress == null || temporaryAddress.isBlank()) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=missingFields");
                        break;
                    }

                    if (!ValidationUtil.isValidPassword(password.trim())) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidPassword");
                        break;
                    }

                    String normalizedEmail = email.trim().toLowerCase();
                    String normalizedPhone = phone.trim();
                    String normalizedUsername = normalizedEmail;

                    if (!ValidationUtil.isValidEmail(normalizedEmail)) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidEmail");
                        break;
                    }
                    if (!ValidationUtil.isValidPhone(normalizedPhone)) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidPhone");
                        break;
                    }

                    if (userDAO.usernameExists(normalizedUsername)) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=usernameExists");
                        break;
                    }
                    if (userDAO.emailExists(normalizedEmail)) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=emailExists");
                        break;
                    }

                    Staff staff = new Staff();
                    staff.setFullName(fullName.trim());
                    staff.setGender(gender.trim());
                    staff.setUsername(normalizedUsername);
                    staff.setEmail(normalizedEmail);
                    staff.setPasswordHash(PasswordUtil.hash(password.trim()));
                    staff.setPhone(normalizedPhone);
                    staff.setPermanentAddress(permanentAddress.trim());
                    staff.setTemporaryAddress(temporaryAddress.trim());
                    staff.setActive(true);

                    int staffUserId = staffDAO.registerStaff(staff);
                    if (staffUserId > 0) {
                        res.sendRedirect(ctx + "/admin?page=staff&msg=created");
                    } else {
                        res.sendRedirect(ctx + "/admin?page=staff&error=createFailed");
                    }
                    break;
                }

                case "toggle-staff-active": {
                    String userIdParam = req.getParameter("userId");
                    if (userIdParam == null || userIdParam.isBlank()) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidStaff");
                        break;
                    }

                    int userId = Integer.parseInt(userIdParam);
                    User user = userDAO.findById(userId);
                    if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidStaff");
                        break;
                    }

                    boolean ok;
                    if (user.isActive()) {
                        ok = userDAO.deactivateUser(userId);
                        res.sendRedirect(ctx + "/admin?page=staff&msg=" + (ok ? "deactivated" : "toggleFailed"));
                    } else {
                        ok = userDAO.activateUser(userId);
                        res.sendRedirect(ctx + "/admin?page=staff&msg=" + (ok ? "activated" : "toggleFailed"));
                    }
                    break;
                }

                case "remove-staff": {
                    String userIdParam = req.getParameter("userId");
                    if (userIdParam == null || userIdParam.isBlank()) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidStaff");
                        break;
                    }

                    int userId = Integer.parseInt(userIdParam);
                    User user = userDAO.findById(userId);
                    if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
                        res.sendRedirect(ctx + "/admin?page=staff&error=invalidStaff");
                        break;
                    }

                    boolean deleted = userDAO.deleteUser(userId);
                    if (deleted) {
                        res.sendRedirect(ctx + "/admin?page=staff&msg=removed");
                    } else {
                        res.sendRedirect(ctx + "/admin?page=staff&error=removeFailed");
                    }
                    break;
                }

                default:
                    res.sendRedirect(ctx + "/admin");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(ctx + "/admin?error=Operation failed");
        }
    }
}