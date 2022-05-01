

/*4.2.1. Mostreu el nom dels negocis ( business ) que pertanyen a la categoria ( category ) de
“Farmàcia”. Ordeneu els resultats per nom.*/

SELECT  b.`name` Nom FROM business b,  category c
WHERE b.category_id = c.category_id AND c.description = 'Farmacia'
ORDER BY b.`name`;

/*4.2.2. Consulta 2 ( 4 punts )
Mostreu el nom de les categories de negoci les quals comencen per “Perruqueria”. Ordeneu
els resultats pel nom de la categoria de forma ascendent.*/

SELECT c.`description`
FROM category c
WHERE c.`description` LIKE "Perruqueria%"
ORDER BY c.`description` ASC;

/*4.2.3. Consulta 3 ( 4 punts )
Seleccioneu el nom i la distància entre els negocis ( bussines ) i el local de l’empresa de
repartiment ( headquarters ) de tots els negocis que estiguin servits pel local amb
identificador 10, a una distància superior a 1000 metres. Ordeneu els resultats per distància
de forma ascendent. */

SELECT b.`name`, s.distance FROM business b, serve s, headquarters h
WHERE h.`code` = 10 AND s.distance > 1000 
AND s.business_id = b.id AND s.headquarters_code = h.`code`
ORDER BY s.distance ASC;

/*4.2.4. Seleccioneu la descripció dels tipus de vehicles existents a la base de dades i indica quants
vehicles de cada tipus hi ha. Ordeneu els resultats pel nombre de vehicles de forma
descendent.*/
SELECT tp.description Nom, COUNT(tp.type_id) Quantitat FROM vehicle_type tp, vehicle v
WHERE v.vehicle_type_id = tp.type_id GROUP BY tp.type_id ORDER BY COUNT(tp.type_id) DESC;

/*4.2.5. Consulta 5 ( 4 punts )
Seleccioneu la llista de negocis ( només el nom ) als quals pot arribar a repartir el rider amb
codi d’identificació 10. Ordeneu els resultats pel nom de negoci de forma descendent.*/

SELECT b.`name` 
FROM business b, rider r, headquarters hq, serve s
WHERE r.headquarters_code = hq.`code` AND r.rider_id = 10 
    AND s.headquarters_code = hq.`code` AND s.business_id = b.id
ORDER BY b.`name` DESC; 

/*4.2.6. Consulta 6 ( 4 punts )
Mostreu l’identificador ( code ) i l’adreça només del local ( headquarters ) més proper a un
negoci ( business ) del tipus restaurant; és a dir, el negoci ha d’estar vinculat a la categoria
“Restaurant” pel seu identificador o pel del seu pare. Mostreu també quina és la distància
que els separa i el nom del negoci.*/
-- SELECT category_id FROM category WHERE `description`= 'Restaurant';
-- SELECT category_id FROM category WHERE parent_category_id IN (SELECT category_id FROM category WHERE `description` = 'Restaurant') ;
-- SELECT category_id FROM category WHERE `description`= 'Restaurant' OR parent_category_id IN (SELECT category_id FROM category WHERE `description` = 'Restaurant');


SELECT DISTINCT h.`code` 'Code', h.postal_address Adreça, s.distance distancia, b.`name` Nom
FROM  business b, category c , serve s, headquarters h
WHERE c.category_id IN (SELECT category_id FROM category 
WHERE `description`= 'Restaurant' OR parent_category_id 
IN (SELECT category_id FROM category WHERE `description` = 'Restaurant')) 
AND s.headquarters_code = h.`code` AND s.business_id = b.id AND c.category_id=b.category_id ORDER BY s.distance ASC LIMIT 0,1;


/*4.2.7. Consulta 7 ( 4 punts )
Mostreu un llistat amb la descripció de les categories ( category ) i de la seva categoria pare
d'aquelles categories que tinguin com a categoria pare la categoria "Tecnologia" o
"Llibreria". En el resultat ha de quedar clar que la primera columna es la descripció de la
categoria i la segona columna es la descripció de la categoria pare. Ordeneu
descendentment els resultats per la descripció de la categoria (no pare)*/

SELECT  c.`description` Hijo ,  v.`description` FROM category c, category v
 WHERE c.parent_category_id IN (SELECT category_id FROM category WHERE `description` = 'Tecnologia' OR  `description` = 'Llibreria')
 AND v.category_id IN (SELECT category_id FROM category WHERE `description` = 'Tecnologia'OR `description` = 'Llibreria') 
 AND v.category_id = c.parent_category_id ORDER BY c.`description` DESC;
 
 /*4.2.8. Consulta 8 ( 9 punts )
 Presenteu un llistat dels riders ( identificador i nom ) que poden conduir més de 3 tipus de
vehicles diferents. Mostreu també el número de tipus de vehicles que poden conduir.*/

