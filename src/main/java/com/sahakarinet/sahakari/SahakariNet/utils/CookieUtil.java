package com.sahakarinet.sahakari.SahakariNet.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtil {

    public static final String COOKIE_USER_ID = "userId";
    public static final String COOKIE_USERNAME = "username";
    public static final String COOKIE_ROLE = "role";
    public static final String COOKIE_MEMBER_ID = "memberId";
    public static final String COOKIE_MEMBER_NAME = "memberName";

    private CookieUtil() {
    }

    public static void addCookie(HttpServletResponse response, String name, String value, int maxAgeSeconds) {
        if (response == null || name == null) {
            return;
        }
        Cookie cookie = new Cookie(name, value == null ? "" : value);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(maxAgeSeconds);
        response.addCookie(cookie);
    }

    public static Cookie getCookie(HttpServletRequest request, String name) {
        if (request == null || name == null) {
            return null;
        }
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (cookie != null && name.equals(cookie.getName())) {
                return cookie;
            }
        }
        return null;
    }

    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie cookie = getCookie(request, name);
        return cookie != null ? cookie.getValue() : null;
    }

    public static void deleteCookie(HttpServletResponse response, String name) {
        if (response == null || name == null) {
            return;
        }
        Cookie cookie = new Cookie(name, "");
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

    public static void clearAuthCookies(HttpServletResponse response) {
        deleteCookie(response, COOKIE_USER_ID);
        deleteCookie(response, COOKIE_USERNAME);
        deleteCookie(response, COOKIE_ROLE);
        deleteCookie(response, COOKIE_MEMBER_ID);
        deleteCookie(response, COOKIE_MEMBER_NAME);
    }
}
