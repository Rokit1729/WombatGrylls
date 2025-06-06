# Projekt „Wombat Grylls” – Baza Danych do zarządzania wycieczkami niebezpiecznymi

Poniżej znajduje się opis struktury i zawartości repozytorium projektu grupy C, realizowanego przez Wiktora Niedźwiedzkiego, Dawida Skowrońskiego, Jakuba Wiszniewskiego, Mateusza Broczkowskiego oraz Filipa Michewicza.

---

## 1. Opis ogólny

Celem projektu jest stworzenie kompletnego rozwiązania bazy danych dla firmy „Wombat Grylls” organizującej niebezpieczne wycieczki. Repozytorium zawiera wszystkie niezbędne elementy:

1. Schemat bazy danych w formacie JSON.
2. Skrypty generujące i wypełniające dane w bazie (Python + CSV).
3. Raport analityczny wykonany w RStudio (HTML oraz źródła Rmd).
4. Dokumentację projektu (opis technologii, zależności funkcyjne, uzasadnienie EKNF).
5. Zestaw plików z danymi źródłowymi (cenniki, dane personalne, listy miast itp.).
6. Instrukcje uruchomienia etapów projektu.

---

## 2. Użyte technologie

- **Python**  
  - `numpy` – obliczenia numeryczne, operacje na macierzach i wektorach.  
  - `math` – funkcje matematyczne (sin, cos, sqrt itp.).  
  - `random` – generowanie liczb losowych.  
  - `pandas` – manipulacja i analiza danych w formacie DataFrame.  
  - `datetime` – operacje na datach i czasie.  
  - `faker` – generowanie sztucznych danych (imiona, adresy, numery telefonów).  
  - `mysql.connector` – połączenie i operacje na bazie MariaDB/MySQL.  
  - `csv` – odczyt/zapis plików CSV.

- **MariaDB**  
  - Silnik bazodanowy do przechowywania i zarządzania modelem danych.  
  - Konfiguracja połączenia oraz uprawnienia – szczegóły w pliku `jak_uruchomic.txt`.

- **RStudio**  
  - `RMariaDB` – interfejs do bazy danych MariaDB/MySQL.  
  - `ggplot2` – wizualizacje danych (wykresy).  
  - `dplyr` – manipulacja danymi w stylu SQL.  
  - `zoo` – praca z danymi czasowymi (szeregi czasowe).  
  - `knitr` – generowanie raportu (HTML, PDF).  
  - `scales` – formatowanie etykiet osi.  
  - `stringr` – operacje na ciągach znaków.

- **Visual Studio Code**  
  - Rozszerzenie **SQLTools MySQL/MariaDB/TiDB** – wygodne wysyłanie zapytań do bazy.  
  - Rozszerzenie **ERD Editor** – tworzenie diagramu ERD i generowanie kodu SQL.

---

## 3. Struktura repozytorium

```

/
├── jak\_uruchomic.txt
├── Generator/
│   ├── generator\_danych.ipynb
│   └── tworzenie\_bazy.ipynb
├── Dokumenty/
│   ├── schemat\_bazy\_projekt.json
│   ├── dokumentacja.Rmd
│   ├── dokumentacja.html
│   ├── analiza\_danych.Rmd
│   └── analiza\_danych.html
├── Dane do generatora/
│   ├── wycieczki.xlsx
│   ├── cennik.csv
│   ├── stanowiska.xlsx
│   ├── imiona.csv
│   ├── nazwiska\_damskie.csv
│   └── nazwiska\_męskie.csv
├── Dane do tabel/
│   ├── oferty.csv
│   ├── cennik.csv
│   ├── kierunki.csv
│   ├── miasta.csv
│   ├── rodzaje.csv
│   ├── osoby.csv
│   ├── dane\_alarmowe.csv
│   ├── stanowiska.csv
│   ├── pracownicy.csv
│   ├── pracownik\_urlop.csv
│   ├── zorganizowana\_wycieczka.csv
│   ├── pracownicy\_wycieczka.csv
│   └── osoby\_zorganizowana\_wycieczka.csv
└── Reszta/  (pliki pomocnicze, np. dodatkowe skrypty, notatki)

```

### 3.1 Pliki w katalogu głównym

- **`jak_uruchomic.txt`**  
  Instrukcja opisująca dokładną kolejność uruchamiania poszczególnych etapów projektu (tworzenie bazy, generowanie danych, wypełnianie, analiza, generowanie raportu).

