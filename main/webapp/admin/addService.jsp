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
<title>Add Service</title>
<style>
    body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #F7F9FB;
        color: #2C3E50;
        display: flex;
    }
    .main { flex: 1; padding: 30px; }
    .card {
        background-color: #fff;
        border-radius: 18px;
        box-shadow: 0 12px 30px rgba(0,0,0,0.08);
        padding: 20px;
        max-width: 600px;
        margin: auto;
    }
    .form-group { margin-bottom: 14px; }
    label { display: block; font-size: 13px; margin-bottom: 4px; color: #2C3E50; }
    input, textarea, select {
        width: 90%;
        padding: 9px 11px;
        border-radius: 8px;
        border: 1px solid #D0D7DE;
        background-color: #FAFBFC;
        font-size: 13px;
        outline: none;
    }
    input:focus, textarea:focus, select:focus {
        border-color: #2ECC71;
        box-shadow: 0 0 0 2px rgba(46,204,113,0.20);
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
        background-color: #2ECC71;
        color: #fff;
        box-shadow: 0 6px 16px rgba(46,204,113,0.4);
    }
    .btn-submit:hover { background-color: #27AE60; }
    .hint { font-size: 13px; opacity: 0.85; margin: 6px 0 0; }
</style>
</head>

<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>➕ Add New Service</h1>

        <div class="card">
            <form action="${pageContext.request.contextPath}/admin/admin-only/services/add" method="post">

                <div class="form-group">
                    <label for="serviceName">Service Name</label>
                    <input type="text" id="serviceName" name="serviceName" required>
                </div>

                <div class="form-group">
                    <label for="categoryId">Category</label>

                    <c:choose>
                        <c:when test="${empty categories}">
                            <select id="categoryId" name="categoryId" disabled>
                                <option>No categories available</option>
                            </select>
                            <p class="hint">Create categories first before adding services.</p>
                        </c:when>

                        <c:otherwise>
                            <select id="categoryId" name="categoryId" required>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}">${c.categoryName}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3" required></textarea>
                </div>

                <div class="form-group">
                    <label for="price">Price (SGD)</label>
                    <input type="number" step="0.01" id="price" name="price" required>
                </div>

                <button type="submit" class="btn-submit">Create Service</button>
            </form>
        </div>
    </div>
</body>
</html>
