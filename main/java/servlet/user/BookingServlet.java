/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Booking servlet
==============================================================*/
package servlet.user;

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
import java.sql.Date;
import java.sql.Timestamp;
import java.util.*;

/**
 * BookingServlet (Controller in MVC)
 * ---------------------------------
 * Responsibilities:
 * 1) Check login session
 * 2) Load selected cart items or draft booking items
 * 3) Handle POST actions: draft / payment / cancel
 * 4) Prepare data and forward to booking.jsp (View)
 *
 * Notes:
 * - Draft saving allows an optional booking date. If date is provided, it is stored/updated.
 * - When editing a draft, the existing booking date is pre-filled and preserved if user does not change it.
 */
@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private final BookingDetailDAO detailDao = new BookingDetailDAO();
    private final BookingDAO bookingDao = new BookingDAO();
    private final ServiceAndCategoryDAO serviceDao = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handlePage(request, response, false);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handlePage(request, response, true);
    }

    /**
     * Shared handler for GET/POST.
     */
    private void handlePage(HttpServletRequest request, HttpServletResponse response, boolean isPost)
            throws ServletException, IOException {

        // 1) Check login status
        Integer userId = (Integer) request.getSession().getAttribute("sessUserId");
        String username = (String) request.getSession().getAttribute("sessUsername");
        if (userId == null || username == null) {
            // Redirect to LoginServlet instead of JSP
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String message = null;
        String error = null;

        // 2) Read optional draftBookingId (editing an existing PENDING booking)
        Integer draftBookingId = null;
        String draftBookingIdStr = request.getParameter("draftBookingId");
        if (draftBookingIdStr != null && !draftBookingIdStr.trim().isEmpty()) {
            try {
                draftBookingId = Integer.parseInt(draftBookingIdStr.trim());
            } catch (NumberFormatException ex) {
                error = "Invalid draft booking id.";
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        }

        // 2.1) Load existing draft booking (for pre-filling and preserving the date)
        Date existingDraftDate = null;
        if (error == null && draftBookingId != null) {
            Booking draftBooking = bookingDao.getBookingByIdForUser(draftBookingId, userId);
            if (draftBooking == null) {
                error = "Draft booking not found.";
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            } else {
                existingDraftDate = draftBooking.getBookingDate(); // may be null depending on DB design
                message = "You are editing your pending booking.";
            }
        }

        // 3) Determine selected booking_detail_id list
        List<Integer> selectedIds = null;
        List<BookingDetail> cartItems = new ArrayList<>();
        float totalPrice = 0f;

        if (error == null) {

            if (draftBookingId != null) {
                // Editing draft booking: load detail IDs by booking_id
                selectedIds = detailDao.getDetailIdsByBookingId(draftBookingId);

                if (selectedIds != null && !selectedIds.isEmpty()) {
                    cartItems = detailDao.getCartItemsByIds(selectedIds);
                    totalPrice = sumSubtotal(cartItems);
                    // message is already set above when draft exists
                } else {
                    error = "No services found for this pending booking.";
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                }

            } else {
                // New booking flow: load selected cart item IDs from session
                selectedIds = (List<Integer>) request.getSession().getAttribute("selectedCartItemIds");

                if (selectedIds != null && !selectedIds.isEmpty()) {
                    cartItems = detailDao.getCartItemsByIds(selectedIds);
                    totalPrice = sumSubtotal(cartItems);
                }
            }
        }

        // 4) Handle POST actions: draft / payment / cancel
        if (error == null && isPost) {
            String action = request.getParameter("action");          // draft / payment / cancel
            String dateStr = request.getParameter("bookingDate");    // yyyy-MM-dd

            // 4.1 Cancel action: remove draft booking and return to cart
            if ("cancel".equals(action)) {
                if (draftBookingId != null) {
                    detailDao.clearBookingIdByBookingId(draftBookingId);
                    bookingDao.delete(draftBookingId);
                }
                request.getSession().removeAttribute("selectedCartItemIds");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            boolean isPayment = "payment".equals(action);
            boolean isDraft = "draft".equals(action);

            // 4.2 Validate selection and date rules
            if (!isPayment && !isDraft) {
                error = "Invalid action.";
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else if (selectedIds == null || selectedIds.isEmpty()) {
                error = "No selected services to book. Please go back to cart.";
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else if (cartItems == null || cartItems.isEmpty()) {
                error = "Selected services could not be loaded. Please try again.";
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else if (isPayment && (dateStr == null || dateStr.trim().isEmpty())) {
                // Payment requires a date
                error = "Please select a booking date.";
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                // 4.3 Parse date if provided; otherwise preserve existing draft date when editing
                Date bookingDate = null;
                if (dateStr != null && !dateStr.trim().isEmpty()) {
                    try {
                        bookingDate = Date.valueOf(dateStr.trim());
                    } catch (IllegalArgumentException ex) {
                        error = "Invalid date format. Please use yyyy-MM-dd.";
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    }
                } else {
                    bookingDate = existingDraftDate; // preserve previous draft date (may be null)
                }

                if (error == null) {
                    // 4.4 Determine booking status
                    String status = isPayment ? "CONFIRMED" : "PENDING";

                    // 4.5 Find existing pending booking for this user
                    Booking existingPending = bookingDao.getPendingBookingByUserId(userId);
                    int bookingId;

                    if (existingPending != null) {
                        // Update existing draft booking (including date if provided/preserved)
                        existingPending.setBookingDate(bookingDate);
                        existingPending.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                        existingPending.setTotalPrice(totalPrice);
                        existingPending.setStatus(status);
                        existingPending.setPaymentStatus("UNPAID");

                        boolean updated = bookingDao.update(existingPending);
                        bookingId = updated ? existingPending.getBookingId() : -1;
                    } else {
                        // Create new booking record
                        Booking booking = new Booking();
                        booking.setUserId(userId);
                        booking.setBookingDate(bookingDate);
                        booking.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                        booking.setTotalPrice(totalPrice);
                        booking.setStatus(status);
                        booking.setPaymentStatus("UNPAID");

                        bookingId = bookingDao.insert(booking);
                    }

                    // 4.6 Attach selected booking_details to booking
                    if (bookingId > 0) {
                        boolean attached = detailDao.attachCartItemsToBooking(selectedIds, bookingId);
                        if (!attached) {
                            error = "Booking was created, but failed to attach selected services. Please contact support.";
                            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        } else {
                            // Clear selection to prevent duplicate booking
                            request.getSession().removeAttribute("selectedCartItemIds");

                            if (isPayment) {
                                response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId);
                                return;
                            } else {
                                response.sendRedirect(request.getContextPath() + "/cart");
                                return;
                            }
                        }
                    } else {
                        error = "Failed to create or update booking. Please try again.";
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    }
                }
            }
        }

        // 5) Prepare a service lookup map for the View (avoid DAO calls in JSP)
        Map<Integer, Service> serviceMap = new HashMap<>();
        if (cartItems != null) {
            for (BookingDetail bd : cartItems) {
                int svcId = bd.getServiceId();
                if (!serviceMap.containsKey(svcId)) {
                    Service svc = serviceDao.getServiceById(svcId);
                    if (svc != null) {
                        serviceMap.put(svcId, svc);
                    }
                }
            }
        }

        // 6) Put data into request scope for booking.jsp (View)
        request.setAttribute("message", message);
        request.setAttribute("error", error);
        request.setAttribute("draftBookingId", draftBookingId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("serviceMap", serviceMap);

        // Existing date used to pre-fill the bookingDate input
        request.setAttribute("existingBookingDate", existingDraftDate);

        // 7) Forward to View
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    /**
     * Sum up subtotals from booking detail list.
     */
    private float sumSubtotal(List<BookingDetail> items) {
        float total = 0f;
        if (items != null) {
            for (BookingDetail bd : items) {
                total += bd.getSubtotal();
            }
        }
        return total;
    }
}
