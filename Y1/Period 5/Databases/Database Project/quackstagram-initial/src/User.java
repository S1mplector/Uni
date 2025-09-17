public class User {
    private int userId;
    private String username;
    private String bio;
    private String password;
    private int postsCount;
    private int followersCount;
    private int followingCount;
    private List<Picture> pictures;

    public User(int userId, String username, String bio, String password) {
        this.userId = userId;
        this.username = username;
        this.bio = bio;
        this.password = password;
        this.pictures = new ArrayList<>();
        this.postsCount = 0;
        this.followersCount = 0;
        this.followingCount = 0;
    }

    // constructor when only username is known
    public User(int userId, String username) {
        this(userId, username, "", "");
    }

    // getters and setters
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public String getPassword() { return password; }
    public int getPostsCount() { return postsCount; }
    public void setPostsCount(int postsCount) { this.postsCount = postsCount; }
    public int getFollowersCount() { return followersCount; }
    public void setFollowersCount(int followersCount) { this.followersCount = followersCount; }
    public int getFollowingCount() { return followingCount; }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }
    public List<Picture> getPictures() { return pictures; }

    public void addPicture(Picture picture) {
        pictures.add(picture);
        postsCount++;
    }

    @Override
    public String toString() {
        return username + ":" + bio + ":" + password;
    }
}
