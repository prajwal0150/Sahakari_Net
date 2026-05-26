package com.sahakarinet.sahakari.SahakariNet.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DbConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/sahakarinet";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "12345";
    private static volatile HikariDataSource DATA_SOURCE = createDataSource();

    private static String dbUrl() {
        String url = normalizeJdbcUrl(firstNonBlank(
                System.getenv("SPRING_DATASOURCE_URL"),
                System.getenv("DATABASE_URL"),
                System.getenv("DB_URL"),
                System.getenv("JDBC_DATABASE_URL"),
                buildRailwayUrl(),
                System.getenv("MYSQL_URL")));
        return url != null ? url : DEFAULT_URL;
    }

    private static String dbUser() {
        String user = firstNonBlank(
                System.getenv("SPRING_DATASOURCE_USERNAME"),
                System.getenv("DATABASE_USERNAME"),
                System.getenv("DB_USER"),
                System.getenv("JDBC_DATABASE_USERNAME"),
                embeddedUserFromUrl(System.getenv("SPRING_DATASOURCE_URL")),
                embeddedUserFromUrl(System.getenv("DATABASE_URL")),
                embeddedUserFromUrl(System.getenv("DB_URL")),
                embeddedUserFromUrl(System.getenv("JDBC_DATABASE_URL")),
                embeddedUserFromUrl(buildRailwayUrl()),
                embeddedUserFromUrl(System.getenv("MYSQL_URL")),
                System.getenv("MYSQLUSER"));
        return user != null ? user : DEFAULT_USER;
    }

    private static String dbPass() {
        String password = firstNonBlank(
                System.getenv("SPRING_DATASOURCE_PASSWORD"),
                System.getenv("DATABASE_PASSWORD"),
                System.getenv("DB_PASSWORD"),
                System.getenv("JDBC_DATABASE_PASSWORD"),
                embeddedPasswordFromUrl(System.getenv("SPRING_DATASOURCE_URL")),
                embeddedPasswordFromUrl(System.getenv("DATABASE_URL")),
                embeddedPasswordFromUrl(System.getenv("DB_URL")),
                embeddedPasswordFromUrl(System.getenv("JDBC_DATABASE_URL")),
                embeddedPasswordFromUrl(buildRailwayUrl()),
                embeddedPasswordFromUrl(System.getenv("MYSQL_URL")),
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

    private static String normalizeJdbcUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isBlank()) {
            return null;
        }

        String normalized = rawUrl.trim();

        if (normalized.startsWith("mysql://")) {
            normalized = "jdbc:" + normalized;
        }

        if (!normalized.startsWith("jdbc:mysql://")) {
            return normalized;
        }

        String remainder = normalized.substring("jdbc:mysql://".length());
        int slashIndex = remainder.indexOf('/');
        if (slashIndex < 0) {
            return normalized;
        }

        String authority = remainder.substring(0, slashIndex);
        String pathAndQuery = remainder.substring(slashIndex);

        int atIndex = authority.lastIndexOf('@');
        if (atIndex >= 0) {
            authority = authority.substring(atIndex + 1);
        }

        return "jdbc:mysql://" + authority + pathAndQuery;
    }

    private static String embeddedUserFromUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isBlank()) {
            return null;
        }

        String normalized = rawUrl.trim();
        if (normalized.startsWith("mysql://")) {
            normalized = "jdbc:" + normalized;
        }

        if (!normalized.startsWith("jdbc:mysql://")) {
            return null;
        }

        String remainder = normalized.substring("jdbc:mysql://".length());
        int slashIndex = remainder.indexOf('/');
        String authority = slashIndex >= 0 ? remainder.substring(0, slashIndex) : remainder;
        int atIndex = authority.lastIndexOf('@');
        if (atIndex < 0) {
            return null;
        }

        String credentials = authority.substring(0, atIndex);
        int colonIndex = credentials.indexOf(':');
        if (colonIndex < 0) {
            return credentials.isBlank() ? null : credentials;
        }

        String user = credentials.substring(0, colonIndex);
        return user.isBlank() ? null : user;
    }

    private static String embeddedPasswordFromUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isBlank()) {
            return null;
        }

        String normalized = rawUrl.trim();
        if (normalized.startsWith("mysql://")) {
            normalized = "jdbc:" + normalized;
        }

        if (!normalized.startsWith("jdbc:mysql://")) {
            return null;
        }

        String remainder = normalized.substring("jdbc:mysql://".length());
        int slashIndex = remainder.indexOf('/');
        String authority = slashIndex >= 0 ? remainder.substring(0, slashIndex) : remainder;
        int atIndex = authority.lastIndexOf('@');
        if (atIndex < 0) {
            return null;
        }

        String credentials = authority.substring(0, atIndex);
        int colonIndex = credentials.indexOf(':');
        if (colonIndex < 0 || colonIndex == credentials.length() - 1) {
            return null;
        }

        String password = credentials.substring(colonIndex + 1);
        return password.isBlank() ? null : password;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }

    private static HikariDataSource createDataSource() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl());
        config.setUsername(dbUser());
        config.setPassword(dbPass());
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(Integer.parseInt(firstNonBlank(System.getenv("DB_POOL_SIZE"), "5")));
        config.setMinimumIdle(2);
        config.setConnectionTimeout(10000);
        config.setIdleTimeout(600000);
        config.setKeepaliveTime(60000);
        config.setMaxLifetime(300000);
        config.setValidationTimeout(3000);
        config.setConnectionTestQuery("SELECT 1");
        config.setInitializationFailTimeout(-1);
        config.setPoolName("SahakariNetPool");
        return new HikariDataSource(config);
    }

    private static synchronized HikariDataSource dataSource() {
        if (DATA_SOURCE == null || DATA_SOURCE.isClosed()) {
            DATA_SOURCE = createDataSource();
        }
        return DATA_SOURCE;
    }

    private static synchronized void refreshDataSource() {
        HikariDataSource current = DATA_SOURCE;
        DATA_SOURCE = createDataSource();
        if (current != null && !current.isClosed()) {
            current.close();
        }
    }

    // creates database connection and return
    // uses throws SQLException for handle error or connection fails
    public static Connection getConnection() throws SQLException {
        try {
            return dataSource().getConnection();
        } catch (SQLException firstFailure) {
            refreshDataSource();
            return dataSource().getConnection();
        }
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
