<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Service Details (View)
  ====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dbAccess.services.Service" %>

<%
    // 1) Get data prepared by ServicePageServlet
    Service svcDetail = (Service) request.getAttribute("svcDetail");
    String message = (String) request.getAttribute("message");

    // 2) Safety check: if servlet did not set svcDetail, show 500
    if (svcDetail == null) {
        response.sendError(500, "Service details not provided by controller.");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Details</title>

<style>
    body {
        margin: 0;
        padding: 0;
        background: #f5f5f5;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .page-container {
        flex: 1;
        max-width: 1100px;
        margin: 40px auto;
        padding: 0 20px 40px;
    }

    .service-card {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        display: flex;
        padding: 32px;
        gap: 32px;
        align-items: stretch;
        min-height: 420px;
    }

    .service-image-wrapper {
        flex: 0 0 250px;
        border-radius: 16px;
        overflow: hidden;
    }

    .service-image-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    .service-info {
        flex: 1;
        padding: 10px 10px 10px 20px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .service-title {
        font-size: 32px;
        font-weight: 700;
        margin: 0;
        color: #2C3E50;
    }

    .service-description {
        font-size: 16px;
        line-height: 1.7;
        color: #444;
        margin-top: 10px;
        margin-bottom: 20px;
        padding: 10px 20px 20px 40px;
        white-space: pre-line;
    }

    .service-price {
        font-size: 28px;
        font-weight: 700;
        color: #E67E22;
        margin-top: 10px;
        padding-left: 40px;
    }

    .add-cart-btn {
        background: #E67E22;
        color: #fff;
        padding: 12px 26px;
        font-size: 16px;
        border-radius: 999px;
        border: none;
        cursor: pointer;
        transition: 0.2s;
        margin-left: 40px;
    }

    .add-cart-btn:hover {
        background: #D35400;
    }

    .message {
        margin-top: 16px;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 14px;
        margin-left: 40px;
        max-width: 420px;
    }

    .success { background: #e9f7ef; color: #1e8449; }

    @media(max-width: 860px){
        .service-card { flex-direction: column; }
        .service-image-wrapper { flex: none; height: 260px; }
        .service-info { padding: 16px 10px; }
        .service-description,
        .service-price,
        .add-cart-btn,
        .message {
            padding-left: 0;
            margin-left: 0;
        }
    }
</style>
</head>

<body>

<%@ include file="webContent/navBar.jsp" %>

<div class="page-container">
    <div class="service-card">

        <!-- Left: image -->
        <div class="service-image-wrapper">
            <img src="<%= request.getContextPath() %>/public/service/<%= svcDetail.getImageUrl() %>"
                 alt="<%= svcDetail.getServiceName() %>">
        </div>

        <!-- Right: text and actions -->
        <div class="service-info">
            <div>
                <h1 class="service-title"><%= svcDetail.getServiceName() %></h1>

                <p class="service-description">
                    <%= svcDetail.getDescription() %>
                </p>

                <div class="service-price">
                    $<%= String.format("%.2f", svcDetail.getPrice()) %>
                </div>
            </div>

            <div>
                <!-- POST back to /service (Servlet) -->
                <form method="post" action="<%= request.getContextPath() %>/service">
                    <input type="hidden" name="serviceId" value="<%= svcDetail.getServiceId() %>">
                    <button class="add-cart-btn">Add to Cart</button>
                </form>

                <% if (message != null) { %>
                    <div class="message success"><%= message %></div>
                <% } %>
            </div>
        </div>

    </div>
</div>

<%@ include file="webContent/footer.jsp" %>
</body>
</html>
