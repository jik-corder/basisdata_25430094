-- ========================================================
-- Skrip DDL Modul 03: Implementasi Skema Fisik Database Kopma
-- Nama  : Abizar Gavra Andika
-- NPM   : 25430094
-- Kelas : D Ilmu Komputer
-- Kelanjutan dari Perancangan Logika & ERD Modul 02
-- ========================================================

-- Bersihkan dan buat database baru agar bebas dari file korup
DROP DATABASE IF EXISTS kopma_25430094;
CREATE DATABASE kopma_25430094 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE kopma_25430094;

-- Hapus tabel berelasi dari anak ke induk (jika dijalankan ulang)
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- 1. Tabel Petugas (Master)
CREATE TABLE petugas (
    id_petugas SMALLINT AUTO_INCREMENT PRIMARY KEY,
    kode_petugas CHAR(3) UNIQUE NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    peran_petugas ENUM('kasir', 'gudang', 'ketua') NOT NULL
) ENGINE=InnoDB;

-- 2. Tabel Anggota (Master)
CREATE TABLE anggota (
    id_anggota INT AUTO_INCREMENT PRIMARY KEY,
    no_anggota CHAR(6) UNIQUE NOT NULL,
    nim_anggota CHAR(10) UNIQUE NOT NULL,
    nama_anggota VARCHAR(100) NOT NULL,
    prodi_anggota VARCHAR(60) NOT NULL,
    no_hp_anggota VARCHAR(15),
    status_anggota ENUM('aktif', 'nonaktif') NOT NULL,
    tgl_daftar_anggota DATE NOT NULL
) ENGINE=InnoDB;

-- 3. Tabel Pemasok (Master)
CREATE TABLE pemasok (
    id_pemasok INT AUTO_INCREMENT PRIMARY KEY,
    nama_pemasok VARCHAR(100) NOT NULL,
    telepon_pemasok VARCHAR(15),
    alamat_pemasok VARCHAR(200)
) ENGINE=InnoDB;

-- 4. Tabel Barang (Master)
CREATE TABLE barang (
    id_barang INT AUTO_INCREMENT PRIMARY KEY,
    kode_barang VARCHAR(10) UNIQUE NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    kategori_barang ENUM('ATK', 'makanan', 'minuman') NOT NULL,
    harga_jual_barang DECIMAL(12,2) CHECK (harga_jual_barang >= 0),
    stok_barang INT CHECK (stok_barang >= 0),
    stok_min_barang INT DEFAULT 5
) ENGINE=InnoDB;

-- 5. Tabel Penjualan (Transaksi Utama)
CREATE TABLE penjualan (
    id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
    no_nota_penjualan CHAR(12) UNIQUE NOT NULL,
    tgl_penjualan DATETIME NOT NULL,
    id_petugas SMALLINT NOT NULL,
    id_anggota INT DEFAULT NULL,
    bayar_penjualan DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) 
        REFERENCES petugas(id_petugas) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) 
        REFERENCES anggota(id_anggota) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. Tabel Detail Penjualan (Transaksi Detail - Relasi N:M Barang & Penjualan)
CREATE TABLE detail_penjualan (
    id_penjualan INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_penjualan SMALLINT CHECK (qty_detail_penjualan > 0),
    harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_penjualan, id_barang),
    CONSTRAINT fk_detail_penjualan_penjualan FOREIGN KEY (id_penjualan) 
        REFERENCES penjualan(id_penjualan) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang) 
        REFERENCES barang(id_barang) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 7. Tabel Pembelian (Transaksi Utama Pembelian ke Pemasok)
CREATE TABLE pembelian (
    id_pembelian INT AUTO_INCREMENT PRIMARY KEY,
    no_faktur_pembelian VARCHAR(20) NOT NULL,
    tgl_pembelian DATE NOT NULL,
    id_pemasok INT NOT NULL,
    status_pembelian ENUM('dipesan', 'diterima') NOT NULL,
    CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) 
        REFERENCES pemasok(id_pemasok) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 8. Tabel Detail Pembelian (Transaksi Detail - Relasi N:M Barang & Pembelian)
CREATE TABLE detail_pembelian (
    id_pembelian INT NOT NULL,
    id_barang INT NOT NULL,
    qty_detail_pembelian INT CHECK (qty_detail_pembelian > 0),
    harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_pembelian, id_barang),
    CONSTRAINT fk_detail_pembelian_pembelian FOREIGN KEY (id_pembelian) 
        REFERENCES pembelian(id_pembelian) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang) 
        REFERENCES barang(id_barang) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;