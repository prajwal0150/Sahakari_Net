package com.sahakarinet.sahakari.SahakariNet.Auth;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        // ✅ Allow public resources (IMPORTANT to avoid infinite redirect)
        if (uri.endsWith("login.jsp") ||
                uri.endsWith("register.jsp") ||
                uri.contains("/css/") ||
                uri.contains("/js/") ||
                uri.contains("/images/")) {

            chain.doFilter(req, res);
            return;
        }

        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // ❌ Not logged in → redirect
        if (role == null) {
            response.sendRedirect(ctx + "/login.jsp");
            return;
        }

        // ✅ Safer path checks (use startsWith instead of contains)
        boolean adminPath = uri.startsWith(ctx + "/admin") || uri.startsWith(ctx + "/Views/admin");
        boolean staffPath = uri.startsWith(ctx + "/staff") || uri.startsWith(ctx + "/Views/staff");
        boolean memberPath = uri.startsWith(ctx + "/member") || uri.startsWith(ctx + "/Views/member");
        boolean loanPath = uri.startsWith(ctx + "/loan");
        boolean txPath = uri.startsWith(ctx + "/transaction");
        boolean reportPath = uri.startsWith(ctx + "/report");

        // 🔐 Role-based access control
        if (adminPath && !"ADMIN".equals(role)) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        if (staffPath && !("STAFF".equals(role) || "ADMIN".equals(role))) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        if (memberPath && !"MEMBER".equals(role)) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        // ❗ Restrict staff from approving loans
        if (loanPath && "STAFF".equals(role) && uri.contains("approve")) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        // (Optional) restrict reports & transactions if needed
        if (reportPath && !"ADMIN".equals(role)) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        if (txPath && !("ADMIN".equals(role) || "STAFF".equals(role))) {
            response.sendRedirect(ctx + "/error.jsp?code=403");
            return;
        }

        // ✅ Continue request
        chain.doFilter(req, res);
    }
}