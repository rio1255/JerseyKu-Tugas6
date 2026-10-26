## Kontribusi Fransisco A F Pede

NIM: 23083000022

### Pengujian Integritas Foreign Key

Pengujian dilakukan dengan mencoba memasukkan data pesanan yang menggunakan referensi foreign key tidak valid.

**Hasil pengujian:** MySQL menolak perintah INSERT dengan error `#1452`. Hasil ini menunjukkan bahwa constraint foreign key mencegah penyimpanan data yang merujuk pada data induk yang tidak valid.

Pengujian ini merupakan bagian dari verifikasi integritas referensial pada basis data JerseyKu.
