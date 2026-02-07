/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Home page servlet
==============================================================*/
package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * HomeServlet
 * -----------
 * Controller for home page.
 * Only forwards to home.jsp (View).
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If later you need to load data for home page, do it here.
        // Example:
        // request.setAttribute("xxx", data);

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
