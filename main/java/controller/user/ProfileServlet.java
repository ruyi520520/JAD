/*=====================================
    Author: Huang Ruyi
    Date: 4/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.user;

import dbAccess.user.User;
import dbAccess.user.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("sessUserId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        User user = userDAO.getUserById(userId);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("sessUserId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        User current = userDAO.getUserById(userId);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // ===== Read form fields =====
        String email = trim(request.getParameter("email"));

        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phone"));
        String dobStr = trim(request.getParameter("dateOfBirth")); // yyyy-mm-dd
        String gender = trim(request.getParameter("gender"));
        String address = trim(request.getParameter("address"));

        String allergies = trim(request.getParameter("allergies"));
        String medicalHistory = trim(request.getParameter("medicalHistory"));
        String currentMedications = trim(request.getParameter("currentMedications"));
        String emergencyContactName = trim(request.getParameter("emergencyContactName"));
        String emergencyContactPhone = trim(request.getParameter("emergencyContactPhone"));
        String notes = trim(request.getParameter("notes"));

        // password fields (optional)
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // ===== Validation =====
        if (isBlank(email) || !email.contains("@")) {
            request.setAttribute("error", "Please enter a valid email.");
            request.setAttribute("user", current);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // email duplicate (excluding self)
        if (userDAO.isEmailExistsForOtherUser(email, userId)) {
            request.setAttribute("error", "Email already in use.");
            request.setAttribute("user", current);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // Parse DOB (optional)
        Date dob = null;
        if (!isBlank(dobStr)) {
            try {
                dob = Date.valueOf(dobStr); // expects yyyy-mm-dd
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid Date of Birth format.");
                request.setAttribute("user", current);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
        }

        // Validate gender (optional, but must match ENUM if provided)
        // allowed: MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY
        if (!isBlank(gender)) {
            boolean okGender =
                    gender.equals("MALE") ||
                    gender.equals("FEMALE") ||
                    gender.equals("OTHER") ||
                    gender.equals("PREFER_NOT_TO_SAY");
            if (!okGender) gender = "PREFER_NOT_TO_SAY";
        } else {
            gender = "PREFER_NOT_TO_SAY";
        }

        // Password update check (only if user entered something)
        boolean wantsPasswordChange = !isBlank(newPassword) || !isBlank(confirmNewPassword);
        if (wantsPasswordChange) {
            if (isBlank(newPassword) || isBlank(confirmNewPassword)) {
                request.setAttribute("error", "To change password, please fill in both password fields.");
                request.setAttribute("user", current);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(confirmNewPassword)) {
                request.setAttribute("error", "New passwords do not match.");
                request.setAttribute("user", current);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            if (newPassword.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters.");
                request.setAttribute("user", current);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
        }

        // ===== Build updated user object =====
        // keep immutable fields: userId, username, roleId, passwordHash, createdAt
        User updated = new User();
        updated.setUserId(current.getUserId());
        updated.setUsername(current.getUsername());
        updated.setRoleId(current.getRoleId());
        updated.setPasswordHash(current.getPasswordHash()); // not used in updateUser()
        updated.setCreatedAt(current.getCreatedAt());

        // update allowed fields
        updated.setEmail(email);

        updated.setFullName(fullName);
        updated.setPhone(phone);
        updated.setDateOfBirth(dob);
        updated.setGender(gender);
        updated.setAddress(address);

        updated.setAllergies(allergies);
        updated.setMedicalHistory(medicalHistory);
        updated.setCurrentMedications(currentMedications);

        updated.setEmergencyContactName(emergencyContactName);
        updated.setEmergencyContactPhone(emergencyContactPhone);
        updated.setNotes(notes);

        // ===== Persist =====
        boolean okProfile = userDAO.updateUser(updated);
        if (!okProfile) {
            request.setAttribute("error", "Profile update failed. Please try again.");
            request.setAttribute("user", current);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        if (wantsPasswordChange) {
            boolean okPwd = userDAO.updatePassword(userId, newPassword);
            if (!okPwd) {
                request.setAttribute("error", "Profile updated, but password update failed.");
                request.setAttribute("user", userDAO.getUserById(userId));
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
        }

        // Reload fresh user
        User reloaded = userDAO.getUserById(userId);
        request.setAttribute("user", reloaded);
        request.setAttribute("success", wantsPasswordChange
                ? "Profile and password updated successfully."
                : "Profile updated successfully.");
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
