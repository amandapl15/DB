
DROP SCHEMA IF EXISTS upf_riders;
CREATE DATABASE IF NOT EXISTS upf_riders;
USE upf_riders;

CREATE TABLE headquarters (
    `code` INT(5) PRIMARY KEY,
    latitude FLOAT,
    longitude FLOAT,
    postal_address VARCHAR(100)
);

CREATE TABLE rider (
    rider_id INT(5) PRIMARY KEY,
    `name` VARCHAR(50),
    headquarters_code INT(5),
    CONSTRAINT FK_rider_headquarters_code FOREIGN KEY (headquarters_code)
        REFERENCES headquarters (`code`)
);

CREATE TABLE vehicle_type (
    type_id INT(5) PRIMARY KEY,
    `description` VARCHAR(50),
    number_of_wheels INT(5)
);

CREATE TABLE vehicle (
    ref_number INT(5) PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(50),
    liter_capacity INT(5),
    vehicle_type_id INT(5),
    CONSTRAINT FK_vehicle_vehicle_type_id FOREIGN KEY (vehicle_type_id)
        REFERENCES vehicle_type (type_id)
);

CREATE TABLE category (
    category_id INT(5) PRIMARY KEY,
    `description` VARCHAR(100),
    parent_category_id INT(5) DEFAULT NULL,
    CONSTRAINT FK_category_parent_category_id FOREIGN KEY (parent_category_id)
        REFERENCES category (category_id)
);

CREATE TABLE business (
    id INT(5) PRIMARY KEY,
    `name` VARCHAR(100) DEFAULT NULL,
    latitude FLOAT,
    longitude FLOAT,
    address VARCHAR(100) DEFAULT NULL,
    category_id INT(5),
    CONSTRAINT FK_business_category_id FOREIGN KEY (category_id)
        REFERENCES category (category_id)
);

CREATE TABLE serve (
    business_id INT(5),
    headquarters_code INT(5),
    distance FLOAT,
    CONSTRAINT FK_serve_business_id FOREIGN KEY (business_id)
        REFERENCES business (id),
    CONSTRAINT FK_serve_headquarters_code FOREIGN KEY (headquarters_code)
        REFERENCES headquarters (`code`)
);

CREATE TABLE licensed (
    rider_id INT(5),
    vehicle_type_id INT(5),
    years_experience INT(5),
    CONSTRAINT FK_licensed_rider_id FOREIGN KEY (rider_id)
        REFERENCES rider (rider_id), 
        CONSTRAINT FK_licensed_vehicle_type_id FOREIGN KEY (vehicle_type_id)
        REFERENCES vehicle_type (type_id)
);

CREATE TABLE uses (
    vehicle_ref_number INT(5),
    headquarters_code INT(5),
    CONSTRAINT FK_uses_vehicle_ref_number FOREIGN KEY (vehicle_ref_number)
        REFERENCES vehicle (ref_number),
    CONSTRAINT FK_uses_headquarters_code FOREIGN KEY (headquarters_code)
        REFERENCES headquarters (`code`)
);
