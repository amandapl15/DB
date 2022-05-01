
DROP SCHEMA IF EXISTS upfgram;
CREATE SCHEMA IF NOT EXISTS upfgram;
USE upfgram;

CREATE TABLE `user` (
    id INT(5) PRIMARY KEY,
    user_name VARCHAR(50),
    `name` VARCHAR(50),
    surname VARCHAR(50),
    birthday_date DATE,
    gender VARCHAR(50)
);
    
CREATE TABLE follow (
    userid_follow INT(5),
    userid_followed INT(5),
    follow_datetime DATETIME,
    CONSTRAINT FK_userid_follow FOREIGN KEY (userid_follow)
        REFERENCES `user` (id),
    CONSTRAINT FK_userid_followed FOREIGN KEY (userid_followed)
        REFERENCES `user` (id)
);

CREATE TABLE `group` (
    id INT(5) PRIMARY KEY,
   `name` VARCHAR(255)
);

CREATE TABLE post (
    id INT(5) PRIMARY KEY,
   `text` VARCHAR(250),
   post_datetime DATETIME,
   reply_to_post_id INT(5),
   user_write_id INT(5),
    CONSTRAINT FK_user_write_id FOREIGN KEY (user_write_id)
        REFERENCES `user` (id),
    CONSTRAINT FK_reply_to_post_id FOREIGN KEY (reply_to_post_id)
        REFERENCES post (id)
);

CREATE TABLE feedback (
	user_id INT(5),
    parent_post_id INT(5),
    `code` VARCHAR(50),
    CONSTRAINT FK_feedback_user_id FOREIGN KEY (user_id)
		REFERENCES `user` (id),
	CONSTRAINT FK_feedback_parent_post_id FOREIGN KEY (parent_post_id)
		REFERENCES post (id)
);

CREATE TABLE belongs (
	group_id INT(5),
    user_id INT(5),
    CONSTRAINT FK_belongs_group_id FOREIGN KEY (group_id)
		REFERENCES `group` (id),
    CONSTRAINT FK_belongs_user_id FOREIGN KEY (user_id)
		REFERENCES `user` (id)	
);