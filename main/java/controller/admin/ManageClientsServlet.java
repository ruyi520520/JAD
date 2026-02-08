package controller.admin;

import dbAccess.user.User;
import dbAccess.user.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/admin-only/clients")
public class ManageClientsServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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

        int totalRecords = userDAO.getClientCount();
        int totalPages = (int) Math.ceil(totalRecords / (double) recordsPerPage);
        if (totalPages == 0) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * recordsPerPage;

        List<User> clients = userDAO.getClientsPage(offset, recordsPerPage);

        request.setAttribute("clients", clients);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/viewClients.jsp").forward(request, response);
    }
}
