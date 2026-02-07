<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
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
        margin-bottom: 20px;
    }
    .stats { display: flex; gap: 20px; }
    .stat-card {
        flex: 1;
        background-color: #2ECC71;
        color: #fff;
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 6px 16px rgba(46,204,113,0.4);
    }
    .stat-card h2 { margin: 0; font-size: 28px; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>Welcome, Admin!</h1>
        <p>Here are your current stats:</p>

        <div class="stats">
            <div class="stat-card">
                <h2>${serviceCount}</h2>
                <p>Services</p>
            </div>

            <div class="stat-card">
                <h2>${bookingCount}</h2>
                <p>Bookings</p>
            </div>

            <div class="stat-card">
                <h2>${clientCount}</h2>
                <p>Clients</p>
            </div>
        </div>

        <div class="card">
            <h3>Quick Actions</h3>
            <p>Use the sidebar to manage services, view bookings, and access client information.</p>
        </div>
    </div>
</body>
</html>
