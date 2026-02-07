package controller.user;

import dbAccess.careHistory.CareHistoryDAO;
import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategory;
import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.*;

@WebServlet("/care-history")
public class CareHistoryServlet extends HttpServlet {

    private final CareHistoryDAO historyDAO = new CareHistoryDAO();
    private final ServiceAndCategoryDAO serviceDAO = new ServiceAndCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("sessUserId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== Read filters =====
        String from = request.getParameter("fromDate");
        String to = request.getParameter("toDate");
        String serviceIdStr = request.getParameter("serviceId");

        Date fromDate = (from == null || from.isBlank()) ? null : Date.valueOf(from);
        Date toDate = (to == null || to.isBlank()) ? null : Date.valueOf(to);

        Integer serviceId = null;
        if (serviceIdStr != null && !serviceIdStr.isBlank()) {
            try {
                serviceId = Integer.valueOf(serviceIdStr);
            } catch (NumberFormatException e) {
                serviceId = null; // ignore invalid filter
            }
        }

        // ===== History data =====
        request.setAttribute("history",
            historyDAO.getCareHistory(userId, fromDate, toDate, serviceId)
        );


        // ===== Services dropdown: convert List<ServiceAndCategory> -> List<Service> =====
        List<Service> serviceList = new ArrayList<>();
        Set<Integer> seen = new HashSet<>();

        for (ServiceAndCategory sac : serviceDAO.getAllServiceAndCategory()) {
            if (sac.getService() != null) {
                int sid = sac.getService().getServiceId();
                if (seen.add(sid)) {
                    serviceList.add(sac.getService());
                }
            }
        }

        request.setAttribute("services", serviceList);

        request.getRequestDispatcher("/careHistory.jsp").forward(request, response);
    }
}
