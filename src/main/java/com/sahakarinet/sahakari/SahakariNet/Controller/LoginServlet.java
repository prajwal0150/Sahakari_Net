package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.UserDao;
import com.sahakarinet.sahakari.SahakariNet.utils.CookieUtil;
import com.sahakarinet.sahakari.SahakariNet.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final int AUTH_COOKIE_MAX_AGE_SECONDS = 8 * 60 * 60;

    private UserDao userDAO = new UserDao();
    private MemberDao memberDAO = new MemberDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Already logged in? redirect to dashboard
        String role = SessionUtil.getRole(req);
        if (role != null) {
            redirectByRole(role, req, res);
            return;
        }
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic validation
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Please enter username and password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        String normalizedUsername = username.trim();

        // Keep demo/default admin credentials usable on fresh databases.
        if ("admin".equalsIgnoreCase(normalizedUsername)) {
            userDAO.ensureDefaultAdmin();
        }

        User user = userDAO.findByUsername(normalizedUsername);
        if (user == null) {
            String lower = normalizedUsername.toLowerCase();
            if (!lower.equals(normalizedUsername)) {
                user = userDAO.findByUsername(lower);
            }
            if (user == null && normalizedUsername.contains("@")) {
                user = userDAO.findByEmail(lower);
            }
        }

        if (user != null && !user.isActive()) {
            req.setAttribute("error", "Your account is not approved by the admin yet.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        if (!userDAO.verifyAndUpgradePassword(user, password)) {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // Create session
        SessionUtil.setUserSession(req, user.getId(), user.getUsername(), user.getRole());
        CookieUtil.addCookie(res, CookieUtil.COOKIE_USER_ID, String.valueOf(user.getId()), AUTH_COOKIE_MAX_AGE_SECONDS);
        CookieUtil.addCookie(res, CookieUtil.COOKIE_USERNAME, user.getUsername(), AUTH_COOKIE_MAX_AGE_SECONDS);
        CookieUtil.addCookie(res, CookieUtil.COOKIE_ROLE, user.getRole(), AUTH_COOKIE_MAX_AGE_SECONDS);

        // If member, also store memberId
        if ("MEMBER".equals(user.getRole())) {
            Member member = memberDAO.findByUserId(user.getId());
            if (member != null) {
                SessionUtil.setMemberSession(req, member.getId(), member.getFullName());
                CookieUtil.addCookie(res, CookieUtil.COOKIE_MEMBER_ID, String.valueOf(member.getId()),
                        AUTH_COOKIE_MAX_AGE_SECONDS);
                CookieUtil.addCookie(res, CookieUtil.COOKIE_MEMBER_NAME, member.getFullName(),
                        AUTH_COOKIE_MAX_AGE_SECONDS);
            }
        } else {
            CookieUtil.deleteCookie(res, CookieUtil.COOKIE_MEMBER_ID);
            CookieUtil.deleteCookie(res, CookieUtil.COOKIE_MEMBER_NAME);
        }

        redirectByRole(user.getRole(), req, res);
    }

    private void redirectByRole(String role, HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        String ctx = req.getContextPath();
        switch (role) {
            case "ADMIN":
                res.sendRedirect(ctx + "/admin");
                break;
            case "STAFF":
                res.sendRedirect(ctx + "/staff");
                break;
            case "MEMBER":
                res.sendRedirect(ctx + "/member");
                break;
            default:
                res.sendRedirect(ctx + "/login.jsp");
        }
    }
}