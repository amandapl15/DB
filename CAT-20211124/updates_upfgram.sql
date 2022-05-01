
USE upfgram;

/*1. (5 punts) Modificar l’estructura de la taula missatges (post) per tal d’afegir
cinc camps nous:*/
	/*1. Un camp de tipus data i hora que indiqui la data del primer reply que
	s’ha fet contestant al missatge (first_reply_datetime).*/
	/*2. Un camp de tipus data i hora que indiqui la data del darrer missatge
	que s’ha fet contestant al missatge (last_reply_datetime).*/
	/*3. Un camp de tipus numèric que indiqui el número tal de missatges
	contestant que ha tingut el missatge (nb_replies).*/
	/*4. Un camp de tipus numèric que indiqui el número total de m’agrada
	(likes) que ha tingut el missatge (nb_likes).*/
	/*5. Un camp de tipus numèric que indiqui el número total de no
	m’agrada (dislikes) que ha tingut el missatge (nb_dislikes).
*/
-- Guardamos pos si acaso en una view la tabla post sin alterar

DROP VIEW IF EXISTS postView ; CREATE VIEW postView AS SELECT * FROM post;
SELECT * FROM postView;

ALTER TABLE post
ADD first_reply_datetime DATETIME DEFAULT NULL,
 ADD last_reply_datetime DATETIME DEFAULT NULL, 
 ADD nb_replies INT(5) DEFAULT '0',
 ADD nb_likes INT(5) DEFAULT '0', 
 ADD nb_dislikes INT(5) DEFAULT '0';

SELECT * FROM post;

/*2. (9 punts) Crear un procediment anomenat postUpdateRepliesInfo que
actualitzi tots dels camps acabats d’afegir ( first_reply_datetime,
last_reply_datetime, nb_replies ), tenint en compte els registres existents a
la base de dades, és a dir, que per a cada missatge (post) actualitzi la data
del primer missatge que es va escriure com a resposta, la data del darrer
missatge que es va escriure com a resposta i el número de respostes que
ha tingut el missatge en total.*/


/*DROP VIEW IF EXISTS postViewreplies ; CREATE VIEW postViewreplies AS 
SELECT DISTINCT pv.id IDR, pv.`text` textR, pv.post_datetime post_datetimeR, pv.reply_to_post_id, pv1.id ID, pv1.`text` text, pv1.post_datetime post_datetime 
FROM postView pv JOIN postView pv1 ON pv.reply_to_post_id = pv1.id;
SELECT * FROM postViewreplies;

DROP VIEW IF EXISTS postViewRepliesCountdateOldNEW ; CREATE VIEW postViewRepliesCountdateOldNEW AS 
SELECT pvr1.ID, pvr1.`text`, pvr1.IDR IDROLD, pvr1.post_datetimeR dateOLD, pvr3.IDR IDRNEW, 
pvr3.post_datetimeR dateNEW, COUNT(pvr4.IDR) countId 
FROM postViewreplies pvr1, postViewreplies pvr3, postViewreplies pvr4
WHERE pvr1.reply_to_post_id = pvr1.ID  AND pvr3.reply_to_post_id = pvr1.ID AND pvr4.reply_to_post_id = pvr1.ID
AND pvr1.post_datetimeR IN (SELECT MIN(pvr2.post_datetimeR) FROM postViewreplies pvr2 WHERE pvr1.reply_to_post_id = pvr2.ID)
AND pvr3.post_datetimeR IN (SELECT MAX(pvr2.post_datetimeR) FROM postViewreplies pvr2 WHERE pvr3.reply_to_post_id = pvr2.ID)
GROUP BY pvr1.ID, pvr4.ID;
SELECT * FROM postViewRepliesCountdateOldNEW;

UPDATE post JOIN postViewRepliesCountdateOldNEW 
ON post.id = postViewRepliesCountdateOldNEW.ID 
SET post.first_reply_datetime = postViewRepliesCountdateOldNEW.dateOLD,
 post.last_reply_datetime = postViewRepliesCountdateOldNEW.dateNEW,
 post.nb_replies = postViewRepliesCountdateOldNEW.countId;
SELECT * FROM post;*/

