<!-- =====================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Feedback (View only, MVC)
====================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dbAccess.feedback.FeedbackView" %>

<%
    // 1) Read session user info
    Integer sessUserId = (Integer) session.getAttribute("sessUserId");

    // 2) Read servlet-prepared data
    String formMode = (String) request.getAttribute("formMode");
    if (formMode == null) formMode = "create";

    Integer editFeedbackId = (Integer) request.getAttribute("editFeedbackId");
    Integer editRating = (Integer) request.getAttribute("editRating");
    String editComment = (String) request.getAttribute("editComment");

    List<FeedbackView> myFeedbackList =
            (List<FeedbackView>) request.getAttribute("myFeedbackList");
    if (myFeedbackList == null) myFeedbackList = new ArrayList<>();

    List<FeedbackView> othersFeedbackList =
            (List<FeedbackView>) request.getAttribute("othersFeedbackList");
    if (othersFeedbackList == null) othersFeedbackList = new ArrayList<>();

    // 3) Success message from PRG redirect
    String msg = request.getParameter("msg");
    String fbMessage = null;
    if ("created".equals(msg)) fbMessage = "Thank you for your feedback.";
    if ("updated".equals(msg)) fbMessage = "Your feedback has been updated.";
    if ("deleted".equals(msg)) fbMessage = "Your feedback has been deleted.";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Feedback</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background-color: #F7F9FB;
            color: #2C3E50;
        }

        a { text-decoration: none; }

        .page-wrapper {
            max-width: 1100px;
            margin: 0 auto;
            padding: 32px 20px 60px;
        }

        .page-header { margin-bottom: 24px; }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin: 0 0 6px;
        }

        .page-subtitle {
            font-size: 13px;
            color: #7F8C8D;
            max-width: 600px;
        }

        .feedback-layout {
            display: grid;
            grid-template-columns: minmax(0, 1.2fr) minmax(0, 1fr);
            gap: 20px;
            align-items: flex-start;
            margin-bottom: 32px;
        }

        @media (max-width: 880px) {
            .feedback-layout { grid-template-columns: 1fr; }
        }

        .card {
            background-color: #FFFFFF;
            border-radius: 14px;
            box-shadow: 0 8px 22px rgba(0,0,0,0.06);
            padding: 18px 18px 20px;
        }

        .card-header { margin-bottom: 10px; }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 4px;
        }

        .card-subtitle {
            font-size: 12px;
            color: #95A5A6;
            margin: 0;
        }

        .message {
            margin-bottom: 12px;
            padding: 8px 10px;
            border-radius: 6px;
            font-size: 13px;
        }

        .message.success {
            background-color: #E9F7EF;
            color: #1E8449;
            border: 1px solid #A9DFBF;
        }

        .login-hint {
            font-size: 13px;
            color: #7F8C8D;
        }

        .login-hint a {
            color: #E67E22;
            font-weight: 600;
        }

        .feedback-form {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-top: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 500;
            display: block;
            margin-bottom: 4px;
        }

        .comment-textarea {
            width: 100%;
            min-height: 80px;
            resize: vertical;
            padding: 8px 10px;
            border-radius: 8px;
            border: 1px solid #D0D7DE;
            font-size: 13px;
            font-family: inherit;
        }

        .form-note {
            font-size: 11px;
            color: #95A5A6;
        }

        .btn-primary {
            border-radius: 999px;
            background-color: #E67E22;
            color: #FFFFFF;
            border: none;
            padding: 9px 22px;
            font-size: 13px;
            cursor: pointer;
            margin-top: 6px;
        }

        .btn-primary:hover { background-color: #D35400; }

        .feedback-section-title {
            font-size: 17px;
            font-weight: 600;
            margin: 0 0 10px;
        }

        .feedback-list {
            list-style: none;
            padding-left: 0;
            margin: 0;
        }

        .feedback-item {
            border-bottom: 1px solid #ECF0F1;
            padding: 10px 0;
        }

        .feedback-item:last-child { border-bottom: none; }

        .fb-username {
            font-size: 13px;
            font-weight: 600;
        }

        .fb-rating {
            font-size: 12px;
            color: #F39C12;
            margin-top: 2px;
        }

        .fb-comment {
            font-size: 13px;
            color: #4A4A4A;
            margin-top: 4px;
            line-height: 1.5;
        }

        .fb-empty {
            font-size: 12px;
            color: #95A5A6;
            padding: 4px 0;
        }

        .star-rating {
            display: flex;
            gap: 12px;
            cursor: pointer;
            margin: 6px 0 8px;
        }

        .star {
            font-size: 36px;
            color: #D0D7DE;
            transition: color 0.2s;
        }

        .star:hover,
        .star.hovered { color: #F5B041; }

        .star.selected { color: #E67E22; }

        .feedback-actions {
            margin-top: 6px;
            display: flex;
            gap: 8px;
        }

        .btn-secondary,
        .btn-danger {
            border-radius: 999px;
            border: none;
            padding: 4px 10px;
            font-size: 11px;
            cursor: pointer;
        }

        .btn-secondary {
            background-color: #ECF0F1;
            color: #2C3E50;
        }

        .btn-secondary:hover { background-color: #D5D8DC; }

        .btn-danger {
            background-color: #E74C3C;
            color: #FFFFFF;
        }

        .btn-danger:hover { background-color: #C0392B; }

        .page-foot-note {
            font-size: 12px;
            color: #95A5A6;
            text-align: center;
            margin-top: 12px;
        }
    </style>
</head>
<body>

    <%-- Global navbar include --%>
    <%@ include file="webContent/navBar.jsp" %>

    <div class="page-wrapper">
        <header class="page-header">
            <h1 class="page-title">Feedback</h1>
            <p class="page-subtitle">
                Share your experience with our home care services, and see what other families have said.
            </p>
        </header>

        <div class="feedback-layout">

            <!-- Left column: form + user's history -->
            <section class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <%= "update".equals(formMode) ? "Edit your feedback" : "Your feedback" %>
                    </h2>
                    <p class="card-subtitle">
                        We really appreciate your comments – it helps us improve our services.
                    </p>
                </div>

                <% if (fbMessage != null) { %>
                    <div class="message success"><%= fbMessage %></div>
                <% } %>

                <% if (sessUserId == null) { %>
                    <p class="login-hint">
                        Please <a href="<%= request.getContextPath() %>/login">log in</a> to leave feedback.
                    </p>
                <% } else { %>
                    <!-- Feedback form -->
                    <form method="post"
                          action="<%= request.getContextPath() %>/feedback"
                          class="feedback-form">

                        <input type="hidden" name="action" value="<%= "update".equals(formMode) ? "update" : "create" %>">

                        <% if ("update".equals(formMode) && editFeedbackId != null) { %>
                            <input type="hidden" name="feedback_id" value="<%= editFeedbackId %>">
                        <% } %>

                        <div class="form-group">
                            <label for="ratingInput">Rating</label>

                            <div class="star-rating"
                                 id="starRating"
                                 data-current-rating="<%= (editRating != null ? editRating : 0) %>">
                                <span class="star" data-value="1">&#9733;</span>
                                <span class="star" data-value="2">&#9733;</span>
                                <span class="star" data-value="3">&#9733;</span>
                                <span class="star" data-value="4">&#9733;</span>
                                <span class="star" data-value="5">&#9733;</span>
                            </div>

                            <input type="hidden" name="rating" id="ratingInput" required>

                            <p class="form-note">Click the stars to select your rating (1 to 5).</p>
                        </div>

                        <div class="form-group">
                            <label for="comment">Comment (optional)</label>
                            <textarea id="comment" name="comment" class="comment-textarea"
                                      placeholder="You can share what went well, and what we can do better."><%= (editComment != null ? editComment : "") %></textarea>
                        </div>

                        <button type="submit" class="btn-primary">
                            <%= "update".equals(formMode) ? "Update feedback" : "Submit feedback" %>
                        </button>
                    </form>
                <% } %>

                <hr style="border:none;border-top:1px solid #ECF0F1;margin:18px 0 10px;" />

                <h3 class="feedback-section-title">Your past feedback</h3>

                <ul class="feedback-list">
                    <% if (sessUserId == null) { %>
                        <li class="fb-empty">Log in to see your own feedback history.</li>
                    <% } else if (myFeedbackList.isEmpty()) { %>
                        <li class="fb-empty">You have not submitted any feedback yet.</li>
                    <% } else { %>
                        <% for (FeedbackView fb : myFeedbackList) { %>
                            <li class="feedback-item">
                                <div class="fb-username"><%= fb.getUsername() %></div>
                                <div class="fb-rating">★ <%= fb.getRating() %> / 5</div>

                                <div class="fb-comment">
                                    <%
                                        String cmt = fb.getComment();
                                        if (cmt == null || cmt.trim().isEmpty()) {
                                            out.print("(No comment)");
                                        } else {
                                            out.print(cmt);
                                        }
                                    %>
                                </div>

                                <div class="feedback-actions">
                                    <!-- Edit (GET) -->
                                    <form method="get" action="<%= request.getContextPath() %>/feedback" style="display:inline;">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" name="feedback_id" value="<%= fb.getFeedbackId() %>">
                                        <button type="submit" class="btn-secondary">Edit</button>
                                    </form>

                                    <!-- Delete (POST) -->
                                    <form method="post" action="<%= request.getContextPath() %>/feedback"
                                          style="display:inline;"
                                          onsubmit="return confirm('Are you sure you want to delete this feedback?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="feedback_id" value="<%= fb.getFeedbackId() %>">
                                        <button type="submit" class="btn-danger">Delete</button>
                                    </form>
                                </div>
                            </li>
                        <% } %>
                    <% } %>
                </ul>
            </section>

            <!-- Right column: other users -->
            <section class="card">
                <div class="card-header">
                    <h2 class="card-title">Other users' feedback</h2>
                    <p class="card-subtitle">See what other families say about our services.</p>
                </div>

                <ul class="feedback-list">
                    <% if (othersFeedbackList.isEmpty()) { %>
                        <li class="fb-empty">There is no feedback yet. Be the first to leave one.</li>
                    <% } else { %>
                        <% for (FeedbackView fb : othersFeedbackList) { %>
                            <li class="feedback-item">
                                <div class="fb-username"><%= fb.getUsername() %></div>
                                <div class="fb-rating">★ <%= fb.getRating() %> / 5</div>
                                <div class="fb-comment">
                                    <%
                                        String cmt2 = fb.getComment();
                                        if (cmt2 == null || cmt2.trim().isEmpty()) {
                                            out.print("(No comment)");
                                        } else {
                                            out.print(cmt2);
                                        }
                                    %>
                                </div>
                            </li>
                        <% } %>
                    <% } %>
                </ul>
            </section>

        </div>

        <p class="page-foot-note">
            Your feedback will be stored in the <code>feedback</code> table with your user ID, integer rating (1 to 5) and comment.
        </p>
    </div>

    <%@ include file="webContent/footer.jsp" %>

    <!-- Star rating script (integer only, supports edit mode) -->
    <script>
        (function () {
            const ratingContainer = document.getElementById('starRating');
            const ratingInput = document.getElementById('ratingInput');

            if (!ratingContainer || !ratingInput) return;

            const stars = ratingContainer.querySelectorAll('.star');
            const initialRatingAttr = ratingContainer.getAttribute('data-current-rating') || '0';
            let selectedRating = parseInt(initialRatingAttr, 10) || 0;

            function applySelectedRating() {
                stars.forEach(s => {
                    const v = parseInt(s.getAttribute('data-value'), 10);
                    s.classList.toggle('selected', v <= selectedRating);
                    s.classList.remove('hovered');
                });
                if (selectedRating > 0) ratingInput.value = selectedRating;
            }

            applySelectedRating();

            stars.forEach(star => {
                star.addEventListener('mouseover', () => {
                    const value = parseInt(star.getAttribute('data-value'), 10);
                    stars.forEach(s => {
                        const v = parseInt(s.getAttribute('data-value'), 10);
                        s.classList.toggle('hovered', v <= value);
                    });
                });

                star.addEventListener('mouseout', () => {
                    stars.forEach(s => s.classList.remove('hovered'));
                });

                star.addEventListener('click', () => {
                    selectedRating = parseInt(star.getAttribute('data-value'), 10);
                    ratingInput.value = selectedRating;
                    stars.forEach(s => {
                        const v = parseInt(s.getAttribute('data-value'), 10);
                        s.classList.toggle('selected', v <= selectedRating);
                    });
                });
            });

            ratingContainer.addEventListener('mouseleave', applySelectedRating);
        })();
    </script>

</body>
</html>