### 3.2 Katalog `Generator/`

1. **`generator_danych.ipynb`**  
   - Notebook Pythona odpowiedzialny za:  
     - Generowanie realistycznych danych testowych (klienci, pracownicy, urlopy, oferty, itp.) przy użyciu pakietów `faker`, `random`, `pandas`, `datetime`.  
     - Zapis wygenerowanych danych do plików CSV w katalogu „Dane do tabel”.  
   - Uwzględnia:  
     - Poprawność dat (zakres czasu działania firmy, daty wycieczek, daty płatności).  
     - Realistyczne imiona i nazwiska (na podstawie danych GUS).  
     - Zgodność z minimalnym wynagrodzeniem krajowym dla pracowników.  
     - Przynajmniej 5 rodzajów wycieczek i 10 zorganizowanych wyjazdów w poprzednim roku.

2. **`tworzenie_bazy.ipynb`**  
   - Notebook Pythona łączący się z serwerem MariaDB (lub lokalną instancją) za pomocą `mysql.connector`.  
   - Tworzy schemat bazy danych (tabele, klucze główne, obce, indeksy) na podstawie pliku JSON (`Dokumenty/schemat_bazy_projekt.json`).  
   - Wstawia wygenerowane pliki CSV do odpowiadających im tabel, obsługując wartości NULL odpowiednio.

### 3.3 Katalog `Dokumenty/`

1. **`schemat_bazy_projekt.json`**  
   - Dokument JSON zawierający kompletny schemat bazy danych w formacie umożliwiającym automatyczne wygenerowanie tabel (ERD + definicje atrybutów, typów, kluczy).

2. **`dokumentacja.Rmd`**  
   - Plik źródłowy w R Markdown, generujący pełną dokumentację projektu w formacie HTML.  
   - Zawiera:  
     - Spis użytych technologii.  
     - Listę plików z krótkim opisem.  
     - Zależności funkcyjne dla każdej relacji.  
     - Uzasadnienie poprawności bazy w EKNF.  
     - Opis najtrudniejszych elementów realizacji.

3. **`dokumentacja.html`**  
   - Wygenerowana wersja HTML dokumentacji (wynik działania `knitr` na `dokumentacja.Rmd`).

4. **`analiza_danych.Rmd`**  
   - Plik źródłowy w R Markdown do analizy danych (część 3 projektu).  
   - Zawiera skrypty R łączące się z bazą danych (via `RMariaDB`), wykonujące:  
     - Analizę popularności rodzajów wycieczek (koszty, zyski, rentowność).  
     - Wykres liczby obsłużonych klientów w kolejnych miesiącach (analiza trendu).  
     - Badanie lojalności klientów (powroty na kolejne wycieczki).  
     - Cztery dodatkowe pytania analityczne wypracowane przez zespół.

5. **`analiza_danych.html`**  
   - Wygenerowany raport HTML z analizy danych (wynik działania `knitr` na `analiza_danych.Rmd`).

6. **`.Rhistory`**  
   - Historia sesji R (automatycznie tworzona przez RStudio podczas pracy nad plikami Rmd).

### 3.4 Katalog `Dane do generatora/`

Zestaw plików wejściowych używanych przez notebook `generator_danych.ipynb`:

- **`wycieczki.xlsx`** – aktualna oferta wycieczek firmy „Wombat Grylls” (nazwy, opisy, kategorie).
- **`cennik.csv`** – arkusz cen bazowych i cen jednostkowych dla każdej oferty.
- **`stanowiska.xlsx`** – lista stanowisk pracowniczych wraz z minimalnymi wynagrodzeniami.
- **`imiona.csv`, `nazwiska_damskie.csv`, `nazwiska_męskie.csv`** – zestawy imion i nazwisk (dane GUS), służące do generowania realistycznych danych personalnych klientów i pracowników.

### 3.5 Katalog `Dane do tabel/`

Pliki CSV, które stanowią dane wejściowe do wypełnienia tabel w bazie (stanowią wynik poprzedniego etapu):

