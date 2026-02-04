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
        response.sendError(401, "Unauthorized User.");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services</title>
<style>
    body { margin:0;
    	   font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .desc-cell {max-width: 350px; word-wrap: break-word; white-space: normal;}
	.actions-cell {text-align: center; vertical-align: middle;}
	.actions-wrapper {display: flex; flex-direction: column; align-items: center; gap: 15px;}    
    .btn { padding:6px 12px; border-radius:8px; border:none; cursor:pointer;
           font-size:13px; font-weight:600; text-decoration:none; margin-right:6px; }
    .btn-add { background:#2ECC71; color:#fff; }
    .btn-edit { background:#3498DB; color:#fff; }
    .btn-delete { background:#C0392B; color:#fff; }
    .btn:hover { opacity:0.9; }
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
    function confirmDelete(serviceId, serviceName) {
        document.getElementById("deleteModal").style.display = "block";
        document.getElementById("deleteServiceName").innerText = serviceName;
        document.getElementById("deleteServiceId").value = serviceId;
    }
    function closeModal() {
        document.getElementById("deleteModal").style.display = "none";
    }
</script>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>🛠 Manage Services</h1>
        <p>View, add, edit, or delete service offerings.</p>

        <div class="card">
            <a href="addService.jsp" class="btn btn-add">➕ Add Service</a>

            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Name</th><th>Category</th><th>Description</th><th>Price</th><th>Actions</th>
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

                        // Count total records
                        PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM service");
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) totalRecords = rsCount.getInt(1);
                        totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
                        rsCount.close(); psCount.close();

                        // Fetch paginated records
                        String sql = "SELECT s.service_id, s.service_name, s.description, s.price, c.category_name " +
                                     "FROM service s LEFT JOIN service_category c ON s.category_id = c.category_id " +
                                     "LIMIT ?, ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, start);
                        ps.setInt(2, recordsPerPage);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("service_id");
                            String name = rs.getString("service_name");
                            String desc = rs.getString("description");
                            String category = rs.getString("category_name");
                            double price = rs.getDouble("price");
                %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= name %></td>
                        <td><%= category %></td>
                        <td class="desc-cell" title="<%= desc %>"><%= desc %></td>
                        <td>$<%= price %></td>
                        <td class="actions-cell">
						    <div class="actions-wrapper">
						        <a href="editService.jsp?id=<%= id %>" class="btn btn-edit">✏️ Edit</a>
						        <button type="button" class="btn btn-delete"
						                onclick="confirmDelete(<%= id %>, '<%= name %>')">🗑 Delete</button>
						    </div>
						</td>
                    </tr>
                <%
                        }
                        rs.close(); ps.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
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
                    <a href="manageServices.jsp?page=<%= i %>" class="active"><%= i %></a>
                <%
                        } else {
                %>
                    <a href="manageServices.jsp?page=<%= i %>"><%= i %></a>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Delete confirmation modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Delete</h3>
            <p>Are you sure you want to delete <strong id="deleteServiceName"></strong>?</p>
            <form action="processDeleteService.jsp" method="post">
                <input type="hidden" id="deleteServiceId" name="serviceId">
                <button type="submit" class="btn btn-confirm">Yes, Delete</button>
                <button type="button" class="btn btn-cancel" onclick="closeModal()">Cancel</button>
            </form>
        </div>
    </div>
</body>
</html>
