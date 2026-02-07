<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Bookings</title>
<style>
    body { margin:0; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,sans-serif;
           background-color:#F7F9FB; color:#2C3E50; display:flex; }
    .main { flex:1; padding:30px; }
    .card { background:#fff; border-radius:18px; box-shadow:0 12px 30px rgba(0,0,0,0.08);
            padding:20px; margin-bottom:20px; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { padding:12px; text-align:left; border-bottom:1px solid #D0D7DE; }
    th { background:#FAFBFC; font-weight:600; }
    .btn { padding:6px 12px; border-radius:8px; border:none; cursor:pointer;
           font-size:13px; font-weight:600; text-decoration:none; margin-right:6px; display:inline-block; }
    .btn-edit { background:#3498DB; color:#fff; }
    .btn-delete { background:#C0392B; color:#fff; }
    .btn:hover { opacity:0.9; }
    .status { font-weight:600; }
    .status.PENDING { color:#F39C12; }
    .status.CONFIRMED { color:#27AE60; }
    .status.COMPLETED { color:#2980B9; }
    .status.CANCELLED { color:#C0392B; }
    .payment.UNPAID { color:#C0392B; font-weight:600; }
    .payment.PAID { color:#27AE60; font-weight:600; }
    .payment.REFUNDED { color:#2980B9; font-weight:600; }
    .payment.FAILED { color:#C0392B; font-weight:600; }
    .pagination { margin-top:20px; text-align:center; }
    .pagination a { display:inline-block; margin:0 5px; padding:8px 12px; border-radius:6px;
                    background:#2ECC71; color:#fff; text-decoration:none; font-weight:600; }
    .pagination a.active { background:#27AE60; }

    /* Modal */
    .modal { display:none; position:fixed; z-index:999; left:0; top:0; width:100%; height:100%;
             background-color:rgba(0,0,0,0.5); }
    .modal-content { background:#fff; border-radius:18px; padding:20px; max-width:400px;
                     margin:15% auto; text-align:center; box-shadow:0 12px 30px rgba(0,0,0,0.2); }
    .modal h3 { margin-bottom:20px; }
</style>

<script>
    function confirmDeleteBooking(id, client) {
        document.getElementById("deleteBookingModal").style.display = "block";
        document.getElementById("deleteBookingClient").innerText = client;
        document.getElementById("deleteBookingId").value = id;
    }
    function closeBookingModal() {
        document.getElementById("deleteBookingModal").style.display = "none";
    }
</script>
</head>

<body>
    <%@ include file="../webContent/adminSidebar.jsp" %>

    <div class="main">
        <h1>📅 Manage Bookings</h1>
        <p>All client bookings with details and status.</p>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Client</th>
                        <th>Date</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Services</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="r" items="${rows}">
                        <tr>
                            <td>${r.bookingId}</td>
                            <td>${r.clientUsername}</td>
                            <td>${r.date}</td>
                            <td>$${r.totalPrice}</td>
                            <td class="status ${r.status}">${r.status}</td>
                            <td class="payment ${r.paymentStatus}">${r.paymentStatus}</td>
                            <td>
                                <c:forEach var="s" items="${r.services}" varStatus="st">
                                    ${s}<c:if test="${!st.last}">, </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a class="btn btn-edit"
                                   href="${pageContext.request.contextPath}/admin/bookings/edit?id=${r.bookingId}">
                                   ✏️ Edit
                                </a>

                                <button type="button" class="btn btn-delete"
                                        onclick="confirmDeleteBooking(${r.bookingId}, '${r.clientUsername}')">
                                    🗑 Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty rows}">
                        <tr><td colspan="8">No bookings found.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/bookings?page=${i}"
                       class="${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Delete confirmation modal -->
    <div id="deleteBookingModal" class="modal">
        <div class="modal-content">
            <h3>Confirm Delete</h3>
            <p>Are you sure you want to delete booking for <strong id="deleteBookingClient"></strong>?</p>

            <form action="${pageContext.request.contextPath}/admin/bookings/delete" method="post">
                <input type="hidden" id="deleteBookingId" name="bookingId">
                <button type="submit" class="btn btn-delete">Yes, Delete</button>
                <button type="button" class="btn btn-edit" onclick="closeBookingModal()">Cancel</button>
            </form>
        </div>
    </div>
</body>
</html>
