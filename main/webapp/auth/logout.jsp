<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2
====================================== -->
  <%
    // Clear session
    session.invalidate();

    // Back to login
    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
%>
