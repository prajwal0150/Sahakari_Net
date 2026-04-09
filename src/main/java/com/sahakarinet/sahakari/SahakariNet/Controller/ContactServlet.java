package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.utils.DbConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("contact.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        if (isBlank(name) || isBlank(email) || isBlank(message)) {
            res.sendRedirect(req.getContextPath() + "/contact.jsp?error=missing");
            return;
        }

        String ctx = req.getContextPath();
        String normalizedSubject = subject == null ? "" : subject.trim();
        String normalizedMessage = message.trim();
        if (!normalizedSubject.isBlank()) {
            normalizedMessage = "Subject: " + normalizedSubject + System.lineSeparator() + System.lineSeparator()
                    + normalizedMessage;
        }
        String sql = "INSERT INTO contact_inquiries (name, email, message) VALUES (?,?,?)";

        try (Connection conn = DbConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setString(2, email.trim());
            ps.setString(3, normalizedMessage);
            ps.executeUpdate();

            res.sendRedirect(ctx + "/contact.jsp?sent=true");
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect(ctx + "/contact.jsp?error=failed");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

}