- **`oferty.csv`** – informacje o organizowanych eventach (id_oferty, nazwa, id_rodzaju, id_kierunku, id_miasta, opis, id_cennika, czas_trwania, czy_bezpieczna).
- **`cennik.csv`** – zestawienie kosztów i cen (id_cennika, koszt_na_osobe, cena_biletu, koszt_podstawowy).
- **`kierunki.csv`** – dane o dostępnych kierunkach wycieczek (id_kierunku, miejsce).
- **`miasta.csv`** – lista miast, w których organizowane są eventy (id_miasta, nazwa).
- **`rodzaje.csv`** – rodzaje wycieczek (id_rodzaju, nazwa).
- **`osoby.csv`** – dane klientów (id_osoby, imię, nazwisko, numer telefonu, e-mail, id_alarm).
- **`dane_alarmowe.csv`** – dane kontaktów alarmowych (id_alarm, imię, nazwisko, numer telefonu).
- **`stanowiska.csv`** – dane o stanowiskach pracowników (id_stanowiska, nazwa stanowiska, wynagrodzenie).
- **`pracownicy.csv`** – zatrudnieni pracownicy (id_pracownika, imię, nazwisko, id_stanowiska, data_zatrudnienia, czy_zatrudniony, numer telefonu, e-mail).
- **`pracownik_urlop.csv`** – informacje o urlopach pracowników (id_pracownika, początek_urlopu, koniec_urlopu).
- **`zorganizowana_wycieczka.csv`** – dane o zorganizowanych wycieczkach (id_wycieczki, id_oferty, data_wycieczki).
- **`pracownicy_wycieczka.csv`** – przyporządkowanie pracowników do konkretnych wycieczek (id_wycieczki, id_pracownika).
- **`osoby_zorganizowana_wycieczka.csv`** – uczestnicy wycieczek (id_wycieczki, id_osoby, data_platnosci, ocena).

### 3.6 Katalog `Reszta/`

Zawiera dodatkowe pliki pomocnicze wykorzystane podczas realizacji projektu (np. notatki, drobne skrypty, wersje robocze).

---

## 4. Instrukcje uruchomienia

Dokładna kolejność i sposób uruchamiania poszczególnych etapów znajduje się w pliku:

- **`jak_uruchomic.txt`**  
  Zawiera krok po kroku instrukcję uruchamiania:
  1. Utworzenie schematu bazy danych (`Generator/tworzenie_bazy.ipynb`).  
  2. Generacja danych testowych i zapis do CSV (`Generator/generator_danych.ipynb`).  
  3. Wczytanie danych CSV do bazy (również poprzez `tworzenie_bazy.ipynb`).  
  4. Uruchomienie analizy danych w R (`Dokumenty/analiza_danych.Rmd`).  
  5. Wygenerowanie dokumentacji (`Dokumenty/dokumentacja.Rmd`).  

---

## 5. Schemat bazy danych

Pełny schemat bazy w formacie JSON znajduje się w:

- **`Dokumenty/schemat_bazy_projekt.json`**  

Schemat zawiera definicję relacji:

1. **`stanowiska`**  
   - Atrybuty: `id_stanowiska (PK)`, `stanowisko`, `wynagrodzenie`  
   - Zależności funkcyjne:  
     - `id_stanowiska → stanowisko, wynagrodzenie`  
     - `stanowisko → id_stanowiska, wynagrodzenie`  

2. **`pracownicy`**  
   - Atrybuty: `id_pracownika (PK)`, `imie`, `nazwisko`, `id_stanowiska (FK)`, `data_zatrudnienia`, `czy_zatrudniony`, `numer_telefonu`, `email`  
   - Zależności funkcyjne:  
     - `id_pracownika → imie, nazwisko, id_stanowiska, data_zatrudnienia, czy_zatrudniony, numer_telefonu, email`  
     - `numer_telefonu → id_pracownika, imie, nazwisko, id_stanowiska, data_zatrudnienia, czy_zatrudniony, email`  
     - `email → id_pracownika, imie, nazwisko, id_stanowiska, data_zatrudnienia, czy_zatrudniony, numer_telefonu`  

3. **`urlopy`**  
   - Atrybuty: `id_pracownika (FK)`, `poczatek_urlopu (PK, część składowa)`, `koniec_urlopu`  
   - Zależności funkcyjne:  
     - `(id_pracownika, poczatek_urlopu) → koniec_urlopu`  
     - `(id_pracownika, koniec_urlopu) → poczatek_urlopu`  

4. **`osoby`**  
   - Atrybuty: `id_osoby (PK)`, `imie`, `nazwisko`, `numer_telefonu`, `email`, `id_alarm (FK)`  
   - Zależności funkcyjne:  
     - `id_osoby → imie, nazwisko, numer_telefonu, email, id_alarm`  
     - `numer_telefonu → id_osoby, imie, nazwisko, email, id_alarm`  
     - `email → id_osoby, imie, nazwisko, numer_telefonu, id_alarm`  

