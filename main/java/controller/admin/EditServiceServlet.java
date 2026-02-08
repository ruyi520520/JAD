package controller.admin;

import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategoryDAO;
import dbAccess.services.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/admin-only/services/edit")
public class EditServiceServlet extends HttpServlet {

    private final ServiceAndCategoryDAO dao = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            request.setAttribute("error", "No service ID provided.");
            request.getRequestDispatcher("/admin/editService.jsp").forward(request, response);
            return;
        }

        int serviceId;
        try {
            serviceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid service ID.");
            request.getRequestDispatcher("/admin/editService.jsp").forward(request, response);
            return;
        }

        Service service = dao.getServiceById(serviceId);
        if (service == null) {
            request.setAttribute("error", "Service not found.");
        } else {
            request.setAttribute("service", service);
        }

        List<ServiceCategory> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/admin/editService.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("serviceName");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));

            Service s = new Service();
            s.setServiceId(serviceId);
            s.setCategoryId(categoryId);
            s.setServiceName(name);
            s.setDescription(desc);
            s.setPrice(price);

            dao.updateService(s);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/admin-only/services");
    }
}
