/* =====================================
	Author: Huang Ruyi
	Date: 20/11/2025
	Description: ST0510/JAD project1 - Service entity
  ====================================== */
package dbAccess.services;

public class Service {
    private int serviceId;
    private int categoryId;
    private String serviceName;
    private String description;
    private String imageUrl;
    private double price;

    public Service() {}

    public Service(int serviceId, int categoryId, String serviceName,
                   String description, String imageUrl, double price) {
        this.serviceId = serviceId;
        this.categoryId = categoryId;
        this.serviceName = serviceName;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
    }

    // Getter and setter
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
