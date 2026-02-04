/* =====================================
    Author: Huang Ruyi
    Date: 20/11/2025
    Description: ST0510/JAD project1 - Payment entity
  ====================================== */
package dbAccess.payments;

public class Payment {
    private int payment_id;
    private int booking_id;
    private String amount;
    private String payment_method;
    private String payment_status;
    private double transaction_id;
    private String remarks;

    public Payment() {}

    public Payment(int payment_id, int booking_id, String amount, String payment_method, String payment_status,
    		double transaction_id, String remarks) {
        this.payment_id = payment_id;
        this.booking_id = booking_id;
        this.amount = amount;
        this.payment_method = payment_method;
        this.payment_status = payment_status;
        this.transaction_id = transaction_id;
        this.remarks = remarks;
    }

    
    // Getter and setter
	public int getPayment_id() {
		return payment_id;
	}

	public void setPayment_id(int payment_id) {
		this.payment_id = payment_id;
	}

	public int getBooking_id() {
		return booking_id;
	}

	public void setBooking_id(int booking_id) {
		this.booking_id = booking_id;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getPayment_method() {
		return payment_method;
	}

	public void setPayment_method(String payment_method) {
		this.payment_method = payment_method;
	}

	public String getPayment_status() {
		return payment_status;
	}

	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}

	public double getTransaction_id() {
		return transaction_id;
	}

	public void setTransaction_id(double transaction_id) {
		this.transaction_id = transaction_id;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
    
}
