<%@ page import="java.util.List" %>
<%@ page import="com.dao.UserDao" %>
<%@ page import="com.model.Task" %>

<html>
<head>
    <title>Add Task</title>
</head>
<body>
    <h1>Add New Task</h1>
    
    <form method="post" action="EmployeeServlet">
        <input type="hidden" name="action" value="AddTask">
        
        <label for="employeeName">Employee Name:</label>
        <input type="text" id="employeeName" name="employeeName" required><br><br>
        
        <label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="Employee">Employee</option>
            <!-- Add more roles as necessary -->
        </select><br><br>
        
        <label for="project">Project:</label>
        <input type="text" id="project" name="project" required><br><br>
        
        <label for="date">Date:</label>
        <input type="date" id="date" name="date" required><br><br>
        
        <label for="startTime">Start Time:</label>
        <input type="time" id="startTime" name="startTime" required><br><br>
        
        <label for="endTime">End Time:</label>
        <input type="time" id="endTime" name="endTime" required><br><br>
        
        <label for="taskCategory">Task Category:</label>
        <input type="text" id="taskCategory" name="taskCategory" required><br><br>
        
        <label for="description">Description:</label>
        <textarea id="description" name="description" required></textarea><br><br>
        
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <label for="userId">User ID:</label>
        <input type="text" id="userId" name="userId" required><br><br>
        
        <input type="submit" value="Add Task">
        <a href="EmployeeTasks.jsp" class="button-link">Go Back</a>
        <br></br>
        <a href="logout.jsp" class="button-link">Logout</a>
    </form>
    
    <%
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <p style="color:red;"><%= message %></p>
    <%
        }
    %>
</body>
</html>
