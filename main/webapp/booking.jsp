<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Booking page (View only)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>

<%@ page import="java.util.*" %>
<%@ page import="dbAccess.booking.BookingDetail" %>
<%@ page import="dbAccess.services.Service" %>

<%
    // Data prepared by BookingServlet
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    Integer draftBookingId = (Integer) request.getAttribute("draftBookingId");

    List<BookingDetail> cartItems = (List<BookingDetail>) request.getAttribute("cartItems");
    Float totalPriceObj = (Float) request.getAttribute("totalPrice");
    float totalPrice = (totalPriceObj == null) ? 0f : totalPriceObj;

    Map<Integer, Service> serviceMap = (Map<Integer, Service>) request.getAttribute("serviceMap");
    if (serviceMap == null) {
        serviceMap = new HashMap<>();
    }
%>
<%
    /*
     * Existing booking date prepared by BookingServlet.
     * This value is used to pre-fill the date input when editing a draft.
     */
    Date existingBookingDate = (Date) request.getAttribute("existingBookingDate");
    String existingBookingDateStr = (existingBookingDate != null) ? existingBookingDate.toString() : "";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking</title>
<style>
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
        margin: 40px auto;
        padding: 0 16px 40px;
        flex: 1;
    }

    h1 {
        font-size: 26px;
        margin-bottom: 20px;
        color: #2C3E50;
    }

    .message {
        margin-bottom: 16px;
        padding: 10px 14px;
        border-radius: 6px;
        font-size: 13px;
    }

    .message.success {
        background-color: #e9f7ef;
        color: #1e8449;
        border: 1px solid #a9dfbf;
    }

    .message.error {
        background-color: #fbeeee;
        color: #c0392b;
        border: 1px solid #f5b7b1;
    }

    .booking-form-card {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        padding: 20px 24px;
        margin-bottom: 24px;
    }

    .form-row {
        display: flex;
        gap: 16px;
        margin-bottom: 12px;
        flex-wrap: wrap;
    }

    .form-field {
        flex: 1;
        min-width: 200px;
    }

    .form-field label {
        display: block;
        font-size: 13px;
        margin-bottom: 4px;
        color: #555;
    }

    .form-field input[type="date"] {
        width: 100%;
        padding: 8px 10px;
        border-radius: 6px;
        border: 1px solid #ccc;
        font-size: 14px;
        box-sizing: border-box;
    }

    .form-actions {
        display: flex;
        gap: 12px;
        margin-top: 16px;
        flex-wrap: wrap;
        align-items: center;
    }

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

    .btn-secondary {
        background-color: #ecf0f1;
        color: #2C3E50;
    }

    .btn-secondary:hover {
        background-color: #d0d7de;
        transform: translateY(-1px);
    }

    .btn-primary {
        background-color: #E67E22;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #D35400;
        transform: translateY(-1px);
    }

    .btn-outline {
        background-color: #fff;
        color: #2C3E50;
        border: 1px solid #d0d7de;
    }

    .btn-outline:hover {
        background-color: #f0f0f0;
        transform: translateY(-1px);
    }

    table.cart-table {
        width: 100%;
        border-collapse: collapse;
        background-color: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
    }

    table.cart-table th,
    table.cart-table td {
        padding: 12px 14px;
        font-size: 14px;
        text-align: left;
        border-bottom: 1px solid #ecf0f1;
    }

    table.cart-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #2C3E50;
    }

    table.cart-table tr:last-child td {
        border-bottom: none;
    }

    .cart-index { width: 60px; color: #7f8c8d; }
    .cart-title { font-weight: 500; color: #2C3E50; }
    .cart-price, .cart-subtotal { white-space: nowrap; }

    .cart-total-row {
        font-weight: 600;
        background-color: #fcfcfc;
    }

    .cart-empty {
        background-color: #fff;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        text-align: center;
        color: #7f8c8d;
    }
</style>
</head>
<body>

    <%-- Include global navbar --%>
    <%@ include file="webContent/navBar.jsp" %>

    <div class="page-container">
        <h1>Booking</h1>

        <% if (message != null) { %>
            <div class="message success"><%= message %></div>
        <% } %>

        <% if (error != null) { %>
            <div class="message error"><%= error %></div>
        <% } %>

        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <div class="cart-empty">
                You don't have any selected services to book.
                <br><br>
                <a href="<%= request.getContextPath() %>/cart" class="btn btn-primary">
                    Back to cart
                </a>
            </div>
        <% } else { %>

        <%-- Post to BookingServlet --%>
        <form method="post" action="<%= request.getContextPath() %>/booking">

            <%-- Preserve draftBookingId if editing a pending booking --%>
            <input type="hidden" name="draftBookingId"
                   value="<%= (draftBookingId != null ? draftBookingId : "") %>">

            <div class="booking-form-card">
                <div class="form-row">
                    <div class="form-field">
                        <label for="bookingDate">Booking date</label>
                        <input type="date" id="bookingDate" name="bookingDate" value="<%= existingBookingDateStr %>">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" name="action" value="draft" class="btn btn-outline">
                        Save as draft
                    </button>

                    <button type="submit" name="action" value="payment" class="btn btn-primary">
                        Proceed to payment
                    </button>

                    <button type="submit" name="action" value="cancel" class="btn btn-secondary">
                        Cancel and back to cart
                    </button>
                </div>
            </div>

            <table class="cart-table">
                <thead>
                    <tr>
                        <th class="cart-index">#</th>
                        <th>Service</th>
                        <th class="cart-price">Price</th>
                        <th class="cart-subtotal">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int index = 1;
                        for (BookingDetail item : cartItems) {
                            int svcId = item.getServiceId();
                            Service svc = serviceMap.get(svcId);

                            String title = (svc != null) ? svc.getServiceName() : ("Service #" + svcId);
                            double unitPrice = (svc != null) ? svc.getPrice() : item.getSubtotal();
                            double rowSubtotal = item.getSubtotal();
                    %>
                    <tr>
                        <td class="cart-index"><%= index %>.</td>
                        <td class="cart-title"><%= title %></td>
                        <td class="cart-price">$<%= String.format("%.2f", unitPrice) %></td>
                        <td class="cart-subtotal">$<%= String.format("%.2f", rowSubtotal) %></td>
                    </tr>
                    <%
                            index++;
                        }
                    %>
                    <tr class="cart-total-row">
                        <td colspan="3" style="text-align: right;">Total:</td>
                        <td class="cart-subtotal">$<%= String.format("%.2f", totalPrice) %></td>
                    </tr>
                </tbody>
            </table>
        </form>

        <% } %>
    </div>

    <%@ include file="webContent/footer.jsp" %>
</body>
</html>
