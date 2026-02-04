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
<title>Edit Service</title>
<style>
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #F7F9FB;
        color: #2C3E50;
        display: flex;
    }
    .main {
        flex: 1;
        padding: 30px;
    }
    .card {
        background-color: #fff;
        border-radius: 18px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.08);
        padding: 20px;
        max-width: 600px;
        margin: auto;
    }
    .form-group {
        margin-bottom: 14px;
    }
    label {
        display: block;
        font-size: 13px;
        margin-bottom: 4px;
        color: #2C3E50;
    }
    input, textarea, select {
        width: 100%;
        padding: 9px 11px;
        border-radius: 8px;
        border: 1px solid #D0D7DE;
        background-color: #FAFBFC;
        font-size: 13px;
        outline: none;
    }
    input:focus, textarea:focus, select:focus {
        border-color: #3498DB;
        box-shadow: 0 0 0 2px rgba(52,152,219,0.20);
        background-color: #fff;
    }
    .btn-submit {
        width: 100%;
        padding: 10px;
        border-radius: 999px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        background-color: #3498DB;
        color: #fff;
        box-shadow: 0 6px 16px rgba(52,152,219,0.4);
    }
    .btn-submit:hover {
        background-color: #2980B9;
    }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>✏️ Edit Service</h1>
        <div class="card">
            <%
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.isEmpty()) {
                    out.println("<p>Error: Service ID missing.</p>");
                } else {
                    try {
                        int serviceId = Integer.parseInt(idStr);
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(
                        		"jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC");

                        String sql = "SELECT service_name, category_id, description, price FROM service WHERE service_id = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, serviceId);
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            String name = rs.getString("service_name");
                            int categoryId = rs.getInt("category_id");
                            String desc = rs.getString("description");
                            double price = rs.getDouble("price");
            %>
            <form action="processEditService.jsp" method="post">
                <input type="hidden" name="serviceId" value="<%= serviceId %>">

                <div class="form-group">
                    <label for="serviceName">Service Name</label>
                    <input type="text" id="serviceName" name="serviceName" value="<%= name %>" required>
                </div>

                <div class="form-group">
                    <label for="categoryId">Category</label>
                    <select id="categoryId" name="categoryId" required>
                        <%
                            PreparedStatement psCat = conn.prepareStatement("SELECT category_id, category_name FROM service_category");
                            ResultSet rsCat = psCat.executeQuery();
                            while (rsCat.next()) {
                                int catId = rsCat.getInt("category_id");
                                String catName = rsCat.getString("category_name");
                                String selected = (catId == categoryId) ? "selected" : "";
                        %>
                                <option value="<%= catId %>" <%= selected %>><%= catName %></option>
                        <%
                            }
                            rsCat.close();
                            psCat.close();
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3" required><%= desc %></textarea>
                </div>

                <div class="form-group">
                    <label for="price">Price (SGD)</label>
                    <input type="number" step="0.01" id="price" name="price" value="<%= price %>" required>
                </div>

                <button type="submit" class="btn-submit">Update Service</button>
            </form>
            <%
                        } else {
                            out.println("<p>Error: Service not found.</p>");
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
