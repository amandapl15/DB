/* Seleccioneu el nom i la distància entre els negocis ( bussines ) i el local de l’empresa de
repartiment ( headquarters ) de tots els negocis que estiguin servits pel local amb
identificador 10, a una distància superior a 1000 metres. Ordeneu els resultats per distància
de forma ascendent.*/

select b.`name`, s.distance from business b, serve s, headquarters h
where h.`code`= 10 and s.distance>1000 and s.business_id= b.id and s.headquarters_code = h.`code` order by s.distance asc;