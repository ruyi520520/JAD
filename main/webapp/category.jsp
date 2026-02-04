<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Browse Services (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dbAccess.services.Service" %>

<%
    // Data prepared by CategoryServlet
    List<Service> adlList = (List<Service>) request.getAttribute("adlList");
    List<Service> healthList = (List<Service>) request.getAttribute("healthList");
    List<Service> mentalList = (List<Service>) request.getAttribute("mentalList");
    List<Service> safetyList = (List<Service>) request.getAttribute("safetyList");

    // Safe fallback to avoid NullPointerException in View
    if (adlList == null) adlList = new ArrayList<>();
    if (healthList == null) healthList = new ArrayList<>();
    if (mentalList == null) mentalList = new ArrayList<>();
    if (safetyList == null) safetyList = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Services by Category</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background-color: #F7F9FB;
            color: #2C3E50;
        }

        a { text-decoration: none; color: inherit; }

        .page-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px 60px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .page-subtitle {
            font-size: 14px;
            color: #7F8C8D;
            max-width: 520px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
            margin-top: 24px;
        }

        @media (max-width: 768px) {
            .category-grid { grid-template-columns: 1fr; }
        }

        .category-card {
            background-color: #FFFFFF;
            border-radius: 16px;
            box-shadow: 0 10px 26px rgba(0,0,0,0.06);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .category-image {
            width: 100%;
            height: 190px;
            overflow: hidden;
            background-color: #ECEFF1;
        }

        .category-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .category-body {
            padding: 16px 18px 14px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .category-title {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
        }

        .category-desc {
            font-size: 13px;
            color: #7F8C8D;
            line-height: 1.6;
        }

        .service-list {
            list-style: none;
            padding-left: 0;
            margin: 10px 0 0;
        }

        .service-list li {
            font-size: 13px;
            margin-bottom: 4px;
        }

        .service-link {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 0;
            color: #2C3E50;
        }

        .service-link span.bullet {
            width: 4px;
            height: 4px;
            border-radius: 50%;
            background-color: #E67E22;
        }

        .service-link:hover { color: #E67E22; }

        .category-footer-note {
            font-size: 12px;
            color: #95A5A6;
            margin-top: 4px;
        }

        .page-actions {
            margin-top: 28px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
        }

        .btn-ghost {
            border-radius: 999px;
            padding: 10px 22px;
            font-size: 13px;
            border: 1px solid #D0D7DE;
            background-color: #FFFFFF;
            color: #2C3E50;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-ghost:hover { background-color: #F3F4F6; }

        .page-foot-note {
            margin-top: 18px;
            text-align: center;
            font-size: 12px;
            color: #95A5A6;
        }
    </style>
</head>
<body>

    <%-- Global navbar include --%>
    <%@ include file="webContent/navBar.jsp" %>

    <div class="page-wrapper">
        <header class="page-header">
            <h1 class="page-title">Browse services by category</h1>
            <p class="page-subtitle">
                We group our home care services into four key areas so you can quickly
                find the type of support your loved one needs.
            </p>
        </header>

        <section class="category-grid">

            <!-- 1) Activities of Daily Living (ADL) -->
            <article class="category-card">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/public/ADL.jpg"
                         alt="Activities of Daily Living (ADL)">
                </div>
                <div class="category-body">
                    <h2 class="category-title">Activities of Daily Living (ADL)</h2>
                    <p class="category-desc">
                        Support with bathing, dressing, toileting, feeding and mobility to help maintain
                        independence and dignity in everyday life.
                    </p>

                    <ul class="service-list">
                        <% for (Service s : adlList) { %>
                            <li>
                                <a class="service-link"
                                   href="<%= request.getContextPath() %>/service?serviceId=<%= s.getServiceId() %>">
                                    <span class="bullet"></span>
                                    <%= s.getServiceName() %>
                                </a>
                            </li>
                        <% } %>
                        <% if (adlList.isEmpty()) { %>
                            <li class="category-footer-note">No services available right now.</li>
                        <% } %>
                    </ul>
                </div>
            </article>

            <!-- 2) Health & Medical Care -->
            <article class="category-card">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/public/Health and Medical Care.jpeg"
                         alt="Health & Medical Care">
                </div>
                <div class="category-body">
                    <h2 class="category-title">Health &amp; Medical Care</h2>
                    <p class="category-desc">
                        Nursing care, medication reminders and monitoring after discharge to make
                        recovery at home safer and more comfortable.
                    </p>

                    <ul class="service-list">
                        <% for (Service s : healthList) { %>
                            <li>
                                <a class="service-link"
                                   href="<%= request.getContextPath() %>/service?serviceId=<%= s.getServiceId() %>">
                                    <span class="bullet"></span>
                                    <%= s.getServiceName() %>
                                </a>
                            </li>
                        <% } %>
                        <% if (healthList.isEmpty()) { %>
                            <li class="category-footer-note">No services available right now.</li>
                        <% } %>
                    </ul>
                </div>
            </article>

            <!-- 3) Mental & Emotional Care -->
            <article class="category-card">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/public/Mental and Emotional Care.png"
                         alt="Mental & Emotional Care">
                </div>
                <div class="category-body">
                    <h2 class="category-title">Mental &amp; Emotional Care</h2>
                    <p class="category-desc">
                        Companionship, conversation and light activities to reduce loneliness and
                        keep the mind active and engaged.
                    </p>

                    <ul class="service-list">
                        <% for (Service s : mentalList) { %>
                            <li>
                                <a class="service-link"
                                   href="<%= request.getContextPath() %>/service?serviceId=<%= s.getServiceId() %>">
                                    <span class="bullet"></span>
                                    <%= s.getServiceName() %>
                                </a>
                            </li>
                        <% } %>
                        <% if (mentalList.isEmpty()) { %>
                            <li class="category-footer-note">No services available right now.</li>
                        <% } %>
                    </ul>
                </div>
            </article>

            <!-- 4) Environment & Safety -->
            <article class="category-card">
                <div class="category-image">
                    <img src="${pageContext.request.contextPath}/public/Environment and Safety.jpeg"
                         alt="Environment & Safety">
                </div>
                <div class="category-body">
                    <h2 class="category-title">Environment &amp; Safety</h2>
                    <p class="category-desc">
                        Home safety checks, assistive equipment suggestions and support so that
                        living at home stays safe and worry-free.
                    </p>

                    <ul class="service-list">
                        <% for (Service s : safetyList) { %>
                            <li>
                                <a class="service-link"
                                   href="<%= request.getContextPath() %>/service?serviceId=<%= s.getServiceId() %>">
                                    <span class="bullet"></span>
                                    <%= s.getServiceName() %>
                                </a>
                            </li>
                        <% } %>
                        <% if (safetyList.isEmpty()) { %>
                            <li class="category-footer-note">No services available right now.</li>
                        <% } %>
                    </ul>
                </div>
            </article>

        </section>

        <div class="page-actions">
            <a href="<%= request.getContextPath() %>/home" class="btn-ghost">
                ← Back to home
            </a>
        </div>

        <p class="page-foot-note">
            Not sure which category fits? You can always start a conversation with us and we’ll walk through your needs together.
        </p>
    </div>

    <%@ include file="webContent/footer.jsp" %>
</body>
</html>
