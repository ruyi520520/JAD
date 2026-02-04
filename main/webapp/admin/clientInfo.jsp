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
<title>Client Details</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>👤 Client Details</h1>
        <%
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int userId = Integer.parseInt(idStr);
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(
                    		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

                    // Fetch user info
                    PreparedStatement psUser = conn.prepareStatement(
                        "SELECT username, email, created_at FROM user WHERE user_id=?");
                    psUser.setInt(1, userId);
                    ResultSet rsUser = psUser.executeQuery();
                    if (rsUser.next()) {
        %>
        <div class="card">
            <h2><%= rsUser.getString("username") %></h2>
            <p>Email: <%= rsUser.getString("email") %></p>
            <p>Joined: <%= rsUser.getTimestamp("created_at") %></p>
        </div>
        <%
                    }
                    rsUser.close(); psUser.close();

                    // Fetch bookings
                    PreparedStatement psBookings = conn.prepareStatement(
                    		"SELECT b.booking_id, b.date, b.total_price, b.status, b.payment_status "+
                    		"FROM booking b "+
                    		"JOIN booking_details bd ON b.booking_id = bd.booking_id "+
                    		"WHERE bd.user_id = ? "+
                    		"ORDER BY b.date DESC");
                    psBookings.setInt(1, userId);
                    ResultSet rsBookings = psBookings.executeQuery();
        %>
        <div class="card">
            <h3>📅 Bookings</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Date</th><th>Total</th><th>Status</th><th>Payment</th><th>Services</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    while (rsBookings.next()) {
                        int bookingId = rsBookings.getInt("booking_id");
                        Timestamp date = rsBookings.getTimestamp("date");
                        double total = rsBookings.getDouble("total_price");
                        String status = rsBookings.getString("status");
                        String payment = rsBookings.getString("payment_status");

                        // Fetch services for booking
                        PreparedStatement psServices = conn.prepareStatement(
                            "SELECT s.service_name FROM booking_details bd " +
                            "JOIN service s ON bd.service_id=s.service_id WHERE bd.booking_id=?");
                        psServices.setInt(1, bookingId);
                        ResultSet rsServices = psServices.executeQuery();
                        StringBuilder services = new StringBuilder();
                        while (rsServices.next()) {
                            if (services.length() > 0) services.append(", ");
                            services.append(rsServices.getString("service_name"));
                        }
                        rsServices.close(); psServices.close();
                %>
                    <tr>
                        <td><%= bookingId %></td>
                        <td><%= date %></td>
                        <td>$<%= total %></td>
                        <td><%= status %></td>
                        <td><%= payment %></td>
                        <td><%= services.toString() %></td>
                    </tr>
                <%
                    }
                    rsBookings.close(); psBookings.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                }
            } else {
                out.println("<p>No client ID provided.</p>");
            }
        %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
