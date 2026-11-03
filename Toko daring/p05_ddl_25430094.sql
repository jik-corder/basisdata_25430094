-- ============================================================
-- File: p05_ddl_25430094.sql
-- Proyek: Toko Daring (store_094)
-- Nama: Abizar Gavra Andika
-- NPM: 25430094
-- ============================================================

DROP DATABASE IF EXISTS store_094;
CREATE DATABASE store_094;
USE store_094;

-- AB-01: Aturan Identitas Petugas
CREATE TABLE petugas (
    id_petugas VARCHAR(10) NOT NULL,
    nama_petugas VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_petugas)
) ENGINE=InnoDB;

-- AB-02: Aturan Master Katalog Barang
CREATE TABLE barang (
    kode_barang VARCHAR(10) NOT NULL,
    nama_barang VARCHAR(100) NOT NULL,
    harga INT NOT NULL,
    stok INT NOT NULL,
    PRIMARY KEY (kode_barang),
    CONSTRAINT chk_harga_positif CHECK (harga >= 0),
    CONSTRAINT chk_stok_non_negatif CHECK (stok >= 0)
) ENGINE=InnoDB;

-- AB-03: Aturan Header Transaksi Penjualan
CREATE TABLE penjualan (
    no_faktur VARCHAR(20) NOT NULL,
    tanggal DATE NOT NULL,
    id_petugas VARCHAR(10) NULL,
    PRIMARY KEY (no_faktur),
    CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) 
        REFERENCES petugas(id_petugas) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- AB-04: Aturan Detail Item Transaksi Penjualan
CREATE TABLE detail_penjualan (
    no_faktur VARCHAR(20) NOT NULL,
    kode_barang VARCHAR(10) NOT NULL,
    jumlah INT NOT NULL,
    subtotal INT NOT NULL,
    PRIMARY KEY (no_faktur, kode_barang),
    CONSTRAINT fk_detail_penjualan FOREIGN KEY (no_faktur) 
        REFERENCES penjualan(no_faktur) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detail_barang FOREIGN KEY (kode_barang) 
        REFERENCES barang(kode_barang) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_jumlah_item CHECK (jumlah > 0),
    CONSTRAINT chk_subtotal_positif CHECK (subtotal >= 0)
) ENGINE=InnoDB;