package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.utils.CookieUtil;
import com.sahakarinet.sahakari.SahakariNet.utils.SessionUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        SessionUtil.clearSession(req);
        CookieUtil.clearAuthCookies(res);
        res.sendRedirect(req.getContextPath() + "/login.jsp?logout=true");
    }
}