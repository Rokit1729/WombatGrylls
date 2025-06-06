-- TESTY

SELECT * FROM zorganizowana_wycieczka;

SELECT t1.id_wycieczki, t1.data_wycieczki, ADDDATE(t1.data_wycieczki, t2.czas_trwania-1)
FROM zorganizowana_wycieczka AS t1 JOIN oferty AS t2 USING(id_oferty)
WHERE ADDDATE(t1.data_wycieczki, t2.czas_trwania-1) >= CURDATE()
ORDER BY t1.data_wycieczki, t1.id_wycieczki;


SELECT COUNT(id_osoby)
FROM osoby_zorganizowana_wycieczka
WHERE id_wycieczki IN  (SELECT t1.id_wycieczki
                        FROM zorganizowana_wycieczka AS t1 JOIN oferty AS t2 USING(id_oferty)
                        WHERE ADDDATE(t1.data_wycieczki, t2.czas_trwania-1) >= CURDATE());

SELECT * FROM osoby_zorganizowana_wycieczka WHERE id_wycieczki <= 329;





-- ŚREDNIA OCEN
-- 4. Który plan wycieczek i która konkretna wycieczka mają najlepszą, a który najgorszą średnią ocenę? Jakie elementy wpływają na te wyniki i czy warto zrezygnować z najgorzej ocenianej oferty?


-- Najlepiej oceniane wycieczki (uwzględnienie, że średnie paru wycieczek mogą być równe)
SELECT t1.id_wycieczki,
        t2.id_oferty,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_wycieczki`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN zorganizowana_wycieczka AS t2 USING(id_wycieczki)
WHERE ocena IS NOT NULL
GROUP BY id_wycieczki
HAVING FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                        FROM osoby_zorganizowana_wycieczka
                                        WHERE ocena IS NOT NULL
                                        GROUP BY id_wycieczki
                                        ORDER BY `x` DESC
                                        LIMIT 1)
ORDER BY id_wycieczki;

-- Najgorzej oceniane wycieczki (uwzględnienie, że średnie paru wycieczek mogą być równe)
SELECT t1.id_wycieczki,
        t2.id_oferty,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_wycieczki`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN zorganizowana_wycieczka AS t2 USING(id_wycieczki)
WHERE ocena IS NOT NULL
GROUP BY id_wycieczki
HAVING FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                        FROM osoby_zorganizowana_wycieczka
                                        WHERE ocena IS NOT NULL
                                        GROUP BY id_wycieczki
                                        ORDER BY `x` ASC
                                        LIMIT 1)
ORDER BY id_wycieczki;


-- Najlepiej oceniane oferty (uwzględnienie, że średnie paru ofert mogą być równe)
SELECT t2.id_oferty,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_oferty`
FROM osoby_zorganizowana_wycieczka AS t1 JOIN zorganizowana_wycieczka AS t2 USING (id_wycieczki)
WHERE t1.ocena IS NOT NULL
GROUP BY t2.id_oferty
HAVING FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(t1.ocena)*100)/100 AS `x`
                                        FROM osoby_zorganizowana_wycieczka AS t1 JOIN zorganizowana_wycieczka AS t2 USING (id_wycieczki)
                                        WHERE t1.ocena IS NOT NULL
                                        GROUP BY t2.id_oferty
                                        ORDER BY `x` DESC
                                        LIMIT 1)
ORDER BY id_wycieczki;


-- Najgorzej oceniane oferty (uwzględnienie, że średnie paru ofert mogą być równe)
SELECT t2.id_oferty,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_oferty`
FROM osoby_zorganizowana_wycieczka AS t1 JOIN zorganizowana_wycieczka AS t2 USING (id_wycieczki)
WHERE t1.ocena IS NOT NULL
GROUP BY t2.id_oferty
HAVING FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(t1.ocena)*100)/100 AS `x`
                                        FROM osoby_zorganizowana_wycieczka AS t1 JOIN zorganizowana_wycieczka AS t2 USING (id_wycieczki)
                                        WHERE t1.ocena IS NOT NULL
                                        GROUP BY t2.id_oferty
                                        ORDER BY `x` ASC
                                        LIMIT 1)
ORDER BY id_wycieczki;


-- Średnie ocen wycieczek z podziałem na koordynatorów
SELECT t2.id_pracownika,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN pracownicy_wycieczka AS t2 USING(id_wycieczki)
JOIN pracownicy AS t3 USING(id_pracownika)
JOIN stanowiska AS t4 USING(id_stanowiska)
WHERE t4.stanowisko = 'Koordynator wycieczki'
AND t1.ocena IS NOT NULL
GROUP BY t2.id_pracownika;

-- Średnie ocen wycieczek z podziałem na fotografów
SELECT t2.id_pracownika,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN pracownicy_wycieczka AS t2 USING(id_wycieczki)
JOIN pracownicy AS t3 USING(id_pracownika)
JOIN stanowiska AS t4 USING(id_stanowiska)
WHERE t4.stanowisko = 'Fotograf'
AND t1.ocena IS NOT NULL
GROUP BY t2.id_pracownika;


-- Średnie oceny ofert (wszystkich)
SELECT t2.id_oferty,
        FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_ofert`
FROM osoby_zorganizowana_wycieczka AS t1 JOIN zorganizowana_wycieczka AS t2 USING (id_wycieczki)
WHERE t1.ocena IS NOT NULL
GROUP BY t2.id_oferty;




SELECT t1.id_wycieczki,
t3.nazwa,
FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_wycieczki`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN zorganizowana_wycieczka AS t2 USING(id_wycieczki)
JOIN oferty AS t3 USING(id_oferty)
WHERE ocena IS NOT NULL
GROUP BY id_wycieczki
HAVING
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` DESC
                                LIMIT 1)
OR
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` DESC
                                LIMIT 1, 1)
OR
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` DESC
                                LIMIT 2, 1)
ORDER BY `srednia_ocena_wycieczki` DESC, id_wycieczki;

SELECT t1.id_wycieczki,
t3.nazwa,
FLOOR(AVG(t1.ocena)*100)/100 AS `srednia_ocena_wycieczki`
FROM osoby_zorganizowana_wycieczka AS t1
JOIN zorganizowana_wycieczka AS t2 USING(id_wycieczki)
JOIN oferty AS t3 USING(id_oferty)
WHERE ocena IS NOT NULL
GROUP BY id_wycieczki
HAVING
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` ASC
                                LIMIT 1)
OR
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` ASC
                                LIMIT 1, 1)
OR
FLOOR(AVG(t1.ocena)*100)/100 = (SELECT FLOOR(AVG(ocena)*100)/100 AS `x`
                                FROM osoby_zorganizowana_wycieczka
                                WHERE ocena IS NOT NULL
                                GROUP BY id_wycieczki
                                ORDER BY `x` ASC
                                LIMIT 2, 1)
ORDER BY `srednia_ocena_wycieczki` ASC, id_wycieczki;
