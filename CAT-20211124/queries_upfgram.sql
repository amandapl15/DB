
USE upfgram;

/*1. (2,5 punts) Llistar tots els usuaris (user) de cada grup (group), ordenats per
primer nom del grup i després per el nom d’usuari (user_name). Mostrant
el nom del grup i dels usuaris el seu nom d’usuari, nom i cognom.*/

SELECT g.`name`GRUPO,u.user_name USERNAME, u.`name` NOMBRE, u.surname APELLIDO 
FROM `group` g, `user`u , belongs b WHERE u.id = b.user_id AND g.id=b.group_id ORDER BY g.`name`, u.user_name;

/*2. (2,5 punts) Crear una vista amb el nom mutualFollowing amb un llistat dels
usuaris (user) que segueixen a altres usuaris i que alhora són seguits per
aquests, és a dir, que la relació de seguiment (follow) sigui mútua com si
fos un match.
La vista resultant només ha de tenir els identificadors i nom d’usuari
(user_name) dels usuaris. Ordeneu el resultat pels identificadors.*/

DROP VIEW IF EXISTS mutualFollowing ;
CREATE VIEW mutualFollowing AS
SELECT DISTINCT u1.id ID_FOLLOW, u1.user_name USER_FOLLOW,u2.id ID_FOLLOWED, u2.user_name USER_FOLLOWED
FROM `user`u1 JOIN follow f JOIN `user`u2 ON
f.userid_follow=u1.id AND f.userid_followed=u2.id 
AND (u1.id, u2.id) NOT IN (SELECT 
	least(userid_follow, userid_followed) as u1,
	greatest(userid_follow, userid_followed) as u2
from follow 
group BY u1, u2
having count(*)=1) AND (u2.id, u1.id) NOT IN (SELECT 
	least(userid_follow, userid_followed) as u1,
	greatest(userid_follow, userid_followed) as u2
from follow 
group BY u1, u2
having count(*)=1)
ORDER BY u1.id, u2.id;
SELECT * FROM mutualFollowing;

/*3. (2,5 punts) Mostra el nom per cada usuari (user) i quants missatges (post)
té a la xarxa. Llista tots els usuaris, tinguin o no missatges. Si no tenen
missatge, el recompte de posts es mostrarà com un 0. Ordena el resultat
mostrant primer aquells usuaris que tinguin més missatges i després pel
nom d’usuari.*/

-- SELECT u.`name`,count(p.user_write_id) FROM `user` u, post p WHERE u.id = p.user_write_id GROUP BY u.`name` ORDER BY count(p.user_write_id) DESC, u.`name` DESC;

DROP VIEW IF EXISTS countPost ;
CREATE VIEW countPost AS
SELECT user_write_id, count(user_write_id) userCount FROM post GROUP BY user_write_id ORDER by count(user_write_id) DESC;
-- SELECT * FROM countPost;

SELECT DISTINCT u.`name` NOMBRE, IFNULL(p.userCount, 0) `Nº POSTS`
FROM `user` u LEFT JOIN countPost p ON u.id = p.user_write_id
ORDER BY p.userCount DESC, u.`name` ASC;

/*4. (5 punts) Llistar el seguidor més antic de l’Anna Donoso. Mostreu el nom
d’usuari, nom i cognom del seguidor i la data en que va començar a ser
seguidor.
*/
-- SELECT id FROM `user` WHERE `name`= 'Anna' AND surname = 'Donoso';
-- SELECT * FROM follow f WHERE userid_follow IN (SELECT id FROM `user` WHERE `name`= 'Anna' AND surname = 'Donoso');

SELECT u2.user_name, u2.`name`, u2.surname, MIN(f.follow_datetime)
FROM `user` u1, `user` u2, follow f
WHERE f.userid_followed = (SELECT id FROM `user` WHERE `name` = 'Anna' AND surname = 'Donoso')
		AND f.userid_followed = u1.id
        AND f.userid_follow = u2.id;
        
/*5. (5 punts) Quins seguidors de l’Angel Gallardo SÓN MAJORS que ell?
Llistar nom, cognom i data de naixement, ordenant per data de naixement
de forma que, els primers resultats siguin els de major edat i els darrers els
més joves.*/

SELECT u2.`name`, u2.surname, u2.birthday_date
FROM `user` u1, `user` u2, follow f
WHERE f.userid_followed = (SELECT id FROM `user` WHERE `name` = 'Angel' AND surname = 'Gallardo')
		AND f.userid_followed = u1.id
        AND f.userid_follow = u2.id
        AND u1.birthday_date > u2.birthday_date;

/*6. (5 punts) Per a cada usuari a la xarxa, es desitja saber la quantitat de
seguidors que té, separant-los per gènere. El llistat ha de contenir 5
columnes: identificador de l’usuari, nom d’usuari (user_name), quantitat de
seguidors de gènere no binari, quantitat de seguidors de gènere femení i
quantitat de seguidors de gènere masculí. Ordeneu el resultat per nom
d’usuari.
Nota: Investigueu com emprar la funció IF() combinada amb COUNT() de
MySQL sobre atributs per ajudar a resoldre aquesta consulta.
*/

