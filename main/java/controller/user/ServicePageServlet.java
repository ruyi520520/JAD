/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Service page servlet
==============================================================*/
package controller.user;

import dbAccess.booking.BookingDetail;
import dbAccess.booking.BookingDetailDAO;
import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Responsibilities:
 * 1) Read and validate serviceId (400 if missing/invalid)
 * 2) Load service details (404 if not found)
 * 3) Handle POST "Add to Cart" (login required)
 * 4) Forward to servicePage.jsp (View)
 */
@WebServlet("/service")
public class ServicePageServlet extends HttpServlet {

    // 1) DAO instances (can also create inside methods)
    private final ServiceAndCategoryDAO serviceDao = new ServiceAndCategoryDAO();
    private final BookingDetailDAO bookingDetailDao = new BookingDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 2) Resolve serviceId from request or session
            Integer serviceId = resolveServiceId(request);

            // 3) Load service details
            Service svcDetail = serviceDao.getServiceById(serviceId);
            if (svcDetail == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found.");
                return;
            }

            // 4) Put data into request scope for JSP
            request.setAttribute("svcDetail", svcDetail);

            // 5) Forward to View
            request.getRequestDispatcher("/servicePage.jsp").forward(request, response);

        } catch (IllegalArgumentException ex) {
            // 6) Bad input -> 400
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
        } catch (Exception ex) {
            // 7) Unexpected server error -> 500
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1) Login required to add to cart
            Integer userId = (Integer) request.getSession().getAttribute("sessUserId");
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }

            // 2) Resolve serviceId
            Integer serviceId = resolveServiceId(request);

            // 3) Load service details (need price for subtotal)
            Service svcDetail = serviceDao.getServiceById(serviceId);
            if (svcDetail == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found.");
                return;
            }

            // 4) Create cart item (booking_id = null means "still in cart")
            BookingDetail newDetail = new BookingDetail();
            newDetail.setBookingId(null);
            newDetail.setServiceId(serviceId);
            newDetail.setUserId(userId);
            newDetail.setSubtotal((float) svcDetail.getPrice());

            // 5) Insert into DB
            boolean ok = bookingDetailDao.insert(newDetail);
            if (!ok) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add service to cart.");
                return;
            }

            // 6) Pass data to View + success message
            request.setAttribute("svcDetail", svcDetail);
            request.setAttribute("message", "Service added to cart successfully.");

            // 7) Forward back to same View (PRG optional, but ok for your assignment)
            request.getRequestDispatcher("/servicePage.jsp").forward(request, response);

        } catch (IllegalArgumentException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error.");
        }
    }

    /**
     * Resolve and validate serviceId from request parameter or session.
     * @throws IllegalArgumentException for missing/invalid values (-> 400)
     */
    private Integer resolveServiceId(HttpServletRequest request) {
        HttpSession session = request.getSession();

        // 1) Read serviceId from query or form
        String paramServiceId = request.getParameter("serviceId");

        // 2) Fallback to session stored serviceId (optional)
        if (paramServiceId == null || paramServiceId.trim().isEmpty()) {
            Object saved = session.getAttribute("selectedServiceId");
            if (saved != null) {
                paramServiceId = saved.toString();
            }
        }

        // 3) Validate missing
        if (paramServiceId == null || paramServiceId.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing service id.");
        }

        // 4) Parse integer
        int serviceId;
        try {
            serviceId = Integer.parseInt(paramServiceId.trim());
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Invalid service id.");
        }

        // 5) Save into session for later (optional)
        session.setAttribute("selectedServiceId", String.valueOf(serviceId));

        return serviceId;
    }
}
