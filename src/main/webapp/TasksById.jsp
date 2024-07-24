<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.model.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tasks by ID</title>
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
        #userPieChart {
            max-width: 800px;
            margin: auto;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h1>Tasks by ID</h1>
    <form method="post" action="AdminServlet">
        <input type="hidden" name="action" value="viewById">
        <label for="taskId">Task ID:</label>
        <input type="number" id="taskId" name="taskId" required>
        <input type="submit" value="View Task">
        <a href="managerAdminDashboard.jsp" class="button-link">Go Back</a>
        <a href="logout.jsp" class="button-link">Logout</a>
    </form>

    <%
        List<Task> tasks = (List<Task>) request.getAttribute("tasks");
        String message = (String) request.getAttribute("message");
        if (message != null) {
            out.println("<p>" + message + "</p>");
        } else if (tasks != null && !tasks.isEmpty()) {
            // Prepare data for pie chart
            List<String> projects = new ArrayList<>();
            List<Integer> taskCounts = new ArrayList<>();

            for (Task task : tasks) {
                String project = task.getProject();
                int index = projects.indexOf(project);
                if (index == -1) {
                    projects.add(project);
                    taskCounts.add(1);
                } else {
                    taskCounts.set(index, taskCounts.get(index) + 1);
                }
            }

            StringBuilder chartLabels = new StringBuilder();
            StringBuilder chartData = new StringBuilder();
            for (int i = 0; i < projects.size(); i++) {
                if (i > 0) {
                    chartLabels.append(",");
                    chartData.append(",");
                }
                chartLabels.append("'").append(projects.get(i)).append("'");
                chartData.append(taskCounts.get(i));
            }
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
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                for (Task task : tasks) {
            %>
            <tr>
                <td><%= task.getTaskId() %></td>
                <td><%= task.getEmployeeName() %></td>
                <td><%= task.getRole() %></td>
                <td><%= task.getProject() %></td>
                <td><%= dateFormat.format(task.getDate()) %></td>
                <td><%= timeFormat.format(task.getStartTime()) %></td>
                <td><%= timeFormat.format(task.getEndTime()) %></td>
                <td><%= task.getTaskCategory() %></td>
                <td><%= task.getDescription() %></td>
                <td><%= task.getUsername() %></td>
                <td><%= task.getPassword() %></td>
                <td><%= task.getUserId() %></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <h2>Task Distribution by Project</h2>
    <canvas id="userPieChart" width="400" height="400"></canvas>
    <script>
        var ctx = document.getElementById('userPieChart').getContext('2d');
        var userPieChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: [<%= chartLabels.toString() %>],
                datasets: [{
                    label: 'Task Distribution',
                    data: [<%= chartData.toString() %>],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                var label = tooltipItem.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                label += tooltipItem.raw + ' tasks';
                                return label;
                            }
                        }
                    }
                }
            }
        });
    </script>

    <% 
        } else {
            out.println("<p>No task found for the specified ID.</p>");
        } 
    %>
</body>
</html>
