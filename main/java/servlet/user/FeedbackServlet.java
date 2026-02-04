/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Feedback servlet
==============================================================*/
package servlet.user;

import dbAccess.feedback.Feedback;
import dbAccess.feedback.FeedbackDAO;
import dbAccess.feedback.FeedbackView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * FeedbackServlet (Controller in MVC)
 * ----------------------------------
 * Handles:
 * - Display feedback page (GET)
 * - Edit mode (GET action=edit)
 * - Create/Update/Delete feedback (POST)
 */
@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Read session user info (can be null -> not logged in)
        Integer userId = (Integer) request.getSession().getAttribute("sessUserId");

        // 2) Default form mode
        String formMode = "create";
        Integer editFeedbackId = null;
        Integer editRating = null;
        String editComment = null;

        // 3) Handle edit mode: /feedback?action=edit&feedback_id=xxx
        String action = request.getParameter("action");
        if ("edit".equalsIgnoreCase(action)) {

            // Must be logged in to edit
            if (userId == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }

            String feedbackIdStr = request.getParameter("feedback_id");
            int feedbackId = parseIntSafe(feedbackIdStr, -1);
            if (feedbackId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid feedback id.");
                return;
            }

            // Ownership check
            Feedback fb = FeedbackDAO.getFeedbackByIdAndUser(feedbackId, userId);
            if (fb == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Feedback not found or not owned by you.");
                return;
            }

            formMode = "update";
            editFeedbackId = fb.getFeedbackId();
            editRating = (int) fb.getRating();
            editComment = fb.getComment();
        }

        // 4) Load lists for view
        List<FeedbackView> myList = (userId != null)
                ? FeedbackDAO.getFeedbackByUser(userId)
                : java.util.Collections.emptyList();

        List<FeedbackView> othersList = FeedbackDAO.getFeedbackFromOthers(userId);

        // 5) Put data into request scope
        request.setAttribute("formMode", formMode);
        request.setAttribute("editFeedbackId", editFeedbackId);
        request.setAttribute("editRating", editRating);
        request.setAttribute("editComment", editComment);

        request.setAttribute("myFeedbackList", myList);
        request.setAttribute("othersFeedbackList", othersList);

        // 6) Forward to JSP view
        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("sessUserId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
            return;
        }

        try {
            if ("delete".equalsIgnoreCase(action)) {
                handleDelete(request, response, userId);
                return;
            }

            if ("create".equalsIgnoreCase(action)) {
                handleCreate(request, response, userId);
                return;
            }

            if ("update".equalsIgnoreCase(action)) {
                handleUpdate(request, response, userId);
                return;
            }

            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action value.");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Internal server error while processing feedback.");
        }
    }

    // ---------- Helpers ----------

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        int feedbackId = parseIntSafe(request.getParameter("feedback_id"), -1);
        if (feedbackId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid feedback id for deletion.");
            return;
        }

        boolean ok = FeedbackDAO.deleteFeedbackByOwner(feedbackId, userId);
        if (!ok) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Failed to delete feedback. It may not exist or it is not yours.");
            return;
        }

        // PRG pattern to avoid resubmission
        response.sendRedirect(request.getContextPath() + "/feedback?msg=deleted");
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        int rating = parseRating(request, response);
        if (rating == -1) return;

        String comment = safeTrim(request.getParameter("comment"));

        Feedback fb = new Feedback(0, userId, rating, comment);
        int id = FeedbackDAO.createFeedback(fb);
        if (id <= 0) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Failed to save your feedback, please try again.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/feedback?msg=created");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {

        int feedbackId = parseIntSafe(request.getParameter("feedback_id"), -1);
        if (feedbackId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid feedback id for update.");
            return;
        }

        int rating = parseRating(request, response);
        if (rating == -1) return;

        String comment = safeTrim(request.getParameter("comment"));

        Feedback fb = new Feedback(feedbackId, userId, rating, comment);
        boolean ok = FeedbackDAO.updateFeedbackByOwner(fb);
        if (!ok) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Failed to update feedback. It may not exist or it is not yours.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/feedback?msg=updated");
    }

    private int parseRating(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ratingStr = request.getParameter("rating");
        int rating = parseIntSafe(ratingStr, -1);

        if (rating < 1 || rating > 5) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5.");
            return -1;
        }
        return rating;
    }

    private int parseIntSafe(String s, int fallback) {
        if (s == null) return fallback;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }

    private String safeTrim(String s) {
        return (s == null) ? null : s.trim();
    }
}
