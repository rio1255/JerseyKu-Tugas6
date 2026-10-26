-- ============================================================
-- JERSEYKU - TUGAS 6: IMPLEMENTASI BASIS DATA FINAL
-- DBMS: MySQL 8.0.16+ / InnoDB / utf8mb4
-- Sumber rancangan: Tugas 5 Rancangan Final, Bagian 5.2
-- Kelompok: Hendrikus de Ornai, Fransisko A F Pede, Delpiero Falerio Wafom
-- Jalankan file ini di phpMyAdmin atau MySQL.
-- Catatan: NIM anggota belum tercantum pada dokumen Tugas 5,
-- sehingga wajib diisi pada header kepemilikan sebelum dikumpulkan.
-- ============================================================

CREATE DATABASE IF NOT EXISTS jerseyku
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jerseyku;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS mockup;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pemain;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS desain;
DROP TABLE IF EXISTS template_jersey;
DROP TABLE IF EXISTS kategori_olahraga;
DROP TABLE IF EXISTS pengguna;
SET FOREIGN_KEY_CHECKS = 1;

-- PEMILIK: Hendrikus de Ornai | NIM: [ISI NIM] | MODUL: Autentikasi & Pengguna
CREATE TABLE pengguna (
  id_pengguna INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255) NOT NULL COMMENT 'Simpan hash bcrypt, bukan password polos',
  no_hp VARCHAR(20) NULL,
  peran ENUM('pelanggan','desainer','admin') NOT NULL DEFAULT 'pelanggan',
  aktif BOOLEAN NOT NULL DEFAULT TRUE,
  dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_pengguna_email UNIQUE (email)
) ENGINE=InnoDB;

-- PEMILIK: Hendrikus de Ornai | NIM: [ISI NIM] | MODUL: Template & Desain
CREATE TABLE kategori_olahraga (
  id_kategori INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(50) NOT NULL,
  CONSTRAINT uq_kategori_nama UNIQUE (nama_kategori)
) ENGINE=InnoDB;

