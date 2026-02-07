package dto;

import java.util.List;
import dbAccess.booking.Booking;

public class BookingWithServices {
    private Booking booking;
    private List<String> services;

    public BookingWithServices() {}

    public BookingWithServices(Booking booking, List<String> services) {
        this.booking = booking;
        this.services = services;
    }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public List<String> getServices() { return services; }
    public void setServices(List<String> services) { this.services = services; }
}
