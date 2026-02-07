package dto;

import java.sql.Timestamp;
import java.util.List;

public class AdminBookingRow {
    private int bookingId;
    private String clientUsername;
    private Timestamp date;
    private double totalPrice;
    private String status;
    private String paymentStatus;
    private List<String> services;

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getClientUsername() { return clientUsername; }
    public void setClientUsername(String clientUsername) { this.clientUsername = clientUsername; }

    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public List<String> getServices() { return services; }
    public void setServices(List<String> services) { this.services = services; }
}
