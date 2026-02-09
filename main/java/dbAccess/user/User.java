/*=====================================
    Author: Huang Ruyi
    Date: 9/2/2026
    Description: ST0510/JAD project 2
====================================== */
package dbAccess.user;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * User (Model)
 * ------------
 * Represents a user record from the `user` table, including optional profile and medical information.
 */
public class User {
    private int userId;
    private String username;
    private int roleId;
    private String passwordHash;
    private String email;

    // Profile fields
    private String fullName;
    private String phone;
    private Date dateOfBirth;
    private String gender;     // Store as String to keep changes minimal (ENUM in DB)
    private String address;

    // Medical fields
    private String allergies;
    private String medicalHistory;
    private String currentMedications;
    private String emergencyContactName;
    private String emergencyContactPhone;
    private String notes;

    private Timestamp createdAt;

    public User() {}

    /**
     * Full constructor for mapping DB records.
     */
    public User(int userId, String username, int roleId, String passwordHash, String email,
                String fullName, String phone, Date dateOfBirth, String gender, String address,
                String allergies, String medicalHistory, String currentMedications,
                String emergencyContactName, String emergencyContactPhone, String notes,
                Timestamp createdAt) {

        this.userId = userId;
        this.username = username;
        this.roleId = roleId;
        this.passwordHash = passwordHash;
        this.email = email;

        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;

        this.allergies = allergies;
        this.medicalHistory = medicalHistory;
        this.currentMedications = currentMedications;
        this.emergencyContactName = emergencyContactName;
        this.emergencyContactPhone = emergencyContactPhone;
        this.notes = notes;

        this.createdAt = createdAt;
    }

 // Backwards-compatible constructor (old one)
    public User(int userId, String username, int roleId, String passwordHash, String email, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.roleId = roleId;
        this.passwordHash = passwordHash;
        this.email = email;
        this.createdAt = createdAt;
    }
    
    /**
     * Minimal constructor used for registration.
     */
    public User(String username, int roleId, String passwordHash, String email) {
        this.username = username;
        this.roleId = roleId;
        this.passwordHash = passwordHash;
        this.email = email;
    }

    // ===== Getters & setters =====
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }

    public String getCurrentMedications() { return currentMedications; }
    public void setCurrentMedications(String currentMedications) { this.currentMedications = currentMedications; }

    public String getEmergencyContactName() { return emergencyContactName; }
    public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

    public String getEmergencyContactPhone() { return emergencyContactPhone; }
    public void setEmergencyContactPhone(String emergencyContactPhone) { this.emergencyContactPhone = emergencyContactPhone; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
