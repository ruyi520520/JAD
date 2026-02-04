/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project2 - BookingDetail DAO
==============================================================*/
package dbAccess.booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dbAccess.dbConnection;

public class BookingDetailDAO {

    // 1. Get DB connection
	private Connection getConnection() throws Exception {
        return dbConnection.getConnection();
	}
	
    /**
     * Insert a new cart item into booking_details.
     * No quantity field. Each record represents 1 service with its subtotal.
     */
    public boolean insert(BookingDetail detail) {
        String sql = "INSERT INTO booking_details (booking_id, service_id, user_id, subtotal) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 1. booking_id (can be null when still in cart)
            if (detail.getBookingId() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, detail.getBookingId());
            }

            // 2. Basic fields
            ps.setInt(2, detail.getServiceId());
            ps.setInt(3, detail.getUserId());
            ps.setFloat(4, detail.getSubtotal());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Load all cart items for a user.
     * booking_id IS NULL means item is still in cart (not checked out yet).
     */
    public List<BookingDetail> getCartByUserId(int userId) {
        List<BookingDetail> list = new ArrayList<>();

        String sql = "SELECT booking_detail_id, booking_id, service_id, user_id, subtotal "
                   + "FROM booking_details "
                   + "WHERE user_id = ? AND booking_id IS NULL";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetail bd = new BookingDetail();
                    bd.setBookingDetailId(rs.getInt("booking_detail_id"));

                    int bookingId = rs.getInt("booking_id");
                    if (rs.wasNull()) {
                        bd.setBookingId(null);
                    } else {
                        bd.setBookingId(bookingId);
                    }

                    bd.setServiceId(rs.getInt("service_id"));
                    bd.setUserId(rs.getInt("user_id"));
                    bd.setSubtotal(rs.getFloat("subtotal"));

                    list.add(bd);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /** Delete selected cart records */
    public boolean deleteBookingDetails(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return false;

        // Build placeholders (?, ?, ?) for the IN clause
        StringBuilder sb = new StringBuilder();
        sb.append("DELETE FROM booking_details WHERE booking_detail_id IN (");
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        sb.append(")");

        String sql = sb.toString();

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            for (Integer id : ids) {
                ps.setInt(index++, id);
            }

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Attach *all* cart items of a user to a given booking.
     * booking_id IS NULL means "still in cart".
     */
    public boolean attachCartItemsToBooking(int userId, int bookingId) {
        String sql = "UPDATE booking_details "
                   + "SET booking_id = ? "
                   + "WHERE user_id = ? AND booking_id IS NULL";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Load specific cart items by their IDs (still in cart).
     */
	public List<BookingDetail> getCartItemsByIds(List<Integer> ids) {
	    List<BookingDetail> list = new ArrayList<>();
	    if (ids == null || ids.isEmpty()) {
	        return list;
	    }
	
	    StringBuilder sb = new StringBuilder();
	    sb.append("SELECT booking_detail_id, booking_id, service_id, user_id, subtotal ")
	      .append("FROM booking_details WHERE booking_detail_id IN (");
	    for (int i = 0; i < ids.size(); i++) {
	        if (i > 0) sb.append(",");
	        sb.append("?");
	    }
	    sb.append(")");
	
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sb.toString())) {
	
	        int index = 1;
	        for (Integer id : ids) {
	            ps.setInt(index++, id);
	        }
	
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                BookingDetail bd = new BookingDetail();
	                bd.setBookingDetailId(rs.getInt("booking_detail_id"));
	
	                int bookingId = rs.getInt("booking_id");
	                if (rs.wasNull()) {
	                    bd.setBookingId(null);
	                } else {
	                    bd.setBookingId(bookingId);
	                }
	
	                bd.setServiceId(rs.getInt("service_id"));
	                bd.setUserId(rs.getInt("user_id"));
	                bd.setSubtotal(rs.getFloat("subtotal"));
	
	                list.add(bd);
	            }
	        }
	
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	
	    return list;
	}


    /**
     * Attach *selected* cart items to a booking by their IDs.
     */
	public boolean attachCartItemsToBooking(List<Integer> ids, int bookingId) {
	    if (ids == null || ids.isEmpty()) return false;
	
	    StringBuilder sb = new StringBuilder();
	    sb.append("UPDATE booking_details SET booking_id = ? ")
	      .append("WHERE booking_detail_id IN (");
	    for (int i = 0; i < ids.size(); i++) {
	        if (i > 0) sb.append(",");
	        sb.append("?");
	    }
	    sb.append(")");
	
	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sb.toString())) {
	
	        int index = 1;
	        ps.setInt(index++, bookingId);
	        for (Integer id : ids) {
	            ps.setInt(index++, id);
	        }
	
	        int rows = ps.executeUpdate();
	        return rows > 0;
	
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

    /**
     *  Get booking_detail_id list by booking_id
     */
	public List<Integer> getDetailIdsByBookingId(int bookingId) {
	    List<Integer> ids = new ArrayList<>();
	    String sql = "SELECT booking_detail_id FROM booking_details WHERE booking_id = ?";

	    try (Connection conn = getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, bookingId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                ids.add(rs.getInt("booking_detail_id"));
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return ids;
	}

    /**
     * Clear booking_id for all details that belong to a booking.
     */
    public boolean clearBookingIdByBookingId(int bookingId) {
        // 1. SQL to set booking_id = NULL for all rows with this booking_id
        String sql = "UPDATE booking_details SET booking_id = NULL WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 2. Bind booking_id
            ps.setInt(1, bookingId);

            // 3. Execute update
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            // 4. Log and return false if any error
            e.printStackTrace();
            return false;
        }
    }


}
