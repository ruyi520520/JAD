/* =====================================
    Author: Huang Ruyi
    Date: 25/11/2025
    Description: ST0510/JAD project1 - BookingDetail entity
  ====================================== */
package dbAccess.booking;

public class BookingDetail {

    private int bookingDetailId;
    private Integer bookingId;   // Null when still in cart
    private int serviceId;
    private int userId;
    private float subtotal;      // Subtotal price for this item

    public BookingDetail() {
    }

    public BookingDetail(int bookingDetailId, Integer bookingId,
                         int serviceId, int userId, float subtotal) {
        this.bookingDetailId = bookingDetailId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.userId = userId;
        this.subtotal = subtotal;
    }

    // Getters
    public int getBookingDetailId() { return bookingDetailId; }
    public Integer getBookingId() { return bookingId; }
    public int getServiceId() { return serviceId; }
    public int getUserId() { return userId; }
    public float getSubtotal() { return subtotal; }

    // Setters
    public void setBookingDetailId(int bookingDetailId) { this.bookingDetailId = bookingDetailId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setSubtotal(float subtotal) { this.subtotal = subtotal; }
}
