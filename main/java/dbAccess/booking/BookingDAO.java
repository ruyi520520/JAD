/* ===========================================================
    Author: Huang Ruyi
    Date: 26/1/2026
    Description: ST0510/JAD project2 - Booking DAO
==============================================================*/
package dbAccess.booking;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import dto.AdminBookingRow;

import dbAccess.dbConnection;

public class BookingDAO {

    // 1. Get DB connection
	 private Connection getConnection() throws Exception {
	        return dbConnection.getConnection();
	 }

    /**
     * Insert a new booking record and return the generated booking_id.
     * Returns -1 if insert fails.
     */
    public int insert(Booking booking) {
        String sql = "INSERT INTO booking "
                   + "(`date`, created_at, total_price, status, payment_status) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setDate(1, booking.getBookingDate());     // `date`
            ps.setTimestamp(2, booking.getCreatedAt());  // created_at
            ps.setFloat(3, booking.getTotalPrice());     // total_price
            ps.setString(4, booking.getStatus());        // status
            ps.setString(5, booking.getPaymentStatus()); // payment_status

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);   // booking_id
                    }
                }
            }
            return -1;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }


    /**
     * Find existing PENDING booking for this user (if any).
     */
    public Booking getPendingBookingByUserId(int userId) {
        String sql =
            "SELECT b.booking_id, b.`date`, b.created_at, b.total_price, b.status, b.payment_status " +
            "FROM booking b " +
            "JOIN booking_details d ON b.booking_id = d.booking_id " +
            "WHERE d.user_id = ? AND b.status = 'PENDING' " +
            "ORDER BY b.created_at DESC " +
            "LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingDate(rs.getDate("date"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    b.setTotalPrice(rs.getFloat("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setUserId(userId);
                    return b;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    /**
     * Update an existing booking (used when continuing a draft).
     */
    public boolean update(Booking booking) {
        String sql = "UPDATE booking "
                   + "SET `date` = ?, created_at = ?, total_price = ?, status = ?, payment_status = ? "
                   + "WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, booking.getBookingDate()); 
            ps.setTimestamp(2, booking.getCreatedAt());
            ps.setFloat(3, booking.getTotalPrice());
            ps.setString(4, booking.getStatus());
            ps.setString(5, booking.getPaymentStatus());
            ps.setInt(6, booking.getBookingId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a booking by booking_id.
     */
    public boolean delete(int bookingId) {
        // 1. SQL to delete booking by ID
        String sql = "DELETE FROM booking WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 2. Bind booking_id
            ps.setInt(1, bookingId);

            // 3. Execute delete
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            // 4. Log and return false if any error
            e.printStackTrace();
            return false;
        }
    }
    
    // get total booking count
    public int getBookingCount() {
    	 String sql = "SELECT COUNT(*) FROM booking";
    	 try (Connection conn = getConnection();
    	      PreparedStatement ps = conn.prepareStatement(sql);
    	      ResultSet rs = ps.executeQuery()) {
    	     if (rs.next()) return rs.getInt(1);
    	 } catch (Exception e) { e.printStackTrace(); }
    	 return 0;
    	}
    
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();

        String sql =
            "SELECT DISTINCT b.booking_id, b.`date`, b.created_at, b.total_price, b.status, b.payment_status " +
            "FROM booking b " +
            "JOIN booking_details bd ON b.booking_id = bd.booking_id " +
            "WHERE bd.user_id = ? " +
            "ORDER BY b.`date` DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingDate(rs.getDate("date"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    b.setTotalPrice(rs.getFloat("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setUserId(userId);
                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


 // Admin: get booking by id
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT booking_id, `date`, created_at, total_price, status, payment_status FROM booking WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingDate(rs.getDate("date"));          // if your column is DATE, keep this
                    b.setCreatedAt(rs.getTimestamp("created_at")); // timestamp
                    b.setTotalPrice(rs.getFloat("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    return b;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Admin: update editable fields
    public boolean updateAdminBooking(int bookingId, java.sql.Timestamp dateTime, float totalPrice,
                                      String status, String paymentStatus) {

        String sql = "UPDATE booking SET `date` = ?, total_price = ?, status = ?, payment_status = ? WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, dateTime);
            ps.setFloat(2, totalPrice);
            ps.setString(3, status);
            ps.setString(4, paymentStatus);
            ps.setInt(5, bookingId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countBookings() {
        String sql = "SELECT COUNT(*) FROM booking";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean deleteBookingById(int bookingId) {
        String sql = "DELETE FROM booking WHERE booking_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<AdminBookingRow> getAdminBookingRowsPage(int offset, int limit) {
        List<AdminBookingRow> list = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, b.`date`, b.total_price, b.status, b.payment_status, u.username " +
            "FROM booking b " +
            "JOIN booking_details bd ON b.booking_id = bd.booking_id " +
            "JOIN user u ON bd.user_id = u.user_id " +
            "GROUP BY b.booking_id, b.`date`, b.total_price, b.status, b.payment_status, u.username " +
            "ORDER BY b.booking_id " +
            "LIMIT ?, ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminBookingRow row = new AdminBookingRow();
                    row.setBookingId(rs.getInt("booking_id"));
                    row.setClientUsername(rs.getString("username"));
                    row.setDate(rs.getTimestamp("date"));
                    row.setTotalPrice(rs.getDouble("total_price"));
                    row.setStatus(rs.getString("status"));
                    row.setPaymentStatus(rs.getString("payment_status"));
                    list.add(row);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Retrieve a booking by bookingId and validate it belongs to the given user.
     * This is used for loading/editing a user's draft booking safely.
     */
    public Booking getBookingByIdForUser(int bookingId, int userId) {
        String sql =
            "SELECT b.booking_id, b.`date`, b.created_at, b.total_price, b.status, b.payment_status " +
            "FROM booking b " +
            "JOIN booking_details d ON b.booking_id = d.booking_id " +
            "WHERE b.booking_id = ? AND d.user_id = ? " +
            "LIMIT 1";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setBookingDate(rs.getDate("date"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    b.setTotalPrice(rs.getFloat("total_price"));
                    b.setStatus(rs.getString("status"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setUserId(userId);
                    return b;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
