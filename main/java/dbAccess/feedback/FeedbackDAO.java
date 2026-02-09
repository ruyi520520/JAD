/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package dbAccess.feedback;

import dbAccess.dbConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FeedbackDAO (Model in MVC)
 * -------------------------
 * Responsibilities:
 * - CRUD operations for feedback table
 * - All DB access is isolated here (Servlet should not write SQL)
 */
public class FeedbackDAO {

    // ---------- CREATE ----------
    public static int createFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (user_id, rating, comment) VALUES (?, ?, ?)";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, feedback.getUserId());
            stmt.setInt(2, (int) feedback.getRating()); // enforce integer
            stmt.setString(3, feedback.getComment());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // generated feedback_id
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ---------- READ: by ID (no ownership check) ----------
    public static Feedback getFeedbackById(int id) {
        String sql = "SELECT feedback_id, user_id, rating, comment FROM feedback WHERE feedback_id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Feedback(
                            rs.getInt("feedback_id"),
                            rs.getInt("user_id"),
                            rs.getInt("rating"),
                            rs.getString("comment")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ---------- READ: by ID + userId (ownership check) ----------
    public static Feedback getFeedbackByIdAndUser(int feedbackId, int userId) {
        String sql = "SELECT feedback_id, user_id, rating, comment " +
                     "FROM feedback WHERE feedback_id = ? AND user_id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedbackId);
            stmt.setInt(2, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Feedback(
                            rs.getInt("feedback_id"),
                            rs.getInt("user_id"),
                            rs.getInt("rating"),
                            rs.getString("comment")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ---------- UPDATE (must match userId) ----------
    public static boolean updateFeedbackByOwner(Feedback feedback) {
        String sql = "UPDATE feedback SET rating = ?, comment = ? " +
                     "WHERE feedback_id = ? AND user_id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, (int) feedback.getRating());
            stmt.setString(2, feedback.getComment());
            stmt.setInt(3, feedback.getFeedbackId());
            stmt.setInt(4, feedback.getUserId());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ---------- DELETE (must match userId) ----------
    public static boolean deleteFeedbackByOwner(int feedbackId, int userId) {
        String sql = "DELETE FROM feedback WHERE feedback_id = ? AND user_id = ?";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedbackId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ---------- LIST: current user's feedback (with username) ----------
    public static List<FeedbackView> getFeedbackByUser(int userId) {
        List<FeedbackView> list = new ArrayList<>();

        String sql = "SELECT f.feedback_id, f.rating, f.comment, u.username " +
                     "FROM feedback f " +
                     "JOIN user u ON f.user_id = u.user_id " +
                     "WHERE f.user_id = ? " +
                     "ORDER BY f.feedback_id DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new FeedbackView(
                            rs.getInt("feedback_id"),
                            rs.getString("username"),
                            rs.getInt("rating"),
                            rs.getString("comment")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ---------- LIST: other users' feedback ----------
    public static List<FeedbackView> getFeedbackFromOthers(Integer excludeUserId) {
        List<FeedbackView> list = new ArrayList<>();

        String sqlWithExclude =
                "SELECT f.feedback_id, f.rating, f.comment, u.username " +
                "FROM feedback f " +
                "JOIN user u ON f.user_id = u.user_id " +
                "WHERE f.user_id <> ? " +
                "ORDER BY f.feedback_id DESC";

        String sqlNoExclude =
                "SELECT f.feedback_id, f.rating, f.comment, u.username " +
                "FROM feedback f " +
                "JOIN user u ON f.user_id = u.user_id " +
                "ORDER BY f.feedback_id DESC";

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = (excludeUserId == null)
                     ? conn.prepareStatement(sqlNoExclude)
                     : conn.prepareStatement(sqlWithExclude)) {

            if (excludeUserId != null) {
                stmt.setInt(1, excludeUserId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new FeedbackView(
                            rs.getInt("feedback_id"),
                            rs.getString("username"),
                            rs.getInt("rating"),
                            rs.getString("comment")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
