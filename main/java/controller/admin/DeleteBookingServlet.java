package controller.admin;

import dbAccess.booking.BookingDAO;
import dbAccess.booking.BookingDetailDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/bookings/delete")
public class DeleteBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingDetailDAO bookingDetailDAO = new BookingDetailDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("bookingId");

        try {
            int bookingId = Integer.parseInt(idStr);

            // detach details first (prevents FK constraint issues)
            bookingDetailDAO.clearBookingIdByBookingId(bookingId);

            bookingDAO.deleteBookingById(bookingId);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings");
    }
}
