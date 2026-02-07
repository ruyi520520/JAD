package controller.admin;

import dbAccess.booking.BookingDAO;
import dbAccess.booking.BookingDetailDAO;
import dto.AdminBookingRow;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/bookings")
public class ManageBookingsServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingDetailDAO bookingDetailDAO = new BookingDetailDAO();

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

        int totalRecords = bookingDAO.countBookings();
        int totalPages = (int) Math.ceil(totalRecords / (double) recordsPerPage);
        if (totalPages == 0) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * recordsPerPage;

        List<AdminBookingRow> rows = bookingDAO.getAdminBookingRowsPage(offset, recordsPerPage);

        // attach services list per booking
        for (AdminBookingRow row : rows) {
            row.setServices(bookingDetailDAO.getServiceNamesByBookingId(row.getBookingId()));
        }

        request.setAttribute("rows", rows);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/admin/manageBookings.jsp").forward(request, response);
    }
}
