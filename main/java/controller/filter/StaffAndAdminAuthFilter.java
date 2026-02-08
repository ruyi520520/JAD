package controller.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class StaffAndAdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession sess = request.getSession(false);

        // Not logged in
        if (sess == null || sess.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Role check
        String roleName = (String) sess.getAttribute("sessRoleName");
        if (roleName == null) {
            response.sendRedirect(request.getContextPath() + "/errorHandling/401.jsp");
            return;
        }

        boolean allowed = "Admin".equalsIgnoreCase(roleName) || "Staff".equalsIgnoreCase(roleName);
        if (!allowed) {
            response.sendRedirect(request.getContextPath() + "/errorHandling/401.jsp");
            return;
        }

        chain.doFilter(req, res);
    }
}
