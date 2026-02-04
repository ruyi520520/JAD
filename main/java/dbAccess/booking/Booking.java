/* =====================================
    Author: Huang Ruyi
    Date: 25/11/2025
    Description: ST0510/JAD project1 - Booking entity
  ====================================== */
package dbAccess.booking;

import java.sql.Date;
import java.sql.Timestamp;

public class Booking {

    private Integer bookingId;      // PK (auto increment)
    private Integer userId;         // Who made this booking
    private Date bookingDate;       // Date chosen by user
    private Timestamp createdAt;    // When the booking record was created
    private float totalPrice;       // Sum of all selected booking_detail subtotals
    private String status;          // PENDING / CONFIRMED
    private String paymentStatus;   // UNPAID / PAID ...

    public Booking() {}

    // Getters & setters
    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public float getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(float totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
