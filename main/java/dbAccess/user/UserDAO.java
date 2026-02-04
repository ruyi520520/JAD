package dbAccess.user;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import dbAccess.dbConnection;

/**
 * UserDAO (Data Access Object)
 * ----------------------------
 * Provides CRUD operations for the `user` table, including profile and medical fields.
 */
public class UserDAO {

    private Connection getConnection() throws Exception {
        return dbConnection.getConnection();
    }

    /**
     * Create a user with minimal required fields.
     * Profile and medical fields are left as NULL by default.
     */
    public boolean addUser(User user) {
        String sql = "INSERT INTO `user` (username, role_id, password_hash, email) "
                   + "VALUES (?, ?, SHA2(?, 256), ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setInt(2, user.getRoleId());
            stmt.setString(3, user.getPasswordHash()); // plain password (will be hashed in SQL)
            stmt.setString(4, user.getEmail());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // get user by username
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM `user` WHERE username = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // get user by email
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM `user` WHERE email = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // read user by id
    public User getUserById(int userId) {
        String sql = "SELECT * FROM `user` WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // get all users
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM `user`";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapUser(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // delete user
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM `user` WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // check email used by another user (excluding current user)
    public boolean isEmailExistsForOtherUser(String email, int currentUserId) {
        String sql = "SELECT user_id FROM `user` WHERE email = ? AND user_id <> ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setInt(2, currentUserId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return true; // defensive: treat as exists if error
        }
    }

    /**
     * Update user fields except password_hash.
     * Password should be updated via updatePassword() for correctness and security.
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE `user` SET "
                   + "username = ?, role_id = ?, email = ?, "
                   + "full_name = ?, phone = ?, date_of_birth = ?, gender = ?, address = ?, "
                   + "allergies = ?, medical_history = ?, current_medications = ?, "
                   + "emergency_contact_name = ?, emergency_contact_phone = ?, notes = ? "
                   + "WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int i = 1;

            pstmt.setString(i++, user.getUsername());
            pstmt.setInt(i++, user.getRoleId());
            pstmt.setString(i++, user.getEmail());

            pstmt.setString(i++, user.getFullName());
            pstmt.setString(i++, user.getPhone());
            pstmt.setDate(i++, user.getDateOfBirth());
            pstmt.setString(i++, user.getGender());
            pstmt.setString(i++, user.getAddress());

            pstmt.setString(i++, user.getAllergies());
            pstmt.setString(i++, user.getMedicalHistory());
            pstmt.setString(i++, user.getCurrentMedications());

            pstmt.setString(i++, user.getEmergencyContactName());
            pstmt.setString(i++, user.getEmergencyContactPhone());
            pstmt.setString(i++, user.getNotes());

            pstmt.setInt(i++, user.getUserId());

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update password for a user.
     * The provided password is plain text and will be hashed in SQL.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE `user` SET password_hash = SHA2(?, 256) WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Convert ResultSet to User object, including profile and medical columns.
     */
    private User mapUser(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("user_id"),
            rs.getString("username"),
            rs.getInt("role_id"),
            rs.getString("password_hash"),
            rs.getString("email"),

            rs.getString("full_name"),
            rs.getString("phone"),
            rs.getDate("date_of_birth"),
            rs.getString("gender"),
            rs.getString("address"),

            rs.getString("allergies"),
            rs.getString("medical_history"),
            rs.getString("current_medications"),
            rs.getString("emergency_contact_name"),
            rs.getString("emergency_contact_phone"),
            rs.getString("notes"),

            rs.getTimestamp("created_at")
        );
    }

    // ===== Login =====
    public LoginResult verifyLogin(String username, String password) {
        String sql = "SELECT user_id FROM `user` WHERE username = ? AND password_hash = SHA2(?, 256)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 1) username exists?
            User user = getUserByUsername(username);
            if (user == null) return LoginResult.USER_NOT_FOUND;

            // 2) password correct?
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return LoginResult.SUCCESS;
            }

            return LoginResult.WRONG_PASSWORD;

        } catch (Exception e) {
            e.printStackTrace();
            return LoginResult.SERVER_ERROR;
        }
    }

    public enum LoginResult {
        SUCCESS,
        USER_NOT_FOUND,
        WRONG_PASSWORD,
        SERVER_ERROR
    }

    // ===== Register helpers =====
    public boolean isUsernameExists(String username) {
        return getUserByUsername(username) != null;
    }

    public boolean isEmailExists(String email) {
        return getUserByEmail(email) != null;
    }
}
