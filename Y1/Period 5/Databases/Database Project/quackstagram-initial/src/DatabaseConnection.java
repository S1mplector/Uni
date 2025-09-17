import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL =
      "jdbc:mysql://localhost:3306/quackstagram"
    + "?serverTimezone=UTC"
    + "&useSSL=false"
    + "&allowPublicKeyRetrieval=true";
    private static final String USER     = "quackuser";
    private static final String PASSWORD = "quackpass";
        
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Successfully connected to MySQL!");
        } catch (SQLException e) {
            System.err.println("❌ Connection failed:");
            e.printStackTrace();
        }
    }
}
