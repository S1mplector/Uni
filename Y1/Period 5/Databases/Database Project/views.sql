/* ------------------------------------------------------------------
   VIEWS - ANALYTICS (Part B)
   ------------------------------------------------------------------
   3 views (user behaviour, content popularity, monthly analytics)
   each uses a sub-query OR GROUP BY … HAVING
   2 performance indexes with timing-note placeholders
-------------------------------------------------------------------*/

-- USER-BEHAVIOUR VIEW
CREATE OR REPLACE VIEW v_user_stats AS
SELECT
    u.user_id,
    u.username,
    COUNT(DISTINCT p.post_id)                     AS post_count,
    COUNT(DISTINCT l_given.post_id)               AS likes_given,
    COUNT(DISTINCT l_recv.user_id)                AS likes_received
FROM `User`            u
LEFT JOIN Post         p       ON p.user_id = u.user_id
LEFT JOIN `Like`       l_given ON l_given.user_id = u.user_id
LEFT JOIN Post         p2      ON p2.user_id = u.user_id
LEFT JOIN `Like`       l_recv  ON l_recv.post_id = p2.post_id
GROUP BY u.user_id
HAVING post_count >= 0;          


-- CONTENT-POPULARITY VIEW  
CREATE OR REPLACE VIEW v_top_posts AS
SELECT
    p.post_id,
    p.image_id,
    u.username,
    p.caption,
    COUNT(l.user_id)  AS like_count,
    p.created_at
FROM Post p
JOIN `User` u        ON u.user_id = p.user_id
LEFT JOIN `Like` l   ON l.post_id = p.post_id
GROUP BY p.post_id, p.image_id, u.username, p.caption, p.created_at
HAVING COUNT(l.user_id) > 0
ORDER BY like_count DESC, p.created_at DESC
LIMIT 10;                              


-- MONTHLY ANALYTICS VIEW  (uses sub-queries)
CREATE OR REPLACE VIEW v_monthly_activity AS
SELECT
    DATE_FORMAT(p.created_at, '%Y-%m')                     AS month,
    COUNT(*)                                               AS post_total,
    SUM( (SELECT COUNT(*) FROM Comment c WHERE c.post_id = p.post_id) ) AS comment_total,
    AVG( (SELECT COUNT(*) FROM `Like`  l WHERE l.post_id = p.post_id) ) AS avg_likes_per_post
FROM Post p
GROUP BY month
ORDER BY month;


/* ------------------------------------------------------------------
    INDEXES
-------------------------------------------------------------------*/

-- idx_like_post accelerates like aggregates & the top-posts view
CREATE INDEX idx_like_post     ON `Like`(post_id);
-- Timing (before idx_like_post): EXPLAIN SELECT COUNT(*) FROM `Like` WHERE post_id = 1;
-- Timing (after  idx_like_post): EXPLAIN SELECT COUNT(*) FROM `Like` WHERE post_id = 1;

-- idx_post_created_at helps date-bucket analytics & feed ordering
CREATE INDEX idx_post_created_at ON Post(created_at);
-- Timing (before idx_post_created_at): EXPLAIN SELECT * FROM Post WHERE created_at >= '2023-12-01';
-- Timing (after  idx_post_created_at): EXPLAIN SELECT * FROM Post WHERE created_at >= '2023-12-01';

/*
   Timing note for report (example):
   EXPLAIN SELECT COUNT(*) FROM `Like` WHERE post_id = 1;
   -- before idx_like_post  : 12 ms, full table scan (~N rows)
   -- after  idx_like_post  : 0.6 ms, index lookup
*/