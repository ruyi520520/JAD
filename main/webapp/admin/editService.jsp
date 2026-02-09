<!--  =====================================
    Author: Huang Ruyi
    Date: 7/2/2026
    Description: ST0510/JAD project 2
====================================== */ -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Service</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; max-width:600px; margin:auto; }
    .form-group { margin-bottom:14px; }
    label { display:block; font-size:13px; margin-bottom:4px; }
    input, select, textarea { width:95%; padding:9px 11px; border-radius:8px; border:1px solid #D0D7DE;
                              background:#FAFBFC; font-size:13px; }
    textarea { min-height:100px; resize:vertical; }
    .btn-submit { width:100%; padding:10px; border-radius:999px; border:none; font-size:14px;
                  font-weight:600; cursor:pointer; background:#3498DB; color:#fff; }
    .btn-submit:hover { background:#2980B9; }
    .error { background:#ffe6e6; border:1px solid #ffb3b3; padding:10px; border-radius:10px; margin-bottom:12px; }
</style>
</head>

<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>✏️ Edit Service</h1>

        <div class="card">
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty service}">
                <form action="${pageContext.request.contextPath}/admin/admin-only/services/edit" method="post">
                    <input type="hidden" name="serviceId" value="${service.serviceId}">

                    <div class="form-group">
                        <label>Service Name</label>
                        <input type="text" name="serviceName" value="${service.serviceName}" required>
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="categoryId" required>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}"
                                    <c:if test="${c.categoryId == service.categoryId}">selected</c:if>>
                                    ${c.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" required>${service.description}</textarea>
                    </div>

                    <div class="form-group">
                        <label>Price</label>
                        <input type="number" step="0.01" name="price" value="${service.price}" required>
                    </div>

                    <button type="submit" class="btn-submit">Update Service</button>
                </form>
            </c:if>
        </div>
    </div>
</body>
</html>
