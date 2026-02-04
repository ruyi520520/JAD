<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>Care Schedule History</title>
<style>
    /* Same style as Cart / Profile */
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .page-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 16px;
        flex: 1;
    }

    h1 { font-size: 26px; color: #2C3E50; }

    .card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        padding: 16px;
        margin-bottom: 16px;
    }

    .history-item {
        border-bottom: 1px solid #ecf0f1;
        padding: 12px 0;
    }
    .history-item:last-child { border-bottom: none; }

    .title { font-weight: 600; color: #2C3E50; }
    .meta { font-size: 13px; color: #7f8c8d; margin-top: 4px; }

    .filters {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        align-items: flex-end;
    }

    input, select {
        padding: 8px 10px;
        border-radius: 10px;
        border: 1px solid #dfe6e9;
    }

    .btn {
        border-radius: 999px;
        padding: 8px 18px;
        border: none;
        cursor: pointer;
        background-color: #E67E22;
        color: #fff;
    }
</style>
</head>

<body>

    <%-- Include global navbar --%>
    <%@ include file="webContent/navBar.jsp" %>

<div class="page-container">
    <h1>Care Schedule History</h1>

    <!-- Filters -->
    <form method="get" class="card filters">
        <div>
            <label>From</label><br>
            <input type="date" name="fromDate" value="${param.fromDate}">
        </div>
        <div>
            <label>To</label><br>
            <input type="date" name="toDate" value="${param.toDate}">
        </div>
        <div>
            <label>Service</label><br>
            <select name="serviceId">
                <option value="">All services</option>
                <c:forEach var="s" items="${services}">
                    <option value="${s.serviceId}"
                        <c:if test="${param.serviceId == s.serviceId}">selected</c:if>>
                        ${s.serviceName}
                    </option>
                </c:forEach>
            </select>
        </div>
        <button class="btn">Filter</button>
    </form>

    <!-- History list -->
    <div class="card">
        <c:if test="${empty history}">
            <div class="meta">No care history found.</div>
        </c:if>

		<div class="card">
		    <c:if test="${empty history}">
		        <div class="meta">No care history found.</div>
		    </c:if>
		
		    <c:forEach var="b" items="${history}">
		        <div class="history-item">
		            <div class="title">
		                Booking on ${b.bookingDate}
		            </div>
		
		            <div class="meta">
		                Subtotal: $${b.bookingSubtotal} |
		                Status: ${b.bookingStatus}
		            </div>
		
		            <div style="margin-top:10px; padding-left:12px;">
		                <c:forEach var="d" items="${b.serviceDetails}">
		                    <div class="meta" style="padding:6px 0;">
		                        - ${d.serviceName} : $${d.subtotal}
		                    </div>
		                </c:forEach>
		            </div>
		        </div>
		    </c:forEach>
		</div>

    </div>
</div>

    <%-- Include global footer --%>
    <%@ include file="webContent/footer.jsp" %>

</body>
</html>
	