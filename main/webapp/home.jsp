<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Home page (View)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        /* ===== Basic reset for this page only ===== */
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background-color: #F7F9FB;
            color: #2C3E50;
        }

        a {
            text-decoration: none;
        }

        /* ===== Fullscreen hero image section ===== */
        .hero-full {
            position: relative;
            width: 100%;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #FFFFFF;
            overflow: hidden;
        }

        /* Dark overlay on hero image */
        .hero-full::before {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(
                to bottom,
                rgba(0, 0, 0, 0.45),
                rgba(0, 0, 0, 0.55)
            );
            z-index: 1;
        }

        .hero-full img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center top;
            z-index: 0;
        }

        .hero-full-content {
            position: relative;
            z-index: 2;
            text-align: center;
            padding: 0 20px;
        }

        .hero-full-title {
            font-size: 38px;
            font-weight: 700;
            color: #2ECC71;
            text-shadow: 0 6px 18px rgba(0,0,0,0.45);
        }

        @media (max-width: 540px) {
            .hero-full-title {
                font-size: 26px;
            }
        }

        /* ===== Home page main container (below hero image) ===== */
        .home-main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 60px 40px;
        }

        .home-hero {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 30px;
            align-items: flex-start;
            margin-bottom: 40px;
        }

        .home-hero-text h1 {
            font-size: 28px;
            margin-bottom: 14px;
            color: #1F2D3D;
        }

        .home-hero-text p {
            font-size: 16px;
            line-height: 1.7;
            margin-bottom: 18px;
            color: #4A4A4A;
        }

        .home-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 16px;
        }

        .home-badge {
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 999px;
            background-color: #ECF0F1;
            color: #555;
        }

        .home-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 8px;
        }

        .btn-secondary {
            border-radius: 999px;
            border: 1px solid #BDC3C7;
            padding: 10px 20px;
            font-size: 14px;
            color: #2C3E50;
            background-color: #FFFFFF;
        }

        .btn-secondary:hover {
            background-color: #F2F4F6;
        }

        .home-note {
            margin-top: 12px;
            font-size: 13px;
            color: #7F8C8D;
        }

        .home-hero-card {
            background-color: #FFFFFF;
            border-radius: 16px;
            box-shadow: 0 12px 26px rgba(0,0,0,0.08);
            padding: 20px 22px;
        }

        .home-hero-card h3 {
            font-size: 18px;
            margin-bottom: 8px;
        }

        .home-hero-card p {
            font-size: 13px;
            margin-bottom: 10px;
            color: #555;
        }

        .home-list {
            list-style: none;
            font-size: 13px;
            color: #555;
            margin-bottom: 10px;
            padding-left: 0;
        }

        .home-list li {
            margin-bottom: 6px;
        }

        .home-list li::before {
            content: "• ";
            color: #E67E22;
        }

        .home-card-note {
            font-size: 12px;
            color: #95A5A6;
        }

        .home-section {
            margin-top: 20px;
        }

        .home-section-header {
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .home-section-title {
            font-size: 22px;
            font-weight: 600;
        }

        .home-section-subtitle {
            font-size: 13px;
            color: #7F8C8D;
        }

        .home-service-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
        }

        .home-service-card {
            background-color: #FFFFFF;
            border-radius: 12px;
            padding: 16px 14px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.04);
        }

        .home-service-card h4 {
            font-size: 15px;
            margin-bottom: 8px;
        }

        .home-service-card p {
            font-size: 13px;
            color: #666;
            line-height: 1.6;
        }

        .home-service-image {
            width: 100%;
            height: 120px;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 10px;
            background-color: #F2F4F6;
        }

        .home-service-image img {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
        }

        .home-info-strip {
            background-color: #ECF0F1;
            margin-top: 30px;
            padding: 14px 20px;
            text-align: center;
            font-size: 13px;
            color: #555;
            border-radius: 8px;
        }

        @media (max-width: 900px) {
            .home-hero {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .home-service-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 540px) {
            .home-main {
                padding: 40px 20px 30px;
            }

            .home-hero-text h1 {
                font-size: 22px;
            }

            .home-service-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <%-- Global navbar include (View only) --%>
    <%@ include file="webContent/navBar.jsp" %>

    <!-- Fullscreen hero image section -->
    <section class="hero-full">
        <img src="${pageContext.request.contextPath}/public/hero-image.jpg" alt="Helping hero image">
        <div class="hero-full-content">
            <h1 class="hero-full-title">Welcome to Helping Home Care Services</h1>
        </div>
    </section>

    <main class="home-main">
        <section class="home-hero">
            <div class="home-hero-text">
                <div class="home-badges">
                    <span class="home-badge">Home care support</span>
                    <span class="home-badge">For seniors & families</span>
                    <span class="home-badge">Safe · Professional · Warm</span>
                </div>

                <h1>Home care support for your loved ones</h1>
                <p>
                    Helping provides daily living assistance, health and medical support,
                    emotional care, and a safer home environment for seniors and families
                    who need continuous support.
                </p>

                <div class="home-actions">
                    <a href="<%=request.getContextPath()%>/categories" class="btn-secondary">View our services</a>
                </div>

                <p class="home-note">
                    No matter if it is daily living, medical needs, or emotional support,
                    we are here to walk with you and your loved ones at home.
                </p>
            </div>

            <div class="home-hero-card">
                <h3>Why choose Helping?</h3>
                <p>
                    We focus on practical, safe and warm care at home, suitable for seniors,
                    people after discharge, and busy families.
                </p>
                <ul class="home-list">
                    <li>One-stop daily living &amp; health care services</li>
                    <li>Respect dignity, privacy and emotional needs</li>
                    <li>Flexible schedules and customized care plans</li>
                </ul>
                <p class="home-card-note">
                    * Service details and pricing can be discussed and adjusted based on your actual situation.
                </p>
            </div>
        </section>

        <section class="home-section" id="services">
            <div class="home-section-header">
                <h2 class="home-section-title">Core Service Areas</h2>
                <p class="home-section-subtitle">
                    We cover four key dimensions of home care needs.
                </p>
            </div>

            <div class="home-service-grid">
                <div class="home-service-card">
                    <div class="home-service-image">
                        <img src="${pageContext.request.contextPath}/public/ADL.jpg" alt="Activities of Daily Living (ADL)">
                    </div>
                    <h4>Activities of Daily Living (ADL)</h4>
                    <p>
                        Assistance with bathing, dressing, grooming, toileting, feeding
                        and mobility to maintain independence in daily life.
                    </p>
                </div>

                <div class="home-service-card">
                    <div class="home-service-image">
                        <img src="${pageContext.request.contextPath}/public/Health and Medical Care.jpeg" alt="Health &amp; Medical Care">
                    </div>
                    <h4>Health &amp; Medical Care</h4>
                    <p>
                        Vital signs monitoring, nursing care, medication reminders and
                        rehabilitation support for better continuity after leaving hospital.
                    </p>
                </div>

                <div class="home-service-card">
                    <div class="home-service-image">
                        <img src="${pageContext.request.contextPath}/public/Mental and Emotional Care.png" alt="Mental &amp; Emotional Care">
                    </div>
                    <h4>Mental &amp; Emotional Care</h4>
                    <p>
                        Companionship, conversation, light activities and cognitive
                        exercises to reduce loneliness and keep the mind active.
                    </p>
                </div>

                <div class="home-service-card">
                    <div class="home-service-image">
                        <img src="${pageContext.request.contextPath}/public/Environment and Safety.jpeg" alt="Environment &amp; Safety">
                    </div>
                    <h4>Environment &amp; Safety</h4>
                    <p>
                        Home safety assessment, assistive equipment suggestions and
                        emergency response support to make home safer and more comfortable.
                    </p>
                </div>
            </div>
        </section>

        <div class="home-info-strip">
            Not sure which service is suitable? Contact us and we will help you find a matching care plan.
        </div>

    </main>

    <%-- Global footer include --%>
    <%@ include file="webContent/footer.jsp" %>

</body>
</html>
