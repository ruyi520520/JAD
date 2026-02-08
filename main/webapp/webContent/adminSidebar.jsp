<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .sidebar {
        width: 220px;
        background-color: #1F2D3D;
        color: #fff;
        min-height: 100vh;
        padding: 20px;
        box-sizing: border-box;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .sidebar h2 {
        font-size: 18px;
        margin-bottom: 20px;
    }
    .sidebar-nav {
        flex: 1;
    }
    .sidebar a {
        display: block;
        color: #fff;
        padding: 10px;
        margin-bottom: 8px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 14px;
    }
    .sidebar a:hover {
        background-color: #27AE60;
    }
    .logout-btn {
        display: block;
        text-align: center;
        padding: 10px;
        border-radius: 8px;
        background-color: #C0392B;
        color: #fff;
        font-weight: 600;
        text-decoration: none;
        position: sticky;
        bottom: 20px;
    }
    .logout-btn:hover {
        background-color: #A93226;
    }
</style>

<div class="sidebar">
    <div>
        <h2>⚙️ Admin Panel</h2>

        <div class="sidebar-nav">

            <!-- Admin + staff -->
            <a href="${pageContext.request.contextPath}/admin/dashboard">🏠 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/bookings">📅 View Bookings</a>

            <!-- Admin only -->
            <c:if test="${sessionScope.sessRoleName eq 'Admin'}">
                <a href="${pageContext.request.contextPath}/admin/admin-only/services">🛠 Manage Services</a>
                <a href="${pageContext.request.contextPath}/admin/admin-only/clients">👥 Clients</a>
                <a href="${pageContext.request.contextPath}/admin/auditLogs">📝 Audit Log</a>
            </c:if>

        </div>
    </div>

    <div class="sidebar-logout">
        <form action="${pageContext.request.contextPath}/auth/logout" method="post">
            <button type="submit" class="logout-btn">🚪 Logout</button>
        </form>
    </div>
</div>

