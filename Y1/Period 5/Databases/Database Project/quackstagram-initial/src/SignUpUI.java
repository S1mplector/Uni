import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;

public class SignUpUI extends JFrame {

    private static final int WIDTH = 300;
    private static final int HEIGHT = 500;

    private JTextField txtUsername;
    private JTextField txtPassword;
    private JTextField txtBio;
    private JButton btnRegister;
    private JLabel lblPhoto;
    private JButton btnUploadPhoto;
    private final String profilePhotoStoragePath = "img/storage/profile/";
    private JButton btnSignIn;

    public SignUpUI() {
        setTitle("Quackstagram - Register");
        setSize(WIDTH, HEIGHT);
        setMinimumSize(new Dimension(WIDTH, HEIGHT));
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout(10, 10));
        initializeUI();
    }

    private void initializeUI() {
        JPanel headerPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        headerPanel.setBackground(new Color(51, 51, 51));
        JLabel lblRegister = new JLabel("Quackstagram 🐥");
        lblRegister.setFont(new Font("Arial", Font.BOLD, 16));
        lblRegister.setForeground(Color.WHITE);
        headerPanel.add(lblRegister);
        headerPanel.setPreferredSize(new Dimension(WIDTH, 40));

        lblPhoto = new JLabel();
        lblPhoto.setPreferredSize(new Dimension(80, 80));
        lblPhoto.setHorizontalAlignment(JLabel.CENTER);
        lblPhoto.setVerticalAlignment(JLabel.CENTER);
        lblPhoto.setIcon(new ImageIcon(new ImageIcon("img/logos/DACS.png").getImage().getScaledInstance(80, 80, Image.SCALE_SMOOTH)));
        JPanel photoPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        photoPanel.add(lblPhoto);

        JPanel fieldsPanel = new JPanel();
        fieldsPanel.setLayout(new BoxLayout(fieldsPanel, BoxLayout.Y_AXIS));
        fieldsPanel.setBorder(BorderFactory.createEmptyBorder(5, 20, 5, 20));

        txtUsername = new JTextField("Username");
        txtPassword = new JTextField("Password");
        txtBio = new JTextField("Bio");
        txtBio.setForeground(Color.GRAY);
        txtUsername.setForeground(Color.GRAY);
        txtPassword.setForeground(Color.GRAY);

        fieldsPanel.add(Box.createVerticalStrut(10));
        fieldsPanel.add(photoPanel);
        fieldsPanel.add(Box.createVerticalStrut(10));
        fieldsPanel.add(txtUsername);
        fieldsPanel.add(Box.createVerticalStrut(10));
        fieldsPanel.add(txtPassword);
        fieldsPanel.add(Box.createVerticalStrut(10));
        fieldsPanel.add(txtBio);

        btnUploadPhoto = new JButton("Upload Photo");
        btnUploadPhoto.addActionListener(e -> handleProfilePictureUpload());
        JPanel photoUploadPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        photoUploadPanel.add(btnUploadPhoto);
        fieldsPanel.add(photoUploadPanel);

        btnRegister = new JButton("Register");
        btnRegister.addActionListener(this::onRegisterClicked);
        btnRegister.setBackground(new Color(255, 90, 95));
        btnRegister.setForeground(Color.BLACK);
        btnRegister.setFocusPainted(false);
        btnRegister.setBorderPainted(false);
        btnRegister.setFont(new Font("Arial", Font.BOLD, 14));

        JPanel registerPanel = new JPanel(new BorderLayout());
        registerPanel.setBackground(Color.WHITE);
        registerPanel.add(btnRegister, BorderLayout.CENTER);

        btnSignIn = new JButton("Already have an account? Sign In");
        btnSignIn.addActionListener(e -> openSignInUI());
        registerPanel.add(btnSignIn, BorderLayout.SOUTH);

        add(headerPanel, BorderLayout.NORTH);
        add(fieldsPanel, BorderLayout.CENTER);
        add(registerPanel, BorderLayout.SOUTH);
    }

    private void onRegisterClicked(ActionEvent event) {
        String username = txtUsername.getText();
        String password = txtPassword.getText();
        String bio = txtBio.getText();

        if (doesUsernameExist(username)) {
            JOptionPane.showMessageDialog(this, "Username already exists. Choose another.", "Error", JOptionPane.ERROR_MESSAGE);
        } else {
            saveCredentials(username, password, bio);
            handleProfilePictureUpload();
            dispose();
            SwingUtilities.invokeLater(() -> new SignInUI().setVisible(true));
        }
    }

    private boolean doesUsernameExist(String username) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT user_id FROM User WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void saveCredentials(String username, String password, String bio) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO User(username, password, bio) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, bio);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void handleProfilePictureUpload() {
        JFileChooser chooser = new JFileChooser();
        chooser.setFileFilter(new FileNameExtensionFilter("Image files", ImageIO.getReaderFileSuffixes()));
        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            saveProfilePicture(file, txtUsername.getText());
        }
    }

    private void saveProfilePicture(File file, String username) {
        try {
            BufferedImage image = ImageIO.read(file);
            File outputFile = new File(profilePhotoStoragePath + username + ".png");
            ImageIO.write(image, "png", outputFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void openSignInUI() {
        dispose();
        SwingUtilities.invokeLater(() -> new SignInUI().setVisible(true));
    }
}
