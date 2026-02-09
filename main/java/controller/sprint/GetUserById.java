/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.sprint;

import java.io.IOException;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import dbAccess.user.User;

@WebServlet("/GetUserById")
public class GetUserById extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uidParam = request.getParameter("uid");

        int uid;
        try {
            uid = Integer.parseInt(uidParam);
            if (uid <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            request.setAttribute("err", "NotFound");
            request.getRequestDispatcher("sprint/customManagement.jsp").forward(request, response);
            return;
        }

        Client client = ClientBuilder.newClient();
        String restUrl = "http://localhost:8081/user-ws/users/getUser/" + uid;

        WebTarget target = client.target(restUrl);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.get();

        System.out.println("status: " + resp.getStatus());

        try {
            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {

                // Read raw JSON string first (avoid default Timestamp mapping crash)
                String json = resp.readEntity(String.class);

                // Custom JSON-B config to handle Timestamp ISO strings
                JsonbConfig config = new JsonbConfig().withAdapters(new TimestampAdapter());
                Jsonb jsonb = JsonbBuilder.create(config);

                User user = jsonb.fromJson(json, User.class);

                if (user == null || user.getUserId() <= 0) {
                    request.setAttribute("err", "NotFound");
                } else {
                    request.setAttribute("userObj", user);
                }

            } else {
                request.setAttribute("err", "NotFound");
            }
        } finally {
            resp.close();
            client.close();
        }

        RequestDispatcher rd = request.getRequestDispatcher("sprint/customManagement.jsp");
        rd.forward(request, response);
    }
}
