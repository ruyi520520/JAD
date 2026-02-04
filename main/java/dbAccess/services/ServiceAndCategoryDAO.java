/* =====================================
    Author: Huang Ruyi
    Date: 20/11/2025
    Description: ST0510/JAD project1 - service and category DAO
  ====================================== */
package dbAccess.services;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dbAccess.dbConnection;

public class ServiceAndCategoryDAO {

    // Use shared DB connection
    private Connection getConnection() throws Exception {
        return dbConnection.getConnection();
    }

    // Retrieve data of category and service
    public List<ServiceAndCategory> getAllServiceAndCategory() {
        List<ServiceAndCategory> list = new ArrayList<>();

        String sql =
                "SELECT " +
                "  c.category_id, c.category_name, " +
                "  s.service_id, s.category_id AS s_category_id, " +
                "  s.service_name, s.description, s.image_url, s.price " +
                "FROM service_category c " +
                "LEFT JOIN service s ON c.category_id = s.category_id " +
                "ORDER BY c.category_id, s.service_id";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                // 1. Create category object
                ServiceCategory category = new ServiceCategory();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));

                // 2. Create Service object
                Service service = null;
                int serviceId = rs.getInt("service_id");
                if (!rs.wasNull()) {
                    service = new Service();
                    service.setServiceId(serviceId);
                    service.setCategoryId(rs.getInt("s_category_id"));
                    service.setServiceName(rs.getString("service_name"));
                    service.setDescription(rs.getString("description"));
                    service.setImageUrl(rs.getString("image_url"));
                    service.setPrice(rs.getDouble("price"));
                }

                // 3. Encapsulated into ServiceAndCategory
                ServiceAndCategory sac = new ServiceAndCategory();
                sac.setCategory(category);
                sac.setService(service);

                list.add(sac);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get service by service_id
    public Service getServiceById(int serviceId) {
        String sql =
            "SELECT service_id, category_id, service_name, description, image_url, price " +
            "FROM service WHERE service_id = ?";

        try (
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, serviceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setServiceName(rs.getString("service_name"));
                    s.setDescription(rs.getString("description"));
                    s.setImageUrl(rs.getString("image_url"));
                    s.setPrice(rs.getDouble("price"));
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert a record into booking_details
    public boolean insertBookingDetail(int serviceId, int userId, double subtotal) {
        String sql = "INSERT INTO booking_details (service_id, user_id, subtotal) VALUES (?, ?, ?)";

        try (
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, serviceId);
            ps.setInt(2, userId);
            ps.setDouble(3, subtotal);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
