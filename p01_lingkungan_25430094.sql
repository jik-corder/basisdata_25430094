-- Skrip Praktikum Modul 1
-- Nama: Abizar Gavra Andika
-- NPM: 25430094

CREATE DATABASE IF NOT EXISTS store_094
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'abizar_094'@'localhost' IDENTIFIED BY 'PasswordKerja#123';
GRANT ALL PRIVILEGES ON store_094.* TO 'abizar_094'@'localhost';
FLUSH PRIVILEGES;