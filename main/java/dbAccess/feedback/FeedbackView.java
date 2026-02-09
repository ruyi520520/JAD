/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package dbAccess.feedback;

/**
 * FeedbackView
 * ------------
 * A simple DTO for rendering feedback lists in JSP (includes username).
 */
public class FeedbackView {
    private int feedbackId;
    private String username;
    private int rating;
    private String comment;

    public FeedbackView(int feedbackId, String username, int rating, String comment) {
        this.feedbackId = feedbackId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
    }

    public int getFeedbackId() { return feedbackId; }
    public String getUsername() { return username; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
}
