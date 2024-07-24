package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String Un = request.getParameter("username");
        String Upwd = request.getParameter("password");
        String role = getUserRole(Un, Upwd);

        if (role != null) {
            // Redirect based on user role
            switch (role) {
                case "Employee":
                    response.sendRedirect("employeeDashboard.jsp");
                    break;
                case "Associate":
                    response.sendRedirect("associateDashboard.jsp");
                    break;
                case "Manager":
                case "Admin":
                    response.sendRedirect("managerAdminDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("login.jsp"); // Redirect to login page if role is unrecognized
                    break;
            }
        } else {
            // Login failed
            response.sendRedirect("login.jsp"); // Redirect to the login page again
        }
    }

    // Method to validate user and get their role from MySQL database
    private String getUserRole(String Un, String Upwd) {
        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to MySQL database tasktracking
            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/tasktracking", "root", "2003");
                 PreparedStatement statement = connection.prepareStatement("SELECT role FROM users WHERE username = ? AND password = ?")) {

                // Set parameters for the query
                statement.setString(1, Un);
                statement.setString(2, Upwd);

                // Execute the query
                try (ResultSet result = statement.executeQuery()) {
                    // Check if any row exists in the result set and retrieve the role
                    if (result.next()) {
                        return result.getString("role");
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return null; // Return null if validation fails or an exception occurs
    }
}