DELIMITER $$
	DROP PROCEDURE IF EXISTS postUpdateRepliesInfo $$
	CREATE PROCEDURE postUpdateRepliesInfo()
	BEGIN
		DROP VIEW IF EXISTS postViewreplies ; CREATE VIEW postViewreplies AS 
		SELECT DISTINCT pv.id IDR, pv.`text` textR, pv.post_datetime post_datetimeR, pv.reply_to_post_id, pv1.id ID, pv1.`text` text, pv1.post_datetime post_datetime 
		FROM postView pv JOIN postView pv1 ON pv.reply_to_post_id = pv1.id;
		-- SELECT * FROM postViewreplies;

		DROP VIEW IF EXISTS postViewRepliesCountdateOldNEW ; CREATE VIEW postViewRepliesCountdateOldNEW AS 
		SELECT pvr1.ID, pvr1.`text`, pvr1.IDR IDROLD, pvr1.post_datetimeR dateOLD,pvr3.IDR IDRNEW, 
		pvr3.post_datetimeR dateNEW, COUNT(pvr4.IDR) countId 
		FROM postViewreplies pvr1, postViewreplies pvr3, postViewreplies pvr4
		WHERE pvr1.reply_to_post_id = pvr1.ID  AND pvr3.reply_to_post_id = pvr1.ID AND pvr4.reply_to_post_id = pvr1.ID
		AND pvr1.post_datetimeR IN (SELECT MIN(pvr2.post_datetimeR) FROM postViewreplies pvr2 WHERE pvr1.reply_to_post_id = pvr2.ID)
		AND pvr3.post_datetimeR IN (SELECT MAX(pvr2.post_datetimeR) FROM postViewreplies pvr2 WHERE pvr3.reply_to_post_id = pvr2.ID)
		GROUP BY pvr1.ID, pvr3.ID;
		-- SELECT * FROM postViewRepliesCountdateOldNEW;
		
		SET SQL_SAFE_UPDATES = 0;

		UPDATE post JOIN postViewRepliesCountdateOldNEW ON post.id = postViewRepliesCountdateOldNEW.ID 
		SET post.first_reply_datetime = postViewRepliesCountdateOldNEW.dateOLD,
		 post.last_reply_datetime = postViewRepliesCountdateOldNEW.dateNEW,
		 post.nb_replies = postViewRepliesCountdateOldNEW.countId;
		
        SET SQL_SAFE_UPDATES = 1;

		 SELECT * FROM post;
END 
$$ DELIMITER ;

CALL  postUpdateRepliesInfo();

/*
3. (9 punts) Crear un disparador anomenat updatePostFeedbackInfo que
cada cop que s’insereixi un registre a la taula de m’agrada i no m’agrada
(feedback), actualitzi la informació del número de m’agrada (nb_likes) i no
m’agrada (nb_dislikes) que té el missatge, tenint en compte el que cal
modificar en cada cas. És a dir, si es fa un m’agrada (like) només s’ha
d’actualitzar el número de m’agrada del missatge i viceversa. Tret del cas
en què la informació de likes i també la de dislikes sigui zero, en aquest
cas s’han d’actualitzar ambdós.
Escriviu consultes d’inserció que forcin l’execució del disparador i
comproveu el resultat de l’execució
*/

/* views  de la act8 de queries_upfgram*/
DROP VIEW IF EXISTS LIKES_DISLIKES;
CREATE VIEW LIKES_DISLIKES AS
SELECT p.id, f.`code`, p.`text` FROM post p LEFT JOIN feedback f ON p.id = f.parent_post_id;

DROP VIEW IF EXISTS Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje;
CREATE VIEW Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje AS
SELECT DISTINCT ld.id, SUM(IF(ld.`code`= 'L', 1, 0)) AS LIKES,
SUM(IF(ld.`code`= 'D', 1, 0)) AS DISLIKES FROM LIKES_DISLIKES ld GROUP BY ld.id;

DROP TRIGGER IF EXISTS updatePostFeedbackInfo;
DELIMITER \\
CREATE TRIGGER updatePostFeedbackInfo AFTER INSERT ON feedback
	FOR EACH ROW
		BEGIN
			
        SET SQL_SAFE_UPDATES = 0;

		UPDATE post JOIN Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje ON post.id = Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje.ID
		SET post.nb_likes = Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje.LIKES,
		post.nb_dislikes = Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje.DISLIKES;
				
		SET SQL_SAFE_UPDATES = 1;
        
		END;
\\DELIMITER ;

SELECT * FROM post;

INSERT INTO feedback (user_id, parent_post_id, `code`) VALUES
(10,1,"L"),
(10,2,"D"),
(10,5,"D"),
(11,1,"D"),
(11,6,"L"),
(12,22,"L"),
(12,12,"L");
			
SELECT * FROM post;


