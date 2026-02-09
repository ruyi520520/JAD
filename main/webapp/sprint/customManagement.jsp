<!-- =====================================
    Author: Huang Ruyi
    Date: 9/2/2025
    Description: Customer Management (table view)
   ====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dbAccess.user.User" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Management</title>
<style>
    table { border-collapse: collapse; width: 100%; margin-top: 12px; }
    th, td { border: 1px solid #ccc; padding: 8px; vertical-align: top; }
    th { background: #f5f5f5; text-align: left; }
    .error { color: red; font-weight: bold; }
    .section { margin-top: 22px; }
</style>
</head>
<body>

<p><%=request.getRequestURI()%></p>

<%
    String error = (String) request.getAttribute("err");
    if ("NotFound".equals(error)) {
%>
    <p class="error">ERROR: User not found!</p>
<%
    }
%>

<div class="section">
    <h2>List All Customers</h2>
    <form action="<%=request.getContextPath()%>/GetUserList" method="get">
        <input type="submit" value="List All Customers">
    </form>

<%
    @SuppressWarnings("unchecked")
    ArrayList<User> uAL = (ArrayList<User>) request.getAttribute("userArray");

    if (uAL != null) {
%>
    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Username</th>
                <th>Email</th>

                <th>Date of Birth</th>
                <th>Gender</th>
                <th>Address</th>

                <th>Allergies</th>
                <th>Medical History</th>
                <th>Current Medications</th>
                <th>Emergency Contact Name</th>
                <th>Emergency Contact Phone</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (User u : uAL) {
        %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getUsername() == null ? "" : u.getUsername() %></td>
                <td><%= u.getEmail() == null ? "" : u.getEmail() %></td>

                <td><%= u.getDateOfBirth() == null ? "" : u.getDateOfBirth() %></td>
                <td><%= u.getGender() == null ? "" : u.getGender() %></td>
                <td><%= u.getAddress() == null ? "" : u.getAddress() %></td>

                <td><%= u.getAllergies() == null ? "" : u.getAllergies() %></td>
                <td><%= u.getMedicalHistory() == null ? "" : u.getMedicalHistory() %></td>
                <td><%= u.getCurrentMedications() == null ? "" : u.getCurrentMedications() %></td>
                <td><%= u.getNotes() == null ? "" : u.getNotes() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
<%
    }
%>
</div>


<div class="section">
    <h2>Get User by User ID</h2>
    <form action="<%=request.getContextPath()%>/GetUserById" method="get">
        Enter User ID:
        <input type="text" name="uid" size="25">
        <input type="submit" value="Submit">
    </form>

<%
    User one = (User) request.getAttribute("userObj");
    if (one != null) {
%>
    <table>
        <thead>
            <tr>
                <th>Username</th>
                <th>Email</th>

                <th>Full Name</th>
                <th>Phone</th>
                <th>Date of Birth</th>
                <th>Gender</th>
                <th>Address</th>

                <th>Allergies</th>
                <th>Medical History</th>
                <th>Current Medications</th>
                <th>Emergency Contact Name</th>
                <th>Emergency Contact Phone</th>
                <th>Notes</th>

                <th>Created At</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><%= one.getUsername() == null ? "" : one.getUsername() %></td>
                <td><%= one.getEmail() == null ? "" : one.getEmail() %></td>

                <td><%= one.getFullName() == null ? "" : one.getFullName() %></td>
                <td><%= one.getPhone() == null ? "" : one.getPhone() %></td>
                <td><%= one.getDateOfBirth() == null ? "" : one.getDateOfBirth() %></td>
                <td><%= one.getGender() == null ? "" : one.getGender() %></td>
                <td><%= one.getAddress() == null ? "" : one.getAddress() %></td>

                <td><%= one.getAllergies() == null ? "" : one.getAllergies() %></td>
                <td><%= one.getMedicalHistory() == null ? "" : one.getMedicalHistory() %></td>
                <td><%= one.getCurrentMedications() == null ? "" : one.getCurrentMedications() %></td>
                <td><%= one.getEmergencyContactName() == null ? "" : one.getEmergencyContactName() %></td>
                <td><%= one.getEmergencyContactPhone() == null ? "" : one.getEmergencyContactPhone() %></td>
                <td><%= one.getNotes() == null ? "" : one.getNotes() %></td>

                <td><%= one.getCreatedAt() == null ? "" : one.getCreatedAt() %></td>
            </tr>
        </tbody>
    </table>
<%
    }
%>
</div>

</body>
</html>
