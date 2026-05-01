package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.utils.session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        session.clearSession(req);
        res.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
    }
}