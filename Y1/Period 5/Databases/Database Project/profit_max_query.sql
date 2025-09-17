-- Profit Maximization queries

-- 1: List all users who have more than X followers where X can be any integer value.

SELECT u.username
FROM User u JOIN Follow f ON f.followed_id = u.user_id
GROUP BY u.user_id
HAVING COUNT(*) > :target_value;

-- 2. Show the total number of posts made by each user. (You will have to decide how this is done, via a username or userid)

SELECT u.username, COUNT(p.post_id)
FROM User u JOIN Post p ON p.user_id = u.user_id
GROUP BY u.user_id

-- 3. Find all comments made on a particular user’s post.

SELECT c.comment_id, c.`text`
FROM Comment AS c
JOIN Post AS p ON p.post_id = c.post_id
JOIN User AS u ON u.user_id = c.user_id
WHERE u.username = :target_username;

-- 4. Display the top X most liked posts.

SELECT p.post_id, p.caption, p.image_id, u.username AS post_owner, COUNT(l.user_id) AS like_count
FROM Post p 
JOIN `User` AS u ON u.user_id = p.user_id
LEFT JOIN `Like` AS l ON l.post_id = p.post_id
GROUP BY p.post_id, p.caption, p.image_id, u.username
ORDER BY like_count DESC 
LIMIT :top_most_liked_posts;

-- 5. Count the number of posts each user has liked

SELECT u.username, COUNT(l.post_id) AS likes_given_to_post
FROM User AS u 
LEFT JOIN `Like` AS l ON u.user_id = l.user_id
GROUP BY u.user_id, p.post_id, p.caption;

-- 6. List all the users who haven't made a post yet 

SELECT username, user_id
FROM `User` 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM Post);

-- 7. List users who dont follow each other

SELECT u1.username AS User1, u2.username AS User2
FROM Follow f1
JOIN Follow f2 ON f1.follower_id = f2.followed_id AND f1.followed_id = f2.follower_id
JOIN User u1 ON u1.user_id = f1.follower_id
JOIN User u2 ON u2.user_id = f1.followed_id
WHERE f1.follower_id < f1.followed_id;

-- 8. The user with the highest number of posts 

SELECT u.user_id, u.username, COUNT(*) AS post_count
FROM User AS u 
JOIN Post AS p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
ORDER BY post_count DESC
LIMIT 1;

-- 9. List the top X users with the most followers

SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_count
FROM User AS u 
LEFT JOIN Follow AS f ON u.user_id = f.followed_id
GROUP BY u.user_id, u.username
ORDER BY follower_count DESC 
LIMIT :x_most_followers;

-- 10. Find posts that have been liked by all users.

SELECT p.post_id, p.caption AS postname
FROM Post AS p
JOIN `Like` AS l USING(post_id)
GROUP BY p.post_id, p.caption
HAVING COUNT(DISTINCT l.user_id) = (SELECT COUNT(*) FROM `User`);

-- 11. Display the most active user (based on posts and likes).

SELECT u.user_id, u.username, 
       (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id) + COUNT(DISTINCT l.like_id)) AS activity_score
FROM User u
LEFT JOIN Post p ON p.user_id = u.user_id
LEFT JOIN Comment c ON c.user_id = u.user_id
LEFT JOIN `Like` l ON l.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY activity_score DESC
LIMIT 1;

-- 12. Find the average number of likes per post for each user.

SELECT u.user_id, u.username, AVG(like_counts.like_count) AS avg_likes_per_post
FROM User u
JOIN Post p ON u.user_id = p.user_id
LEFT JOIN (
    SELECT post_id, COUNT(user_id) AS like_count
    FROM `Like`
    GROUP BY post_id
) like_counts ON p.post_id = like_counts.post_id
GROUP BY u.user_id, u.username;

-- 13. Show posts that have more comments than likes.

SELECT p.post_id, 
p.caption, 
p.user_id, 
u.username AS post_owner, 
COUNT(DISTINCT c.post_id) AS comment_count,
COUNT(l.post_id) AS like_count
FROM Post AS p 
LEFT JOIN Comment AS c ON p.post_id = c.post_id
LEFT JOIN `Like` AS l ON p.post_id = l.post_id
LEFT JOIN User AS u ON p.user_id = u.user_id
GROUP BY p.post_id, p.caption
HAVING COUNT(c.post_id) > COUNT(l.post_id);

-- 14. List the users who have liked every post of a specific user.

SELECT u.username
FROM User u
WHERE NOT EXISTS (
    SELECT p.post_id
    FROM Post p
    WHERE p.user_id = :specific_user_id
    AND NOT EXISTS (
        SELECT 1
        FROM `Like` l
        WHERE l.post_id = p.post_id AND l.user_id = u.user_id
    )
);

-- 15. Display the most popular post of each user (based on likes).

SELECT p.user_id, p.post_id, p.caption, COUNT(l.user_id) AS like_count
FROM Post p
LEFT JOIN `Like` l ON p.post_id = l.post_id
GROUP BY p.user_id, p.post_id, p.caption
HAVING COUNT(l.user_id) = (
    SELECT MAX(like_counts)
    FROM (
        SELECT COUNT(l2.user_id) AS like_counts
        FROM Post p2
        LEFT JOIN `Like` l2 ON p2.post_id = l2.post_id
        WHERE p2.user_id = p.user_id
        GROUP BY p2.post_id
    ) AS user_like_counts
)
ORDER BY p.user_id;


-- 16. Find the user(s) with the highest ratio of followers to following

SELECT u.user_id, 
u.username,
COUNT(DISTINCT f1.follower_id) AS follower_count,
COUNT(DISTINCT f2.followed_id),
COUNT(DISTINCT f1.follower_id) * 1.0 / NULLIF(COUNT(DISTINCT f2.followed_id), 0) AS follower_to_following_ratio
FROM User AS u 
-- To count how many people follows the user 
JOIN Follow AS f1
ON u.user_id = f1.followed_id 
-- To count how many people the user follows 
JOIN Follow AS f2
ON u.user_id = f2.follower_id
GROUP BY u.user_id,
u.username, 
f1.follower_id
ORDER BY follower_to_following_ratio DESC;

-- 17. Show the month with the highest number of posts made.

SELECT COUNT(*) as post_count,
DATE_FORMAT(p.created_at, '%Y-%m') AS month
FROM Post AS p
GROUP BY month
ORDER BY post_count DESC 
LIMIT 1;

-- 18. Identify users who have not interacted with a specific user’s posts

SELECT u.user_id, u.username
FROM User u
WHERE NOT EXISTS (
    SELECT 1
    FROM Post p
    LEFT JOIN `Like` l ON l.post_id = p.post_id
    LEFT JOIN Comment c ON c.post_id = p.post_id
    WHERE p.user_id = :specific_user_id
    AND (l.user_id = u.user_id OR c.user_id = u.user_id)
)
AND u.user_id != :specific_user_id;

-- 19: Display the user with the greatest increase in followers in the last X days

SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_gain
FROM User u
JOIN Follow f ON u.user_id = f.followed_id
WHERE f.followed_at >= DATE_SUB(NOW(), INTERVAL :X_days DAY)
GROUP BY u.user_id, u.username
ORDER BY follower_gain DESC
LIMIT 1;

-- 20: Find users who are followed by more than X% of the platform users

SELECT u.user_id, u.username, COUNT(f.follower_id) AS followers_count
FROM User u
LEFT JOIN Follow f ON u.user_id = f.followed_id
GROUP BY u.user_id, u.username
HAVING followers_count > (
    (SELECT COUNT(*) FROM User) * (:percentage / 100)
);





















