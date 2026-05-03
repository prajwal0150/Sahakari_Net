package com.sahakarinet.sahakari.SahakariNet.utils;

public class ValidationUtil {
    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^(97|98)\\d{8}$");
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    public static boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    public static boolean isValidUsername(String username) {
        return username != null && username.matches("^[a-zA-Z0-9_]{4,20}$");
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isValidFullName(String fullName) {
        return fullName != null && fullName.matches("^[A-Za-z]+(?:\\s[A-Za-z]+)*$");
    }

    public static boolean isValidCitizenshipNo(String citizenshipNo) {
        return citizenshipNo != null && citizenshipNo.matches("^[0-9\\-/]{5,30}$");
    }

}
