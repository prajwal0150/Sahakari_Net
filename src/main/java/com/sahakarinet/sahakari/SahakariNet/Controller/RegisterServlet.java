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

        // Validation
        if (ValidationUtil.isNullOrEmpty(fullName) || ValidationUtil.isNullOrEmpty(username)
                || ValidationUtil.isNullOrEmpty(password) || ValidationUtil.isNullOrEmpty(gender)) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!password.equals(confirmPw)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (email != null && !email.isBlank() && !ValidationUtil.isValidEmail(email.trim())) {
            req.setAttribute("error", "Invalid email format.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (phone != null && !phone.isBlank() && !ValidationUtil.isValidPhone(phone.trim())) {
            req.setAttribute("error", "Invalid phone number. Use 97xxxxxxxx or 98xxxxxxxx.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (userDAO.usernameExists(username.trim())) {
            req.setAttribute("error", "Username '" + username + "' is already taken.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (email != null && !email.isBlank() && userDAO.emailExists(email.trim())) {
            req.setAttribute("error", "Email is already registered.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (citizenshipNo == null || citizenshipNo.isBlank()) {
            req.setAttribute("error", "Citizenship number is required for member registration.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }
        if (memberDAO.citizenshipExists(citizenshipNo.trim())) {
            req.setAttribute("error", "Citizenship number is already registered.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        // Create user
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setEmail(email != null ? email.trim() : "");
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
        newMember.setFullName(fullName.trim());
        newMember.setDateOfBirth(dob);
        newMember.setGender(gender.trim());
        newMember.setPhone(phone.trim());
        newMember.setAddress(address.trim());
        newMember.setCitizenshipNo(citizenshipNo.trim());
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