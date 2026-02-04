/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Register servlet
==============================================================*/
package servlet.auth;

import dbAccess.user.UserDAO;
import dbAccess.user.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Read parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2) Basic validation
        if (isBlank(username) || isBlank(email) || isBlank(password) || isBlank(confirmPassword)) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        if (!email.contains("@")) {
            request.setAttribute("error", "Please enter a valid email.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        // 3) Duplicate checks
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username already exists.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email already in use.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        // 4) Create user object (minimal constructor for registration)
        User newUser = new User(
                username,
                2,          // Customer
                password,   // DAO hashes
                email
        );


        // 5) Insert user
        boolean ok = userDAO.addUser(newUser);

        if (!ok) {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        /* =====================================================
           ⭐ Registered successfully -- login directly
           ===================================================== */

        // 6) Retrieve newly created user
        User user = userDAO.getUserByUsername(username);

        if (user == null) {
            // Defensive fallback
            request.setAttribute("error", "Registration succeeded but login failed.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        // 7) Create session and store login info
        HttpSession session = request.getSession(true);
        session.setAttribute("sessUserId", user.getUserId());
        session.setAttribute("sessUsername", user.getUsername());

        // 8) Redirect to home (same behavior as LoginServlet)
        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
