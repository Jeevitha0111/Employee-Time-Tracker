<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.dao.AdminDao" %>
<%@ page import="com.model.Task" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tasks by Project and Date</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        #weeklyBarChart {
            max-width: 800px;
            margin: auto;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h2>Tasks by Project and Date</h2>
    
    <form method="get" action="TasksByProjectAndDate.jsp">
        <label for="project">Project:</label>
        <input type="text" id="project" name="project" required>
        <br><br>
        <label for="date">Date (yyyy-mm-dd):</label>
        <input type="text" id="date" name="date" required>
        <br><br>
        <input type="submit" value="Search">
    </form>

    <%
        String project = request.getParameter("project");
        String dateStr = request.getParameter("date");

        if (project != null && dateStr != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            Date date = null;
            try {
                date = sdf.parse(dateStr);
            } catch (java.text.ParseException e) {
                e.printStackTrace();
            }

            if (date != null) {
                AdminDao adminDao = new AdminDao();
                Calendar cal = Calendar.getInstance();
                cal.setTime(date);
                cal.set(Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek());

                List<Date> weekDates = new ArrayList<>();
                for (int i = 0; i < 7; i++) {
                    weekDates.add(cal.getTime());
                    cal.add(Calendar.DAY_OF_MONTH, 1);
                }

                int[] tasksPerDay = new int[7];
                for (int i = 0; i < 7; i++) {
                    String currentDateStr = sdf.format(weekDates.get(i));
                    List<Task> tasks = adminDao.getTaskbyProjectandDate(project, currentDateStr);
                    tasksPerDay[i] = tasks.size();
                }

                // Prepare data for Chart.js
                StringBuilder chartLabels = new StringBuilder();
                StringBuilder chartData = new StringBuilder();
                String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
                for (int i = 0; i < 7; i++) {
                    if (i > 0) {
                        chartLabels.append(",");
                        chartData.append(",");
                    }
                    chartLabels.append("'").append(days[i]).append("'");
                    chartData.append(tasksPerDay[i]);
                }
    %>

    <h2>Tasks for project: <%= project %> during the week of: <%= sdf.format(weekDates.get(0)) %></h2>

    <canvas id="weeklyBarChart" width="400" height="200"></canvas>
    <script>
        var ctx = document.getElementById('weeklyBarChart').getContext('2d');
        var weeklyBarChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [<%= chartLabels.toString() %>],
                datasets: [{
                    label: 'Number of Tasks',
                    data: [<%= chartData.toString() %>],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                var label = tooltipItem.dataset.label || '';
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
            }
        }
    %>
</body>
</html>
