<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Global Navigation Bar (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="dbAccess.services.Service" %>

<%
    /*
     * Read login information from session.
     */
    String username = (String) session.getAttribute("sessUsername");

    /*
     * Read navbar dropdown data prepared by NavbarDataFilter.
     * Type: Map<CategoryName, List<Service>>
     */
    Map<String, List<Service>> categoryServices =
            (Map<String, List<Service>>) request.getAttribute("categoryServices");

    /*
     * Safety fallback:
     * If filter did not run or DB failed, ensure navbar does not crash.
     */
    if (categoryServices == null) {
        categoryServices = new LinkedHashMap<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Helping Navbar</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
/* ==== Reset basic styles ==== */
* { margin: 0; padding: 0; box-sizing: border-box; }

body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif; }

/* ==== Color variables ==== */
:root {
    --nav-bg: #2C3E50;
    --nav-bg-hover: #34495E;
    --accent: #E67E22;
    --accent-hover: #D35400;
    --text-light: #FFFFFF;
    --dropdown-bg: #FFFFFF;
    --dropdown-border: #E0E0E0;
    --text-dark: #2C3E50;
}

/* ==== Navbar wrapper ==== */
.navbar-wrapper {
    position: sticky;
    top: 0;
    z-index: 999;
    background-color: var(--nav-bg);
}

/* ==== Main navbar container ==== */
.navbar {
    max-width: 1200px;
    margin: 0 auto;
    padding: 10px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

/* Left side: logo only */
.navbar-left { display: flex; align-items: center; }

/* Right side: hamburger + menu + login/avatar */
.navbar-right {
    display: flex;
    align-items: center;
    gap: 16px;
}

/* Logo style */
.logo {
    color: var(--text-light);
    font-size: 24px;
    font-weight: 700;
    text-decoration: none;
    letter-spacing: 0.03em;
}
.logo span { color: var(--accent); }

/* Menu (desktop) */
.menu {
    display: flex;
    align-items: center;
    gap: 20px;
    position: relative;
}

.menu a {
    color: var(--text-light);
    text-decoration: none;
    padding: 8px 12px;
    font-size: 14px;
    border-radius: 4px;
    transition: background-color 0.25s ease;
}

.menu a:hover { background-color: var(--nav-bg-hover); }

/* Dropdown wrapper */
.dropdown { position: relative; }

/* Dropdown arrow icon */
.dropdown > a::after {
    content: '';
    border: 4px solid transparent;
    border-top-color: var(--text-light);
    margin-top: 2px;
}

/* Mega dropdown container */
.dropdown-content {
    display: none;
    position: absolute;
    top: 110%;
    right: 0;
    background-color: var(--dropdown-bg);
    color: var(--text-dark);
    min-width: 360px;
    border: 1px solid var(--dropdown-border);
    border-radius: 6px;
    padding: 14px 16px;
    z-index: 100;
    box-shadow: 0 10px 24px rgba(0,0,0,0.15);
}

/* Show dropdown on hover (desktop) */
.dropdown:hover .dropdown-content {
    display: flex;
    gap: 24px;
    justify-content: space-between;
}

/* Dropdown category section */
.dropdown-content .category { flex: 1; min-width: 160px; }

.dropdown-content h4 {
    margin-bottom: 6px;
    font-size: 15px;
    font-weight: 600;
}

/* Dropdown item list */
.dropdown-content ul { list-style: none; }

.dropdown-content ul li {
    margin-bottom: 5px;
    font-size: 13px;
    line-height: 1.4;
    color: #555;
}

.dropdown-content ul li a {
    text-decoration: none;
    color: #555;
    display: block;
    padding: 3px 0;
}

.dropdown-content ul li a:hover { color: var(--accent); }

/* Login button */
.login-btn {
    background-color: var(--accent);
    color: var(--text-light);
    padding: 8px 16px;
    border-radius: 999px;
    text-decoration: none;
    white-space: nowrap;
    transition: background-color 0.25s ease, transform 0.1s ease;
}

.login-btn:hover {
    background-color: var(--accent-hover);
    transform: translateY(-1px);
}

/* ==== User avatar dropdown (logged in) ==== */
.user-menu { position: relative; }

.user-avatar {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    border: 2px solid var(--accent);
    background-color: var(--nav-bg-hover);
    color: var(--text-light);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    padding: 0;
    outline: none;
    font-size: 18px;
}

/* ✅ 你原本缺的：user-dropdown 容器 */
.user-dropdown {
    display: none;
    position: absolute;
    top: 115%;
    right: 0;
    background-color: var(--dropdown-bg);
    border: 1px solid var(--dropdown-border);
    border-radius: 6px;
    min-width: 180px;
    box-shadow: 0 10px 24px rgba(0,0,0,0.15);
    padding: 6px 0;
    z-index: 200;
}

.user-menu.open .user-dropdown { display: block; }

/* Dropdown items */
.user-dropdown-item {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 12px;
    font-size: 14px;
    color: var(--text-dark);
    text-decoration: none;
    background: transparent;
    border: none;
    cursor: pointer;
    text-align: left;
}

.user-dropdown-item .item-icon { font-size: 16px; }

.user-dropdown-item:hover { background-color: #F4F6F7; }

.user-dropdown-item.user-logout { color: #C0392B; }

/* Remove default margin in form */
.user-dropdown form { margin: 0; }

/* ==== Mobile hamburger button ==== */
.menu-toggle {
    display: none;
    width: 32px;
    height: 32px;
    flex-direction: column;
    justify-content: center;
    gap: 4px;
    background: transparent;
    border: none;
    cursor: pointer;
}

.menu-toggle span {
    height: 2px;
    background-color: var(--text-light);
    border-radius: 1px;
    transition: transform 0.25s ease, opacity 0.25s ease;
}

/* ==== Responsive layout (≤768px) ==== */
@media (max-width: 768px) {
    .menu-toggle { display: flex; }

    .menu {
        position: absolute;
        top: 56px;
        left: 0;
        right: 0;
        flex-direction: column;
        background-color: var(--nav-bg);
        padding: 12px 16px;
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s ease;
    }

    .menu.open { max-height: 600px; }

    /* Dropdown changes to expansion list on mobile */
    .dropdown-content {
        position: static;
        display: none;
        box-shadow: none;
        border: none;
        padding: 8px 0;
        flex-direction: column;
        min-width: auto;
    }

    .dropdown.open .dropdown-content { display: flex; }
}

/* Hamburger animation */
.menu-toggle.active span:nth-child(1) { transform: translateY(6px) rotate(45deg); }
.menu-toggle.active span:nth-child(2) { opacity: 0; }
.menu-toggle.active span:nth-child(3) { transform: translateY(-6px) rotate(-45deg); }
</style>

</head>

<body>

<div class="navbar-wrapper">
    <nav class="navbar">

        <!-- Left: Logo -->
        <div class="navbar-left">
            <a href="<%= request.getContextPath() %>/home" class="logo">
                Helping<span>.</span>
            </a>
        </div>

        <!-- Right: Menu + User -->
        <div class="navbar-right">
        
		<button class="menu-toggle" id="menuToggle">
		    <span></span><span></span><span></span>
		</button>

            <!-- Main menu -->
            <div class="menu" id="mainMenu">

                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%=request.getContextPath()%>/feedback">Feedback</a>

                <!-- Services dropdown -->
                <div class="dropdown" id="servicesDropdown">
                    <a href="javascript:void(0);">Services</a>

                    <div class="dropdown-content">
                        <% for (Map.Entry<String, List<Service>> entry : categoryServices.entrySet()) { %>
                            <div class="category">
                                <h4><%= entry.getKey() %></h4>
                                <ul>
                                    <% for (Service s : entry.getValue()) { %>
                                        <li>
                                            <a href="<%= request.getContextPath() %>/service?serviceId=<%= s.getServiceId() %>">
                                                <%= s.getServiceName() %>
                                            </a>
                                        </li>
                                    <% } %>
                                </ul>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Login / User avatar -->
            <% if (username != null) { %>
                <!-- Logged-in user -->
                <div class="user-menu">
				    <div class="user-avatar">👤</div>
				    <div class="user-dropdown">
				
				        <!-- Profile -->
				        <a href="<%= request.getContextPath() %>/profile" class="user-dropdown-item">
				            <span class="item-icon">⚙️</span>
				            Profile
				        </a>
				
				        <!-- Care History -->
				        <a href="<%= request.getContextPath() %>/care-history" class="user-dropdown-item">
				            <span class="item-icon">📅</span>
				            Care History
				        </a>
				
				        <!-- Cart -->
				        <a href="<%= request.getContextPath() %>/cart" class="user-dropdown-item">
				            <span class="item-icon">🛒</span>
				            Cart
				        </a>
				
				        <!-- Logout -->
				        <form action="<%= request.getContextPath() %>/auth/logout.jsp" method="post">
				            <button type="submit" class="user-dropdown-item user-logout">
				                <span class="item-icon" style="color: red">➜]</span>
				                <span>Logout</span>
				            </button>
				        </form>
				
				    </d	iv>
				</div>

            <% } else { %>
                <!-- Guest -->
                <a href="<%= request.getContextPath() %>/login" class="login-btn">Login</a>
            <% } %>

        </div>
    </nav>
</div>

<script>
    // Toggle user dropdown
    const userMenu = document.querySelector('.user-menu');
    const avatar = document.querySelector('.user-avatar');

    if (userMenu && avatar) {
        avatar.addEventListener('click', (e) => {
            e.stopPropagation();
            userMenu.classList.toggle('open');
        });

        document.addEventListener('click', () => {
            userMenu.classList.remove('open');
        });
    }
</script>

</body>
</html>
