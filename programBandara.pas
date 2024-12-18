uses crt;
label 1, 2, 3, 4, 5, 6, 7;
type
   bandara0 = record
    nama, hari, bulan1, zona : string;
    bujur, jam, menit, lintang : real;
    tanggal, bulan, tahun, utc : integer;
    jumlah_hari, jumlah_hari2 : longint;
   end;

   pesawat0 = record
    nama, kode, nomor, call, website : string;
    kecepatan, persen : real;
    kursi : integer;
   end;


   passenger0 = record
    bandara, bandara1, bandara2 : array[1..40] of bandara0;
    pesawat, pesawat1 : array[1..12] of pesawat0;
    pilihan1, pilihan2, pilihan3, pilihan4, pilihan6, tanggal, bulan, tahun, x, z, j : integer;
    pilihan5, nama_penumpang, y, p : string;
    harga1 : array[1..10] of real;
    q : array[1..4] of real;
    jam : real;
   end;


var
   passenger : array[1..100] of passenger0;
   i, b, k, m, jumlah : integer;
   ch : char;
   validasi : boolean;


function jarak(a,b : integer): real; //Ini Adalah function untuk menghitung jarak antara dua titik di permukaan bumi menggunakan rumus haversine
    begin
        with passenger[k] do
            begin
                jarak := sqrt(sqr(sin(abs((bandara[a].lintang - bandara[b].lintang)) / 2 * pi / 180)) + cos(bandara[a].lintang * pi / 180) * cos(bandara[b].lintang * pi / 180) * sqr(sin(abs((bandara[a].bujur - bandara[b].bujur)) / 2 * pi / 180))) / sqrt(1 - (sqr(sin(abs((bandara[a].lintang - bandara[b].lintang)) / 2 * pi / 180)) + cos(bandara[a].lintang * pi / 180) * cos(bandara[b].lintang * pi / 180) * sqr(sin(abs((bandara[a].bujur - bandara[b].bujur)) / 2 * pi / 180)))) * 2 * 6371;
            end
    end;

function waktu(a,b,c : integer): real; //Di sini kita akan menghitung waktu perjalanan menggunakan rumus mencari waktu
    begin
        with passenger[k] do
            begin
                waktu := (jarak(a,b) / pesawat[c].kecepatan * 60);
                q[4] := waktu;
                if jarak(pilihan1,pilihan2) > 2500 then waktu := waktu + 120;
                q[1] := waktu;
            end;
    end;

function harga(a,b,c : integer): real; //Ini adalah function untuk menentukan harga dari perjalanan, tergantung pada jarak, maskapai, kelas, dan lain - lain
    begin
        with passenger[k] do
            begin
                if pilihan6 = 1 then
                    begin
                        if pilihan5 = 'B' then harga := (((jarak(a,b) / 1000) * 1000000) * pesawat[c].persen) * 110 / 100;
                        if pilihan5 = 'E' then harga := ((jarak(a,b) / 1000) * 1000000) * pesawat[c].persen;
                    end;
                if pilihan6 = 2 then
                    begin
                        if pilihan5 = 'B' then harga := ((((jarak(a,b) / 1000) * 1000000) * pesawat[c].persen) / 15865) * 110 / 100;
                        if pilihan5 = 'E' then harga := (((jarak(a,b) / 1000) * 1000000) * pesawat[c].persen) / 15865;
                    end;
                harga1[10] := harga;
            end;
    end;


