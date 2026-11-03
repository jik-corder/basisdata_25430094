-- ============================================================
-- File: p06_data_25430094.sql
-- Proyek: Toko Daring (store_094)
-- Nama: Abizar Gavra Andika | NPM: 25430094 (P = 4)
-- ============================================================

USE store_094;

-- 1. BERSIHKAN DATA LAMA
DELETE FROM detail_penjualan;
DELETE FROM penjualan;
DELETE FROM barang;
DELETE FROM petugas;

-- 2. DML TABEL INDUK: PETUGAS (Minimal 5 Baris)
INSERT INTO petugas (id_petugas, nama_petugas) VALUES
('PET01', 'Abizar Gavra'),
('PET02', 'Budi Santoso'),
('PET03', 'Siti Rahma'),
('PET04', 'Deni Setiawan'),
('PET05', 'Eka Putri');

-- 3. DML TABEL INDUK: BARANG (Minimal 5 Baris)
INSERT INTO barang (kode_barang, nama_barang, harga, stok) VALUES
('BRG01', 'Kemeja Flannel', 150000, 50),
('BRG02', 'Celana Jeans', 250000, 30),
('BRG03', 'Jaket Parka', 350000, 20),
('BRG04', 'Sepatu Sneakers', 400000, 15),
('BRG05', 'Kaos Polos', 75000, 100);

-- 4. DML TABEL TRANSAKSI: PENJUALAN (10 x P = 40 Baris, Tersebar di 3+ Tanggal)
INSERT INTO penjualan (no_faktur, tanggal, id_petugas) VALUES
('FK-20261001-01', '2026-10-01', 'PET01'), ('FK-20261001-02', '2026-10-01', 'PET02'),
('FK-20261001-03', '2026-10-01', 'PET01'), ('FK-20261001-04', '2026-10-01', 'PET03'),
('FK-20261001-05', '2026-10-01', 'PET02'), ('FK-20261001-06', '2026-10-01', 'PET04'),
('FK-20261001-07', '2026-10-01', 'PET01'), ('FK-20261001-08', '2026-10-01', 'PET05'),
('FK-20261001-09', '2026-10-01', 'PET03'), ('FK-20261001-10', '2026-10-01', 'PET02'),
('FK-20261001-11', '2026-10-01', 'PET01'), ('FK-20261001-12', '2026-10-01', 'PET04'),
('FK-20261001-13', '2026-10-01', 'PET05'), ('FK-20261001-14', '2026-10-01', 'PET02'),

('FK-20261002-01', '2026-10-02', 'PET01'), ('FK-20261002-02', '2026-10-02', 'PET03'),
('FK-20261002-03', '2026-10-02', 'PET02'), ('FK-20261002-04', '2026-10-02', 'PET04'),
('FK-20261002-05', '2026-10-02', 'PET05'), ('FK-20261002-06', '2026-10-02', 'PET01'),
('FK-20261002-07', '2026-10-02', 'PET02'), ('FK-20261002-08', '2026-10-02', 'PET03'),
('FK-20261002-09', '2026-10-02', 'PET04'), ('FK-20261002-10', '2026-10-02', 'PET05'),
('FK-20261002-11', '2026-10-02', 'PET01'), ('FK-20261002-12', '2026-10-02', 'PET02'),
('FK-20261002-13', '2026-10-02', 'PET03'),

('FK-20261003-01', '2026-10-03', 'PET01'), ('FK-20261003-02', '2026-10-03', 'PET02'),
('FK-20261003-03', '2026-10-03', 'PET03'), ('FK-20261003-04', '2026-10-03', 'PET04'),
('FK-20261003-05', '2026-10-03', 'PET05'), ('FK-20261003-06', '2026-10-03', 'PET01'),
('FK-20261003-07', '2026-10-03', 'PET02'), ('FK-20261003-08', '2026-10-03', 'PET03'),
('FK-20261003-09', '2026-10-03', 'PET04'), ('FK-20261003-10', '2026-10-03', 'PET05'),
('FK-20261003-11', '2026-10-03', 'PET01'), ('FK-20261003-12', '2026-10-03', 'PET02'),
('FK-20261003-13', '2026-10-03', 'PET03');

-- 5. DML TABEL DETAIL PENJUALAN
INSERT INTO detail_penjualan (no_faktur, kode_barang, jumlah, subtotal) VALUES
('FK-20261001-01', 'BRG01', 2, 300000),
('FK-20261001-01', 'BRG02', 1, 250000),
('FK-20261001-02', 'BRG05', 3, 225000),
('FK-20261002-01', 'BRG03', 1, 350000),
('FK-20261003-01', 'BRG04', 1, 400000);