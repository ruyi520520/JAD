/*=====================================
    Author: 
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.admin;

import dbAccess.booking.BookingDAO;
import dbAccess.services.ServiceAndCategoryDAO;
import dbAccess.user.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final ServiceAndCategoryDAO serviceDao = new ServiceAndCategoryDAO();
    private final BookingDAO bookingDao = new BookingDAO();
    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int serviceCount = serviceDao.getServiceCount();
        int bookingCount = bookingDao.getBookingCount();
        int clientCount  = userDao.getClientCount();

        request.setAttribute("serviceCount", serviceCount);
        request.setAttribute("bookingCount", bookingCount);
        request.setAttribute("clientCount", clientCount);

        request.getRequestDispatcher("/admin/adminDashboard.jsp").forward(request, response);
    }
}
