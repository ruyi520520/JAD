/*=====================================
    Author: 
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.admin;

import dbAccess.booking.Booking;
import dbAccess.booking.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/admin/bookings/edit")
public class EditBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            request.setAttribute("error", "No booking ID provided.");
            request.getRequestDispatcher("/admin/editBooking.jsp").forward(request, response);
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid booking ID.");
            request.getRequestDispatcher("/admin/editBooking.jsp").forward(request, response);
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("error", "Booking not found.");
        } else {
            request.setAttribute("booking", booking);
        }

        request.getRequestDispatcher("/admin/editBooking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String dateStr = request.getParameter("date"); // datetime-local => "YYYY-MM-DDTHH:mm"
            float totalPrice = Float.parseFloat(request.getParameter("totalPrice"));
            String status = request.getParameter("status");
            String payment = request.getParameter("payment");

            // Parse datetime-local
            LocalDateTime ldt = LocalDateTime.parse(dateStr);
            Timestamp ts = Timestamp.valueOf(ldt);

            boolean ok = bookingDAO.updateAdminBooking(bookingId, ts, totalPrice, status, payment);

            if (ok) {
                // Redirect back to bookings list or booking details page
                response.sendRedirect(request.getContextPath() + "/admin/bookings");
            } else {
                request.setAttribute("error", "Failed to update booking.");
                response.sendRedirect(request.getContextPath() + "/admin/bookings/edit?id=" + bookingId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/admin/editBooking.jsp").forward(request, response);
        }
    }
}
