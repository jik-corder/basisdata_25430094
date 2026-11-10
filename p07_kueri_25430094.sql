-- ==========================================================
-- Nama File : p07_kueri_25430094.sql
-- Topik     : Milestone Proyek 7 (Kueri Satu Tabel - Store 094)
-- Nama      : Abizar Gavra Andika
-- NPM       : 25430094
-- ==========================================================

-- 1. Menggunakan LIKE (Pencarian Pola Teks)
-- KI: KI-01 | Pertanyaan: Apa saja barang yang namanya mengandung kata 'Aksesoris'?
-- Hasil yang diharapkan: Menampilkan daftar barang yang memiliki kata 'Aksesoris' pada kolom nama_barang.
SELECT * 
FROM barang 
WHERE nama_barang LIKE '%Aksesoris%';


-- 2. Menggunakan BETWEEN (Rentang Nilai)
-- KI: KI-02 | Pertanyaan: Barang apa saja yang harganya berada di kisaran Rp10.000 sampai Rp50.000?
-- Hasil yang diharapkan: Menampilkan barang dengan rentang harga jual antara 10000 dan 50000.
SELECT id_barang, nama_barang, harga_jual_barang 
FROM barang 
WHERE harga_jual_barang BETWEEN 10000 AND 50000;


-- 3. Menggunakan IN (Pencarian dalam Daftar Nilai)
-- KI: KI-03 | Pertanyaan: Barang apa saja yang berasal dari kategori 'K01', 'K03', atau 'K05'?
-- Hasil yang diharapkan: Menampilkan barang yang id_kategorinya cocok dengan salah satu nilai dalam daftar.
SELECT * 
FROM barang 
WHERE id_kategori IN ('K01', 'K03', 'K05');


-- 4. Menggunakan IS NULL (Pengecekan Nilai Kosong/NULL)
-- KI: KI-04 | Pertanyaan: Barang apa saja yang belum memiliki catatan deskripsi?
-- Hasil yang diharapkan: Menampilkan data barang di mana kolom deskripsi bernilai NULL.
SELECT id_barang, nama_barang 
FROM barang 
WHERE deskripsi_barang IS NULL;


-- 5. Menggunakan CASE (Kondisional / Percabangan)
-- KI: KI-05 | Pertanyaan: Bagaimana status ketersediaan stok setiap barang berdasarkan jumlahnya?
-- Hasil yang diharapkan: Menampilkan kolom tambahan status 'Habis', 'Menipis', atau 'Aman'.
SELECT 
    nama_barang, 
    stok,
    CASE 
        WHEN stok = 0 THEN 'Habis'
        WHEN stok BETWEEN 1 AND 5 THEN 'Menipis'
        ELSE 'Aman'
    END AS status_stok
FROM barang;


-- 6. Menggunakan Fungsi Tanggal (DATE / NOW / YEAR)
-- KI: KI-06 | Pertanyaan: Produk apa saja yang ditambahkan pada tahun 2026?
-- Hasil yang diharapkan: Menampilkan data berdasarkan filter tahun tanggal pencatatan.
SELECT * 
FROM barang 
WHERE YEAR(tanggal_ditambahkan) = 2026;


-- 7. Menggunakan Fungsi String (CONCAT & LOWER)
-- KI: KI-07 | Pertanyaan: Bagaimana tampilan kode barang dan nama barang dalam bentuk ringkas berhuruf kecil?
-- Hasil yang diharapkan: Menggabungkan kode dan nama barang dengan format huruf kecil semua.
SELECT 
    LOWER(CONCAT(id_barang, ' - ', nama_barang)) AS info_barang_ringkas 
FROM barang;


-- 8. Kombinasi Operator Perbandingan & Logika Dasar (AND/OR)
-- KI: KI-08 | Pertanyaan: Barang apa saja yang harganya di atas 100000 dan stoknya kurang dari 10?
-- Hasil yang diharapkan: Menampilkan produk kategori premium yang persediaannya terbatas.
SELECT * 
FROM barang 
WHERE harga_jual_barang > 100000 AND stok < 10;


-- 9. Menggunakan Fungsi Agregasi Sederhana pada Satu Tabel (COUNT)
-- KI: KI-09 | Pertanyaan: Berapa total jumlah jenis barang yang terdaftar di dalam tabel barang?
-- Hasil yang diharapkan: Menampilkan angka total baris data pada tabel barang.
SELECT COUNT(*) AS total_jenis_barang 
FROM barang;


-- 10. Menggunakan ORDER BY & LIMIT (Pengurutan & Pembatasan Hasil)
-- KI: KI-10 | Pertanyaan: Apa 5 barang dengan harga termahal?
-- Hasil yang diharapkan: Menampilkan 5 produk diurutkan dari harga tertinggi ke terendah.
SELECT id_barang, nama_barang, harga_jual_barang 
FROM barang 
ORDER BY harga_jual_barang DESC 
LIMIT 5;