procedure times(var a : integer; var b : integer; var c : integer); //Ini adalah procedure untuk mendeteksi hari sesuai dengan tanggal yang diinputkan user, dan juga untuk menghitung perbedaan zona waktu
    begin
        with passenger[k] do
            begin
                bandara[b].jumlah_hari := bandara[a].jumlah_hari + (trunc(waktu(a,b,c) / 1440)) - trunc((bandara[a].utc - bandara[b].utc) / 1440);
                bandara[b].jumlah_hari2 := bandara[b].jumlah_hari;

                if q[1] > 1440 then q[1] := q[1] - trunc(q[1]/1440) * 1440 ;
                bandara[b].tahun := (bandara[b].jumlah_hari div (303 * 365 + 97 * 366)) * 400;
                bandara[b].jumlah_hari := bandara[b].jumlah_hari mod (303 * 365 + 97 * 366);

                if bandara[b].jumlah_hari >= (76 * 365 + 24 * 366) then
                    begin
                        bandara[b].tahun := bandara[b].tahun + (bandara[b].jumlah_hari div (76 * 365 + 24 * 366) * 100);
                        bandara[b].jumlah_hari := bandara[b].jumlah_hari mod (76 * 365 + 24 * 366);
                    end;

                bandara[b].tahun :=bandara[b].tahun + (bandara[b].jumlah_hari div (3 * 365 + 1 * 366) * 4);
                bandara[b].jumlah_hari := bandara[b].jumlah_hari mod (3 * 365 + 1 * 366);

                bandara[b].menit := (bandara[a].jam - trunc(bandara[a].jam)) * 100 + q[1] - (bandara[a].utc - bandara[b].utc) ;
                bandara[b].jam := trunc(bandara[b].menit / 60);
                bandara[b].menit := bandara[b].menit - (bandara[b].jam * 60);
                bandara[b].jam := trunc(bandara[a].jam) + bandara[b].jam;

                if (bandara[b].jam > 24) then 
                    begin
                        bandara[b].jam := bandara[b].jam - 24;
                        bandara[b].jumlah_hari := bandara[b].jumlah_hari + 1;
                        bandara[b].jumlah_hari2 := bandara[b].jumlah_hari2 + 1;
                    end;

                if bandara[b].jumlah_hari > (1 * 365) then
                    begin
                                bandara[b].tahun := bandara[b].tahun + (bandara[b].jumlah_hari div (1 * 365) * 1);
                                bandara[b].jumlah_hari := bandara[b].jumlah_hari mod (1 * 365);
                                
                                if bandara[b].jumlah_hari = 0 then 
                                    begin
                                        bandara[b].jumlah_hari := 365;
                                        bandara[b].tahun := bandara[b].tahun - 1;
                                    end;

                                if (bandara[b].jumlah_hari = 1) and ((tahun mod 4 = 0) and ((tahun mod 100 <> 0) or (tahun mod 400 = 0))) then 
                                    begin
                                        bandara[b].jumlah_hari := 366;
                                        bandara[b].tahun := bandara[b].tahun - 1;
                                    end;
                    end;

                if bandara[b].jumlah_hari = 0 then 
                    begin
                        bandara[b].jumlah_hari := 366;
                        bandara[b].tahun := bandara[b].tahun - 1;
                    end;

                bandara[b].tahun := bandara[b].tahun + 1;

                if bandara[b].jumlah_hari2 mod 7 = 0 then bandara[b].hari:= 'Minggu';
                if bandara[b].jumlah_hari2 mod 7 = 1 then bandara[b].hari:= 'Senin';
                if bandara[b].jumlah_hari2 mod 7 = 2 then bandara[b].hari:= 'Selasa';
                if bandara[b].jumlah_hari2 mod 7 = 3 then bandara[b].hari:= 'Rabu';
                if bandara[b].jumlah_hari2 mod 7 = 4 then bandara[b].hari:= 'Kamis';
                if bandara[b].jumlah_hari2 mod 7 = 5 then bandara[b].hari:= 'Jumat';
                if bandara[b].jumlah_hari2 mod 7 = 6 then bandara[b].hari:= 'Sabtu';

                if (bandara[b].tahun mod 4 = 0) and ((bandara[b].tahun mod 100 <> 0) or (bandara[b].tahun mod 400 = 0)) then 
                    begin
                        if (bandara[b].jumlah_hari >= 1) and (bandara[b].jumlah_hari <= 31) then
                            begin
                                bandara[b].bulan1 := 'Januari';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 0;
                            end;
                        if (bandara[b].jumlah_hari >= 32) and (bandara[b].jumlah_hari <= 60) then
                            begin
                                bandara[b].bulan1 := 'Februari';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 31;
                            end;
                        if (bandara[b].jumlah_hari >= 61) and (bandara[b].jumlah_hari <= 91) then
                            begin
                                bandara[b].bulan1 := 'Maret';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 60;
                            end;
                        if (bandara[b].jumlah_hari >= 92) and (bandara[b].jumlah_hari <= 121) then
                            begin
                                bandara[b].bulan1 := 'April';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 91;
                            end;
                        if (bandara[b].jumlah_hari >= 122) and (bandara[b].jumlah_hari <= 152) then
                            begin
                                bandara[b].bulan1 := 'Mei';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 121;
                            end;
                        if (bandara[b].jumlah_hari >= 153) and (bandara[b].jumlah_hari <= 182) then
                            begin
                                bandara[b].bulan1 := 'Juni';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 152;
                            end;
                        if (bandara[b].jumlah_hari >= 183) and (bandara[b].jumlah_hari <= 213) then
                            begin
                                bandara[b].bulan1 := 'Juli';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 182;
                            end;
                        if (bandara[b].jumlah_hari >= 214) and (bandara[b].jumlah_hari <= 244) then
                            begin
                                bandara[b].bulan1 := 'Agustus';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 213;
                            end;
                        if (bandara[b].jumlah_hari >= 245) and (bandara[b].jumlah_hari <= 274) then
                            begin
                                bandara[b].bulan1 := 'September';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 244;
                            end;
                        if (bandara[b].jumlah_hari >= 275) and (bandara[b].jumlah_hari <= 305) then
                            begin
                                bandara[b].bulan1 := 'Oktober';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 274;
                            end;
                        if (bandara[b].jumlah_hari >= 306) and (bandara[b].jumlah_hari <= 335) then
                            begin
                                bandara[b].bulan1 := 'November';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 305;
                            end;
                        if (bandara[b].jumlah_hari >= 336) and (bandara[b].jumlah_hari <= 366) then
                            begin
                                bandara[b].bulan1 := 'Desember';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 335;
                            end;
                    end
                else
                    begin
                        if (bandara[b].jumlah_hari >= 1) and (bandara[b].jumlah_hari <= 31) then
                            begin
                                bandara[b].bulan1 := 'Januari';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 0;
                            end;
                        if (bandara[b].jumlah_hari >= 32) and (bandara[b].jumlah_hari <= 59) then
                            begin
                                bandara[b].bulan1 := 'Februari';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 31;
                            end;
                        if (bandara[b].jumlah_hari >= 60) and (bandara[b].jumlah_hari <= 90) then
                            begin
                                bandara[b].bulan1 := 'Maret';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 59;
                            end;
                        if (bandara[b].jumlah_hari >= 91) and (bandara[b].jumlah_hari <= 120) then
                            begin
                                bandara[b].bulan1 := 'April';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 90;
                            end;
                        if (bandara[b].jumlah_hari >= 121) and (bandara[b].jumlah_hari <= 151) then
                            begin
                                bandara[b].bulan1 := 'Mei';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 120;
                            end;
                        if (bandara[b].jumlah_hari >= 152) and (bandara[b].jumlah_hari <= 181) then
                            begin
                                bandara[b].bulan1 := 'Juni';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 151;
                            end;
                        if (bandara[b].jumlah_hari >= 182) and (bandara[b].jumlah_hari <= 212) then
                            begin
                                bandara[b].bulan1 := 'Juli';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 181;
                            end;
                        if (bandara[b].jumlah_hari >= 213) and (bandara[b].jumlah_hari <= 243) then
                            begin
                                bandara[b].bulan1 := 'Agustus';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 212;
                            end;
                        if (bandara[b].jumlah_hari >= 244) and (bandara[b].jumlah_hari <= 273) then
                            begin
                                bandara[b].bulan1 := 'September';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 243;
                            end;
                            if (bandara[b].jumlah_hari >= 274) and (bandara[b].jumlah_hari <= 304) then
                                begin
                                    bandara[b].bulan1 := 'Oktober';
                                    bandara[b].tanggal := bandara[b].jumlah_hari - 273;
                                end;
                        if (bandara[b].jumlah_hari >= 305) and (bandara[b].jumlah_hari <= 334) then
                            begin
                                bandara[b].bulan1 := 'November';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 304;
                            end;
                        if (bandara[b].jumlah_hari >= 335) and (bandara[b].jumlah_hari <= 365) then
                            begin
                                bandara[b].bulan1 := 'Desember';
                                bandara[b].tanggal := bandara[b].jumlah_hari - 334;
                            end;
                    end;

                x := bandara[b].tahun;
                y := bandara[b].bulan1;
                z := bandara[b].tanggal;
                p := bandara[b].hari;
                q[2] := bandara[b].jam;
                q[3] := bandara[b].menit;
            end;
   end;