-- SELECT * FROM licensed ORDER BY rider_id;
-- SELECT rider_id, COUNT(rider_id) FROM licensed GROUP BY rider_id ORDER BY COUNT(rider_id) DESC;


DROP VIEW IF EXISTS Count_rider ;
CREATE VIEW Count_rider AS
SELECT rider_id, COUNT(rider_id) rider_count FROM licensed GROUP BY rider_id ORDER BY COUNT(rider_id) DESC;
-- SELECT * FROM Count_rider;

SELECT  r.rider_id ,r.`name`, l.rider_count  n_vehiculos FROM rider r,  Count_rider l
WHERE r.rider_id = l.rider_id  AND l.rider_count>3;

/*4.2.9.
Mostreu un llistat dels clients que poden ser servits des d’algun dels headquarters que usen
pel seu repartiment almenys un vehicle de 2 rodes i cap de 6 rodes. Mostra el nom del
negoci del client, latitud, longitud i també la descripció del tipus de vehicle. Evita que
apareguin duplicats. Ordena ascendentment el teu resultat pel nom del negoci.*/

DROP VIEW IF EXISTS Headquarter_vehicles_more_than_2 ;
CREATE VIEW Headquarter_vehicles_more_than_2 AS
SELECT DISTINCT h.`code`, vt.`description`, vt.number_of_wheels  FROM headquarters h JOIN uses u JOIN vehicle v JOIN vehicle_type vt 
ON h.`code` = u.headquarters_code AND u.vehicle_ref_number = v.ref_number AND v.vehicle_type_id = vt.type_id
AND vt.number_of_wheels >=2 ORDER BY vt.number_of_wheels, h.`code`;

-- SELECT * FROM Headquarter_vehicles_more_than_2;

DROP VIEW IF EXISTS Headquarter_vehicles_is_6 ;
CREATE VIEW Headquarter_vehicles_is_6 AS
SELECT DISTINCT h.`code`, vt.`description`, vt.number_of_wheels  FROM headquarters h JOIN uses u JOIN vehicle v JOIN vehicle_type vt 
ON h.`code` = u.headquarters_code AND u.vehicle_ref_number = v.ref_number AND v.vehicle_type_id = vt.type_id
AND vt.number_of_wheels = 6 ORDER BY vt.number_of_wheels, h.`code`;

-- SELECT * FROM Headquarter_vehicles_not_6;

-- SELECT DISTINCT h2.`code`, h2.`description`, h2.number_of_wheels  FROM Headquarter_vehicles_more_than_2 h2 WHERE h2.`code`NOT IN (SELECT `code` FROM Headquarter_vehicles_is_6);

SELECT DISTINCT b.`name` NOM, b.latitude Latitude, b.longitude Longitude, hv2.`description`
 FROM business b , Headquarter_vehicles_more_than_2 hv2 , serve s
WHERE b.id = s.business_id AND hv2.`code` NOT IN (SELECT `code` FROM Headquarter_vehicles_is_6)
AND hv2.`code`= s.headquarters_code  ORDER BY b.`name` ASC;

/* 4.2.10. Consulta 10 ( 9 punts )
Seleccioneu la categoria i el nom dels clients de les categories “Dentista” o “Farmàcia” que
poden ser servits per algun vehicle de les marques “Mitsubishi” o “Volkswagen”,
juntament amb la marca ( brand ) heu de mostrar el tipus de vehicle ( description ) i el seu
nombre de rodes. Mostreu el llistat sense repeticions i ordenat primer ascendentment per la
categoria del client, després pel nombre de rodes per ordre descendent, després pel nom del
negoci ascendentment i per darrer pel tipus de vehicle ascendentment.*/ 

SELECT DISTINCT b.`name`, c.`description`, v.brand, vt.`description`, vt.number_of_wheels
FROM business b, category c, vehicle v, vehicle_type vt, serve s, uses u
WHERE b.category_id = c.category_id AND c.`description` IN 
        (SELECT `description` FROM category WHERE `description` = "Dentista" OR `description` = "Farmàcia")
	AND s.business_id = b.id AND s.headquarters_code = u.headquarters_code AND u.vehicle_ref_number = v.ref_number
	AND v.vehicle_type_id = vt.type_id AND v.brand IN 
        (SELECT brand FROM vehicle WHERE brand = "Mitsubishi" OR brand = "Volkswagen")
ORDER BY c.`description` ASC, vt.number_of_wheels DESC, b.`name` ASC, vt.`description` ASC;