-- PEMILIK: Hendrikus de Ornai | NIM: [ISI NIM] | MODUL: Template & Desain
CREATE TABLE template_jersey (
  id_template INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_kategori INT UNSIGNED NOT NULL,
  nama_template VARCHAR(100) NOT NULL,
  gambar_dasar VARCHAR(255) NOT NULL,
  harga_dasar DECIMAL(12,2) NOT NULL,
  aktif BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_template_harga CHECK (harga_dasar >= 0),
  CONSTRAINT fk_template_kategori FOREIGN KEY (id_kategori)
    REFERENCES kategori_olahraga(id_kategori)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PEMILIK: Hendrikus de Ornai | NIM: [ISI NIM] | MODUL: Template & Desain
CREATE TABLE desain (
  id_desain INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_pelanggan INT UNSIGNED NOT NULL,
  id_template INT UNSIGNED NOT NULL,
  nama_tim VARCHAR(100) NOT NULL,
  warna_utama CHAR(7) NOT NULL,
  warna_sekunder CHAR(7) NULL,
  pola ENUM('polos','garis','gradasi') NOT NULL DEFAULT 'polos',
  font VARCHAR(50) NOT NULL DEFAULT 'Arial',
  logo_url VARCHAR(255) NULL,
  dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  diubah_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_desain_warna_utama CHECK (warna_utama REGEXP '^#[0-9A-Fa-f]{6}$'),
  CONSTRAINT chk_desain_warna_sekunder CHECK (warna_sekunder IS NULL OR warna_sekunder REGEXP '^#[0-9A-Fa-f]{6}$'),
  CONSTRAINT fk_desain_pelanggan FOREIGN KEY (id_pelanggan)
    REFERENCES pengguna(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_desain_template FOREIGN KEY (id_template)
    REFERENCES template_jersey(id_template) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PEMILIK: Fransisko A F Pede | NIM: [ISI NIM] | MODUL: Pesanan
CREATE TABLE pesanan (
  id_pesanan INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_pelanggan INT UNSIGNED NOT NULL,
  id_desain INT UNSIGNED NOT NULL,
  id_desainer INT UNSIGNED NULL,
  tgl_pesanan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  jumlah_total INT UNSIGNED NOT NULL,
  total_harga DECIMAL(12,2) NOT NULL,
  persen_dp TINYINT UNSIGNED NOT NULL DEFAULT 50,
  alamat_kirim TEXT NOT NULL,
  estimasi_selesai DATE NULL,
  status ENUM('menunggu_dp','verifikasi_dp','review_desain','persetujuan_mockup','produksi','menunggu_pelunasan','dikirim','selesai')
    NOT NULL DEFAULT 'menunggu_dp',
  CONSTRAINT uq_pesanan_desain UNIQUE (id_desain),
  CONSTRAINT chk_pesanan_jumlah CHECK (jumlah_total > 0),
  CONSTRAINT chk_pesanan_total CHECK (total_harga >= 0),
  CONSTRAINT chk_pesanan_dp CHECK (persen_dp BETWEEN 1 AND 100),
  CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan)
    REFERENCES pengguna(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pesanan_desain FOREIGN KEY (id_desain)
    REFERENCES desain(id_desain) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pesanan_desainer FOREIGN KEY (id_desainer)
    REFERENCES pengguna(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PEMILIK: Fransisko A F Pede | NIM: [ISI NIM] | MODUL: Pesanan
CREATE TABLE detail_pemain (
  id_detail INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_pesanan INT UNSIGNED NOT NULL,
  nama_punggung VARCHAR(20) NOT NULL,
  no_punggung TINYINT UNSIGNED NOT NULL,
  ukuran ENUM('XS','S','M','L','XL','XXL') NOT NULL,
  CONSTRAINT uq_pemain_nomor UNIQUE (id_pesanan, no_punggung),
  CONSTRAINT chk_pemain_nomor CHECK (no_punggung BETWEEN 0 AND 99),
  CONSTRAINT fk_pemain_pesanan FOREIGN KEY (id_pesanan)
    REFERENCES pesanan(id_pesanan) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- PEMILIK: Fransisko A F Pede | NIM: [ISI NIM] | MODUL: Pembayaran
CREATE TABLE pembayaran (
  id_pembayaran INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_pesanan INT UNSIGNED NOT NULL,
  id_verifikator INT UNSIGNED NULL,
  jenis ENUM('dp','pelunasan') NOT NULL,
  metode ENUM('transfer','qris') NOT NULL,
  jumlah_bayar DECIMAL(12,2) NOT NULL,
  bukti_bayar VARCHAR(255) NOT NULL,
  status_verifikasi ENUM('menunggu','valid','ditolak') NOT NULL DEFAULT 'menunggu',
  catatan_verifikasi VARCHAR(255) NULL,
  tgl_verifikasi DATETIME NULL,
  dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_pembayaran_jenis UNIQUE (id_pesanan, jenis),
  CONSTRAINT chk_pembayaran_jumlah CHECK (jumlah_bayar > 0),
  CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan)
    REFERENCES pesanan(id_pesanan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pembayaran_verifikator FOREIGN KEY (id_verifikator)
    REFERENCES pengguna(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- PEMILIK: Delpiero Falerio Wafom | NIM: [ISI NIM] | MODUL: Mockup & Produksi
CREATE TABLE mockup (
  id_mockup INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_pesanan INT UNSIGNED NOT NULL,
  id_desainer INT UNSIGNED NOT NULL,
  versi INT UNSIGNED NOT NULL,
  file_mockup VARCHAR(255) NOT NULL,
  status ENUM('menunggu','disetujui','revisi') NOT NULL DEFAULT 'menunggu',
  catatan_revisi VARCHAR(255) NULL,
  catatan_desainer VARCHAR(255) NULL,
  dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_mockup_versi UNIQUE (id_pesanan, versi),
  CONSTRAINT chk_mockup_versi CHECK (versi >= 1),
  CONSTRAINT fk_mockup_pesanan FOREIGN KEY (id_pesanan)
    REFERENCES pesanan(id_pesanan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_mockup_desainer FOREIGN KEY (id_desainer)
    REFERENCES pengguna(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- DATA AWAL (seed). Minimal 5 baris pada setiap tabel utama.
-- Untuk data demo, password_hash berisi placeholder hash demo,
-- bukan kredensial untuk login aplikasi.
-- ============================================================
INSERT INTO pengguna (nama,email,password_hash,no_hp,peran,aktif) VALUES
('Andi Pratama','andi.pratama@example.com','$2b$12$demo_hash_andi','081234560001','pelanggan',1),
('Bunga Lestari','bunga.lestari@example.com','$2b$12$demo_hash_bunga','081234560002','pelanggan',1),
('Citra Mahendra','citra.mahendra@example.com','$2b$12$demo_hash_citra','081234560003','pelanggan',1),
('Hendrikus de Ornai','hendrikus@example.com','$2b$12$demo_hash_hendrikus','081234560004','admin',1),
('Delpiero Falerio Wafom','delpiero@example.com','$2b$12$demo_hash_delpiero','081234560005','desainer',1),
('Fransisko A F Pede','fransisko@example.com','$2b$12$demo_hash_fransisko','081234560006','admin',1);

INSERT INTO kategori_olahraga (nama_kategori) VALUES
('Sepak Bola'),('Futsal'),('Basket'),('Voli'),('Badminton');

INSERT INTO template_jersey (id_kategori,nama_template,gambar_dasar,harga_dasar,aktif) VALUES
(1,'Garuda Home','garuda_home.png',125000,1),
(1,'Garuda Away','garuda_away.png',130000,1),
(2,'Futsal Lightning','futsal_lightning.png',110000,1),
(3,'Basket Skyline','basket_skyline.png',140000,1),
(4,'Voli Wave','voli_wave.png',115000,1),
(5,'Badminton Sprint','badminton_sprint.png',105000,1);

INSERT INTO desain (id_pelanggan,id_template,nama_tim,warna_utama,warna_sekunder,pola,font,logo_url) VALUES
(1,1,'Garuda Muda','#C8102E','#FFFFFF','garis','Arial',NULL),
(2,3,'Bintang Futsal','#0057B8','#FFD700','gradasi','Montserrat',NULL),
(3,4,'Skyline Warriors','#111111','#00AEEF','polos','Roboto',NULL),
(1,2,'Garuda Muda Away','#FFFFFF','#C8102E','garis','Arial',NULL),
(2,5,'Bunga Smash','#008000','#FFFFFF','gradasi','Poppins',NULL);

INSERT INTO pesanan (id_pelanggan,id_desain,id_desainer,jumlah_total,total_harga,persen_dp,alamat_kirim,estimasi_selesai,status) VALUES
(1,1,5,2,250000,50,'Jl. Merdeka No. 10, Malang','2026-11-15','menunggu_dp'),
(2,2,5,3,330000,50,'Jl. Ijen No. 22, Malang','2026-11-16','review_desain'),
(3,3,5,5,700000,50,'Jl. Soekarno Hatta No. 8, Malang','2026-11-18','produksi'),
(1,4,5,2,260000,50,'Jl. Merdeka No. 10, Malang','2026-11-20','menunggu_pelunasan'),
(2,5,5,4,420000,50,'Jl. Ijen No. 22, Malang','2026-11-22','dikirim');

INSERT INTO detail_pemain (id_pesanan,nama_punggung,no_punggung,ukuran) VALUES
(1,'ANDI',7,'L'),(1,'BIMA',10,'M'),
(2,'BUNGA',9,'S'),(2,'RANI',11,'M'),(2,'DION',12,'L'),
(3,'CITRA',4,'M'),(3,'DARA',5,'S'),(3,'NANDO',8,'L'),(3,'RIO',10,'XL'),(3,'TAMA',11,'M'),
(4,'ANDI',7,'L'),(4,'BIMA',10,'M'),
(5,'BUNGA',9,'S'),(5,'RANI',11,'M'),(5,'DION',12,'L'),(5,'RISA',15,'M');

INSERT INTO pembayaran (id_pesanan,id_verifikator,jenis,metode,jumlah_bayar,bukti_bayar,status_verifikasi,catatan_verifikasi,tgl_verifikasi) VALUES
(1,NULL,'dp','transfer',125000,'bukti/ord-1-dp.png','menunggu',NULL,NULL),
(2,4,'dp','qris',165000,'bukti/ord-2-dp.png','valid','Pembayaran sesuai',NOW()),
(3,4,'dp','transfer',350000,'bukti/ord-3-dp.png','valid','DP diterima',NOW()),
(4,4,'dp','transfer',130000,'bukti/ord-4-dp.png','valid','DP diterima',NOW()),
(4,NULL,'pelunasan','qris',130000,'bukti/ord-4-lunas.png','menunggu',NULL,NULL),
(5,4,'dp','qris',210000,'bukti/ord-5-dp.png','valid','DP diterima',NOW());

INSERT INTO mockup (id_pesanan,id_desainer,versi,file_mockup,status,catatan_revisi,catatan_desainer) VALUES
(2,5,1,'mockup/ord-2-v1.png','menunggu',NULL,'Konsep warna biru dan emas'),
(3,5,1,'mockup/ord-3-v1.png','disetujui',NULL,'Mockup final disetujui'),
(3,5,2,'mockup/ord-3-v2.png','disetujui','Perbaiki posisi logo','Logo sudah diperbaiki'),
(4,5,1,'mockup/ord-4-v1.png','disetujui',NULL,'Siap produksi'),
(5,5,1,'mockup/ord-5-v1.png','disetujui',NULL,'Produksi selesai');

-- Verifikasi cepat jumlah data per tabel
SELECT 'pengguna' AS tabel, COUNT(*) AS jumlah FROM pengguna
UNION ALL SELECT 'kategori_olahraga', COUNT(*) FROM kategori_olahraga
UNION ALL SELECT 'template_jersey', COUNT(*) FROM template_jersey
UNION ALL SELECT 'desain', COUNT(*) FROM desain
UNION ALL SELECT 'pesanan', COUNT(*) FROM pesanan
UNION ALL SELECT 'detail_pemain', COUNT(*) FROM detail_pemain
UNION ALL SELECT 'pembayaran', COUNT(*) FROM pembayaran
UNION ALL SELECT 'mockup', COUNT(*) FROM mockup;
