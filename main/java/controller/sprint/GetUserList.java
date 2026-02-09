/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package controller.sprint;

import java.io.IOException;
import java.util.ArrayList;

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

@WebServlet("/GetUserList")
public class GetUserList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Client client = ClientBuilder.newClient();
        String restUrl = "http://localhost:8081/user-ws/users/getAllUsers";

        WebTarget target = client.target(restUrl);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.get();

        System.out.println("status: " + resp.getStatus());

        try {
            if (resp.getStatus() == Response.Status.OK.getStatusCode()) {

                String json = resp.readEntity(String.class);

                JsonbConfig config = new JsonbConfig()
                        .withAdapters(new TimestampAdapter());
                Jsonb jsonb = JsonbBuilder.create(config);

                User[] users = jsonb.fromJson(json, User[].class);

                ArrayList<User> al = new ArrayList<>();
                if (users != null) {
                    for (User u : users) {
                        al.add(u);
                    }
                }

                request.setAttribute("userArray", al);

            } else {
                request.setAttribute("err", "NotFound");
            }
        } finally {
            resp.close();
            client.close();
        }

        RequestDispatcher rd =
                request.getRequestDispatcher("sprint/customManagement.jsp");
        rd.forward(request, response);
    }
}