begin
    clrscr;

        gotoxy(1,1); writeln('Masukkan Banyaknya Penumpang : '); //Mulai dari sini adalah main program yang dimulai dengan inputan user
        gotoxy(32,1); readln(jumlah);

        for k := 1 to jumlah do
            begin
                with passenger[k] do
                    begin
                        clrscr;

                        gotoxy(1,1); writeln('Penumpang Ke-',k);

                        gotoxy(1,3); writeln('Masukkan Nama Anda             : ');
                        gotoxy(1,4); writeln('Masukkan Tanggal Keberangkatan : ');
                        gotoxy(1,5); writeln('Masukkan Bulan Keberangkatan   : ');
                        gotoxy(1,6); writeln('Masukkan Tahun Keberangkatan   : ');
                        gotoxy(1,7); writeln('Masukkan Jam Keberangkatan     : ');

                        gotoxy(34,3); readln(nama_penumpang);
                        5 :
                        validasi := True;
                        gotoxy(34,4); writeln('                                ');
                        gotoxy(34,5); writeln('                                ');
                        gotoxy(34,6); writeln('                                ');
                        gotoxy(34,7); writeln('                                ');
                        gotoxy(34,4); readln(Tanggal);
                        gotoxy(34,5); readln(Bulan);
                        gotoxy(34,6); readln(Tahun);
                        gotoxy(34,7); readln(Jam);

                        gotoxy(1,9); writeln('                                 ');

                        if (jam - trunc(jam) > 0.60) or (jam < 0) or (jam > 24) then
                            begin
                                gotoxy(1,9); writeln('Tolong Masukkan waktu yang Benar');
                                goto 5;
                            end;

                        if (tahun < 0) then validasi := false;;
                        if (bulan < 1) or (bulan > 12) then validasi := false;;

                        if (bulan = 1) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 2) then 
                            begin
                                if (tahun mod 4 = 0) and ((tahun mod 100 <> 0) or (tahun mod 400 = 0)) then 
                                    begin
                                        if (tanggal < 1) or (tanggal > 29) then validasi := false;;
                                    end
                                else
                                    begin
                                        if (tanggal < 1) or (tanggal > 28) then validasi := false;;
                                    end;
                            end
                        else if (bulan = 3) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 4) then 
                            begin
                                if (tanggal < 1) or (tanggal > 30) then validasi := false;;
                            end
                        else if (bulan = 5) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 6) then 
                            begin
                                if (tanggal < 1) or (tanggal > 30) then validasi := false;;
                            end
                        else if (bulan = 7) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 8) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 9) then 
                            begin
                                if (tanggal < 1) or (tanggal > 30) then validasi := false;;
                            end
                        else if (bulan = 10) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end
                        else if (bulan = 11) then 
                            begin
                                if (tanggal < 1) or (tanggal > 30) then validasi := false;;
                            end
                        else if (bulan = 12) then 
                            begin
                                if (tanggal < 1) or (tanggal > 31) then validasi := false;;
                            end;
                            
                            if validasi = false then
                                begin
                                    gotoxy(1,9); writeln('Hari Tidak Valid.');
                                    goto 5;
                                end;

                        clrscr; //Mulai dari sini Adalah Inisialisai untuk informasi setiap bandara dan setiap maskapai

                        bandara[27].nama := 'Soekarno Hatta International Airport (CGK) - Jakarta, Indonesia';
                        bandara[27].bujur := 106.6559;
                        bandara[27].lintang := -6.1256;
                        bandara[27].utc := 420;
                        bandara[27].zona := 'WIB';

                        bandara[28].nama := 'London Heathrow Airport (LHR) - London, United Kingdom';
                        bandara[28].bujur := -0.4543;
                        bandara[28].lintang := 51.4700;
                        bandara[28].utc := 0;
                        bandara[28].zona := 'GMT';

                        bandara[29].nama := 'Munich Airport (MUC) - Munich, Germany';
                        bandara[29].bujur := 11.7861;
                        bandara[29].lintang := 48.3538;
                        bandara[29].utc := 60;
                        bandara[29].zona := 'CET';

                        bandara[30].nama := 'Narita International Airport (NRT) - Tokyo, Japan';
                        bandara[30].bujur := 140.3928;
                        bandara[30].lintang := 35.7769;
                        bandara[30].utc := 540;
                        bandara[30].zona := 'JST';

                        bandara[31].nama := 'Changi Airport (SIN) - Singapore';
                        bandara[31].bujur := 103.9915;
                        bandara[31].lintang := 1.3644;
                        bandara[31].utc := 480;
                        bandara[31].zona := 'SGT';

                        bandara[32].nama := 'Dubai International Airport (DXB) - Dubai';
                        bandara[32].bujur := 55.396255;
                        bandara[32].lintang := 25.276987;
                        bandara[32].utc := 240;
                        bandara[32].zona := 'GST';

                        bandara[33].nama := 'Incheon International Airport (ICN) - Seoul, South Korea';
                        bandara[33].bujur := 126.4407;
                        bandara[33].lintang := 37.4602;
                        bandara[33].utc := 540;
                        bandara[33].zona := 'KST';

                        bandara[34].nama := 'Sydney Kingsford Smith Airport (SYD) - Sydney, Australia';
                        bandara[34].bujur := 151.1753;
                        bandara[34].lintang := -33.9399;
                        bandara[34].utc := 600;
                        bandara[34].zona := 'AEST';

                        bandara[35].nama := 'Beijing Capital International Airport (PEK) - Beijing, China';
                        bandara[35].bujur := 116.5846;
                        bandara[35].lintang := 40.0801;
                        bandara[35].utc := 480;
                        bandara[35].zona := 'CST';

                        bandara[36].nama := 'Charles de Gaulle Airport (CDG) - Paris, France';
                        bandara[36].bujur := 2.5479;
                        bandara[36].lintang := 49.0097;
                        bandara[36].utc := 60;
                        bandara[36].zona := 'CET';

                        bandara[37].nama := 'Istanbul Airport (IST) - Istanbul, Turkey';
                        bandara[37].bujur := 28.7519;
                        bandara[37].lintang := 41.2753;
                        bandara[37].utc := 180;
                        bandara[37].zona := 'TRT';

                        bandara[38].nama := 'Kuala Lumpur International Airport (KUL) - Kuala Lumpur, Malaysia';
                        bandara[38].bujur := 101.7113;
                        bandara[38].lintang := 2.7456;
                        bandara[38].utc := 480;
                        bandara[38].zona := 'MYT';

                        bandara[39].nama := 'King Abdulaziz International Airport (JED) - Jeddah, Saudi Arabia';
                        bandara[39].bujur := 39.1500;
                        bandara[39].lintang := 21.6700;
                        bandara[39].utc := 180;
                        bandara[39].zona := 'AST';

                        bandara[1].nama := 'Bandara Internasional Soekarno-Hatta (CGK) - Jakarta, Indonesia';
                        bandara[1].bujur := 106;
                        bandara[1].lintang := -6;

                        bandara[2].nama := 'Bandara Internasional Kualanamu (KNO) - Medan, Sumatera Utara';
                        bandara[2].bujur := 98;
                        bandara[2].lintang := 3;

                        bandara[3].nama := 'Bandara Internasional Juanda (SUB) - Surabaya, Jawa Timur';
                        bandara[3].bujur := 112;
                        bandara[3].lintang := -7;

                        bandara[4].nama := 'Bandara Internasional Minangkabau (PDG) - Padang, Sumatera Barat';
                        bandara[4].bujur := 100;
                        bandara[4].lintang := 0;

                        bandara[5].nama := 'Bandara Internasional Sultan Iskandar Muda (BTJ) - Banda Aceh';
                        bandara[5].bujur := 95;
                        bandara[5].lintang := 5;

                        bandara[6].nama := 'Bandara Internasional Raja Haji Fisabilillah (TNJ) - Tanjungpinang, Kepulauan Riau';
                        bandara[6].bujur := 104;
                        bandara[6].lintang := 0;

                        bandara[7].nama := 'Bandara Internasional Yogyakarta (YIA) - Yogyakarta';
                        bandara[7].bujur := 110;
                        bandara[7].lintang := -7;

                        bandara[8].nama := 'Bandara Internasional Kertajati (KJT) - Majalengka, Jawa Barat';
                        bandara[8].bujur := 108;
                        bandara[8].lintang := -6;

                        bandara[9].nama := 'Bandara Internasional Blimbingsari (BWX) - Banyuwangi, Jawa Timur';
                        bandara[9].bujur := 114;
                        bandara[9].lintang := -8;

                        bandara[10].nama := 'Bandara Internasional Sultan Mahmud Badaruddin II (PLM) - Palembang, Sumatera Selatan';
                        bandara[10].bujur := 104;
                        bandara[10].lintang := -2;

                        bandara[11].nama := 'Bandara Internasional Adisucipto (YOG) - Yogyakarta';
                        bandara[11].bujur := 110;
                        bandara[11].lintang := -7;

                        bandara[12].nama := 'Bandara Internasional Ngurah Rai (DPS) - Denpasar, Bali';
                        bandara[12].bujur := 115;
                        bandara[12].lintang := -8;

                        bandara[13].nama := 'Bandara Internasional Sultan Hasanuddin (UPG) - Makassar, Sulawesi Selatan';
                        bandara[13].bujur := 119;
                        bandara[13].lintang := -5;

                        bandara[14].nama := 'Bandara Internasional Sam Ratulangi (MDC) - Manado, Sulawesi Utara';
                        bandara[14].bujur := 124;
                        bandara[14].lintang := 1;

                        bandara[15].nama := 'Bandara Internasional Zainuddin Abdul Madjid (LOP) - Lombok, NTB';
                        bandara[15].bujur := 116;
                        bandara[15].lintang := -8;

                        bandara[16].nama := 'Bandara Husein Sastranegara (BDO) - Bandung, Jawa Barat';
                        bandara[16].bujur := 107;
                        bandara[16].lintang := -6;

                        bandara[17].nama := 'Bandara Ahmad Yani (SRG) - Semarang, Jawa Tengah';
                        bandara[17].bujur := 110;
                        bandara[17].lintang := -6;

                        bandara[18].nama := 'Bandara Malang (MLG) - Malang, Jawa Timur';
                        bandara[18].bujur := 112;
                        bandara[18].lintang := -8;

                        bandara[19].nama := 'Bandara Pontianak Supadio (PNK) - Pontianak, Kalimantan Barat';
                        bandara[19].bujur := 109;
                        bandara[19].lintang := 0;

                        bandara[20].nama := 'Bandara Syamsudin Noor (BDJ) - Banjarmasin, Kalimantan Selatan';
                        bandara[20].bujur := 114;
                        bandara[20].lintang := -3;

                        bandara[21].nama := 'Bandara Singkawang (KWG) - Kalimantan Barat';
                        bandara[21].bujur := 108;
                        bandara[21].lintang := 0;

                        bandara[22].nama := 'Bandara Ternate (TTE) - Ternate, Maluku Utara';
                        bandara[22].bujur := 127;
                        bandara[22].lintang := 0;

                        bandara[23].nama := 'Bandara Gorontalo Djalaluddin (GTO) - Gorontalo';
                        bandara[23].bujur := 123;
                        bandara[23].lintang := 0;

                        bandara[24].nama := 'Bandara El Tari (KOE) - Kupang, Nusa Tenggara Timur';
                        bandara[24].bujur := 123;
                        bandara[24].lintang := -10;

                        bandara[25].nama := 'Bandara Labuan Bajo (LBJ) - Labuan Bajo, Nusa Tenggara Timur';
                        bandara[25].bujur := 127;
                        bandara[25].lintang := 0;

                        bandara[26].nama := 'Bandara Bajawa (BJW) - Flores, Nusa Tenggara Timur';
                        bandara[26].bujur := 121;
                        bandara[26].lintang := -8;

                        pesawat[1].nama := 'Garuda Indonesia';
                        pesawat[1].kecepatan := 800;
                        pesawat[1].kursi := 36;
                        pesawat[1].persen := 130 / 100;
                        pesawat[1].nomor := 'GA';
                        pesawat[1].call := '0804-1-800-807';
                        pesawat[1].website := 'www.garuda-indonesia.com';

                        pesawat[2].nama := 'Lion Air';
                        pesawat[2].kecepatan := 850;
                        pesawat[2].kursi := 38;
                        pesawat[2].persen := 110 / 100;
                        pesawat[2].nomor := 'JT';
                        pesawat[2].call := '0804-177-8899';
                        pesawat[2].website := 'www.lionair.co.id';

                        pesawat[3].nama := 'AirAsia';
                        pesawat[3].kecepatan := 830;
                        pesawat[3].kursi := 33;
                        pesawat[3].persen := 110 / 100;
                        pesawat[3].nomor := 'AK';
                        pesawat[3].call := '0804-1-400-400';
                        pesawat[3].website := 'www.airasia.com';

                        pesawat[4].nama := 'Sriwijaya Air';
                        pesawat[4].kecepatan := 850;
                        pesawat[4].kursi := 26;
                        pesawat[4].persen := 120 / 100;
                        pesawat[4].nomor := 'SJ';
                        pesawat[4].call := '0804-1-777-777';
                        pesawat[4].website := 'www.sriwijayaair.co.id';

                        pesawat[5].nama := 'Citilink';
                        pesawat[5].kecepatan := 830;
                        pesawat[5].kursi := 33;
                        pesawat[5].persen := 120 / 100;
                        pesawat[5].nomor := 'QG';
                        pesawat[5].call := '0804-1-080808';
                        pesawat[5].website := 'www.citilink.co.id';

                        pesawat[6].nama := 'Batik Air';
                        pesawat[6].kecepatan := 850;
                        pesawat[6].kursi := 35;
                        pesawat[6].persen := 125 / 100;
                        pesawat[6].nomor := 'ID';
                        pesawat[6].call := '0804-1-808-808';
                        pesawat[6].website := 'www.batikair.com';

                        pesawat[7].nama := 'Emirates';
                        pesawat[7].kecepatan := 900;
                        pesawat[7].kursi := 354;
                        pesawat[7].persen := 200 / 100;
                        pesawat[7].nomor := 'EK';
                        pesawat[7].call := '+971 4 214 4444';
                        pesawat[7].website := 'www.emirates.com';

                        pesawat[8].nama := 'Singapore Airlines';
                        pesawat[8].kecepatan := 900;
                        pesawat[8].kursi := 264;
                        pesawat[8].persen := 180 / 100;
                        pesawat[8].nomor := 'SQ';
                        pesawat[8].call := '+65 6223 8888';
                        pesawat[8].website := 'www.singaporeair.com';

                        pesawat[9].nama := 'Lufthansa';
                        pesawat[9].kecepatan := 910;
                        pesawat[9].kursi := 364;
                        pesawat[9].persen := 175 / 100;
                        pesawat[9].nomor := 'LH';
                        pesawat[9].call := '+49 69 86 799 799';
                        pesawat[9].website := 'www.lufthansa.com';

                        pesawat[10].nama := 'Qatar Airways';
                        pesawat[10].kecepatan := 900;
                        pesawat[10].kursi := 317;
                        pesawat[10].persen := 190 / 100;
                        pesawat[10].nomor := 'QR';
                        pesawat[10].call := '+974 4023 0000';
                        pesawat[10].website := 'www.qatarairways.com';

                        pesawat[11].nama := 'Air France';
                        pesawat[11].kecepatan := 900;
                        pesawat[11].kursi := 306;
                        pesawat[11].persen := 175 / 100;
                        pesawat[11].nomor := 'AF';
                        pesawat[11].call := '+33 9 69 39 36 54';
                        pesawat[11].website := 'www.airfrance.com';

                        pesawat[12].nama := 'Cathay Pacific';
                        pesawat[12].kecepatan := 900;
                        pesawat[12].kursi := 364;
                        pesawat[12].persen := 175 / 100;
                        pesawat[12].nomor := 'CX';
                        pesawat[12].call := '+852 2747 1818';
                        pesawat[12].website := 'www.cathaypacific.com';

                        for i := 1 to 26 do
                            begin
                                if ((i >= 1) and (i <= 11)) or ((i >= 16) and (i <= 21)) then
                                    begin
                                        bandara[i].zona := 'WIB';
                                        bandara[i].utc := 420;
                                    end
                                else if (i = 22) then
                                    begin
                                        bandara[i].zona := 'WIT';
                                        bandara[i].utc := 540;
                                    end
                                else
                                    begin
                                        bandara[i].zona := 'WITA';
                                        bandara[i].utc := 480;
                                    end;
                            end;

                        gotoxy(1,1); writeln('Penumpang Ke-',k);

                        gotoxy(1,3); writeln('[1] Penerbangan Domestik');
                        gotoxy(1,4); writeln('[2] Penerbangan Internasional');
                        gotoxy(1,5); writeln('Silakan Pilih Jenis Penerbangan Anda [1/2] : ');
                        gotoxy(46,5); readln(pilihan6);

                        clrscr;

                        if pilihan6 = 1 then // Ini Adalah Inputan Berikutnya Jika User Memilih Penerbangan Domestik
                            begin
                                gotoxy(1,1); writeln('-------------------------Penerbangan Domestik-------------------------');
                                for i := 1 to 26 do
                                    begin
                                        gotoxy(1,i + 3); writeln('[',i,'] ',bandara[i].nama);
                                    end;

                                1 :
                                gotoxy(27,33); writeln('                ');
                                gotoxy(27,34); writeln('                ');
                                gotoxy(1,33); writeln('Masukkan Bandara Asal   : ');
                                gotoxy(1,34); writeln('Masukkan Bandara Tujuan : ');

                                gotoxy(27,33); readln(pilihan1);
                                gotoxy(27,34); readln(pilihan2);
                                gotoxy(1,35); writeln('                                                                                                        ');

                                if (pilihan1 = pilihan2) then 
                                    begin
                                        gotoxy(1,35); writeln('Lokasi Asal dan Tujuan Tidak Boleh sama.');
                                        goto 1;
                                    end;

                                if (jarak(pilihan1,pilihan2) < 100) then 
                                    begin
                                        gotoxy(1,35); writeln('Jarak Antara Kedua Bandara Terlalu Dekat. Tidak Ada Penerbangan Antara Kedua Bandara.');
                                        goto 1;
                                    end;

                                clrscr;

                                if jarak(pilihan1,pilihan2) > 2500 then
                                    begin
                                        writeln('Perjalanan Anda Butuh Transit. Silakan Pilih Lokasi Transit.');
                                        b := 1;

                                        for i := 1 to 15 do
                                            begin
                                                if (i <> pilihan1) or (i <> pilihan2) then 
                                                    begin
                                                        if ((jarak(pilihan1,i) <= 2500) and (jarak(pilihan1,i) > jarak(pilihan1,pilihan2) / 3)) and ((jarak(pilihan2,i) <= 2500) and (jarak(pilihan2,i) > jarak(pilihan1,pilihan2) / 3)) then 
                                                            begin
                                                                bandara1[b].nama := bandara[i].nama;
                                                                bandara1[b].bujur := bandara[i].bujur;
                                                                bandara1[b].lintang := bandara[i].lintang;
                                                                gotoxy(1,b+2); writeln('[',b,'] ',bandara1[b].nama);
                                                                b := b + 1;
                                                            end;
                                                    end;
                                            end;

                                        6 :
                                        m := 0;
                                        gotoxy(25,b + 4); writeln('                       ');
                                        gotoxy(1,b + 4); Writeln('Masukkan Pilihan Anda : '); 
                                        gotoxy(25,b + 4); readln(pilihan3);
                                        gotoxy(1,b + 6); writeln('                                    ');
                                        for i := 1 to b - 1 do
                                            begin
                                                if pilihan3 <> i then m := m + 1;
                                            end;
                                        if (m = b - 1) then
                                            begin
                                                gotoxy(1,b + 6); writeln('Masukkan Pilihan yang Benar.');
                                                goto 6;
                                            end;
                                    end;

                                clrscr;

                                for i := 1 to 6 do
                                    begin
                                        gotoxy(1,i); writeln('[',i,'] ',pesawat[i].nama);
                                    end;

                                3 :
                                gotoxy(1,8); writeln('Pilih Maskapai Penerbangan Anda : '); 
                                gotoxy(1,9); writeln('Kelas Ekonomi [E] Atau Bisnis [B] : '); 
                                gotoxy(35,8); writeln('                         ');
                                gotoxy(37,9); writeln('                         ');
                                gotoxy(35,8); readln(pilihan4);
                                gotoxy(37,9); readln(pilihan5);
                                gotoxy(1,11); writeln('                                              ');
                                pilihan5 := upcase(pilihan5);

                                if (pilihan4 < 1) or (pilihan4 > 6) then
                                    begin
                                        gotoxy(1,11); writeln('Tolong Pilih Maskapai yang Benar.     ');
                                        goto 3;
                                    end;

                                if (pilihan5 <> 'B') and (pilihan5 <> 'E') then
                                    begin
                                        gotoxy(1,11); writeln('Tolong Masukkan Kelas yang Benar.     ');
                                        goto 3;
                                    end;

                            end;

                        if pilihan6 = 2 then //Ini Adalah Inputan Berikutnya Jika User memilih Penerbangan Internasional
                            begin
                                gotoxy(1,1); writeln('-------------------------International Flight-------------------------');
                                for i := 1 to 13 do
                                    begin
                                        gotoxy(1,i + 3); writeln('[',i,'] ',bandara[i + 26].nama);
                                    end;

                                2 :
                                gotoxy(29,21); writeln('                ');
                                gotoxy(29,22); writeln('                ');
                                gotoxy(1,21); writeln('Enter Origin Airport      : ');
                                gotoxy(1,22); writeln('Enter Destination Airport : ');

                                gotoxy(29,21); writeln('                         ');
                                gotoxy(29,22); writeln('                         ');
                                gotoxy(29,21); readln(pilihan1);
                                gotoxy(29,22); readln(pilihan2);
                                gotoxy(1,23); writeln('                                                                                                        ');
                                if (pilihan1 = pilihan2) then 
                                    begin
                                        gotoxy(1,23); writeln('Origin and Destination Locations cannot be the same.');
                                        goto 2;
                                    end;
                                pilihan1 := pilihan1 + 26;
                                pilihan2 := pilihan2 + 26;

                                clrscr;

                                if jarak(pilihan1,pilihan2) > 10000 then
                                    begin
                                        writeln('Your trip requires transit. Please select a transit location.');
                                        b := 1;

                                        for i := 1 to 14 do
                                            begin
                                                if (i + 26 <> pilihan1) or (i + 26 <> pilihan2) then 
                                                    begin
                                                        if ((jarak(pilihan1,i + 26) <= 10000) and (jarak(pilihan1,i + 26) > jarak(pilihan1,pilihan2) / 3)) and ((jarak(pilihan2,i + 26) <= 10000) and (jarak(pilihan2,i + 26) > jarak(pilihan1,pilihan2) / 3)) then 
                                                            begin
                                                                bandara1[b].nama := bandara[i + 26].nama;
                                                                bandara1[b].bujur := bandara[i + 26].bujur;
                                                                bandara1[b].lintang := bandara[i + 26].lintang;
                                                                gotoxy(1,b+2); writeln('[',b,'] ',bandara1[b].nama);
                                                                b := b + 1;
                                                            end;
                                                    end;
                                            end;

                                        7 :
                                        m := 0;
                                        gotoxy(21,b + 4); writeln('                       ');
                                        gotoxy(1,b + 4); Writeln('Enter Your Choice : '); 
                                        gotoxy(21,b + 4); readln(pilihan3);
                                        gotoxy(1,b + 6); writeln('                                    ');
                                        for i := 1 to b - 1 do
                                            begin
                                                if pilihan3 <> i then m := m + 1;
                                            end;
                                        if (m = b - 1) then
                                            begin
                                                gotoxy(1,b + 6); writeln('Enter the Correct Choice.');
                                                goto 7;
                                            end;
                                    end;

                                clrscr;

                                for i := 1 to 6 do
                                    begin
                                        gotoxy(1,i); writeln('[',i,'] ',pesawat[i + 6].nama);
                                    end;

                                4 :
                                gotoxy(1,8); writeln('Select Your Airline : '); 
                                gotoxy(1,9); writeln('Economy Class [E] Or Business [B] : '); 
                                gotoxy(23,8); writeln('                ');
                                gotoxy(37,9); writeln('                ');
                                gotoxy(23,8); readln(pilihan4);
                                gotoxy(37,9); readln(pilihan5);
                                gotoxy(1,11); writeln('                                                   ');
                                pilihan5 := upcase(pilihan5);

                                if (pilihan4 < 1) or (pilihan4 > 6) then
                                    begin
                                        gotoxy(1,11); writeln('Please Enter Correct Airline.     ');
                                        goto 4;
                                    end;

                                if (pilihan5 <> 'B') and (pilihan5 <> 'E') then
                                    begin
                                        gotoxy(1,11); writeln('Please Enter Correct Class.       ');
                                        goto 4;
                                    end;

                                pilihan4 := pilihan4 + 6;

                            end;

                        bandara[pilihan1].tanggal := tanggal;
                        bandara[pilihan1].tahun := tahun;
                        bandara[pilihan1].jam := jam;
                        bandara[pilihan1].bulan := bulan;

                        if pilihan6 = 1 then
                            begin
                                case bulan of
                                    1 : bandara[pilihan1].bulan1 := ' Januari';
                                    2 : bandara[pilihan1].bulan1 := ' Februari';
                                    3 : bandara[pilihan1].bulan1 := ' Maret';
                                    4 : bandara[pilihan1].bulan1 := ' April';
                                    5 : bandara[pilihan1].bulan1 := ' Mey';
                                    6 : bandara[pilihan1].bulan1 := ' Juni';
                                    7 : bandara[pilihan1].bulan1 := ' Juli';
                                    8 : bandara[pilihan1].bulan1 := ' Agustus';
                                    9 : bandara[pilihan1].bulan1 := ' September';
                                    10 : bandara[pilihan1].bulan1 := ' Oktober';
                                    11 : bandara[pilihan1].bulan1 := ' November';
                                    12 : bandara[pilihan1].bulan1 := ' Desember';
                                end;
                            end;

                        if pilihan6 = 2 then
                            begin
                                case bulan of
                                    1 : bandara[pilihan1].bulan1 := ' January';
                                    2 : bandara[pilihan1].bulan1 := ' February';
                                    3 : bandara[pilihan1].bulan1 := ' March';
                                    4 : bandara[pilihan1].bulan1 := ' April';
                                    5 : bandara[pilihan1].bulan1 := ' Mey';
                                    6 : bandara[pilihan1].bulan1 := ' June';
                                    7 : bandara[pilihan1].bulan1 := ' July';
                                    8 : bandara[pilihan1].bulan1 := ' August';
                                    9 : bandara[pilihan1].bulan1 := ' September';
                                    10 : bandara[pilihan1].bulan1 := ' October';
                                    11 : bandara[pilihan1].bulan1 := ' November';
                                    12 : bandara[pilihan1].bulan1 := ' Desember';
                                end;
                            end;

                        with bandara[pilihan1] do
                            begin
                                for i := 1 to tahun - 1 do
                                    begin
                                        if (i mod 4 = 0) and ((i mod 100 <> 0) or (i mod 400 = 0)) then jumlah_hari := jumlah_hari + 366
                                        else jumlah_hari := jumlah_hari + 365;
                                    end;

                                for i := 1 to bulan -1 do
                                    begin
                                        if (i = 1) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 2) then 
                                            begin
                                                if (tahun mod 4 = 0) and ((tahun mod 100 <> 0) or (tahun mod 400 = 0)) then jumlah_hari := jumlah_hari + 29
                                                else jumlah_hari := jumlah_hari + 28;
                                            end;
                                        if (i = 3) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 4) then jumlah_hari := jumlah_hari + 30;
                                        if (i = 5) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 6) then jumlah_hari := jumlah_hari + 30;
                                        if (i = 7) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 8) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 9) then jumlah_hari := jumlah_hari + 30;
                                        if (i = 10) then jumlah_hari := jumlah_hari + 31;
                                        if (i = 11) then jumlah_hari := jumlah_hari + 30;
                                    end;

                                jumlah_hari := jumlah_hari + tanggal;

                                if jumlah_hari mod 7 = 0 then hari:= 'Minggu';
                                if jumlah_hari mod 7 = 1 then hari:= 'Senin';
                                if jumlah_hari mod 7 = 2 then hari:= 'Selasa';
                                if jumlah_hari mod 7 = 3 then hari:= 'Rabu';
                                if jumlah_hari mod 7 = 4 then hari:= 'Kamis';
                                if jumlah_hari mod 7 = 5 then hari:= 'Jumat';
                                if jumlah_hari mod 7 = 6 then hari:= 'Sabtu';

                            end;

                    end;
            end;

        k := 1;

        repeat

            with passenger[k] do //Mulai dari sini Adalah Tampilan Jika User memilih Penerbangan Domestik
                begin

                    times(pilihan1,pilihan2,pilihan4); 

                    bandara[pilihan1].menit := (bandara[pilihan1].jam - trunc(bandara[pilihan1].jam)) * 100;

                    if pilihan6 = 1 then
                        begin

                            clrscr;

                            writeln('------------------------------------------------------');
                            writeln('                TIKET PESAWAT DOMESTIK           ');
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('No. Penerbangan : ',pesawat[pilihan4].nomor,' ',random(800) + 101,' ( ',pesawat[pilihan4].nama,' ) ');
                            writeln('Tanggal Keberangkatan : ',bandara[pilihan1].hari,', ',bandara[pilihan1].tanggal,' ',bandara[pilihan1].bulan1,' ',bandara[pilihan1].tahun);
                            if bandara[pilihan1].jam < 10 then 
                                begin
                                    if bandara[pilihan1].menit < 10 then writeln('Waktu Keberangkatan : 0',bandara[pilihan1].jam:0:0,':0',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona)
                                    else if bandara[pilihan1].menit >= 10 then writeln('Waktu Keberangkatan : 0',bandara[pilihan1].jam:0:0,':',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona);
                                end
                            else if bandara[pilihan1].jam >= 10 then
                                begin
                                    if bandara[pilihan1].menit < 10 then writeln('Waktu Keberangkatan : ',bandara[pilihan1].jam:0:0,':0',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona)
                                    else if bandara[pilihan1].menit >= 10 then writeln('Waktu Keberangkatan : ',bandara[pilihan1].jam:0:0,':',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona);
                                end;
                            writeln('Tanggal Tiba : ',p,', ',z,' ',y,' ',x);
                            if q[2] < 10 then 
                                begin
                                    if q[3] < 10 then writeln('Waktu Tiba : 0',q[2]:0:0,':0',q[3]:0:0,' ',bandara[pilihan2].zona)
                                    else if q[3] >= 10 then writeln('Waktu Tiba : 0',q[2]:0:0,':',q[3]:0:0,' ',bandara[pilihan2].zona);
                                end
                            else if q[2] >= 10 then
                                begin
                                    if q[3] < 10 then writeln('Waktu Tiba : ',q[2]:0:0,':0',q[3]:0:0,' ',bandara[pilihan2].zona)
                                    else if q[3] >= 10 then writeln('Waktu Tiba : ',q[2]:0:0,':',q[3]:0:0,' ',bandara[pilihan2].zona);
                                end;
                            if jarak(pilihan1,pilihan2) > 2500 then
                                begin
                                    writeln('Transit : ',bandara1[pilihan3].nama);
                                    writeln('Waktu Transit : 2 Jam');
                                end;
                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Rute Penerbangan : ');
                            writeln('Dari : ',bandara[pilihan1].nama);
                            writeln('Ke : ',bandara[pilihan2].nama);
                            writeln('Durasi Penerbangan : ',trunc(q[4] / 60),' Jam ',(q[4] - trunc(q[4] / 60) * 60):0:0,' Menit');
                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Detail Penumpang : ');
                            writeln('Nama Penumpang   : ',nama_penumpang);
                            if pilihan5 = 'E' then writeln('Jenis Tiket : Kelas Ekonomi');
                            if pilihan5 = 'B' then writeln('Jenis Tiket : Kelas Bisnis');
                            if pilihan5 = 'E' then
                                begin
                                    writeln('Kursi : ',random(pesawat[pilihan4].kursi - (pesawat[pilihan4].kursi div 4) + pesawat[pilihan4].kursi div 4),'',chr(65 + random(6)));
                                end;
                            if pilihan5 = 'B' then
                                begin
                                    writeln('Kursi : ',random((pesawat[pilihan4].kursi div 4) - 1) + 1,'',chr(65 + random(6)));
                                end;
                            harga(pilihan1,pilihan2,pilihan4);

                            j := 10;
                            while harga1[10] >= 1000 do
                                begin
                                    j := j - 1;
                                    harga1[j] := ((harga1[10] / 1000) - trunc(harga1[10] / 1000)) * 1000;
                                    harga1[10] := (harga1[10] - harga1[j]) / 1000;
                                end;

                            write('Harga : IDR ',harga1[10]:0:0,',');

                            for i := j to 9 do
                                begin
                                    if i = 9 then 
                                        begin
                                            if harga1[i] < 10 then write('00',harga1[i]:0:0)
                                            else if harga1[i] < 100 then write('0',harga1[i]:0:0)
                                            else write(harga1[i]:0:0);
                                        end
                                    else 
                                        begin
                                            if harga1[i] < 10 then write('00',harga1[i]:0:0,',')
                                            else if harga1[i] < 100 then write('0',harga1[i]:0:0,',')
                                            else write(harga1[i]:0:0,',');
                                        end;
                                end;

                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Maskapai : ',pesawat[pilihan4].nama);
                            writeln('Call Center : ',pesawat[pilihan4].call);
                            writeln('Website : ',pesawat[pilihan4].website);
                            writeln;
                            if jarak(pilihan1,pilihan2) > 2500 then 
                                begin
                                    writeln('Informasi Transit : ');
                                    writeln('Transit di ',bandara1[pilihan3].nama);
                                    writeln('Waktu Transit : 2 Jam');
                                end;
                            gotoxy(150,33); writeln('[D] Halaman Selanjutnya');
                            gotoxy(150,34); writeln('[A] Halaman Sebelumnya ');
                            gotoxy(150,35); writeln('[Q] Berhenti           ');

                        end;

                    if pilihan6 = 2 then //Mulai dari sini Adalah Tampilam Jika User memilih Penerbangan Internasional
                        begin

                            clrscr;

                            writeln('------------------------------------------------------');
                            writeln('                INTERNATIONAL PLANE TICKET           ');
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Flight number : ',pesawat[pilihan4].nomor,' ',random(800) + 101,' ( ',pesawat[pilihan4].nama,' ) ');
                            writeln('Departure Date : ',bandara[pilihan1].hari,', ',bandara[pilihan1].tanggal,' ',bandara[pilihan1].bulan1,' ',bandara[pilihan1].tahun);
                            if bandara[pilihan1].jam < 10 then 
                                begin
                                    if bandara[pilihan1].menit < 10 then writeln('Departure time : 0',bandara[pilihan1].jam:0:0,':0',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona)
                                    else if bandara[pilihan1].menit >= 10 then writeln('Departure time : 0',bandara[pilihan1].jam:0:0,':',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona);
                                end
                            else if bandara[pilihan1].jam >= 10 then
                                begin
                                    if bandara[pilihan1].menit < 10 then writeln('Departure time : ',bandara[pilihan1].jam:0:0,':0',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona)
                                    else if bandara[pilihan1].menit >= 10 then writeln('Departure time : ',bandara[pilihan1].jam:0:0,':',bandara[pilihan1].menit:0:0,' ',bandara[pilihan1].zona);
                                end;
                            writeln('Arrival Date : ',p,', ',z,' ',y,' ',x);
                            if q[2] < 10 then 
                                begin
                                    if q[3] < 10 then writeln('Arrival Time : 0',q[2]:0:0,':0',q[3]:0:0,' ',bandara[pilihan2].zona)
                                    else if q[3] >= 10 then writeln('Arrival Time : 0',q[2]:0:0,':',q[3]:0:0,' ',bandara[pilihan2].zona);
                                end
                            else if q[2] >= 10 then
                                begin
                                    if q[3] < 10 then writeln('Arrival Time : ',q[2]:0:0,':0',q[3]:0:0,' ',bandara[pilihan2].zona)
                                    else if q[3] >= 10 then writeln('Arrival Time : ',q[2]:0:0,':',q[3]:0:0,' ',bandara[pilihan2].zona);
                                end;
                            if jarak(pilihan1,pilihan2) > 10000 then
                                begin
                                    writeln('Transit : ',bandara1[pilihan3].nama);
                                    writeln('Transit Time : 2 Hours');
                                end;
                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Aviation Route : ');
                            writeln('From : ',bandara[pilihan1].nama);
                            writeln('To : ',bandara[pilihan2].nama);
                            writeln('Flight Duration : ',trunc(q[4] / 60),' Hours ',(q[4] - trunc(q[4] / 60) * 60):0:0,' Minute');
                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Passenger Details : ');
                            writeln('Passenger Name   : ',nama_penumpang);
                            if pilihan5 = 'E' then writeln('Ticket Type : Economy Class');
                            if pilihan5 = 'B' then writeln('Ticket Type : Business Class');
                            if pilihan5 = 'E' then
                                begin
                                    writeln('Seat : ',random(pesawat[pilihan4].kursi - (pesawat[pilihan4].kursi div 4) + pesawat[pilihan4].kursi div 4),'',chr(65 + random(6)));
                                end;
                            if pilihan5 = 'B' then
                                begin
                                    writeln('Seat : ',random((pesawat[pilihan4].kursi div 4) - 1) + 1,'',chr(65 + random(6)));
                                end;
                            harga(pilihan1,pilihan2,pilihan4);

                            j := 10;
                            while harga1[10] >= 1000 do
                                begin
                                    j := j - 1;
                                    harga1[j] := ((harga1[10] / 1000) - trunc(harga1[10] / 1000)) * 1000;
                                    harga1[10] := (harga1[10] - harga1[j]) / 1000;
                                end;

                            if j = 10 then write('Price : USD ',harga1[10]:0:0);
                            if j < 10 then write('Price : USD ',harga1[10]:0:0,',');

                            for i := j to 9 do
                                begin
                                    if i = 9 then 
                                        begin
                                            if harga1[i] < 10 then write('00',harga1[i]:0:0)
                                            else if harga1[i] < 100 then write('0',harga1[i]:0:0)
                                            else write(harga1[i]:0:0);
                                        end
                                    else 
                                        begin
                                            if harga1[i] < 10 then write('00',harga1[i]:0:0,',')
                                            else if harga1[i] < 100 then write('0',harga1[i]:0:0,',')
                                            else write(harga1[i]:0:0,',');
                                        end;
                                end;

                            writeln;
                            writeln('------------------------------------------------------');
                            writeln;
                            writeln('Airline : ',pesawat[pilihan4].nama);
                            writeln('Call Center : ',pesawat[pilihan4].call);
                            writeln('Website : ',pesawat[pilihan4].website);
                            writeln;
                            if jarak(pilihan1,pilihan2) > 10000 then 
                                begin
                                    writeln('Transit Information : ');
                                    writeln('Transit In ',bandara1[pilihan3].nama);
                                    writeln('Transit Time : 2 Hours');
                                end;
                            gotoxy(150,33); writeln('[D] Next Page    ');
                            gotoxy(150,34); writeln('[A] Previous Page');
                            gotoxy(150,35); writeln('[Q] Halt         ');

                        end;
                        
                end;

            repeat

                if keypressed then //Ini Adalah Fitur Keypressed Untuk membuat Tampilannya lebih Interaktif, Tampilan akan berupa seperti Halaman di mana banyaknya halaman tergantung banyaknya Penumpang dan disediakan Fitur Next Page dan Previous Page denan Keypressed
                    begin
                        ch := readkey;
                        if (ch = 'd') or (ch = 'D') then
                            begin
                                if (k = jumlah) then k := k + 0
                                else 
                                    begin 
                                        k := k + 1;
                                        break;
                                    end;
                            end
                        else if (ch = 'a') or (ch = 'A') then 
                            begin
                                if (k = 1) then k := k - 0
                                else 
                                    begin
                                        k := k - 1;
                                        break;
                                    end;
                            end
                        else if (ch = 'q') or (ch = 'Q') then halt;
                    end;

            until false;

        until false;

end.