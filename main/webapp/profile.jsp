<!--  =====================================
    Author: Huang Ruyi
    Date: 7/2/2026
    Description: ST0510/JAD project 2
====================================== */ -->
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<style>
    /* ===== Match Cart Page Style ===== */
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

    h1 { font-size: 26px; margin-bottom: 8px; color: #2C3E50; }

    .muted { color: #7f8c8d; font-size: 13px; margin-bottom: 18px; }

    .message { margin-bottom: 16px; padding: 10px 14px; border-radius: 6px; font-size: 13px; }
    .message.success { background-color: #e9f7ef; color: #1e8449; border: 1px solid #a9dfbf; }
    .message.error   { background-color: #fbeeee; color: #c0392b; border: 1px solid #f5b7b1; }

    .card {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.06);
        padding: 18px;
        margin-bottom: 16px;
    }

    .card h2 {
        margin: 0 0 10px;
        font-size: 16px;
        color: #2C3E50;
    }

    .row { display: flex; gap: 16px; flex-wrap: wrap; }
    .col { flex: 1; min-width: 260px; }

    label { display: block; font-weight: 600; margin: 10px 0 6px; color: #2C3E50; font-size: 13px; }

    input, select, textarea {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #dfe6e9;
        border-radius: 10px;
        font-size: 14px;
        outline: none;
        background-color: #fff;
    }

    textarea { min-height: 90px; resize: vertical; }

    input:focus, select:focus, textarea:focus {
        border-color: #E67E22;
        box-shadow: 0 0 0 3px rgba(230,126,34,0.15);
    }

    .actions {
        margin-top: 12px;
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        flex-wrap: wrap;
    }

    /* Buttons exactly like cart page */
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
    .btn-secondary { background-color: #ecf0f1; color: #2C3E50; }
    .btn-secondary:hover { background-color: #d0d7de; transform: translateY(-1px); }
    .btn-primary { background-color: #E67E22; color: #fff; }
    .btn-primary:hover { background-color: #D35400; transform: translateY(-1px); }

    .hint { font-size: 13px; color: #7f8c8d; margin-top: 6px; }
</style>

</head>
<body>

    <%-- Include global navbar (use absolute include to avoid path issues) --%>
    <%@ include file="webContent/navBar.jsp" %>

    <div class="page-container">
        <h1>My Profile</h1>

        <div class="muted">
            Username: <b><c:out value="${user.username}" /></b>
            &nbsp;|&nbsp;
            Created at: <c:out value="${user.createdAt}" />
        </div>

        <c:if test="${not empty error}">
            <div class="message error"><c:out value="${error}" /></div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="message success"><c:out value="${success}" /></div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/profile">

            <!-- Basic Info -->
            <div class="card">
                <h2>Basic Info</h2>

                <label>Email *</label>
                <input type="email" name="email" value="${user.email}" required />

                <div class="row">
                    <div class="col">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="${user.fullName}" />
                    </div>
                    <div class="col">
                        <label>Phone</label>
                        <input type="text" name="phone" value="${user.phone}" />
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <label>Date of Birth</label>
                        <input type="date" name="dateOfBirth" value="${user.dateOfBirth}" />
                    </div>
                    <div class="col">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="PREFER_NOT_TO_SAY" <c:if test="${user.gender == 'PREFER_NOT_TO_SAY'}">selected</c:if>>Prefer not to say</option>
                            <option value="MALE" <c:if test="${user.gender == 'MALE'}">selected</c:if>>Male</option>
                            <option value="FEMALE" <c:if test="${user.gender == 'FEMALE'}">selected</c:if>>Female</option>
                            <option value="OTHER" <c:if test="${user.gender == 'OTHER'}">selected</c:if>>Other</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Address -->
            <div class="card">
                <h2>Address</h2>
                <label>Address</label>
                <input type="text" name="address" value="${user.address}" />
            </div>

            <!-- Medical Profile -->
            <div class="card">
                <h2>Medical Profile (Optional)</h2>

                <label>Allergies</label>
                <textarea name="allergies">${user.allergies}</textarea>

                <label>Medical History</label>
                <textarea name="medicalHistory">${user.medicalHistory}</textarea>

                <label>Current Medications</label>
                <textarea name="currentMedications">${user.currentMedications}</textarea>

                <div class="row">
                    <div class="col">
                        <label>Emergency Contact Name</label>
                        <input type="text" name="emergencyContactName" value="${user.emergencyContactName}" />
                    </div>
                    <div class="col">
                        <label>Emergency Contact Phone</label>
                        <input type="text" name="emergencyContactPhone" value="${user.emergencyContactPhone}" />
                    </div>
                </div>

                <label>Notes</label>
                <textarea name="notes">${user.notes}</textarea>
            </div>

            <!-- Change Password -->
            <div class="card">
                <h2>Change Password</h2>
                <div class="hint">Leave blank if you don’t want to change it.</div>

                <div class="row">
                    <div class="col">
                        <label>New Password</label>
                        <input type="password" name="newPassword" />
                    </div>
                    <div class="col">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmNewPassword" />
                    </div>
                </div>
            </div>

            <div class="actions">
                <a href="<%= request.getContextPath() %>/home" class="btn btn-secondary">Back</a>
                <button class="btn btn-primary" type="submit">Save Changes</button>
            </div>
        </form>
    </div>

    <%-- Include global footer --%>
    <%@ include file="webContent/footer.jsp" %>

</body>
</html>
