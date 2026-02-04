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
<title>Manage Bookings</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .btn { padding:6px 12px; border-radius:8px; border:none; cursor:pointer;
           font-size:13px; font-weight:600; text-decoration:none; margin-right:6px; }
    .btn-edit { background:#3498DB; color:#fff; }
    .btn:hover { opacity:0.9; }
    .status { font-weight:600; }
    .status.PENDING { color:#F39C12; }
    .status.CONFIRMED { color:#27AE60; }
    .status.COMPLETED { color:#2980B9; }
    .status.CANCELLED { color:#C0392B; }
    .payment.UNPAID { color:#C0392B; font-weight:600; }
    .payment.PAID { color:#27AE60; font-weight:600; }
    .payment.REFUNDED { color:#2980B9; font-weight:600; }
    .payment.FAILED { color:#C0392B; font-weight:600; }
    .pagination { margin-top:20px; text-align:center; }
    .pagination a { display:inline-block; margin:0 5px; padding:8px 12px; border-radius:6px;
                    background:#2ECC71; color:#fff; text-decoration:none; font-weight:600; }
    .pagination a.active { background:#27AE60; }
    /* Modal */
    .modal { display:none; position:fixed; z-index:999; left:0; top:0; width:100%; height:100%;
             background-color:rgba(0,0,0,0.5); }
    .modal-content { background:#fff; border-radius:18px; padding:20px; max-width:400px;
                     margin:15% auto; text-align:center; box-shadow:0 12px 30px rgba(0,0,0,0.2); }
    .modal h3 { margin-bottom:20px; }
    .modal .btn-confirm { background:#C0392B; color:#fff; }
    .modal .btn-cancel { background:#3498DB; color:#fff; }
</style>
<script>
    function confirmDeleteBooking(id, client) {
        document.getElementById("deleteBookingModal").style.display = "block";
        document.getElementById("deleteBookingClient").innerText = client;
        document.getElementById("deleteBookingId").value = id;
    }
    function closeBookingModal() {
        document.getElementById("deleteBookingModal").style.display = "none";
    }
</script>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>📅 Manage Bookings</h1>
        <p>All client bookings with details and status.</p>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Client</th>
                        <th>Date</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Services</th>
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

                        // Count total bookings
                        PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM booking");
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) totalRecords = rsCount.getInt(1);
                        totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
                        rsCount.close(); psCount.close();

                        // Fetch paginated bookings
                        String sql = "SELECT b.booking_id, b.date, b.total_price, b.status, b.payment_status, u.username "+
                        	"FROM booking b "+
                        	"JOIN booking_details bd ON b.booking_id = bd.booking_id "+
                        	"JOIN user u ON bd.user_id = u.user_id "+
                        	"ORDER BY b.booking_id "+
                        	"LIMIT ?, ?;"
;
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, start);
                        ps.setInt(2, recordsPerPage);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int bookingId = rs.getInt("booking_id");
                            String client = rs.getString("username");
                            Timestamp date = rs.getTimestamp("date");
                            double total = rs.getDouble("total_price");
                            String status = rs.getString("status");
                            String payment = rs.getString("payment_status");

                            // Fetch services for this booking
                            String serviceSql = "SELECT s.service_name FROM booking_details bd " +
                                                "JOIN service s ON bd.service_id = s.service_id " +
                                                "WHERE bd.booking_id = ?";
                            PreparedStatement psServices = conn.prepareStatement(serviceSql);
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
                        <td><%= client %></td>
                        <td><%= date %></td>
                        <td>$<%= total %></td>
                        <td class="status <%= status %>"><%= status %></td>
                        <td class="payment <%= payment %>"><%= payment %></td>
                        <td><%= services.toString() %></td>
                        <td>
                            <a href="editBooking.jsp?id=<%= bookingId %>" class="btn btn-edit">✏️ Edit</a>
                        </td>
                    </tr>
                <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
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
                    <a href="viewBookings.jsp?page=<%= i %>" class="active"><%= i %></a>
                <%
                        } else {
                %>
                    <a href="viewBookings.jsp?page=<%= i %>"><%= i %></a>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Delete confirmation modal -->
    <div id="deleteBookingModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Delete</h3>
            <p>Are you sure you want to delete booking for <strong id="deleteBookingClient"></strong>?</p>
            <form action="bookings/processDeleteBooking.jsp" method="post">
                <input type="hidden" id="deleteBookingId" name="bookingId">
                <button type="submit" class="btn btn-confirm">Yes, Delete</button>
                <button type="button" class="btn btn-cancel" onclick="closeBookingModal()">Cancel</button>
                </form>
                </div>
                </div>
                </body>
                </html>
