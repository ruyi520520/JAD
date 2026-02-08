<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .desc-cell { max-width:350px; word-break:break-word; }
    .btn { padding:6px 12px; border-radius:8px; border:none; cursor:pointer;
           font-size:13px; font-weight:600; text-decoration:none; margin-right:6px; display:inline-block; }
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
</style>

<script>
    function confirmDeleteService(id, name) {
        document.getElementById("deleteServiceModal").style.display = "block";
        document.getElementById("deleteServiceName").innerText = name;
        document.getElementById("deleteServiceId").value = id;
    }
    function closeServiceModal() {
        document.getElementById("deleteServiceModal").style.display = "none";
    }
</script>
</head>

<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>🛠 Manage Services</h1>

        <div class="card">
            <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/admin-only/services/add">➕ Add Service</a>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Service</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="r" items="${rows}">
                        <tr>
                            <td>${r.serviceId}</td>
                            <td>${r.serviceName}</td>
                            <td class="desc-cell">${r.description}</td>
                            <td>${r.categoryName}</td>
                            <td>$${r.price}</td>
                            <td>
                                <a class="btn btn-edit"
                                   href="${pageContext.request.contextPath}/admin/admin-only/services/edit?id=${r.serviceId}">
                                   ✏️ Edit
                                </a>

                                <button type="button" class="btn btn-delete"
                                        onclick="confirmDeleteService(${r.serviceId}, '${r.serviceName}')">
                                    🗑 Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty rows}">
                        <tr><td colspan="6">No services found.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/admin-only/services?page=${i}"
                       class="${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Delete modal -->
    <div id="deleteServiceModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Delete</h3>
            <p>Delete <strong id="deleteServiceName"></strong>?</p>

            <form action="${pageContext.request.contextPath}/admin/admin-only/services/delete" method="post">
                <input type="hidden" id="deleteServiceId" name="serviceId">
                <button type="submit" class="btn btn-delete">Yes, Delete</button>
                <button type="button" class="btn btn-edit" onclick="closeServiceModal()">Cancel</button>
            </form>
        </div>
    </div>
</body>
</html>
