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
<title>Edit Booking</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; max-width:600px; margin:auto; }
    .form-group { margin-bottom:14px; }
    label { display:block; font-size:13px; margin-bottom:4px; }
    input, select { width:90%; padding:9px 11px; border-radius:8px; border:1px solid #D0D7DE;
                    background:#FAFBFC; font-size:13px; }
	.btn { padding:6px 12px; border-radius:8px; border:none; cursor:pointer;
           font-size:13px; font-weight:600; text-decoration:none; margin-right:6px; }
    .btn-submit { width:100%; padding:10px; border-radius:999px; border:none; font-size:14px;
                  font-weight:600; cursor:pointer; background:#3498DB; color:#fff; }
    .btn-submit:hover { background:#2980B9; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>
    <div class="main">
        <h1>✏️ Edit Booking</h1>
        <div class="card">
            <%
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    try {
                        int bookingId = Integer.parseInt(idStr);
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

                        String sql = "SELECT date, total_price, status, payment_status FROM booking WHERE booking_id=?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, bookingId);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
            %>
            <form action="bookings/processEditBooking.jsp" method="post">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">

                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="datetime-local" id="date" name="date"
                           value="<%= rs.getTimestamp("date").toLocalDateTime().toString().replace('T',' ') %>" required>
                </div>

                <div class="form-group">
                    <label for="totalPrice">Total Price</label>
                    <input type="number" step="0.01" id="totalPrice" name="totalPrice"
                           value="<%= rs.getDouble("total_price") %>" required>
                </div>

                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" required>
                        <option <%= rs.getString("status").equals("PENDING")?"selected":"" %>>PENDING</option>
                        <option <%= rs.getString("status").equals("CONFIRMED")?"selected":"" %>>CONFIRMED</option>
                        <option <%= rs.getString("status").equals("COMPLETED")?"selected":"" %>>COMPLETED</option>
                        <option <%= rs.getString("status").equals("CANCELLED")?"selected":"" %>>CANCELLED</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="payment">Payment Status</label>
                    <select id="payment" name="payment" required>
                        <option <%= rs.getString("payment_status").equals("UNPAID")?"selected":"" %>>UNPAID</option>
                        <option <%= rs.getString("payment_status").equals("PAID")?"selected":"" %>>PAID</option>
                        <option <%= rs.getString("payment_status").equals("REFUNDED")?"selected":"" %>>REFUNDED</option>
                        <option <%= rs.getString("payment_status").equals("FAILED")?"selected":"" %>>FAILED</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit">Update Booking</button>
            </form>
            <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) { out.println("<p>Error: "+e.getMessage()+"</p>"); }
                } else { out.println("<p>No booking ID provided.</p>"); }
            %>
        </div>
    </div>
</body>
</html>
