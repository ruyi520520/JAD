/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.admin;

import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategoryDAO;
import dbAccess.services.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/admin-only/services/add")
public class AddServiceServlet extends HttpServlet {

    private final ServiceAndCategoryDAO dao = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ServiceCategory> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/admin/addService.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdStr = request.getParameter("categoryId");
        String name = request.getParameter("serviceName");
        String desc = request.getParameter("description");
        String priceStr = request.getParameter("price");

        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            double price = Double.parseDouble(priceStr);

            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Service name cannot be empty.");
            }

            Service s = new Service();
            s.setCategoryId(categoryId);
            s.setServiceName(name.trim());
            s.setDescription(desc); 
            s.setPrice(price);

            boolean ok = dao.addService(s);

            if (ok) {
                // Go back to service management page
                response.sendRedirect(request.getContextPath() + "/admin/admin-only/services");
            } else {
                // Show errors
                request.setAttribute("error", "Failed to add service. Please try again.");

                List<ServiceCategory> categories = dao.getAllCategories();
                request.setAttribute("categories", categories);

                request.setAttribute("prevCategoryId", categoryIdStr);
                request.setAttribute("prevServiceName", name);
                request.setAttribute("prevDescription", desc);
                request.setAttribute("prevPrice", priceStr);

                request.getRequestDispatcher("/admin/addService.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("error", "Invalid input: " + e.getMessage());

            List<ServiceCategory> categories = dao.getAllCategories();
            request.setAttribute("categories", categories);

            request.setAttribute("prevCategoryId", categoryIdStr);
            request.setAttribute("prevServiceName", name);
            request.setAttribute("prevDescription", desc);
            request.setAttribute("prevPrice", priceStr);

            request.getRequestDispatcher("/admin/addService.jsp").forward(request, response);
        }
    }
}
