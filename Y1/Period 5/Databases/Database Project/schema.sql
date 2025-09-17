-- schema.sql

-- Drop tables if they already exist
DROP TABLE IF EXISTS Notification;
DROP TABLE IF EXISTS `Like`;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS Post;
DROP TABLE IF EXISTS `User`;

-- User
CREATE TABLE `User` (
  user_id     INT            AUTO_INCREMENT PRIMARY KEY,
  username    VARCHAR(255)   NOT NULL UNIQUE,
  password    VARCHAR(255)   NOT NULL,
  bio         TEXT,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO `User` (username, password, bio, created_at) VALUES
  ('Lorin',  'Password', 'For copyright reasons, I am not Grogu', '2023-12-17 19:00:00'),
  ('Xylo',   'Password', 'Fierce warrior, not solo',             '2023-12-17 19:05:00'),
  ('Zara',   'Password', 'Humanoid robot much like the rest',     '2023-12-17 19:10:00'),
  ('Mystar', 'Password', 'Xylo and I are not the same!',          '2023-12-17 19:15:00');

-- Post
CREATE TABLE Post (
  post_id     INT            AUTO_INCREMENT PRIMARY KEY,
  user_id     INT            NOT NULL,
  image_id    VARCHAR(100)   NOT NULL UNIQUE,
  caption     TEXT,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  like_counter INT           NOT NULL DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES `User`(user_id) ON DELETE CASCADE
);

INSERT INTO Post (user_id, image_id, caption, created_at) VALUES
  ((SELECT user_id FROM `User` WHERE username='Lorin'),  'Lorin_1',  'In the cookie jar my hand was not.', '2023-12-17 19:07:43'),
  ((SELECT user_id FROM `User` WHERE username='Lorin'),  'Lorin_2',  'Meditate I must.',                   '2023-12-17 19:09:35'),
  ((SELECT user_id FROM `User` WHERE username='Xylo'),   'Xylo_1',   'My tea strong as Force is.',         '2023-12-17 19:22:40'),
  ((SELECT user_id FROM `User` WHERE username='Xylo'),   'Xylo_2',   'Jedi mind trick failed.',            '2023-12-17 19:23:14'),
  ((SELECT user_id FROM `User` WHERE username='Zara'),   'Zara_1',   'Lost my map I have. Oops.',          '2023-12-17 19:24:31'),
  ((SELECT user_id FROM `User` WHERE username='Zara'),   'Zara_2',   'Yoga with Yoda',                     '2023-12-17 19:25:03'),
  ((SELECT user_id FROM `User` WHERE username='Mystar'), 'Mystar_1', 'Cookies gone?',                      '2023-12-17 19:26:50'),
  ((SELECT user_id FROM `User` WHERE username='Mystar'), 'Mystar_2', 'In my soup a fly is.',               '2023-12-17 19:27:24');

-- Comment
CREATE TABLE Comment (
  comment_id  INT            AUTO_INCREMENT PRIMARY KEY,
  post_id     INT            NOT NULL,
  user_id     INT            NOT NULL,
  text        TEXT           NOT NULL,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES `User`(user_id) ON DELETE CASCADE
);

INSERT INTO Comment (post_id, user_id, text, created_at) VALUES
  (1, (SELECT user_id FROM `User` WHERE username='Xylo'),   'Nice quack!',     '2023-12-17 19:08:00'),
  (3, (SELECT user_id FROM `User` WHERE username='Mystar'), 'Beautiful shot!', '2023-12-17 19:23:30');

-- Like
CREATE TABLE `Like` (
  user_id     INT            NOT NULL,
  post_id     INT            NOT NULL,
  created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, post_id),
  FOREIGN KEY (user_id) REFERENCES `User`(user_id) ON DELETE CASCADE,
  FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE
);

INSERT INTO `Like` (user_id, post_id, created_at) VALUES
  ((SELECT user_id FROM `User` WHERE username='Zara'), 1, '2023-12-17 19:29:41');

-- Follow
CREATE TABLE Follow (
  follower_id INT           NOT NULL,
  followed_id INT           NOT NULL,
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (follower_id, followed_id),
  FOREIGN KEY (follower_id) REFERENCES `User`(user_id) ON DELETE CASCADE,
  FOREIGN KEY (followed_id) REFERENCES `User`(user_id) ON DELETE CASCADE
);

INSERT INTO Follow (follower_id, followed_id, created_at) VALUES
  ((SELECT user_id FROM `User` WHERE username='Xylo'),   (SELECT user_id FROM `User` WHERE username='Lorin'),  '2023-12-17 19:30:00'),
  ((SELECT user_id FROM `User` WHERE username='Zara'),   (SELECT user_id FROM `User` WHERE username='Lorin'),  '2023-12-17 19:31:00'),
  ((SELECT user_id FROM `User` WHERE username='Mystar'), (SELECT user_id FROM `User` WHERE username='Lorin'),  '2023-12-17 19:32:00'),
  ((SELECT user_id FROM `User` WHERE username='Mystar'), (SELECT user_id FROM `User` WHERE username='Zara'),   '2023-12-17 19:33:00'),
  ((SELECT user_id FROM `User` WHERE username='Lorin'),  (SELECT user_id FROM `User` WHERE username='Mystar'), '2023-12-17 19:34:00'),
  ((SELECT user_id FROM `User` WHERE username='Lorin'),  (SELECT user_id FROM `User` WHERE username='Zara'),   '2023-12-17 19:35:00');

-- Notification
CREATE TABLE Notification (
  notif_id   INT        AUTO_INCREMENT PRIMARY KEY,
  owner_id   INT        NOT NULL,
  actor_id   INT        NOT NULL,
  post_id    INT        NULL,
  type       ENUM('like','follow') NOT NULL,
  created_at DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES `User`(user_id) ON DELETE CASCADE,
  FOREIGN KEY (actor_id) REFERENCES `User`(user_id) ON DELETE CASCADE,
  FOREIGN KEY (post_id)  REFERENCES Post(post_id) ON DELETE SET NULL
);

INSERT INTO Notification (owner_id, actor_id, post_id, type, created_at) VALUES
  (
    (SELECT user_id FROM `User` WHERE username='Lorin'),
    (SELECT user_id FROM `User` WHERE username='Zara'),
    1,
    'like',
    '2023-12-17 19:29:41'
  ),
  (
    (SELECT user_id FROM `User` WHERE username='Mystar'),
    (SELECT user_id FROM `User` WHERE username='Lorin'),
    NULL,
    'follow',
    '2023-12-17 19:34:00'
  );
  
  -- Indexes to speed up joins & deletes
CREATE INDEX idx_post_user        ON Post(user_id);
CREATE INDEX idx_comment_post     ON Comment(post_id);
CREATE INDEX idx_comment_user     ON Comment(user_id);
CREATE INDEX idx_like_user        ON `Like`(user_id);
CREATE INDEX idx_like_post        ON `Like`(post_id);
CREATE INDEX idx_follow_follower  ON Follow(follower_id);
CREATE INDEX idx_follow_followed  ON Follow(followed_id);
CREATE INDEX idx_notif_owner      ON Notification(owner_id);
CREATE INDEX idx_notif_actor      ON Notification(actor_id);
CREATE INDEX idx_notif_post       ON Notification(post_id);
CREATE INDEX idx_post_created_at  ON Post(created_at);

