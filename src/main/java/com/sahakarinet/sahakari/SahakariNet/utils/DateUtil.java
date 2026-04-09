package com.sahakarinet.sahakari.SahakariNet.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;

public class DateUtil {
    private static final SimpleDateFormat DISPLAY_FMT = new SimpleDateFormat("dd MMM yyyy");

    public static String formatDisplay(java.sql.Timestamp ts) {
        if (ts == null)
            return "—";
        return DISPLAY_FMT.format(new Date(ts.getTime()));
    }

    public static String formatDisplay(java.sql.Date d) {
        if (d == null)
            return "—";
        return DISPLAY_FMT.format(new Date(d.getTime()));
    }

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