5. **`dane_alarmowe`**  
   - Atrybuty: `id_alarm (PK)`, `imie`, `nazwisko`, `numer_telefonu`  
   - Zależności funkcyjne:  
     - `id_alarm → imie, nazwisko, numer_telefonu`  
     - `numer_telefonu → id_alarm, imie, nazwisko`  

6. **`oferty`**  
   - Atrybuty: `id_oferty (PK)`, `nazwa`, `id_rodzaju (FK)`, `id_kierunku (FK)`, `id_miasta (FK)`, `opis`, `id_cennika (FK)`, `czas_trwania`, `czy_bezpieczna`  
   - Zależności funkcyjne:  
     - `id_oferty → nazwa, id_rodzaju, id_kierunku, id_miasta, opis, id_cennika, czas_trwania, czy_bezpieczna`  
     - `id_cennika → id_oferty, nazwa, id_rodzaju, id_kierunku, id_miasta, opis, czas_trwania, czy_bezpieczna`  

7. **`kierunki`**  
   - Atrybuty: `id_kierunku (PK)`, `miejsce`  
   - Zależności funkcyjne:  
     - `id_kierunku → miejsce`  
     - `miejsce → id_kierunku`  

8. **`miasta`**  
   - Atrybuty: `id_miasta (PK)`, `nazwa`  
   - Zależności funkcyjne:  
     - `id_miasta → nazwa`  
     - `nazwa → id_miasta`  

9. **`rodzaje`**  
   - Atrybuty: `id_rodzaju (PK)`, `nazwa`  
   - Zależności funkcyjne:  
     - `id_rodzaju → nazwa`  
     - `nazwa → id_rodzaju`  

10. **`cennik`**  
    - Atrybuty: `id_cennika (PK)`, `koszt_na_osobe`, `cena_biletu`, `koszt_podstawowy`  
    - Zależności funkcyjne:  
      - `id_cennika → koszt_na_osobe, cena_biletu, koszt_podstawowy`  

11. **`zorganizowana_wycieczka`**  
    - Atrybuty: `id_wycieczki (PK)`, `id_oferty (FK)`, `data_wycieczki`  
    - Zależności funkcyjne:  
      - `id_wycieczki → id_oferty, data_wycieczki`  
      - `(id_oferty, data_wycieczki) → id_wycieczki`  

12. **`osoby_zorganizowana_wycieczka`**  
    - Atrybuty: `id_wycieczki (FK, część klucza)`, `id_osoby (FK, część klucza)`, `data_platnosci`, `ocena`  
    - Zależności funkcyjne:  
      - `(id_wycieczki, id_osoby) → data_platnosci, ocena`  

13. **`pracownicy_wycieczka`**  
    - Atrybuty: `id_wycieczki (FK)`, `id_pracownika (FK)`  
    - Brak dodatkowych zależności funkcyjnych poza użyciem obcych kluczy.  

### 5. Normalizacja i EKNF

- Każda relacja jest w EKNF (Elementarnej Postaci Normalnej), ponieważ wszystkie zależności nietrywialne mają lewą stronę będącą nadkluczem relacji.  
- Szczegółowe uzasadnienie wraz z listą zależności funkcyjnych znajduje się w `Dokumenty/dokumentacja.Rmd` (sekcja „Czy baza jest w EKNF?”).

---

## 6. Analiza danych

1. **Najpopularniejsze rodzaje wypraw**  
   - Porównanie kosztów organizacji, ceny biletu i rentowności.  
2. **Liczba obsłużonych klientów w każdym miesiącu**  
   - Wykres czasu (szereg czasowy) pokazujący trend wzrostu/spadku liczby klientów.  
3. **Lojalność klientów**  
   - Identyfikacja wycieczek, po których klienci powracają, oraz tych, po których rezygnują.  
4. **Dodatkowe pytania analityczne (min. 4)**  
   - Skonstruowane przez zespół na podstawie wygenerowanych danych (np. sezonowość popytu, efektywność kosztów pracowników, analiza urlopów vs. realizacje wyjazdów, itp.).

Pełne wyniki analizy dostępne są w pliku `Dokumenty/analiza_danych.html`.

---

## 7. Dokumentacja i raport

