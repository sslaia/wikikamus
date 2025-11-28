# wikikamus

Sebuah aplikasi untuk menampilkan isi **Wikikamus bahasa daerah di Indonesia**, termasuk kemungkinan untuk menyunting dan menciptakan halaman baru.

## Versi 1.0.0

Melalui Pengaturan pengguna bisa mengatur:
- Bahasa Wikikamus, Mis. memilih bahasa Madura di Pengaturan akan membuat aplikasi menampilkan Halaman Utama Wikikamus bahasa Madura dan semua operasi pencarian, penyuntingan, pembuatan halaman baru berlangsung di dalam lingkungan Wikikamus Madura yang terdapat di https://mad.wiktionary.org
- Mode gelap terang
- Besar ukuran huruf
- Mencari isi kamus
- Menyunting dan membuat halaman baru

## Keterbatasan

Aplikasi ini masih membutuhkan banyak kerja untuk **menyesuaikan berbagai tampilan Halaman Utama Wikikamus** ke layar aplikasi, bukan hanya menyangkut tata letak, melainkan juga seksi-seksi yang perlu dan tidak perlu ditampilkan (yang biasa ditandai dengan nomobile di CSS styles)

Dan karena aplikasi ini mengikutkan 11 situs Wikikamus, maka pekerjaan tsb. di atas menjadi 11 kali lebih banyak!

Seandainya semua situs Wikikamus di Indonesia mengikuti rekomendasi Wikimedia yang ditulis di [sini](https://www.mediawiki.org/wiki/Recommendations_for_mobile_friendly_articles_on_Wikimedia_wikis), mempunyai aturan yang sama untuk CSS styles dan mengikuti tata letak yang sama, maka kerja tsb. hanya dibuat sekali jadi dan akan berjalan untuk semua situs. Kita harap para admin Wikikamus bahasa daerah di Indonesia mendengar dan mengikuti rekomendasi ini di masa depan.

## Rencana untuk versi-versi berikutnya

Yang perlu dikerjakan untuk versi-versi berikutnya:
- Memoles tampilan halaman utama setiap bahasa daerah 
Saat ini tidak diproses apa pun, jadi tampilan bisa kacau, tergantung style css yang digunakan
- Memperbaiki _rendering_ aksara bahasa daerah
- Memperbaiki penganganan pranala wiki
- Memungkinkan pengguna mereset pembaharuan konten halaman 
Sekarang ini konten halaman diunduh sekali seminggu
- Memperbaiki penanganan audio pengucapan
- Memperpaiki penanganan gambar
- Masuk ke dalam dengan akun Wikimedia pengguna sendiri
- Menyunting dan membuat halaman baru langsung dalam aplikasi sendiri

## Ingin membantu memperbaiki?

Repository aplikasi ini terdapat di [https://github.com/sslaia/wikikamus](https://github.com/sslaia/wikikamus)

Silakan mengkontribusi kode perbaikan di sana, terutama untuk perbaikan tampilan dan konten situs bahasa daerah Anda sendiri.

