<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Booking</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; max-width:600px; margin:auto; }
    .form-group { margin-bottom:14px; }
    label { display:block; font-size:13px; margin-bottom:4px; }
    input, select { width:90%; padding:9px 11px; border-radius:8px; border:1px solid #D0D7DE;
                    background:#FAFBFC; font-size:13px; }
    .btn-submit { width:100%; padding:10px; border-radius:999px; border:none; font-size:14px;
                  font-weight:600; cursor:pointer; background:#3498DB; color:#fff; }
    .btn-submit:hover { background:#2980B9; }
    .error { background:#ffe6e6; border:1px solid #ffb3b3; padding:10px; border-radius:10px; margin-bottom:12px; }
</style>
</head>
<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>✏️ Edit Booking</h1>

        <div class="card">
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty booking}">
                <form action="${pageContext.request.contextPath}/admin/bookings/edit" method="post">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}">

                    <div class="form-group">
                        <label for="date">Date</label>
                        <!-- booking.bookingDate might be java.sql.Date in your model.
                             If your DB column is DATETIME, consider changing your entity to Timestamp.
                             For now, this expects the servlet to provide a formatted string if needed. -->
                        <input type="datetime-local" id="date" name="date"
                               value="${dateValue}" required>
                    </div>

                    <div class="form-group">
                        <label for="totalPrice">Total Price</label>
                        <input type="number" step="0.01" id="totalPrice" name="totalPrice"
                               value="${booking.totalPrice}" required>
                    </div>

                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" required>
                            <option value="PENDING"   <c:if test="${booking.status=='PENDING'}">selected</c:if>>PENDING</option>
                            <option value="CONFIRMED" <c:if test="${booking.status=='CONFIRMED'}">selected</c:if>>CONFIRMED</option>
                            <option value="COMPLETED" <c:if test="${booking.status=='COMPLETED'}">selected</c:if>>COMPLETED</option>
                            <option value="CANCELLED" <c:if test="${booking.status=='CANCELLED'}">selected</c:if>>CANCELLED</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="payment">Payment Status</label>
                        <select id="payment" name="payment" required>
                            <option value="UNPAID"    <c:if test="${booking.paymentStatus=='UNPAID'}">selected</c:if>>UNPAID</option>
                            <option value="PAID"      <c:if test="${booking.paymentStatus=='PAID'}">selected</c:if>>PAID</option>
                            <option value="REFUNDED"  <c:if test="${booking.paymentStatus=='REFUNDED'}">selected</c:if>>REFUNDED</option>
                            <option value="FAILED"    <c:if test="${booking.paymentStatus=='FAILED'}">selected</c:if>>FAILED</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-submit">Update Booking</button>
                </form>
            </c:if>
        </div>
    </div>
</body>
</html>
