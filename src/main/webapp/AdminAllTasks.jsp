<%@ page import="java.util.List" %>
<%@ page import="com.model.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Tasks</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .button-link {
            text-decoration: none;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border-radius: 4px;
        }
        .button-link:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>All Tasks</h1>
    <form method="post" action="AdminServlet">
        <input type="hidden" name="action" value="viewAll">
        <input type="submit" value="Refresh Tasks">
        <a href="managerAdminDashboard.jsp" class="button-link">Go Back</a>
        <a href="logout.jsp" class="button-link">Logout</a>
    </form>
    
    <%
        List<Task> tasks = (List<Task>) request.getAttribute("tasks");
        
        if (tasks == null || tasks.isEmpty()) {
            out.println("<p>No tasks found.</p>");
        } else {
    %>
    <table>
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
