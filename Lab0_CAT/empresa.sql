CREATE DATABASE IF NOT EXISTS company DEFAULT CHARACTER SET 'latin1' DEFAULT COLLATE 'latin1_general_cs';
USE `company`;

CREATE TABLE `department` (
  `id` int(4) NOT NULL DEFAULT '0',
  `name` varchar(18) DEFAULT NULL,
  `floor` int(2) DEFAULT NULL,
  `building` varchar(20) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL
) ENGINE=InnoDB;

INSERT INTO `department` (`id`, `name`, `floor`, `building`, `city`) VALUES
(1, 'COMPTABILITAT', 2, 'La Castellana', 'MADRID'),
(2, 'INFORMÀTICA', 3, 'Central', 'BARCELONA'),
(3, 'SECRETARIA', 1, 'Central', 'BARCELONA'),
(4, 'RECURSOS HUMANS', 3, 'Central', 'BARCELONA'),
(5, 'COMPTABILITAT', 2, 'Norte', 'BARCELONA'),
(6, 'SERVEI SISTEMES', 3, 'Central', 'SABADELL'),
(7, 'INFORMÁTICA', 2, 'La Castellana', 'MADRID'),
(8, 'RECURSOS HUMANS', 1, 'La Castellana', 'MADRID'),
(9, 'SERVEIS EXTERIORS', 10, 'Round Building', 'LONDRES'),
(10, 'SERVEIS EXTERIORS', 44, 'R.K.P.G. Building', 'NEW YORK');

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `salary` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE `project` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `budget` int(11) NOT NULL
) ENGINE=InnoDB;

INSERT INTO `project` (`id`, `name`, `budget`) VALUES
(1, 'Construcció versió 1', 3000000),
(2, 'Expansió exterior', 200000),
(3, 'Cerca personal capacitat', 80000);

ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_employees_department` (`department_id`),
  ADD KEY `fk_employees_project` (`project_id`);

ALTER TABLE `project`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `employee`
  ADD CONSTRAINT `fk_employees_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`),
  ADD CONSTRAINT `fk_employees_project` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`);
