/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Service Category servlet
==============================================================*/
package controller.user;

import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategory;
import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * CategoryServlet (Controller in MVC)
 * ----------------------------------
 * Responsibilities:
 * 1) Load all categories + services from DAO
 * 2) Group services into 4 fixed categories for the UI
 * 3) Handle empty data (404) and DAO failure (500)
 * 4) Forward to category.jsp (View)
 */
@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    private final ServiceAndCategoryDAO catDao = new ServiceAndCategoryDAO();

    // Category names used in DB (must match your existing category_name values)
    private static final String CAT_ADL = "Activities of Daily Living (ADL)";
    private static final String CAT_HEALTH = "Health & Medical Care";
    private static final String CAT_MENTAL = "Mental & Emotional Care";
    private static final String CAT_SAFETY = "Environment & Safety";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1) Load all category + service rows
            List<ServiceAndCategory> dataList = catDao.getAllServiceAndCategory();

            // 2) DAO returned null => internal error
            if (dataList == null) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Failed to load service categories.");
                return;
            }

            // 3) Prepare 4 lists for the View (default empty)
            List<Service> adlList = new ArrayList<>();
            List<Service> healthList = new ArrayList<>();
            List<Service> mentalList = new ArrayList<>();
            List<Service> safetyList = new ArrayList<>();

            // 4) Group services by category_name
            for (ServiceAndCategory sac : dataList) {
                if (sac == null || sac.getCategory() == null) continue;

                String categoryName = sac.getCategory().getCategoryName();
                Service svc = sac.getService();

                // LEFT JOIN means service can be null (category with no service)
                if (svc == null) continue;

                if (CAT_ADL.equals(categoryName)) {
                    adlList.add(svc);
                } else if (CAT_HEALTH.equals(categoryName)) {
                    healthList.add(svc);
                } else if (CAT_MENTAL.equals(categoryName)) {
                    mentalList.add(svc);
                } else if (CAT_SAFETY.equals(categoryName)) {
                    safetyList.add(svc);
                }
            }

            // 5) If all lists are empty => no services found
            if (adlList.isEmpty() && healthList.isEmpty() && mentalList.isEmpty() && safetyList.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "No services found in any category.");
                return;
            }

            // 6) Put lists into request scope for JSP rendering
            request.setAttribute("adlList", adlList);
            request.setAttribute("healthList", healthList);
            request.setAttribute("mentalList", mentalList);
            request.setAttribute("safetyList", safetyList);

            // 7) Forward to View
            request.getRequestDispatcher("/category.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Internal server error on browse services page.");
        }
    }
}
