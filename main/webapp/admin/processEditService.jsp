<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Process Edit Service</title>
</head>
<body>
<%
    String idStr = request.getParameter("serviceId");
    String name = request.getParameter("serviceName");
    String desc = request.getParameter("description");
    String priceStr = request.getParameter("price");
    String categoryIdStr = request.getParameter("categoryId");

    if (idStr == null || name == null || desc == null || priceStr == null || categoryIdStr == null ||
        idStr.isEmpty() || name.isEmpty() || desc.isEmpty() || priceStr.isEmpty() || categoryIdStr.isEmpty()) {
        request.setAttribute("error", "All fields are required.");
        RequestDispatcher rd = request.getRequestDispatcher("editService.jsp?id=" + idStr);
        rd.forward(request, response);
        return;
    }

    try {
        int serviceId = Integer.parseInt(idStr);
        double price = Double.parseDouble(priceStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

        String sql = "UPDATE service SET service_name=?, category_id=?, description=?, price=? WHERE service_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setInt(2, categoryId);
        ps.setString(3, desc);
        ps.setDouble(4, price);
        ps.setInt(5, serviceId);

        int rows = ps.executeUpdate();
        ps.close();
        conn.close();

        if (rows > 0) {
            request.setAttribute("success", "Service updated successfully!");
            RequestDispatcher rd = request.getRequestDispatcher("manageServices.jsp");
            rd.forward(request, response);
        } else {
            request.setAttribute("error", "Failed to update service.");
            RequestDispatcher rd = request.getRequestDispatcher("editService.jsp?id=" + idStr);
            rd.forward(request, response);
        }

    } catch (Exception e) {
        request.setAttribute("error", "Error: " + e.getMessage());
        RequestDispatcher rd = request.getRequestDispatcher("editService.jsp?id=" + idStr);
        rd.forward(request, response);
    }
%>
</body>
</html>
