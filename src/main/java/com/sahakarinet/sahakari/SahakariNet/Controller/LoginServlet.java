package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.UserDao;
import com.sahakarinet.sahakari.SahakariNet.utils.session;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();
    private MemberDao memberDAO = new MemberDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Already logged in? redirect to dashboard
        String role = session.getRole(req);
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

        if (!userDAO.verifyAndUpgradePassword(user, password)) {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("error", "Your account is pending approval by the Admin. Please wait.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // Create session
        session.setUserSession(req, user.getId(), user.getUsername(), user.getRole());

        // If member, also store memberId
        if ("MEMBER".equals(user.getRole())) {
            Member member = memberDAO.findByUserId(user.getId());
            if (member != null) {
                session.setMemberSession(req, member.getId(), member.getFullName());
            }
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