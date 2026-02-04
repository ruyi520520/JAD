/* =====================================
	Author: Huang Ruyi
	Date: 20/11/2025
	Description: ST0510/JAD project1 - service with category entity
  ====================================== */
package dbAccess.services;

public class ServiceCategory {
    private int categoryId;
    private String categoryName;

    public ServiceCategory() {}

    public ServiceCategory(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    // Getter and setter
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}
