<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    }
    .logout-btn:hover {
        background-color: #A93226;
    }
</style>

<div class="sidebar">
    <div>
        <h2>⚙️ Admin Panel</h2>
        <div class="sidebar-nav">
            <!-- Controller routes (preferred) -->
            <a href="${pageContext.request.contextPath}/admin/dashboard">🏠 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/services">🛠 Manage Services</a>
            <a href="${pageContext.request.contextPath}/admin/bookings">📅 View Bookings</a>
            <a href="${pageContext.request.contextPath}/admin/clients">👥 Clients</a>
            <a href="${pageContext.request.contextPath}/admin/auditLogs">📝 Audit Log</a>
        </div>
    </div>

    <div>
        <a href="${pageContext.request.contextPath}/auth/logout" class="logout-btn">🚪 Logout</a>
    </div>
</div>
