<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Cart page (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="dbAccess.booking.BookingDetail" %>
<%@ page import="dbAccess.services.Service" %>

<%
    // Data prepared by CartServlet
    String message = (String) request.getAttribute("message");
    String error   = (String) request.getAttribute("error");

    List<BookingDetail> cartItems = (List<BookingDetail>) request.getAttribute("cartItems");

    Double totalAmountObj = (Double) request.getAttribute("totalAmount");
    double totalAmount = (totalAmountObj == null) ? 0.0 : totalAmountObj;

    Map<Integer, Service> serviceMap = (Map<Integer, Service>) request.getAttribute("serviceMap");
    if (serviceMap == null) {
        serviceMap = new HashMap<>();
    }

    // Pending booking info prepared by CartServlet
    Boolean hasPendingBookingObj = (Boolean) request.getAttribute("hasPendingBooking");
    boolean hasPendingBooking = (hasPendingBookingObj != null && hasPendingBookingObj);

    Integer pendingBookingId = (Integer) request.getAttribute("pendingBookingId");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cart</title>
<style>
    /* (No style changes) */
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 0;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    .page-container {
        width: 100%;
        max-width: 1200px;
        margin: 40px auto 24px;
        padding: 0 16px 24px;
        flex: 1;
    }
    h1 { font-size: 26px; margin-bottom: 20px; color: #2C3E50; }
    .message { margin-bottom: 16px; padding: 10px 14px; border-radius: 6px; font-size: 13px; }
    .message.success { background-color: #e9f7ef; color: #1e8449; border: 1px solid #a9dfbf; }
    .message.error { background-color: #fbeeee; color: #c0392b; border: 1px solid #f5b7b1; }
    table.cart-table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
    }
    table.cart-table th, table.cart-table td {
        padding: 12px 14px;
        font-size: 14px;
        text-align: left;
        border-bottom: 1px solid #ecf0f1;
    }
    table.cart-table th { background-color: #f8f9fa; font-weight: 600; color: #2C3E50; }
    table.cart-table tr:last-child td { border-bottom: none; }
    .cart-index { width: 60px; color: #7f8c8d; }
    .cart-title { font-weight: 500; color: #2C3E50; }
    .cart-price, .cart-subtotal { white-space: nowrap; }
    .cart-empty {
        background-color: #fff;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        text-align: center;
        color: #7f8c8d;
    }
    .cart-actions {
        margin-top: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
    }
    .cart-total { font-size: 16px; font-weight: 600; color: #2C3E50; }
    .btn {
        border: none;
        border-radius: 999px;
        padding: 8px 18px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.2s ease, transform 0.1s ease;
        text-decoration: none;
        display: inline-block;
    }
    .btn-delete { background-color: #e74c3c; color: #fff; }
    .btn-delete:hover { background-color: #c0392b; transform: translateY(-1px); }
    .btn-secondary { background-color: #ecf0f1; color: #2C3E50; }
    .btn-secondary:hover { background-color: #d0d7de; transform: translateY(-1px); }
    .btn-primary { background-color: #E67E22; color: #fff; }
    .btn-primary:hover { background-color: #D35400; transform: translateY(-1px); }
</style>
</head>
<body>

    <%-- Include global navbar --%>
    <%@ include file="webContent/navBar.jsp" %>

    <div class="page-container">
        <h1>My Cart</h1>

        <% if (message != null) { %>
            <div class="message success"><%= message %></div>
        <% } %>

        <% if (error != null) { %>
            <div class="message error"><%= error %></div>
        <% } %>

        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <div class="cart-empty">
                Your cart is currently empty.
                <br><br>
                <a href="<%= request.getContextPath() %>/category" class="btn btn-primary">
                    Add services to cart
                </a>
            </div>
        <% } else { %>

        <%-- Post to CartServlet --%>
        <form method="post" action="<%= request.getContextPath() %>/cart">

            <table class="cart-table">
                <thead>
                    <tr>
                        <th style="width: 40px;"><input type="checkbox" id="selectAll"></th>
                        <th class="cart-index">#</th>
                        <th>Item</th>
                        <th class="cart-price">Price</th>
                        <th class="cart-subtotal">Subtotal</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        int index = 1;
                        for (BookingDetail item : cartItems) {
                            int detailId = item.getBookingDetailId();
                            int svcId = item.getServiceId();

                            Service svc = serviceMap.get(svcId);

                            String title = (svc != null) ? svc.getServiceName() : ("Service #" + svcId);
                            double unitPrice = (svc != null) ? svc.getPrice() : item.getSubtotal();
                            double subtotal = item.getSubtotal();
                    %>
                    <tr>
                        <td>
                            <input type="checkbox" name="selectedIds" value="<%= detailId %>">
                        </td>
                        <td class="cart-index"><%= index %>.</td>
                        <td class="cart-title"><%= title %></td>
                        <td class="cart-price">$<%= String.format("%.2f", unitPrice) %></td>
                        <td class="cart-subtotal">$<%= String.format("%.2f", subtotal) %></td>
                    </tr>
                    <%
                            index++;
                        }
                    %>
                </tbody>
            </table>

            <div class="cart-actions">
                <button type="submit" name="action" value="delete" class="btn btn-delete">
                    Remove selected items
                </button>

                <div class="cart-total">
                    Total: $<%= String.format("%.2f", totalAmount) %>
                </div>
            </div>

            <div class="cart-actions" style="margin-top: 12px;">
                <a href="<%= request.getContextPath() %>/category" class="btn btn-secondary">
                    Add more to cart
                </a>

                <%-- If a pending booking exists, continue editing it instead of starting a new booking --%>
                <% if (hasPendingBooking && pendingBookingId != null) { %>
                    <a href="<%= request.getContextPath() %>/booking?draftBookingId=<%= pendingBookingId %>"
                       class="btn btn-primary">
                        Continue editing your previous booking
                    </a>
                <% } else { %>
                    <button type="submit" name="action" value="book" class="btn btn-primary">
                        Book selected
                    </button>
                <% } %>
            </div>
        </form>

        <% } %>
    </div>

    <%@ include file="webContent/footer.jsp" %>

    <script>
        // "Select all" checkbox logic
        const selectAll = document.getElementById('selectAll');
        if (selectAll) {
            selectAll.addEventListener('change', () => {
                const boxes = document.querySelectorAll('input[name="selectedIds"]');
                boxes.forEach(cb => cb.checked = selectAll.checked);
            });
        }
    </script>

</body>
</html>
