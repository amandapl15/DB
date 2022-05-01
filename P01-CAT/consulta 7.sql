/*Mostreu un llistat amb la descripció de les categories ( category ) i de la seva categoria pare
d'aquelles categories que tinguin com a categoria pare la categoria "Tecnologia" o
"Llibreria". En el resultat ha de quedar clar que la primera columna es la descripció de la
categoria i la segona columna es la descripció de la categoria pare. Ordeneu
descendentment els resultats per la descripció de la categoria (no pare).*/

SELECT  c.`description` Hijo ,  v.`description` FROM category c, category v
 WHERE c.parent_category_id IN (SELECT category_id FROM category WHERE `description` = 'Tecnologia' OR  `description` = 'Llibreria')
 AND v.category_id IN (SELECT category_id FROM category WHERE `description` = 'Tecnologia'OR `description` = 'Llibreria') 
 AND v.category_id = c.parent_category_id;