-- ACTIVIDAD 13
-- Base de datos remota con MySQL y XAMPP
-- Responsable: Sergio

CREATE DATABASE IF NOT EXISTS
ag13_usuarios
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE ag13_usuarios;

CREATE TABLE IF NOT EXISTS usuarios (id INT(11) NOT NULL
AUTO_INCREMENT,
apellido_paterno VARCHAR(100) NOT NULL,
apellido_materno VARCHAR(100) NOT NULL,
telefono VARCHAR(20) NOT NUL, 
correo VARCHAR (150) NOT NULL, 
numero_control VARCHAR(30)  NOT NULL,

PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_general_ci;
