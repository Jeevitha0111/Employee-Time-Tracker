package com.controller;

import com.dao.UserDao;
import com.model.Task;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("AddTask".equals(action)) {
            addTask(request, response);
        } else if ("ViewTasks".equals(action)) {
            viewTasks(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
        }
    }

    private void addTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String employeeName = request.getParameter("employeeName");
        String role = request.getParameter("role");
        String project = request.getParameter("project");
        Date date = Date.valueOf(request.getParameter("date"));
        Time startTime = Time.valueOf(request.getParameter("startTime") + ":00");
        Time endTime = Time.valueOf(request.getParameter("endTime") + ":00");
        String taskCategory = request.getParameter("taskCategory");
        String description = request.getParameter("description");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userId = request.getParameter("userId");

        Task task = new Task();
        task.setEmployeeName(employeeName);
        task.setRole(role);
        task.setProject(project);
        task.setDate(date);
        task.setStartTime(startTime);
        task.setEndTime(endTime);
        task.setTaskCategory(taskCategory);
        task.setDescription(description);
        task.setUsername(username);
        task.setPassword(password);
        task.setUserId(userId);

        UserDao userDao = new UserDao();

        try {
            userDao.addTask(task);
            request.setAttribute("message", "Task added successfully!");
        } catch (IllegalArgumentException e) {
            request.setAttribute("message", e.getMessage());
        }

        request.getRequestDispatcher("/EmployeeAddTask.jsp").forward(request, response);
    }

    private void viewTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        UserDao userDao = new UserDao();
        List<Task> tasks = userDao.getTasksByUsername(username, password, role);

        request.setAttribute("tasks", tasks);
        request.getRequestDispatcher("/EmployeeTasks.jsp").forward(request, response);
    }
}
