package controller.admin;

import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/admin-only/services/delete")
public class DeleteServiceServlet extends HttpServlet {

    private final ServiceAndCategoryDAO serviceDAO = new ServiceAndCategoryDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            serviceDAO.deleteService(serviceId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-only/services");
    }
}
