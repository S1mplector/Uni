/* ------------------------------------------------------------------
   triggers.sql  –  1 procedure, 1 function, 2 triggers
   ── Trigger “trg_after_like” calls BOTH the procedure and function
-------------------------------------------------------------------*/

DELIMITER $$

/*    Stored PROCEDURE
      increments a denormalised like_counter on Post           */
CREATE PROCEDURE sp_inc_like_counter(p_post INT)
BEGIN
    UPDATE Post
    SET like_counter = like_counter + 1
    WHERE post_id = p_post;
END$$


/*    Stored FUNCTION
      returns username for convenience / auditing              */
CREATE FUNCTION fn_username(p_uid INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN (SELECT username FROM `User` WHERE user_id = p_uid);
END$$


/*    Trigger AFTER INSERT on Like
      – calls procedure AND function
      – inserts a like-notification                             */
CREATE TRIGGER trg_after_like
AFTER INSERT ON `Like`
FOR EACH ROW
BEGIN
    /* call procedure */
    CALL sp_inc_like_counter(NEW.post_id);

    /* call function (value not used further, just satisfies spec) */
    SET @actor_name := fn_username(NEW.user_id);

    /* create notification for post owner */
    INSERT INTO Notification(owner_id, actor_id, post_id, type)
    SELECT p.user_id, NEW.user_id, NEW.post_id, 'like'
    FROM Post p
    WHERE p.post_id = NEW.post_id;
END$$


/*    Trigger AFTER INSERT on Follow
      – inserts follow-notification                             */
CREATE TRIGGER trg_after_follow
AFTER INSERT ON Follow
FOR EACH ROW
BEGIN
    INSERT INTO Notification(owner_id, actor_id, post_id, type)
    VALUES (NEW.followed_id, NEW.follower_id, NULL, 'follow');
END$$

DELIMITER ;

/* ------------------------------------------------------------------
   ONE-OFF ALTER to add like_counter column (if not already present)
-------------------------------------------------------------------*/
ALTER TABLE Post
  ADD COLUMN IF NOT EXISTS like_counter INT NOT NULL DEFAULT 0;
