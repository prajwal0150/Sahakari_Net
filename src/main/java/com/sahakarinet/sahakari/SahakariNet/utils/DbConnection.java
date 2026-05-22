package com.sahakarinet.sahakari.SahakariNet.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/sahakarinet";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "12345";

    private static String dbUrl() {
        String url = firstNonBlank(
                System.getenv("DB_URL"),
                System.getenv("JDBC_DATABASE_URL"),
                buildRailwayUrl(),
                jdbcFromMysqlUrl(System.getenv("MYSQL_URL")));
        return url != null ? url : DEFAULT_URL;
    }

    private static String dbUser() {
        String user = firstNonBlank(
                System.getenv("DB_USER"),
                System.getenv("JDBC_DATABASE_USERNAME"),
                System.getenv("MYSQLUSER"));
        return user != null ? user : DEFAULT_USER;
    }

    private static String dbPass() {
        String password = firstNonBlank(
                System.getenv("DB_PASSWORD"),
                System.getenv("JDBC_DATABASE_PASSWORD"),
                System.getenv("MYSQLPASSWORD"));
        return password != null ? password : DEFAULT_PASS;
    }

    private static String buildRailwayUrl() {
        String host = System.getenv("MYSQLHOST");
        String port = firstNonBlank(System.getenv("MYSQLPORT"), "3306");
        String database = System.getenv("MYSQLDATABASE");

        if (host == null || host.isBlank() || database == null || database.isBlank()) {
            return null;
        }

        return "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    }

    private static String jdbcFromMysqlUrl(String mysqlUrl) {
        if (mysqlUrl == null || mysqlUrl.isBlank()) {
            return null;
        }

        if (mysqlUrl.startsWith("jdbc:mysql://")) {
            return mysqlUrl;
        }

        if (mysqlUrl.startsWith("mysql://")) {
            return "jdbc:" + mysqlUrl;
        }

        return mysqlUrl;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    // creates database connection and return
    // uses throws SQLException for handle error or connection fails
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        Connection conec = DriverManager.getConnection(dbUrl(), dbUser(), dbPass());
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
