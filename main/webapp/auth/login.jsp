<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Login page (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Read backend error message (set by servlet)
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Helping Home Care Services</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        /* ===== Global reset / base styles (same tone as Home page) ===== */
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background-color: #F7F9FB; /* light grey background */
            color: #2C3E50;
        }

        a {
            text-decoration: none;
        }

        /* ===== Full page layout for login ===== */
        .login-page {
            width: 100%;
            min-height: calc(100vh - 120px); /* leave some space for nav + footer */
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            box-sizing: border-box;
        }

        .login-wrapper {
            max-width: 420px;
            width: 100%;
        }

        /* ===== Optional title above card ===== */
        .login-header {
            text-align: center;
            margin-bottom: 16px;
        }

        .login-header h1 {
            font-size: 24px;
            margin: 0 0 6px;
            color: #1F2D3D;
        }

        .login-header p {
            margin: 0;
            font-size: 13px;
            color: #7F8C8D;
        }

        /* ===== Center login card ===== */
        .login-card {
            background-color: #FFFFFF;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
            padding: 26px 26px 24px;
            box-sizing: border-box;
        }

        .login-badge {
            display: inline-block;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 999px;
            background-color: #ECF0F1;
            color: #555;
            margin-bottom: 10px;
        }

        .login-title {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #1F2D3D;
        }

        .login-subtitle {
            font-size: 13px;
            color: #7F8C8D;
            margin-bottom: 18px;
        }

        /* ===== Form fields ===== */
        .login-form-group {
            margin-bottom: 14px;
        }

        .login-label {
            display: block;
            font-size: 13px;
            margin-bottom: 4px;
            color: #2C3E50;
        }

        .login-input {
            width: 100%;
            padding: 9px 11px;
            border-radius: 8px;
            border: 1px solid #D0D7DE;
            font-size: 13px;
            box-sizing: border-box;
            outline: none;
            background-color: #FAFBFC;
        }

        .login-input:focus {
            border-color: #2ECC71;
            box-shadow: 0 0 0 2px rgba(46, 204, 113, 0.20);
            background-color: #FFFFFF;
        }

        /* ===== Remember me + forgot password row ===== */
        .login-form-extra {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 12px;
            margin-top: 2px;
            margin-bottom: 14px;
        }

        .login-forgot a {
            color: #E67E22;
        }

        /* ===== Submit button ===== */
        .login-btn {
            width: 100%;
            padding: 10px 0;
            border-radius: 999px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background-color: #2ECC71;
            color: #FFFFFF;
            box-shadow: 0 6px 16px rgba(46, 204, 113, 0.4);
        }

        .login-btn:hover {
            background-color: #27AE60;
        }

        /* Centered login error */
        .login-error-box {
            margin-top: 14px;
            padding: 12px 14px;
            color: #C0392B;
            text-align: center;
            font-size: 15px;
            font-weight: 600;
        }

        .login-note {
            margin-top: 12px;
            font-size: 12px;
            color: #95A5A6;
        }

        .login-note a {
            color: #E67E22;
            font-weight: 600;
        }

        @media (max-width: 540px) {
            .login-card {
                padding: 22px 18px 18px;
            }

            .login-title {
                font-size: 20px;
            }

            .login-header h1 {
                font-size: 20px;
            }
        }
    </style>
</head>

<body>
    <%-- Global navigation bar include (relative from /auth/login.jsp) --%>
    <%@ include file="../webContent/navBar.jsp" %>

    <main class="login-page">
        <div class="login-wrapper">
            <div class="login-header">
                <h1>Welcome back to Helping</h1>
                <p>Please log in to manage your home care services.</p>
            </div>

            <div class="login-card">
                <h2 class="login-title">Sign in to your account</h2>
                <p class="login-subtitle">
                    Access your care plans, service bookings and family support records.
                </p>

                <%-- Login form now posts to servlet mapping "/login" --%>
                <form action="<%= request.getContextPath() %>/login" method="post">
                    <div class="login-form-group">
                        <label class="login-label" for="username">Username</label>
                        <input type="text" id="username" name="username"
                               class="login-input" required>
                    </div>

                    <div class="login-form-group">
                        <label class="login-label" for="password">Password</label>
                        <input type="password" id="password" name="password"
                               class="login-input" required>
                    </div>

                    <%-- Error message from servlet --%>
                    <% if (error != null && !error.isEmpty()) { %>
                        <div class="login-error-box"><%= error %></div>
                    <% } %>

                    <div class="login-form-extra">
                        <span class="login-forgot">
                            <a href="forgotPassword.jsp">Forgot password?</a>
                        </span>
                    </div>

                    <button type="submit" class="login-btn">Log in</button>

                    <p class="login-note">
                        New to Helping?
                        <a href="<%= request.getContextPath() %>/register">Create an account</a>
                        to start building a safer home care plan.
                    </p>
                </form>
            </div>
        </div>
    </main>

    <%-- Global footer include (relative from /auth/login.jsp) --%>
    <%@ include file="../webContent/footer.jsp" %>
</body>
</html>
