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
<title>Manage Clients</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .btn-view { background:#3498DB; color:#fff; padding:6px 12px; border-radius:8px;
                text-decoration:none; font-weight:600; }
    .btn-view:hover { opacity:0.9; }
    .pagination { margin-top:20px; text-align:center; }
    .pagination a { display:inline-block; margin:0 5px; padding:8px 12px; border-radius:6px;
                    background:#2ECC71; color:#fff; text-decoration:none; font-weight:600; }
    .pagination a.active { background:#27AE60; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>👥 Manage Clients</h1>
        <p>List of all registered customers.</p>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Created At</th>
                        <th>Actions</th>
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

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

                        // Count total clients
                        PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE role_id=2");
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) totalRecords = rsCount.getInt(1);
                        totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
                        rsCount.close(); psCount.close();

                        // Fetch paginated clients
                        String sql = "SELECT user_id, username, email, created_at FROM user WHERE role_id=2 LIMIT ?, ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, start);
                        ps.setInt(2, recordsPerPage);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("user_id");
                            String username = rs.getString("username");
                            String email = rs.getString("email");
                            Timestamp created = rs.getTimestamp("created_at");
                %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= username %></td>
                        <td><%= email %></td>
                        <td><%= created %></td>
                        <td><a href="clientInfo.jsp?id=<%= id %>" class="btn-view">🔍 View</a></td>
                    </tr>
                <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination">
                <%
                    for (int i = 1; i <= totalPages; i++) {
                        if (i == currentPage) {
                %>
                    <a href="viewClients.jsp?page=<%= i %>" class="active"><%= i %></a>
                <%
                        } else {
                %>
                    <a href="viewClients.jsp?page=<%= i %>"><%= i %></a>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
