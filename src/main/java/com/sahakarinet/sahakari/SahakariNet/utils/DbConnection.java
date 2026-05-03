package com.sahakarinet.sahakari.SahakariNet.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    // link for database connection
    private static String url = "jdbc:mysql://localhost:3306/sahakarinet";
    // username
    private static String user = "root";
    private static String pass = "12345";

    // creates database connection and return
    // uses throws SQLException for handle error or connection fails
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        Connection conec = DriverManager.getConnection(url, user, pass);
        return conec;
    }

    // Test database connection status
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Database connection successful!");
                System.out.println("Connected to: " + conn.getMetaData().getURL());
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
