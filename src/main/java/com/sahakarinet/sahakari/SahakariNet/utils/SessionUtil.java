package com.sahakarinet.sahakari.SahakariNet.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {


    private static HttpSession getSession(HttpServletRequest request, boolean create) {
        return request != null ? request.getSession(create) : null;
    }

    private static HttpSession getSession(HttpServletRequest request) {
        return getSession(request, false);
    }

    public static void setUserSession(HttpServletRequest request, int userId, String username, String role) {
        HttpSession httpSession = getSession(request, true);
        httpSession.setAttribute("userId", userId);
        httpSession.setAttribute("username", username);
        httpSession.setAttribute("role", role);
    }

    public static void setMemberSession(HttpServletRequest request, int memberId, String memberName) {
        HttpSession httpSession = getSession(request, true);
        httpSession.setAttribute("memberId", memberId);
        httpSession.setAttribute("memberName", memberName);
    }

    public static Integer getUserId(HttpServletRequest request) {
        return getIntegerAttribute(request, "userId");
    }

    public static Integer getMemberId(HttpServletRequest request) {
        return getIntegerAttribute(request, "memberId");
    }

    public static String getRole(HttpServletRequest request) {
        return getStringAttribute(request, "role");
    }

    public static void clearSession(HttpServletRequest request) {
        HttpSession httpSession = getSession(request);
        if (httpSession != null) {
            httpSession.invalidate();
        }
    }

    private static String getStringAttribute(HttpServletRequest request, String name) {
        HttpSession httpSession = getSession(request);
        if (httpSession == null) {
            return null;
        }
        Object value = httpSession.getAttribute(name);
        return value != null ? value.toString() : null;
    }

    private static Integer getIntegerAttribute(HttpServletRequest request, String name) {
        HttpSession httpSession = getSession(request);
        if (httpSession == null) {
            return null;
        }
        Object value = httpSession.getAttribute(name);
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        if (value != null) {
            try {
                return Integer.parseInt(value.toString());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }
}
