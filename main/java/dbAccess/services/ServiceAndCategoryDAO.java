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
import dto.AdminServiceRow;

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
    
    // get total service count

	public int getServiceCount() {
	 String sql = "SELECT COUNT(*) FROM service";
	 try (Connection conn = getConnection();
	      PreparedStatement ps = conn.prepareStatement(sql);
	      ResultSet rs = ps.executeQuery()) {
	     if (rs.next()) return rs.getInt(1);
	 } catch (Exception e) { e.printStackTrace(); }
	 return 0;
	}
	
	// get all categories
	public List<ServiceCategory> getAllCategories() {
		List<ServiceCategory> categories = new ArrayList<>();
		String sql = "SELECT category_id, category_name FROM service_category";
		try (
				Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) 
			{
				while (rs.next()) {
					ServiceCategory c = new ServiceCategory();
					c.setCategoryId(rs.getInt("category_id"));
					c.setCategoryName(rs.getString("category_name"));
					categories.add(c);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} return categories; }
	
	//Paginated list for Manage Services
	public List<AdminServiceRow> getServicesPage(int offset, int limit) {
	 List<AdminServiceRow> list = new ArrayList<>();
	 String sql =
	     "SELECT s.service_id, s.service_name, s.description, s.price, c.category_name " +
	     "FROM service s " +
	     "LEFT JOIN service_category c ON s.category_id = c.category_id " +
	     "ORDER BY s.service_id " +
	     "LIMIT ?, ?";

	 try (Connection conn = getConnection();
	      PreparedStatement ps = conn.prepareStatement(sql)) {

	     ps.setInt(1, offset);
	     ps.setInt(2, limit);

	     try (ResultSet rs = ps.executeQuery()) {
	         while (rs.next()) {
	             AdminServiceRow r = new AdminServiceRow();
	             r.setServiceId(rs.getInt("service_id"));
	             r.setServiceName(rs.getString("service_name"));
	             r.setDescription(rs.getString("description"));
	             r.setPrice(rs.getDouble("price"));
	             r.setCategoryName(rs.getString("category_name"));
	             list.add(r);
	         }
	     }
	 } catch (Exception e) {
	     e.printStackTrace();
	 }
	 return list;
	}

	//Create service
	public boolean addService(Service s) {
	 String sql = "INSERT INTO service (category_id, service_name, description, price) VALUES (?, ?, ?, ?)";

	 try (Connection conn = getConnection();
	      PreparedStatement ps = conn.prepareStatement(sql)) {

	     ps.setInt(1, s.getCategoryId());
	     ps.setString(2, s.getServiceName());
	     ps.setString(3, s.getDescription());
	     ps.setDouble(4, s.getPrice());

	     return ps.executeUpdate() > 0;

	 } catch (Exception e) {
	     e.printStackTrace();
	     return false;
	 }
	}

	//Update service
	public boolean updateService(Service s) {
	 String sql = "UPDATE service SET category_id = ?, service_name = ?, description = ?, price = ? WHERE service_id = ?";

	 try (Connection conn = getConnection();
	      PreparedStatement ps = conn.prepareStatement(sql)) {

	     ps.setInt(1, s.getCategoryId());
	     ps.setString(2, s.getServiceName());
	     ps.setString(3, s.getDescription());
	     ps.setDouble(4, s.getPrice());
	     ps.setInt(5, s.getServiceId());

	     return ps.executeUpdate() > 0;

	 } catch (Exception e) {
	     e.printStackTrace();
	     return false;
	 }
	}

	//Delete service
	public boolean deleteService(int serviceId) {
	 String sql = "DELETE FROM service WHERE service_id = ?";

	 try (Connection conn = getConnection();
	      PreparedStatement ps = conn.prepareStatement(sql)) {

	     ps.setInt(1, serviceId);
	     return ps.executeUpdate() > 0;

	 } catch (Exception e) {
	     e.printStackTrace();
	     return false;
	 }
	}

}


