package controller.admin;

import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategoryDAO;
import dbAccess.services.ServiceCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/services/add")
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
            throws IOException {

        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("serviceName");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));

            Service s = new Service();
            s.setCategoryId(categoryId);
            s.setServiceName(name);
            s.setDescription(desc);
            s.setPrice(price);

            dao.addService(s);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/services");
    }
}
