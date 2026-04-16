package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.Member;
import com.sahakarinet.sahakari.SahakariNet.model.User;
import com.sahakarinet.sahakari.SahakariNet.model.dao.MemberDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.UserDao;
import com.sahakarinet.sahakari.SahakariNet.utils.PasswordUtil;
import com.sahakarinet.sahakari.SahakariNet.utils.ValidationUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();
    private MemberDao memberDAO = new MemberDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String dob = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String citizenshipNo = req.getParameter("citizenshipNo");
        String email = req.getParameter("email");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPw = req.getParameter("confirmPassword");

        String normalizedFullName = fullName != null ? fullName.trim() : "";
        String normalizedGender = gender != null ? gender.trim() : "";
        String normalizedPhone = phone != null ? phone.trim() : "";
        String normalizedAddress = address != null ? address.trim() : "";
        String normalizedCitizenship = citizenshipNo != null ? citizenshipNo.trim() : "";
        String normalizedEmail = email != null ? email.trim() : "";
        String normalizedUsername = username != null ? username.trim() : "";

        // Validation
        if (ValidationUtil.isNullOrEmpty(normalizedFullName) || ValidationUtil.isNullOrEmpty(normalizedUsername)
                || ValidationUtil.isNullOrEmpty(password) || ValidationUtil.isNullOrEmpty(normalizedGender)) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (confirmPw == null || !password.equals(confirmPw)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!normalizedEmail.isBlank() && !ValidationUtil.isValidEmail(normalizedEmail)) {
            req.setAttribute("error", "Invalid email format.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!normalizedPhone.isBlank() && !ValidationUtil.isValidPhone(normalizedPhone)) {
            req.setAttribute("error", "Invalid phone number. Use 97xxxxxxxx or 98xxxxxxxx.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (userDAO.usernameExists(normalizedUsername)) {
            req.setAttribute("error", "Username '" + username + "' is already taken.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!normalizedEmail.isBlank() && userDAO.emailExists(normalizedEmail)) {
            req.setAttribute("error", "Email is already registered.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (normalizedCitizenship.isBlank()) {
            req.setAttribute("error", "Citizenship number is required for member registration.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (memberDAO.citizenshipExists(normalizedCitizenship)) {
            req.setAttribute("error", "Citizenship number is already registered.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setUsername(normalizedUsername);
        newUser.setEmail(normalizedEmail);
        newUser.setPasswordHash(PasswordUtil.hash(password));
        newUser.setRole("MEMBER");
        newUser.setActive(false);

        int userId = userDAO.createUser(newUser);
        if (userId == -1) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        // Create member
        Member newMember = new Member();
        newMember.setUserId(userId);
        newMember.setFullName(normalizedFullName);
        newMember.setDateOfBirth(dob);
        newMember.setGender(normalizedGender);
        newMember.setPhone(normalizedPhone);
        newMember.setAddress(normalizedAddress);
        newMember.setCitizenshipNo(normalizedCitizenship);
        newMember.setStatus("PENDING");

        boolean saved = memberDAO.registerMember(newMember);
        if (saved) {
            res.sendRedirect("register?success=true");
        } else {
            req.setAttribute("error", "Member registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
    }
}