- **Plik źródłowy dokumentacji:** `Dokumenty/dokumentacja.Rmd`  
- **Wygenerowana wersja HTML:** `Dokumenty/dokumentacja.html`  
- **Plik źródłowy analizy:** `Dokumenty/analiza_danych.Rmd`  
- **Wygenerowany raport analityczny:** `Dokumenty/analiza_danych.html`  

Cała procedura generowania raportu jest zautomatyzowana przy użyciu `knitr` w RStudio. Wystarczy otworzyć pliki `.Rmd` i uruchomić kompilację (lub wykonać odpowiedni skrypt wskazany w `jak_uruchomic.txt`), aby uzyskać finalne pliki HTML.

---

## 8. Najtrudniejsze elementy realizacji projektu

1. Zebranie się do pracy po feriach świątecznych.  
2. Wymyślenie sensownego sposobu generowania danych spełniających wszystkie założenia (poprawność dat, zależności funkcyjne, realne wartości).  
3. Uwzględnienie wszystkich zależności w danych (np. zapewnienie, że data zakupu wycieczki nie wykracza poza istnienie firmy).  
4. Zrozumienie różnicy między kluczem głównym a elementarnym w kontekście normalizacji EKNF.  
5. Stworzenie lokalnej, działającej bazy danych (konieczność uzyskania dostępu do serwera giniewicz.it z powodu problemów z lokalną instalacją).

---

## 9. Sposób uruchamiania (podsumowanie)

1. **Przygotowanie bazy danych**  
   - Otworzyć `Generator/tworzenie_bazy.ipynb`.  
   - Wykonać połączenie do wybranej instancji MariaDB (lokalnej lub serwer giniewicz.it).  
   - Uruchomić komórki tworzące tabele na podstawie pliku `Dokumenty/schemat_bazy_projekt.json`.

2. **Generacja i wypełnienie danych**  
   - Otworzyć `Generator/generator_danych.ipynb`.  
   - Wygenerować zestaw plików CSV (zawartość katalogu „Dane do tabel”).  
   - W notatniku `tworzenie_bazy.ipynb` wczytać pliki CSV do tabel (obsługa wartości NULL).

3. **Analiza danych**  
   - Otworzyć `Dokumenty/analiza_danych.Rmd`.  
   - Zapewnić poprawne połączenie do tej samej bazy danych.  
   - Uruchomić wszystkie komórki, aby wygenerować `analiza_danych.html`.

4. **Generowanie dokumentacji**  
   - Otworzyć `Dokumenty/dokumentacja.Rmd`.  
   - Uruchomić kompilację (`knitr`) w RStudio, aby uzyskać `dokumentacja.html`.

5. **Przegląd wyników**  
   - Raport analityczny: `Dokumenty/analiza_danych.html`.  
   - Dokumentacja projektu: `Dokumenty/dokumentacja.html`.  

---

## 10. Lista plików i ich zawartość

