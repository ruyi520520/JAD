/* =====================================
    Author: Huang Ruyi
    Date: 20/11/2025
    Description: ST0510/JAD project1 - Payment DAO
   ====================================== */
package dbAccess.payments;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dbAccess.dbConnection;

public class PaymentDAO {

    // Get shared DB connection
    private Connection getConnection() throws Exception {
        return dbConnection.getConnection();
    }

    // Map ResultSet row to Payment object
    private Payment mapRowToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPayment_id(rs.getInt("payment_id"));
        payment.setBooking_id(rs.getInt("booking_id"));
        payment.setAmount(rs.getString("amount"));
        payment.setPayment_method(rs.getString("payment_method"));
        payment.setPayment_status(rs.getString("payment_status"));
        payment.setTransaction_id(rs.getDouble("transaction_id"));
        payment.setRemarks(rs.getString("remarks"));
        return payment;
    }

    // Get all payments
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();

        String sql = "SELECT payment_id, booking_id, amount, payment_method, " +
                     "payment_status, transaction_id, remarks " +
                     "FROM payment ORDER BY payment_id";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Payment payment = mapRowToPayment(rs);
                list.add(payment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Get a single payment by payment_id
    public Payment getPaymentById(int paymentId) {
        Payment payment = null;

        String sql = "SELECT payment_id, booking_id, amount, payment_method, " +
                     "payment_status, transaction_id, remarks " +
                     "FROM payment WHERE payment_id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, paymentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    payment = mapRowToPayment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return payment;
    }

    // Get all payments by booking_id
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> list = new ArrayList<>();

        String sql = "SELECT payment_id, booking_id, amount, payment_method, " +
                     "payment_status, transaction_id, remarks " +
                     "FROM payment WHERE booking_id = ? ORDER BY payment_id";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = mapRowToPayment(rs);
                    list.add(payment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Insert a new payment
    public boolean insertPayment(Payment payment) {
        String sql = "INSERT INTO payment " +
                     "(booking_id, amount, payment_method, payment_status, transaction_id, remarks) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            ps.setInt(1, payment.getBooking_id());
            ps.setString(2, payment.getAmount());
            ps.setString(3, payment.getPayment_method());
            ps.setString(4, payment.getPayment_status());
            ps.setDouble(5, payment.getTransaction_id());
            ps.setString(6, payment.getRemarks());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        payment.setPayment_id(rs.getInt(1));
                    }
                }
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Update an existing payment
    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE payment SET " +
                     "booking_id = ?, amount = ?, payment_method = ?, " +
                     "payment_status = ?, transaction_id = ?, remarks = ? " +
                     "WHERE payment_id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, payment.getBooking_id());
            ps.setString(2, payment.getAmount());
            ps.setString(3, payment.getPayment_method());
            ps.setString(4, payment.getPayment_status());
            ps.setDouble(5, payment.getTransaction_id());
            ps.setString(6, payment.getRemarks());
            ps.setInt(7, payment.getPayment_id());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Delete a payment
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM payment WHERE payment_id = ?";

        try (
                Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, paymentId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