DROP VIEW IF EXISTS Relacion;
CREATE VIEW Relacion AS
SELECT DISTINCT u1.id ID1, u1.user_name NAME1, u1.gender GENDER1, u2.id ID2, u2.user_name NAME2, u2.gender GENDER2 
           FROM `user` u1 LEFT JOIN  follow f  ON (f.userid_follow = u1.id) RIGHT JOIN `user` u2 ON (f.userid_followed = u2.id)
ORDER BY u1.id, u2.id;

-- SELECT * FROM Relacion;

SELECT r.ID2, r.NAME2,
SUM(IF(r.GENDER1 = 'NB', 1, 0)) AS NB,
SUM(IF(r.GENDER1 = 'F' , 1, 0)) AS F,
SUM(IF(r.GENDER1 = 'M' , 1, 0)) AS M
FROM Relacion r GROUP BY r.NAME2 ORDER By r.NAME2;

/*7. (10 punts) L’Anna Puigvert vol conèixer les dates d’aniversari dels seus
seguidors per tal de poder-los felicitar arribat el moment. Per això cal
implementar una consulta que donada la data d’avui del sistema (sigui la
que sigui), llisti el nom, cognom i data de naixement dels seus seguidors,
l’aniversari més proper a la data d’avui especificada ha de ser el primer de
la llista i el darrer el més proper a final de l’any. Per tant, només s’han de
mostrar els aniversaris que queden per davant de l’any en curs.
El llistat també ha d’incloure l’edat actual del seguidor.*/
DROP VIEW IF EXISTS Relacion_birthday;
CREATE VIEW Relacion_birthday AS
SELECT DISTINCT u1.birthday_date CUMPLE1, u1.id ID1, u1.`name` NAME1,  u1.surname SURNAME1, u2.birthday_date CUMPLE2, u2.id ID2, u2.`name` NAME2, u2.surname SURNAME2
           FROM `user` u1 LEFT JOIN  follow f  ON (f.userid_follow = u1.id) RIGHT JOIN `user` u2 ON (f.userid_followed = u2.id)
ORDER BY u1.id, u2.id;

-- SELECT * FROM Relacion_birthday;

SELECT  rb.NAME1 `NAME`,  rb.SURNAME1 `SURNAME`, rb.CUMPLE1 `CUMPLE`, 
IF(Month(CURRENT_DATE())  <= Month(rb.CUMPLE1) AND DAY(CURRENT_DATE()) <= DAY(rb.CUMPLE1),
 YEAR(CURRENT_DATE())-YEAR(rb.CUMPLE1)-1,
 YEAR(CURRENT_DATE())-YEAR(rb.CUMPLE1)) EDAD FROM Relacion_birthday rb WHERE rb.NAME2 = 'Anna' AND rb.SURNAME2 = 'Puigvert' 
AND Month(CURRENT_DATE())  <= Month(rb.CUMPLE1) AND DAY(CURRENT_DATE())  <= DAY(rb.CUMPLE1);

/*8. (10 punts) Crear una vista que contingui, per a cada missatge, quants
likes i dislikes té. És a dir, una vista amb tres columnes: missatge
(identificador), quantitat de likes i quantitat de dislikes. Si un missatge no té
likes o dislikes, s'ha de mostrar un zero. Ordeneu el resultat per
l’identificador del missatge.*/

DROP VIEW IF EXISTS LIKES_DISLIKES;
CREATE VIEW LIKES_DISLIKES AS
SELECT p.id, f.`code`, p.`text` FROM post p LEFT JOIN feedback f ON p.id = f.parent_post_id;

-- SELECT * FROM LIKES_DISLIKES ;

DROP VIEW IF EXISTS Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje;
CREATE VIEW Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje AS
SELECT DISTINCT ld.id, SUM(IF(ld.`code`= 'L', 1, 0)) AS LIKES,
SUM(IF(ld.`code`= 'D', 1, 0)) AS DISLIKES FROM LIKES_DISLIKES ld GROUP BY ld.id;
SELECT * FROM Cantidad_LIKE_DISLIKE_Por_Cada_Mensaje;

/*9. (10 punts) Quins seguidors del Pere Garriga estan als grups als que ell hi
pertany? Doneu el nom i cognom del seguidor sense repetir. Ordeneu els
resultats per nom i després per cognom.*/

DROP VIEW IF EXISTS gruposSeguidoresGarriga;
CREATE VIEW gruposSeguidoresGarriga AS
SELECT u2.id, u2.`name`, u2.surname, b.group_id
FROM `user` u1, `user` u2, follow f, belongs b
WHERE f.userid_followed = (SELECT id FROM `user` WHERE `name` = 'Pere' AND surname = 'Garriga')
		AND f.userid_followed = u1.id
        AND f.userid_follow = u2.id
        AND u2.id = b.user_id
;
-- SELECT * FROM gruposSeguidoresGarriga;

DROP VIEW IF EXISTS gruposGarriga;
CREATE VIEW gruposGarriga AS
SELECT DISTINCT b.group_id
FROM `user` u1, belongs b
WHERE u1.id = (SELECT id FROM `user` WHERE `name` = 'Pere' AND surname = 'Garriga')
		AND u1.id = b.user_id
ORDER BY b.group_id
;
-- SELECT * FROM gruposGarriga;

SELECT DISTINCT gsg.`name`, gsg.surname
FROM gruposSeguidoresGarriga gsg, gruposGarriga gg
WHERE gg.group_id IN (SELECT group_id FROM gruposSeguidoresGarriga)
ORDER BY gsg.`name`, gsg.surname
;