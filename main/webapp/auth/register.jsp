<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Register page (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Helping Home Care Services</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        /* ===== Global reset / base styles ===== */
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background-color: #F7F9FB;
            color: #2C3E50;
        }

        a { text-decoration: none; }

        /* ===== Full page layout ===== */
        .register-page {
            width: 100%;
            min-height: calc(100vh - 120px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            box-sizing: border-box;
        }

        .register-wrapper { max-width: 450px; width: 100%; }

        /* ===== Header ===== */
        .register-header { text-align: center; margin-bottom: 16px; }

        .register-header h1 {
            font-size: 24px;
            margin: 0 0 6px;
            color: #1F2D3D;
        }

        .register-header p {
            margin: 0;
            font-size: 13px;
            color: #7F8C8D;
        }

        /* ===== Card ===== */
        .register-card {
            background-color: #FFFFFF;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
            padding: 26px;
            box-sizing: border-box;
        }

        .register-title {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #1F2D3D;
        }

        .register-subtitle {
            font-size: 13px;
            color: #7F8C8D;
            margin-bottom: 18px;
        }

        /* ===== Form fields ===== */
        .register-form-group { margin-bottom: 14px; }

        .register-label {
            display: block;
            font-size: 13px;
            margin-bottom: 4px;
            color: #2C3E50;
        }

        .register-input {
            width: 100%;
            padding: 9px 11px;
            border-radius: 8px;
            border: 1px solid #D0D7DE;
            background-color: #FAFBFC;
            box-sizing: border-box;
            font-size: 13px;
            outline: none;
        }

        .register-input:focus {
            border-color: #2ECC71;
            box-shadow: 0 0 0 2px rgba(46, 204, 113, 0.20);
            background-color: #FFFFFF;
        }

        /* ===== Button ===== */
        .register-btn {
            width: 100%;
            padding: 10px 0;
            border-radius: 999px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background-color: #2ECC71;
            color: white;
            box-shadow: 0 6px 16px rgba(46, 204, 113, 0.4);
        }

        .register-btn:hover { background-color: #27AE60; }

        /* ===== Error box ===== */
        .register-error-box {
            margin-top: 14px;
            padding: 12px 14px;
            color: #C0392B;
            text-align: center;
            font-size: 15px;
            font-weight: 600;
        }

        .register-note {
            margin-top: 12px;
            font-size: 12px;
            color: #95A5A6;
        }

        .register-note a {
            color: #E67E22;
            font-weight: 600;
        }

        @media (max-width: 540px) {
            .register-card { padding: 22px 18px; }
            .register-title { font-size: 20px; }
        }
    </style>
</head>

<body>

    <%@ include file="../webContent/navBar.jsp" %>

    <main class="register-page">
        <div class="register-wrapper">

            <div class="register-header">
                <h1>Create Your Helping Account</h1>
                <p>Start managing your home care services today.</p>
            </div>

            <div class="register-card">
                <h2 class="register-title">Register</h2>
                <p class="register-subtitle">Fill in your details to create an account.</p>

                <%-- Post to RegisterServlet --%>
                <form action="<%=request.getContextPath()%>/register" method="post">
                    <div class="register-form-group">
                        <label class="register-label" for="username">Username</label>
                        <input type="text" id="username" name="username"
                               class="register-input" required>
                    </div>

                    <div class="register-form-group">
                        <label class="register-label" for="email">Email</label>
                        <input type="email" id="email" name="email"
                               class="register-input" required>
                    </div>

                    <div class="register-form-group">
                        <label class="register-label" for="password">Password</label>
                        <input type="password" id="password" name="password"
                               class="register-input" required>
                    </div>

                    <div class="register-form-group">
                        <label class="register-label" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               class="register-input" required>
                    </div>

                    <% if (error != null && !error.isEmpty()) { %>
                        <div class="register-error-box"><%= error %></div>
                    <% } %>

                    <button type="submit" class="register-btn">Create Account</button>

                    <p class="register-note">
                        Already have an account?
                        <a href="<%= request.getContextPath() %>/login">Log in here</a>.
                    </p>
                </form>
            </div>
        </div>
    </main>

    <%@ include file="../webContent/footer.jsp" %>
</body>
</html>
