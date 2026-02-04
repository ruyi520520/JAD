/* ===========================================================
   Author: Huang Ruyi
   Date: 2/2/2026
   Description: ST0510/JAD project2 - Care history DAO
==============================================================*/
package dbAccess.careHistory;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import dbAccess.dbConnection;

public class CareHistoryDAO {

    // 1. Get DB connection
    private Connection getConnection() throws Exception {
        return dbConnection.getConnection();
    }

    /**
     * Retrieve care schedule history for a user, grouped by booking.
     *
     * Filters:
     * - fromDate (nullable)
     * - toDate   (nullable)
     * - serviceId (nullable)
     */
    public List<CareHistoryItem> getCareHistory(
            int userId,
            Date fromDate,
            Date toDate,
            Integer serviceId
    ) {

        // Use map to group by booking_id while keeping order
        Map<Integer, CareHistoryItem> map = new LinkedHashMap<>();

        StringBuilder sql = new StringBuilder();
        sql.append(
            "SELECT " +
            " b.booking_id, b.`date` AS booking_date, b.status, " +
            " d.subtotal, " +
            " s.service_id, s.service_name, " +
            " c.category_name " +
            "FROM booking b " +
            "JOIN booking_details d ON b.booking_id = d.booking_id " +
            "JOIN service s ON d.service_id = s.service_id " +
            "LEFT JOIN service_category c ON s.category_id = c.category_id " +
            "WHERE d.user_id = ? "
        );

        if (fromDate != null) {
            sql.append("AND b.`date` >= ? ");
        }
        if (toDate != null) {
            sql.append("AND b.`date` <= ? ");
        }
        if (serviceId != null) {
            sql.append("AND s.service_id = ? ");
        }

        sql.append("ORDER BY b.`date` DESC, b.booking_id DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, userId);

            if (fromDate != null) {
                ps.setDate(index++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(index++, toDate);
            }
            if (serviceId != null) {
                ps.setInt(index++, serviceId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    int bookingId = rs.getInt("booking_id");

                    // 1) Get or create booking header
                    CareHistoryItem booking = map.get(bookingId);
                    if (booking == null) {
                        booking = new CareHistoryItem();
                        booking.setBookingId(bookingId);
                        booking.setBookingDate(rs.getDate("booking_date"));
                        booking.setBookingStatus(rs.getString("status"));
                        booking.setBookingSubtotal(0.0); // init
                        map.put(bookingId, booking);
                    }

                    // 2) Create a service detail row
                    CareHistoryItem.ServiceDetail detail = new CareHistoryItem.ServiceDetail();
                    detail.setServiceId(rs.getInt("service_id"));
                    detail.setServiceName(rs.getString("service_name"));
                    detail.setServiceCategory(rs.getString("category_name"));
                    detail.setSubtotal(rs.getDouble("subtotal"));

                    booking.getServiceDetails().add(detail);

                    // 3) Accumulate booking subtotal
                    booking.setBookingSubtotal(booking.getBookingSubtotal() + detail.getSubtotal());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Convert map values -> list
        return new ArrayList<>(map.values());
    }
}
