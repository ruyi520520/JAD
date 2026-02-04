<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Process Delete Service</title>
</head>
<body>
<%
    String idStr = request.getParameter("serviceId");

    if (idStr == null || idStr.isEmpty()) {
        request.setAttribute("error", "Service ID missing.");
        RequestDispatcher rd = request.getRequestDispatcher("manageServices.jsp");
        rd.forward(request, response);
        return;
    }

    try {
        int serviceId = Integer.parseInt(idStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

        String sql = "DELETE FROM service WHERE service_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, serviceId);

        int rows = ps.executeUpdate();
        ps.close();
        conn.close();

        if (rows > 0) {
            request.setAttribute("success", "Service deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete service.");
        }

        RequestDispatcher rd = request.getRequestDispatcher("manageServices.jsp");
        rd.forward(request, response);

    } catch (Exception e) {
        request.setAttribute("error", "Error: " + e.getMessage());
        RequestDispatcher rd = request.getRequestDispatcher("manageServices.jsp");
        rd.forward(request, response);
    }
%>
</body>
</html>
