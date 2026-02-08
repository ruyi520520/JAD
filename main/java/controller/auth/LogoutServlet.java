/* ===========================================================
Author: Huang Ruyi
Date: 8/2/2026
Description: ST0510/JAD project 2 - Logout servlet
============================================================== */
package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session
        HttpSession session = request.getSession(false);

        // If session exists, invalidate it
        if (session != null) {
            session.invalidate();
        }

        // Redirect back to login page
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    }
}
