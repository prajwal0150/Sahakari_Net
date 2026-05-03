package com.sahakarinet.sahakari.SahakariNet.utils;

import java.util.Calendar;

public class DateUtil {

    public static java.sql.Date addMonths(java.sql.Date base, int months) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(base);
        cal.add(Calendar.MONTH, months);
        return new java.sql.Date(cal.getTimeInMillis());
    }

    public static java.sql.Date today() {
        return new java.sql.Date(System.currentTimeMillis());
    }
}
