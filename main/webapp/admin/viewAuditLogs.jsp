<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("sessUserId") == null) {
        response.sendRedirect("../auth/login.jsp");
        return;
    }

    String roleName = (String) sess.getAttribute("sessRoleName");
    if (roleName == null || !"Admin".equalsIgnoreCase(roleName)) {
        response.sendRedirect("../errorHandling/401.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Audit Logs</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .filter-form { margin-bottom:20px; }
    select, button { padding:8px 12px; border-radius:8px; border:1px solid #D0D7DE;
                     font-size:13px; margin-right:10px; }
    button { background:#3498DB; color:#fff; font-weight:600; cursor:pointer; }
    button:hover { opacity:0.9; }
    .pagination { margin-top:20px; text-align:center; }
    .pagination a { display:inline-block; margin:0 5px; padding:8px 12px; border-radius:6px;
                    background:#2ECC71; color:#fff; text-decoration:none; font-weight:600; }
    .pagination a.active { background:#27AE60; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>📜 Audit Logs</h1>
        <p>Track all system actions performed by users.</p>

        <div class="card">
            <!-- Filter Form -->
            <form method="get" class="filter-form">
                <label>Action Type:</label>
                <select name="action_type">
                    <option value="">All</option>
                    <option value="CREATE">CREATE</option>
                    <option value="UPDATE">UPDATE</option>
                    <option value="DELETE">DELETE</option>
                    <option value="LOGIN">LOGIN</option>
                </select>

                <label>Target Type:</label>
                <select name="target_type">
                    <option value="">All</option>
                    <option value="BOOKING">BOOKING</option>
                    <option value="SERVICE">SERVICE</option>
                    <option value="USER">USER</option>
                    <option value="PAYMENT">PAYMENT</option>
                </select>

                <button type="submit">Filter</button>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Action</th>
                        <th>Target</th>
                        <th>Target ID</th>
                        <th>Description</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int currentPage = 1;
                    int recordsPerPage = 10;
                    if (request.getParameter("page") != null) {
                        currentPage = Integer.parseInt(request.getParameter("page"));
                    }
                    int start = (currentPage - 1) * recordsPerPage;
                    int totalRecords = 0, totalPages = 0;

                    String filterAction = request.getParameter("action_type");
                    String filterTarget = request.getParameter("target_type");

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

                        // Build WHERE clause
                        String where = " WHERE 1=1 ";
                        if (filterAction != null && !filterAction.isEmpty()) {
                            where += " AND a.action_type='" + filterAction + "'";
                        }
                        if (filterTarget != null && !filterTarget.isEmpty()) {
                            where += " AND a.target_type='" + filterTarget + "'";
                        }

                        // Count total logs
                        PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM audit_log a" + where);
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) totalRecords = rsCount.getInt(1);
                        totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
                        rsCount.close(); psCount.close();

                        // Fetch logs with pagination
                        String sql = "SELECT a.log_id, u.username, a.action_type, a.target_type, a.target_id, a.description, a.created_at " +
                                     "FROM audit_log a JOIN user u ON a.user_id=u.user_id " +
                                     where + " ORDER BY a.log_id LIMIT ?, ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, start);
                        ps.setInt(2, recordsPerPage);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("log_id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("action_type") %></td>
                        <td><%= rs.getString("target_type") %></td>
                        <td><%= rs.getInt("target_id") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td><%= rs.getTimestamp("created_at") %></td>
                    </tr>
                <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination">
                <%
                    for (int i = 1; i <= totalPages; i++) {
                        String link = "viewAuditLogs.jsp?page=" + i;
                        if (filterAction != null && !filterAction.isEmpty()) {
                            link += "&action_type=" + filterAction;
                        }
                        if (filterTarget != null && !filterTarget.isEmpty()) {
                            link += "&target_type=" + filterTarget;
                        }
                        if (i == currentPage) {
                %>
                    <a href="<%= link %>" class="active"><%= i %></a>
                <%
                        } else {
                %>
                    <a href="<%= link %>"><%= i %></a>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
