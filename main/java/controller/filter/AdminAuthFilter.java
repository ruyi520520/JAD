package controller.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession sess = request.getSession(false);
        
        System.out.println("[AdminAuthFilter] sess=" + (sess != null));
        System.out.println("[AdminAuthFilter] sessUserId=" + (sess == null ? null : sess.getAttribute("sessUserId")));
        System.out.println("[AdminAuthFilter] sessRoleName=" + (sess == null ? null : sess.getAttribute("sessRoleName")));
        System.out.println("[AdminAuthFilter] sessRoleId=" + (sess == null ? null : sess.getAttribute("sessRoleId")));


        // Not logged in
        if (sess == null || sess.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Not admin
        String roleName = (String) sess.getAttribute("sessRoleName");
        if (roleName == null || !"Admin".equalsIgnoreCase(roleName)) {
            response.sendRedirect(request.getContextPath() + "/errorHandling/401.jsp");
            return;
        }

        chain.doFilter(req, res);
    }
}
