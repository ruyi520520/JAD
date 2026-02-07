<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Clients</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .btn-view { background:#3498DB; color:#fff; padding:6px 12px; border-radius:8px;
                text-decoration:none; font-weight:600; display:inline-block; }
    .btn-view:hover { opacity:0.9; }
    .pagination { margin-top:20px; text-align:center; }
    .pagination a { display:inline-block; margin:0 5px; padding:8px 12px; border-radius:6px;
                    background:#2ECC71; color:#fff; text-decoration:none; font-weight:600; }
    .pagination a.active { background:#27AE60; }
</style>
</head>

<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>👥 Manage Clients</h1>
        <p>List of all registered customers.</p>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="u" items="${clients}">
                        <tr>
                            <td>${u.userId}</td>
                            <td>${u.username}</td>
                            <td>${u.email}</td>
                            <td>${u.createdAt}</td>
                            <td>
                                <a class="btn-view"
                                   href="${pageContext.request.contextPath}/admin/clientInfo?id=${u.userId}">
                                   🔍 View
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty clients}">
                        <tr><td colspan="5">No clients found.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/clients?page=${i}"
                       class="${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
