package dbAccess;

import java.sql.Connection;
import java.sql.DriverManager;

public class dbConnection {
    private static final String connURL = "jdbc:mysql://127.0.0.1:3306/jad_project?user=root&password=Hw135790&serverTimezone=UTC";;

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(connURL);
    }
}
