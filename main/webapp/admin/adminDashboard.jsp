<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
<title>Admin Dashboard</title>
<style>
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #F7F9FB;
        color: #2C3E50;
        display: flex;
    }
    /* Sidebar */
    .sidebar {
        width: 220px;
        background-color: #1F2D3D;
        color: #fff;
        min-height: 100vh;
        padding: 20px;
        box-sizing: border-box;
    }
    .sidebar h2 {
        font-size: 18px;
        margin-bottom: 20px;
    }
    .sidebar a {
        display: block;
        color: #fff;
        padding: 10px;
        margin-bottom: 8px;
        border-radius: 8px;
        text-decoration: none;
    }
    .sidebar a:hover {
        background-color: #27AE60;
    }
    /* Main content */
    .main {
        flex: 1;
        padding: 30px;
    }
    .card {
        background-color: #fff;
        border-radius: 18px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.08);
        padding: 20px;
        margin-bottom: 20px;
    }
    .card h3 {
        margin: 0 0 10px;
    }
    .stats {
        display: flex;
        gap: 20px;
    }
    .stat-card {
        flex: 1;
        background-color: #2ECC71;
        color: #fff;
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 6px 16px rgba(46,204,113,0.4);
    }
    .stat-card h2 {
        margin: 0;
        font-size: 28px;
    }
</style>
</head>
<body style="display:flex;">
<%@ include file="../webContent/adminSidebar.jsp" %>

    <!-- Main content -->
    <div class="main">
        <h1>Welcome, Admin!</h1>
        <p>Here are your current stats:</p>

        <div class="stats">
            <div class="stat-card">
                <h2>
                <%
                    // Count services
                    int serviceCount = 0;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");
                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM service");
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) { serviceCount = rs.getInt(1); }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) { out.println("Error: " + e); }
                    out.print(serviceCount);
                %>
                </h2>
                <p>Services</p>
            </div>
            <div class="stat-card">
                <h2>
                <%
                    // Count bookings
                    int bookingCount = 0;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");
                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM booking");
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) { bookingCount = rs.getInt(1); }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) { out.println("Error: " + e); }
                    out.print(bookingCount);
                %>
                </h2>
                <p>Bookings</p>
            </div>
            <div class="stat-card">
                <h2>
                <%
                    // Count clients
                    int clientCount = 0;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");
                        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE role_id = 2");
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) { clientCount = rs.getInt(1); }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) { out.println("Error: " + e); }
                    out.print(clientCount);
                %>
                </h2>
                <p>Clients</p>
            </div>
        </div>

        <div class="card">
            <h3>Quick Actions</h3>
            <p>Use the sidebar to manage services, view bookings, and access client information.</p>
        </div>
    </div>
</body>
</html>
