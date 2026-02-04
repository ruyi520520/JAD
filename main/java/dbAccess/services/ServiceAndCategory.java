/* =====================================
	Author: Huang Ruyi
	Date: 20/11/2025
	Description: ST0510/JAD project1 - Service and category entity
  ====================================== */
package dbAccess.services;

public class ServiceAndCategory {

    private Service service;
    private ServiceCategory category;

    public ServiceAndCategory() {}

    public ServiceAndCategory(Service service, ServiceCategory category) {
        this.service = service;
        this.category = category;
    }

    // getter / setter in Service
    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    // getter / setter in Category
    public ServiceCategory getCategory() {
        return category;
    }

    public void setCategory(ServiceCategory category) {
        this.category = category;
    }
}
