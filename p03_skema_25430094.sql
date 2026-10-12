-- ========================================================
-- Skrip DDL Modul 03: Implementasi Skema Fisik Database Store
-- Nama  : Abizar Gavra Andika
-- NPM   : 25430094
-- Kelas : D Ilmu Komputer
-- Database: store_094
-- ========================================================

USE store_094;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS petugas;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Tabel Petugas
CREATE TABLE petugas (
    id_petugas INT AUTO_INCREMENT PRIMARY KEY,
    kode_petugas VARCHAR(10) UNIQUE NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran ENUM('kasir', 'admin') NOT NULL
) ENGINE=InnoDB;

-- 2. Tabel Barang
CREATE TABLE barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    kode_barang VARCHAR(10) UNIQUE NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori VARCHAR(50) NOT NULL,
    harga DECIMAL(12,2) CHECK (harga >= 0),
    stok INT CHECK (stok >= 0)
) ENGINE=InnoDB;

-- 3. Tabel Penjualan
CREATE TABLE penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    no_nota VARCHAR(20) UNIQUE NOT NULL,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas INT NOT NULL,
    nama_pembeli VARCHAR(100) DEFAULT 'Pelanggan Umum',
    total_bayar DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) 
        REFERENCES petugas(id_petugas) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Tabel Detail Penjualan (Entitas Asosiatif)
CREATE TABLE detail_penjualan (
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    jumlah INT CHECK (jumlah > 0),
    harga_satuan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT fk_detail_penjualan_penjualan FOREIGN KEY (id_penjualan) 
        REFERENCES penjualan(id_penjualan) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang) 
        REFERENCES barang(id_barang) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;