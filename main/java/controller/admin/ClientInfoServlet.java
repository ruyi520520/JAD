/*=====================================
    Author: 
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.admin;

import dbAccess.user.User;
import dbAccess.user.UserDAO;
import dbAccess.booking.Booking;
import dbAccess.booking.BookingDAO;
import dbAccess.booking.BookingDetailDAO;
import dto.BookingWithServices;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/clientInfo")
public class ClientInfoServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final BookingDetailDAO bookingDetailDAO = new BookingDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            request.setAttribute("error", "No client ID provided.");
            request.getRequestDispatcher("/admin/clientInfo.jsp").forward(request, response);
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid client ID.");
            request.getRequestDispatcher("/admin/clientInfo.jsp").forward(request, response);
            return;
        }

        User client = userDAO.getUserById(userId);
        if (client == null) {
            request.setAttribute("error", "Client not found.");
            request.getRequestDispatcher("/admin/clientInfo.jsp").forward(request, response);
            return;
        }

        List<Booking> bookings = bookingDAO.getBookingsByUserId(userId);

        List<BookingWithServices> rows = new ArrayList<>();
        for (Booking b : bookings) {
            List<String> services = bookingDetailDAO.getServiceNamesByBookingId(b.getBookingId());
            rows.add(new BookingWithServices(b, services));
        }

        request.setAttribute("client", client);
        request.setAttribute("bookingRows", rows);

        request.getRequestDispatcher("/admin/clientInfo.jsp").forward(request, response);
    }
}
