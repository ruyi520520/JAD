/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Cart servlet
==============================================================*/
package controller.user;

import dbAccess.booking.Booking;
import dbAccess.booking.BookingDAO;
import dbAccess.booking.BookingDetail;
import dbAccess.booking.BookingDetailDAO;
import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * CartServlet (Controller in MVC)
 * -------------------------------
 * Responsibilities:
 * 1) Check login session
 * 2) Handle POST actions: delete / book
 * 3) Load cart items for current user
 * 4) Prepare service lookup map (avoid DB calls in JSP)
 * 5) Forward to cart.jsp (View)
 *
 * Notes:
 * - If a pending (PENDING) booking exists for the user, the cart page will show
 *   "Continue editing your previous booking" and redirect user to BookingServlet.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final BookingDetailDAO cartDao = new BookingDetailDAO();
    private final BookingDAO bookingDao = new BookingDAO();
    private final ServiceAndCategoryDAO serviceDao = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        renderCart(request, response, null, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Check login
        Integer userId = (Integer) request.getSession().getAttribute("sessUserId");
        if (userId == null) {
            // Redirect to LoginServlet instead of JSP
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String message = null;
        String error = null;

        try {
            String action = request.getParameter("action");

            // 2) Validate action parameter
            if (isBlank(action)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
                return;
            }

            // 3) Read selectedIds[] from checkboxes
            String[] selectedIdsArr = request.getParameterValues("selectedIds");

            if ("delete".equals(action)) {

                // 4) Delete selected items
                if (selectedIdsArr == null || selectedIdsArr.length == 0) {
                    error = "Please select at least one item to remove.";
                } else {
                    List<Integer> ids = parseIdList(selectedIdsArr);

                    // All invalid => 400
                    if (ids.isEmpty()) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                "All selected cart item IDs are invalid for deletion.");
                        return;
                    }

                    boolean ok = cartDao.deleteBookingDetails(ids);
                    if (ok) {
                        message = "Selected items removed from cart.";
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                "Selected cart items were not found for deletion.");
                        return;
                    }
                }

            } else if ("book".equals(action)) {

                /*
                 * If user already has a pending booking, always continue editing
                 * instead of starting a new booking flow.
                 */
                Booking pendingBooking = bookingDao.getPendingBookingByUserId(userId);
                if (pendingBooking != null) {
                    response.sendRedirect(request.getContextPath()
                            + "/booking?draftBookingId=" + pendingBooking.getBookingId());
                    return;
                }

                // 5) Book selected items (go to BookingServlet)
                if (selectedIdsArr == null || selectedIdsArr.length == 0) {
                    error = "Please select at least one item to book.";
                } else {
                    List<Integer> ids = parseIdList(selectedIdsArr);

                    // All invalid => 400
                    if (ids.isEmpty()) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                                "All selected cart item IDs are invalid for booking.");
                        return;
                    }

                    // 6) Store selected cart booking_detail_id list in session
                    request.getSession().setAttribute("selectedCartItemIds", ids);

                    // 7) Redirect to BookingServlet (NOT booking.jsp)
                    response.sendRedirect(request.getContextPath() + "/booking");
                    return;
                }

            } else {
                // Unsupported action => 400
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action value.");
                return;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Internal server error while processing cart action.");
            return;
        }

        // Render cart page again with message/error
        renderCart(request, response, message, error);
    }

    /**
     * Load cart items, compute total, prepare serviceMap, then forward to cart.jsp.
     * Also loads pending booking info to support "Continue editing" UX.
     */
    private void renderCart(HttpServletRequest request, HttpServletResponse response,
                            String message, String error)
            throws ServletException, IOException {

        // 1) Check login session
        Integer userId = (Integer) request.getSession().getAttribute("sessUserId");
        if (userId == null) {
            // Redirect to LoginServlet instead of JSP
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2) Check if user has a pending draft booking
        Booking pendingBooking = bookingDao.getPendingBookingByUserId(userId);
        boolean hasPendingBooking = (pendingBooking != null);
        Integer pendingBookingId = hasPendingBooking ? pendingBooking.getBookingId() : null;

        // 3) Load cart items for this user
        List<BookingDetail> cartItems = cartDao.getCartByUserId(userId);
        if (cartItems == null) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load cart items.");
            return;
        }

        // 4) Compute total and build a service lookup map for the View
        double totalAmount = 0.0;
        Map<Integer, Service> serviceMap = new HashMap<>();

        for (BookingDetail item : cartItems) {
            totalAmount += item.getSubtotal();

            int svcId = item.getServiceId();
            if (!serviceMap.containsKey(svcId)) {
                Service svc = serviceDao.getServiceById(svcId);
                if (svc != null) {
                    serviceMap.put(svcId, svc);
                }
            }
        }

        // 5) Put data into request scope
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("serviceMap", serviceMap);

        // Pending booking flags for JSP (minimal impact)
        request.setAttribute("hasPendingBooking", hasPendingBooking);
        request.setAttribute("pendingBookingId", pendingBookingId);

        // 6) Forward to View
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    /**
     * Parse a String[] into a list of valid integer IDs.
     * Invalid IDs are ignored.
     */
    private List<Integer> parseIdList(String[] idStrings) {
        List<Integer> ids = new ArrayList<>();
        if (idStrings == null) return ids;

        for (String s : idStrings) {
            if (s == null) continue;
            try {
                ids.add(Integer.parseInt(s.trim()));
            } catch (NumberFormatException ignored) {
                // Ignore invalid IDs
            }
        }
        return ids;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
