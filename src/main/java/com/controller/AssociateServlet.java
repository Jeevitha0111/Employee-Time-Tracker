package com.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.AdminDao;
import com.dao.AssociateDao;
import com.model.Task;

@WebServlet("/AssociateServlet")
public class AssociateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        switch (action) {
            case "add":
                addTask(request, response);
                break;
            case "view":
            	viewTasksByProject(request, response);
                break;
            case "viewAll":
            	viewAll(request, response);
                break;
            
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action parameter");
        }
    }

    private void addTask(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from request
        String employeeName = request.getParameter("employeeName");
        String role = request.getParameter("role");
        String project = request.getParameter("project");
        String dateStr = request.getParameter("date");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String taskCategory = request.getParameter("taskCategory");
        String description = request.getParameter("description");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userId = request.getParameter("userId");

        try {
            Date date = parseDate(dateStr);
            Date startTime = parseTime(startTimeStr);
            Date endTime = parseTime(endTimeStr);

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

            AdminDao adminDao = new AdminDao();
            try {
                adminDao.addTask(task);
                request.setAttribute("message", "Task added successfully!");
            } catch (IllegalArgumentException e) {
                request.setAttribute("message", e.getMessage());
            }

            request.getRequestDispatcher("/AddTask.jsp").forward(request, response);
        
        } catch (ParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date/time format");
        }
    }
    
    private void viewTasksByProject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String project = request.getParameter("project");

        if (project == null || project.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing project parameter");
            return;
        }

        AssociateDao associateDao = new AssociateDao();
        List<Task> tasks = associateDao.getTaskbyProject(project);

        request.setAttribute("tasks", tasks);
        request.getRequestDispatcher("/TasksByProject.jsp").forward(request, response);
    }

    
    private void viewAll(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
    	AssociateDao associateDao = new AssociateDao();
        List<Task> tasks = associateDao.viewAll();

        request.setAttribute("tasks", tasks);
        request.getRequestDispatcher("/AllTasks.jsp").forward(request, response);
    }


    private Date parseDate(String dateStr) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.parse(dateStr);
    }

    private Date parseTime(String timeStr) throws ParseException {
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        return timeFormat.parse(timeStr);
    }
}