| Ścieżka                                | Nazwa pliku                       | Opis                                                                                          |
|----------------------------------------|-----------------------------------|-----------------------------------------------------------------------------------------------|
| `/jak_uruchomic.txt`                   | `jak_uruchomic.txt`               | Instrukcja kolejności uruchamiania poszczególnych etapów projektu.                            |
| `/Generator/`                          | —                                 | Katalog zawierający skrypty Pythona do generacji i wypełniania bazy.                          |
| `/Generator/generator_danych.ipynb`    | `generator_danych.ipynb`          | Notebook generujący dane testowe (CSV).                                                        |
| `/Generator/tworzenie_bazy.ipynb`      | `tworzenie_bazy.ipynb`            | Notebook tworzący tabele w bazie i wypełniający je plikami CSV.                               |
| `/Dokumenty/`                          | —                                 | Katalog z dokumentacją, schematem bazy i raportami analitycznymi.                             |
| `/Dokumenty/schemat_bazy_projekt.json` | `schemat_bazy_projekt.json`       | Schemat bazy danych w formacie JSON (definicje tabel, typów, kluczy, indeksów).               |
| `/Dokumenty/dokumentacja.Rmd`          | `dokumentacja.Rmd`                | Źródło dokumentacji (R Markdown).                                                             |
| `/Dokumenty/dokumentacja.html`         | `dokumentacja.html`               | Wygenerowana dokumentacja w formacie HTML.                                                     |
| `/Dokumenty/analiza_danych.Rmd`        | `analiza_danych.Rmd`              | Źródło raportu analitycznego (R Markdown).                                                     |
| `/Dokumenty/analiza_danych.html`       | `analiza_danych.html`             | Wygenerowany raport analityczny w formacie HTML.                                              |
| `/Dane do generatora/`                 | —                                 | Zbiór plików źródłowych używanych do generowania danych testowych.                            |
| `/Dane do generatora/wycieczki.xlsx`   | `wycieczki.xlsx`                  | Aktualna oferta wycieczek (nazwa, opis, kategorie).                                           |
| `/Dane do generatora/cennik.csv`       | `cennik.csv`                      | Arkusz cen bazowych i jednostkowych dla każdej oferty.                                        |
| `/Dane do generatora/stanowiska.xlsx`  | `stanowiska.xlsx`                 | Lista stanowisk pracowników wraz z minimalnymi wynagrodzeniami.                               |
| `/Dane do generatora/imiona.csv`       | `imiona.csv`                      | Lista imion (dane GUS).                                                                       |
| `/Dane do generatora/nazwiska_damskie.csv` | `nazwiska_damskie.csv`          | Lista nazwisk kobiecych (dane GUS).                                                           |
| `/Dane do generatora/nazwiska_męskie.csv` | `nazwiska_męskie.csv`           | Lista nazwisk męskich (dane GUS).                                                             |
| `/Dane do tabel/`                      | —                                 | Pliki CSV przeznaczone do wczytania bezpośrednio do bazy danych.                              |
| `/Dane do tabel/oferty.csv`            | `oferty.csv`                      | Informacje o eventach (id_oferty, nazwa, kategorie, opis, czas trwania, bezpieczeństwo).     |
| `/Dane do tabel/cennik.csv`            | `cennik.csv`                      | Ceny udziału, koszty na osobę i koszty organizacji (id_cennika).                               |
| `/Dane do tabel/kierunki.csv`          | `kierunki.csv`                    | Kierunki wycieczek (id_kierunku, miejsce).                                                     |
| `/Dane do tabel/miasta.csv`            | `miasta.csv`                      | Lista miast (id_miasta, nazwa).                                                                |
| `/Dane do tabel/rodzaje.csv`           | `rodzaje.csv`                     | Rodzaje wycieczek (id_rodzaju, nazwa).                                                         |
| `/Dane do tabel/osoby.csv`             | `osoby.csv`                       | Dane klientów (id_osoby, imię, nazwisko, kontakt, id_alarm).                                    |
| `/Dane do tabel/dane_alarmowe.csv`     | `dane_alarmowe.csv`               | Kontakty alarmowe (id_alarm, imię, nazwisko, numer telefonu).                                  |
| `/Dane do tabel/stanowiska.csv`        | `stanowiska.csv`                  | Stanowiska pracowników (id_stanowiska, nazwa, wynagrodzenie).                                  |
| `/Dane do tabel/pracownicy.csv`        | `pracownicy.csv`                  | Dane pracowników (id_pracownika, imię, nazwisko, stanowisko, data zatrudnienia itp.).          |
| `/Dane do tabel/pracownik_urlop.csv`   | `pracownik_urlop.csv`             | Urlopy pracowników (id_pracownika, początek_urlopu, koniec_urlopu).                           |
| `/Dane do tabel/zorganizowana_wycieczka.csv` | `zorganizowana_wycieczka.csv`| Zorganizowane wycieczki (id_wycieczki, id_oferty, data wycieczki).                             |
| `/Dane do tabel/pracownicy_wycieczka.csv` | `pracownicy_wycieczka.csv`      | Pracownicy przypisani do wycieczek (id_wycieczki, id_pracownika).                              |
| `/Dane do tabel/osoby_zorganizowana_wycieczka.csv` | `osoby_zorganizowana_wycieczka.csv` | Uczestnicy wycieczek (id_wycieczki, id_osoby, data płatności, ocena).         |
| `/Reszta/`                             | —                                 | Pliki pomocnicze, notatki, dodatkowe skrypty używane podczas tworzenia projektu.               |

---

## 11. Kontakt i wsparcie

W razie pytań dotyczących projektu, prosimy o kontakt mailowy z którymkolwiek członkiem zespołu wymienionym w dokumentacji.  

---

© 2025 Wikor Niedźwiedzki, Filip Michewicz, Jakub Wiszniewski, Dawid Skowroński, Mateusz Broczkowski – „Wombat Grylls”  
```
