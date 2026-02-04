<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>400 - Bad Request</title>

<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    .container {
        text-align: center;
        padding: 80px 20px;
        flex: 1;
    }

    h1 {
        font-size: 72px;
        margin-bottom: 10px;
        color: #E67E22;
        font-weight: 700;
    }

    p.subtitle {
        font-size: 20px;
        color: #555;
        margin-bottom: 30px;
    }

    .btn-group {
        display: flex;
        gap: 12px;
        justify-content: center;
        margin-top: 20px;
    }

    .btn {
        padding: 12px 24px;
        border-radius: 999px;
        font-size: 15px;
        border: none;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        transition: 0.2s ease;
    }

    .btn-primary {
        background-color: #E67E22;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #D35400;
        transform: translateY(-2px);
    }

    .btn-outline {
        background-color: #fff;
        color: #2C3E50;
        border: 1px solid #d0d7de;
    }

    .btn-outline:hover {
        background-color: #f0f0f0;
        transform: translateY(-2px);
    }

    .illustration {
        max-width: 380px;
        margin: 0 auto 30px;
    }

</style>
</head>
<body>

    <%@ include file="../webContent/navBar.jsp" %>

    <div class="container">
        <img src="https://cdn-icons-png.flaticon.com/512/565/565547.png"
             class="illustration"
             alt="400 Bad Request">

        <h1>400</h1>
        <p class="subtitle">The request was invalid or cannot be processed.</p>

        <div class="btn-group">
            <a href="<%= request.getContextPath() %>/" class="btn btn-primary">Back to Homepage</a>
            <a href="javascript:history.back()" class="btn btn-outline">Try Again</a>
        </div>
    </div>

    <%@ include file="../webContent/footer.jsp" %>

</body>
</html>