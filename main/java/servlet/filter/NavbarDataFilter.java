/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project 2 - Navbar servlet
==============================================================*/
package servlet.filter;

import dbAccess.services.Service;
import dbAccess.services.ServiceAndCategory;
import dbAccess.services.ServiceAndCategoryDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

/**
 * NavbarDataFilter (Controller support for a shared View component)
 * ---------------------------------------------------------------
 * This filter prepares the dropdown data used by navBar.
 *
 * Why a Filter?
 * - navBar is included in many pages.
 * - We want to avoid writing DAO / SQL logic inside JSP (MVC best practice).
 *
 * What this filter does:
 * 1) Load (Category + Service) data using ServiceAndCategoryDAO
 * 2) Build a Map<CategoryName, List<Service>>
 * 3) Store it into request scope as "categoryServices"
 */
@WebFilter("/*") 
public class NavbarDataFilter implements Filter {

    // Reuse DAO for DB access (Model layer)
    private final ServiceAndCategoryDAO dao = new ServiceAndCategoryDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        // Only handle HTTP requests
        if (req instanceof HttpServletRequest) {

            // Map<CategoryName, List<Service>> used by navbar dropdown
            Map<String, List<Service>> categoryServices = new LinkedHashMap<>();

            try {
                // 1) Retrieve raw list from DAO
                List<ServiceAndCategory> dataList = dao.getAllServiceAndCategory();

                // 2) Convert list into category -> services map
                if (dataList != null) {
                    for (ServiceAndCategory sac : dataList) {
                        if (sac == null || sac.getCategory() == null) continue;

                        String categoryName = sac.getCategory().getCategoryName();
                        Service service = sac.getService();

                        if (categoryName == null || categoryName.trim().isEmpty()) continue;

                        categoryServices.putIfAbsent(categoryName, new ArrayList<>());

                        // service can be null because of LEFT JOIN (category with no service)
                        if (service != null) {
                            categoryServices.get(categoryName).add(service);
                        }
                    }
                }

            } catch (Exception e) {
                // If DB fails, do NOT break the whole page.
                // Just show an empty dropdown to keep UI working.
                categoryServices = new LinkedHashMap<>();
            }

            // 3) Put into request scope for navBar to use
            req.setAttribute("categoryServices", categoryServices);
        }

        // Continue the request
        chain.doFilter(req, res);
    }
}
