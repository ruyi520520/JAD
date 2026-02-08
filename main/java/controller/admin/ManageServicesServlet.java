package controller.admin;

import dbAccess.services.ServiceAndCategoryDAO;
import dto.AdminServiceRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/admin-only/services")
public class ManageServicesServlet extends HttpServlet {

    private final ServiceAndCategoryDAO serviceDAO = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int currentPage = 1;
        int recordsPerPage = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Integer.parseInt(pageParam); }
            catch (NumberFormatException ignored) {}
        }
        if (currentPage < 1) currentPage = 1;

        int totalRecords = serviceDAO.getServiceCount();
        int totalPages = (int) Math.ceil(totalRecords / (double) recordsPerPage);
        if (totalPages == 0) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * recordsPerPage;

        List<AdminServiceRow> rows = serviceDAO.getServicesPage(offset, recordsPerPage);

        request.setAttribute("rows", rows);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/manageServices.jsp").forward(request, response);
    }
}
