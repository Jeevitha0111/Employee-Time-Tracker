package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.controller.Connect;
import com.model.Task;

public class UserDao {

	public void addTask(Task task) {
	    if (isTimeSlotAvailable(task)) {
	        // Check if username and user_id match existing records
	        if (isValidUser(task.getUsername(), task.getUserId())) {
	            String sql = "INSERT INTO tasks (employee_name, role, project, date, start_time, end_time, task_category, description, username, password, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	            try (Connection conn = Connect.getConnection();
	                 PreparedStatement stmt = conn.prepareStatement(sql)) {

	                stmt.setString(1, task.getEmployeeName());
	                stmt.setString(2, task.getRole());
	                stmt.setString(3, task.getProject());
	                stmt.setDate(4, new java.sql.Date(task.getDate().getTime()));
	                stmt.setTime(5, new java.sql.Time(task.getStartTime().getTime()));
	                stmt.setTime(6, new java.sql.Time(task.getEndTime().getTime()));
	                stmt.setString(7, task.getTaskCategory());
	                stmt.setString(8, task.getDescription());
	                stmt.setString(9, task.getUsername());
	                stmt.setString(10, task.getPassword());
	                stmt.setString(11, task.getUserId());

	                stmt.executeUpdate();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        } else {
	            throw new IllegalArgumentException("Invalid username or user ID. Please check.");
	        }
	    } else {
	        throw new IllegalArgumentException("The time slot is already occupied.");
	    }
	}

	private boolean isValidUser(String username, String userId) {
	    String sql = "SELECT * FROM users WHERE username = ? AND user_id = ?";
	    boolean isValid = false;

	    try (Connection conn = Connect.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {

	        stmt.setString(1, username);
	        stmt.setString(2, userId);

	        ResultSet rs = stmt.executeQuery();
	        rs.next();
	        isValid = rs.getInt(1) > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return isValid;
	}

    public List<Task> getTasksByUsername(String username, String password, String role) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE username = ? AND password = ? AND role = ?";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setEmployeeName(rs.getString("employee_name"));
                task.setRole(rs.getString("role"));
                task.setProject(rs.getString("project"));
                task.setDate(rs.getDate("date"));
                task.setStartTime(rs.getTime("start_time"));
                task.setEndTime(rs.getTime("end_time"));
                task.setTaskCategory(rs.getString("task_category"));
                task.setDescription(rs.getString("description"));
                task.setUsername(rs.getString("username"));
                task.setPassword(rs.getString("password"));

                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tasks;
    }
    
    public boolean isTimeSlotAvailable(Task task) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE employee_name = ? AND date = ? AND " +
                     "((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";

        try (Connection conn = Connect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, task.getEmployeeName());
            stmt.setDate(2, new java.sql.Date(task.getDate().getTime()));
            stmt.setTime(3, new java.sql.Time(task.getStartTime().getTime()));
            stmt.setTime(4, new java.sql.Time(task.getStartTime().getTime()));
            stmt.setTime(5, new java.sql.Time(task.getEndTime().getTime()));
            stmt.setTime(6, new java.sql.Time(task.getEndTime().getTime()));

            ResultSet rs = stmt.executeQuery();
            rs.next();
            return rs.getInt(1) == 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}

    

    