/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package dbAccess.feedback;

public class Feedback {
    private int feedbackId;
    private int userId;
    private float rating;
    private String comment;

    public Feedback() {}

    public Feedback(int feedbackId, int userId, float rating, String comment) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
    }

    // Getters
    public int getFeedbackId() { return feedbackId; }
    public int getUserId() { return userId; }
    public float getRating() { return rating; }
    public String getComment() { return comment; }

    // Setters
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setRating(float rating) { this.rating = rating; }
    public void setComment(String comment) { this.comment = comment; }
}
