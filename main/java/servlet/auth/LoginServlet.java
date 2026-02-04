/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Login servlet
==============================================================*/
package servlet.auth;

import dbAccess.user.User;
import dbAccess.user.UserDAO;
import dbAccess.user.UserDAO.LoginResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginResult result = userDAO.verifyLogin(username, password);

        if (result == LoginResult.USER_NOT_FOUND) {
            request.setAttribute("error", "Invalid username");
            request.setAttribute("statusCode", HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        if (result == LoginResult.WRONG_PASSWORD) {
            request.setAttribute("error", "Password is wrong");
            request.setAttribute("statusCode", HttpServletResponse.SC_BAD_REQUEST);
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        if (result == LoginResult.SERVER_ERROR) {
            request.setAttribute("error", "Server error. Please try again.");
            request.setAttribute("statusCode", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        // SUCCESS
        User user = userDAO.getUserByUsername(username);

        if (user == null) {
            // Defensive check: theoretically should not happen
            request.setAttribute("error", "User not found.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);

        session.setAttribute("sessUserId", user.getUserId());
        session.setAttribute("sessUsername", user.getUsername());

        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }
}
