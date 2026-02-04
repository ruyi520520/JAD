<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String idStr = request.getParameter("bookingId");
    String dateStr = request.getParameter("date");
    String totalStr = request.getParameter("totalPrice");
    String status = request.getParameter("status");
    String payment = request.getParameter("payment");

    try {
        int bookingId = Integer.parseInt(idStr);
        double total = Double.parseDouble(totalStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

        String sql = "UPDATE booking SET date=?, total_price=?, status=?, payment_status=? WHERE booking_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, dateStr);
        ps.setDouble(2, total);
        ps.setString(3, status);
        ps.setString(4, payment);
        ps.setInt(5, bookingId);

        ps.executeUpdate();
        ps.close(); conn.close();

        response.sendRedirect("../manageBookings.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
