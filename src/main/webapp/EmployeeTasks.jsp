<%@ page import="java.util.List" %>
<%@ page import="com.model.Task" %>

<html>
<head>
    <title>Employee Tasks</title>
</head>
<body>
    <h1>Employee Tasks</h1>
    
    <form method="post" action="EmployeeServlet">
        <input type="hidden" name="action" value="ViewTasks">
        
        <label for="username">User Name:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="Employee">Employee</option>
        </select><br><br>
        
        <input type="submit" value="View Tasks">
        <a href="EmployeeAddTask.jsp" class="button-link">Add Task</a>
        <a href="logout.jsp" class="button-link">Logout</a>
    </form>
    
    <%
        List<Task> tasks = (List<Task>) request.getAttribute("tasks");
        
        if (tasks == null || tasks.isEmpty()) {
    %>
    <h2>No tasks found for the specified criteria.</h2>
    <%
        } else {
    %>
    <h2>Tasks for Role: <%= request.getParameter("role") %></h2>
    <table border="1">
        <thead>
            <tr>
                <th>Task ID</th>
                <th>Employee Name</th>
                <th>Role</th>
                <th>Project</th>
                <th>Date</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Task Category</th>
                <th>Description</th>
                <th>Username</th>
                <th>Password</th>
                <th>User ID</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Task task : tasks) {
            %>
            <tr>
                <td><%= task.getTaskId() %></td>
                <td><%= task.getEmployeeName() %></td>
                <td><%= task.getRole() %></td>
                <td><%= task.getProject() %></td>
                <td><%= task.getDate() %></td>
                <td><%= task.getStartTime() %></td>
                <td><%= task.getEndTime() %></td>
                <td><%= task.getTaskCategory() %></td>
                <td><%= task.getDescription() %></td>
                <td><%= task.getUsername() %></td>
                <td><%= task.getPassword() %></td>
                <td><%= task.getUserId() %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <%
        }
    %>
</body>
</html>
