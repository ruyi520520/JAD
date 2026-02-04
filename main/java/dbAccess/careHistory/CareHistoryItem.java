/* ===========================================================
   Author: Huang Ruyi
   Date: 2/2/2026
   Description: ST0510/JAD project2 - Care history item (Booking + Services View Model)
==============================================================*/
package dbAccess.careHistory;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class CareHistoryItem {

    // ===== Booking-level fields =====
    private int bookingId;
    private Date bookingDate;
    private String bookingStatus;
    private double bookingSubtotal;

    // ===== Service details under this booking =====
    private List<ServiceDetail> serviceDetails = new ArrayList<>();

    // ===== Getters & Setters (Booking) =====

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public double getBookingSubtotal() {
        return bookingSubtotal;
    }

    public void setBookingSubtotal(double bookingSubtotal) {
        this.bookingSubtotal = bookingSubtotal;
    }

    public List<ServiceDetail> getServiceDetails() {
        return serviceDetails;
    }

    public void setServiceDetails(List<ServiceDetail> serviceDetails) {
        this.serviceDetails = serviceDetails;
    }

    // =========================================================
    // Inner class: Service detail (one row in booking_details)
    // =========================================================
    public static class ServiceDetail {

        private int serviceId;
        private String serviceName;
        private String serviceCategory;
        private double subtotal;

        // ===== Getters & Setters (Service) =====

        public int getServiceId() {
            return serviceId;
        }

        public void setServiceId(int serviceId) {
            this.serviceId = serviceId;
        }

        public String getServiceName() {
            return serviceName;
        }

        public void setServiceName(String serviceName) {
            this.serviceName = serviceName;
        }

        public String getServiceCategory() {
            return serviceCategory;
        }

        public void setServiceCategory(String serviceCategory) {
            this.serviceCategory = serviceCategory;
        }

        public double getSubtotal() {
            return subtotal;
        }

        public void setSubtotal(double subtotal) {
            this.subtotal = subtotal;
        }
    }
}
