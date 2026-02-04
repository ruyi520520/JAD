<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Process Add Service</title>
</head>
<body>
<%
    String name = request.getParameter("serviceName");
    String desc = request.getParameter("description");
    String priceStr = request.getParameter("price");
    String categoryIdStr = request.getParameter("categoryId");

    if (name == null || desc == null || priceStr == null || categoryIdStr == null ||
        name.isEmpty() || desc.isEmpty() || priceStr.isEmpty() || categoryIdStr.isEmpty()) {
        request.setAttribute("error", "All fields are required.");
        RequestDispatcher rd = request.getRequestDispatcher("addService.jsp");
        rd.forward(request, response);
        return;
    }

    try {
        double price = Double.parseDouble(priceStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

        String sql = "INSERT INTO service (service_name, category_id, description, price, image_url) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setInt(2, categoryId);
        ps.setString(3, desc);
        ps.setDouble(4, price);
        ps.setString(5, ""); // placeholder for image_url until upload feature is added

        int rows = ps.executeUpdate();
        ps.close();
        conn.close();

        if (rows > 0) {
            request.setAttribute("success", "Service added successfully!");
            RequestDispatcher rd = request.getRequestDispatcher("manageServices.jsp");
            rd.forward(request, response);
        } else {
            request.setAttribute("error", "Failed to add service.");
            RequestDispatcher rd = request.getRequestDispatcher("addService.jsp");
            rd.forward(request, response);
        }

    } catch (Exception e) {
        request.setAttribute("error", "Error: " + e.getMessage());
        RequestDispatcher rd = request.getRequestDispatcher("addService.jsp");
        rd.forward(request, response);
    }
%>
</body>
</html>
