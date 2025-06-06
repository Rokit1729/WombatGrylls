install.packages("RMariaDB")
install.packages("ggplot2")
install.packages("scales")

options(scipen = 999)
library(scales)
library(ggplot2)
library(RMariaDB)
library(dplyr)
library(zoo)

#Tworzenie połaczenia z serwerem
con <- dbConnect(RMariaDB::MariaDB(),
                 host="giniewicz.it",  
                 user="team24",       
                 password="te@mzaza",  
                 dbname="team24",
)

# Zestawienie wszystkich obsłużonych klientów w danym miesiącu działalności
query_2.1 <- "SELECT YEAR(data_wycieczki) AS rok, 
              MONTH(data_wycieczki) AS miesiac, 
              COUNT(id_osoby) AS liczba_klientow
              FROM osoby_zorganizowana_wycieczka
              JOIN zorganizowana_wycieczka USING(id_wycieczki)
              GROUP BY rok, miesiac
              ORDER BY rok ASC, miesiac ASC;"

#Zapisanie wyniku do ramki danych
df_klienci_wszyscy <- dbGetQuery(con, query_2.1)

#Zamknięcie połączenia
dbDisconnect(con)

head(df_klienci_wszyscy)

#Scalenie kolumn rok i miesiąc
df_klienci_wszyscy %>% mutate(data = paste0(rok,"-",miesiac)) -> df_klienci_wszyscy_data 

df_klienci_wszyscy_data$liczba_klientow <- as.numeric(df_klienci_wszyscy_data$liczba_klientow)
df_klienci_wszyscy_data$data <- as.yearmon(df_klienci_wszyscy_data$data)
df_odbyte_wycieczki<- df_klienci_wszyscy_data[df_klienci_wszyscy_data$data <= "2025-01",] #Obcninamy wycieczki do stycznia 2025 roku, aby miec podsumowanie pełnych miesięcy (opłata musi być do 14 dni przed rozpoczęciem wycieczki)

najw_wart <- which(df_odbyte_wycieczki$liczba_klientow == max(df_odbyte_wycieczki$liczba_klientow))
najm_wart <- which(df_odbyte_wycieczki$liczba_klientow == min(df_odbyte_wycieczki$liczba_klientow))
kolory = rep("lightblue", length(df_odbyte_wycieczki$data))
kolory[najm_wart] <- "red2"
kolory[najw_wart] <- "green3"

liczba_najw_wart <- df_odbyte_wycieczki$liczba_klientow[najw_wart]
liczba_najm_wart <- df_odbyte_wycieczki$liczba_klientow[najm_wart]

najw_mies<- df_odbyte_wycieczki$data[c(najw_wart)]
najmn_mies<- df_odbyte_wycieczki$data[c(najm_wart)]

paste("Największa liczba obsłużonych klientów wynosi", liczba_najw_wart, 
                  "i wystąpiła w miesiącach:", paste(najw_mies, collapse = ", "), ".")
# Tworzenie wykresu
ggplot(df_odbyte_wycieczki, aes(x = data, y = liczba_klientow)) +
  geom_col(fill = kolory) +
  geom_smooth(method = "lm", color = "blue", linetype = "dashed", se = FALSE) +
  labs(title = "Liczba obsłużonych klientów w każdym miesiącu działalności firmy",
       x = "Data",
       y = "Liczba klientów")+
  scale_x_continuous(breaks=as.numeric(df_odbyte_wycieczki$data), labels=format(df_odbyte_wycieczki$data,"%Y %m")) +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Obrót etykiet osi X

trend_klienci_wszyscy <- lm(liczba_klientow ~ as.numeric(data), data = df_odbyte_wycieczki) # funkcja która dopasowuje trend liniowy
trend_klienci_wszyscy <- coef(trend_klienci_wszyscy)[2] # współczynnik kierunkowy
if (trend_klienci_wszyscy > 0) {
  trend_kl_wszyscy_odp <- "trend rosnący liczby obsłużonych klientów w analizowanym przedziale."
} else if (trend_klienci_wszyscy < 0) {
  trend_kl_wszyscy_odp <- "trend malejący liczby obsłużonych klientów maleje w analizowanym przedziale."
} else {
  trend_kl_wszyscy_odp <- "trend, utrzymujący się na stały poziomie liczby obsłużonych."
}

#################################################################
#################################################################
# Gdy uwzględnimy tylko unikatowych klientów w każdym miesiącu

#Tworzenie połaczenia z serwerem
con <- dbConnect(RMariaDB::MariaDB(),
                 host="giniewicz.it",  
                 user="team24",       
                 password="te@mzaza",  
                 dbname="team24",
)


query_2.2 <- "SELECT YEAR(data_wycieczki) AS rok, 
              MONTH(data_wycieczki) AS miesiac, 
              COUNT(DISTINCT(id_osoby)) AS liczba_klientow
              FROM osoby_zorganizowana_wycieczka
              JOIN zorganizowana_wycieczka USING(id_wycieczki)
              GROUP BY rok, miesiac
              ORDER BY rok ASC, miesiac ASC;"

#Zapisanie wyniku do ramki danych
df_klienci_unikatowi <- dbGetQuery(con, query_2.2)

#Zamknięcie połączenia
dbDisconnect(con)

head(df_klienci_unikatowi)

#Scalenie kolumn rok i miesiąc
df_klienci_unikatowi %>% mutate(data = paste0(rok,"-",miesiac)) -> df_klienci_unikatowi_data 
head(df_klienci_unikatowi_data)

df_klienci_unikatowi_data$liczba_klientow <- as.numeric(df_klienci_unikatowi_data$liczba_klientow)
df_klienci_unikatowi_data$data <- as.yearmon(df_klienci_unikatowi_data$data)
df_klienci_unikatowi_odbyte <- df_klienci_unikatowi_data[df_klienci_unikatowi_data$data <= '2025-01',]

najw_wart_uq <- which(df_klienci_unikatowi_odbyte$liczba_klientow == max(df_klienci_unikatowi_odbyte$liczba_klientow))
najm_wart_uq <- which(df_klienci_unikatowi_odbyte$liczba_klientow == min(df_klienci_unikatowi_odbyte$liczba_klientow))
kolory = rep("lightblue", length(df_klienci_unikatowi_odbyte$data))
kolory[najm_wart_uq] <- "red2"
kolory[najw_wart_uq] <- "green3"


liczba_najw_wart_uq <- df_klienci_unikatowi_odbyte$liczba_klientow[najw_wart_uq]
liczba_najm_wart_uq <- df_klienci_unikatowi_odbyte$liczba_klientow[najm_wart_uq]

najw_mies_uq<- df_klienci_unikatowi_odbyte$data[c(najw_wart_uq)]
najmn_mies_uq<- df_klienci_unikatowi_odbyte$data[c(najm_wart_uq)]

paste("Największa liczba obsłużonych klientów wynosi", liczba_najw_wart_uq, 
      "i wystąpiła w miesiącach:", paste(najw_mies_uq, collapse = ", "), ".")


trend_klienci_uq <- lm(liczba_klientow ~ as.numeric(data), data = df_klienci_unikatowi_odbyte) # funkcja która dopasowuje trend liniowy
trend_klienci_uq <- coef(trend_klienci_uq)[2] # współczynnik kierunkowy
if (trend_klienci_uq > 0) {
  trend_klienci_uq_odp <- "trend rosnący liczby obsłużonych klientów w analizowanym przedziale"
} else if (trend_klienci_uq < 0) {
  trend_klienci_uq_odp <- "trend malejący liczby obsłużonych klientów w analizowanym przedziale"
} else {
  trend_klienci_uq_odp <- "trend, utrzymujący się na stały poziomie liczby obsłużonych"
}



# Tworzenie wykresu
ggplot(df_klienci_unikatowi_odbyte, aes(x = data, y = liczba_klientow)) +
  geom_col(fill = kolory) +
  geom_smooth(method = "lm", color = "blue", linetype = "dashed", se = FALSE) +
  labs(title = "Liczba obsłużonych unikatowych klientów w każdym miesiącu działalności firmy",
       x = "Data",
       y = "Liczba klientów")+
  scale_x_continuous(breaks=as.numeric(df_klienci_unikatowi_odbyte$data), labels=format(df_klienci_unikatowi_odbyte$data,"%Y %m")) +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Obrót etykiet osi X

#ILE MIESIĘCZNIE MUSIMY ZAPŁACIĆ PRACOWNIKOM
con <- dbConnect(RMariaDB::MariaDB(),
                 host="giniewicz.it",  
                 user="team24",       
                 password="te@mzaza",  
                 dbname="team24",
)

query_2.3 <- "SELECT COUNT(id_pracownika) AS liczba_pracowników,
              SUM(wynagrodzenie) AS miesieczne_oplaty_wynagrodzen
              FROM stanowiska
              JOIN pracownicy USING(id_stanowiska);"

df_oplaty_pracownikow <- dbGetQuery(con, query_2.3)

dbDisconnect(con)

head(df_oplaty_pracownikow)




#Zliczamy zysk w każdym miesiącu

#Tworzenie połaczenia z serwerem
con <- dbConnect(RMariaDB::MariaDB(),
                 host="giniewicz.it",  
                 user="team24",       
                 password="te@mzaza",  
                 dbname="team24",
)

query_2.1_zysk <- "SELECT  rok,
                          miesiac, 
                          SUM(zysk) AS zysk_miesieczny 
                  FROM (SELECT
                      YEAR(z.data_wycieczki) AS rok,
                      MONTH(z.data_wycieczki) AS miesiac,
                      SUM(c.cena_biletu) - SUM(c.koszt_na_osobe) - SUM(DISTINCT c.koszt_podstawowy) AS zysk 
                  FROM osoby_zorganizowana_wycieczka AS ozw
                  JOIN zorganizowana_wycieczka AS z USING(id_wycieczki)
                  JOIN oferty AS o USING(id_oferty)
                  JOIN cennik AS c USING(id_cennika)
                  WHERE data_platnosci IS NOT NULL
                  GROUP BY id_wycieczki) AS wycieczki_na_miesiac
                  GROUP BY rok, miesiac
                  ORDER BY rok ASC, miesiac ASC;"

#Zapisanie wyniku do ramki danych
df_zysk_wszystko <- dbGetQuery(con, query_2.1_zysk)

#Zamknięcie połączenia
dbDisconnect(con)

head(df_zysk_wszystko)

df_zysk_wszystko %>% mutate(data = paste0(rok,"-",miesiac)) -> df_zysk_wszystko_data 
head(df_zysk_wszystko_data)

df_zysk_wszystko_data$zysk <- as.numeric(df_zysk_wszystko_data$zysk)
df_zysk_wszystko_data$data <- as.yearmon(df_zysk_wszystko_data$data)
df_zysk_faktyczny <- df_zysk_wszystko_data[df_zysk_wszystko_data$data <= "2025-01",]

najw_zysk <- which(df_zysk_faktyczny$zysk == max(df_zysk_faktyczny$zysk))
najm_zysk <- which(df_zysk_faktyczny$zysk == min(df_zysk_faktyczny$zysk))
kol = rep("steelblue", length(df_zysk_faktyczny$data))
kol[najw_zysk] <- "green3"
kol[najm_zysk] <- "red"

#Największy zysk (wartość zł) firma uzyskała w miesiacach

liczba_najw_zysk <- df_zysk_faktyczny$zysk[najw_zysk]
liczba_najmn_zysk <- df_zysk_faktyczny$zysk[najm_zysk]

najw_mies_zysk<- df_zysk_faktyczny$data[c(najw_zysk)]
najmn_mies_zysk<- df_zysk_faktyczny$data[c(najm_zysk)]

paste("Największy zysk", liczba_najw_zysk, 
      "i wystąpił w miesiącach:", paste(najw_mies_zysk, collapse = ", "), ".")


trend_zysk <- lm(zysk ~ as.numeric(data), data = df_zysk_faktyczny) # funkcja która dopasowuje trend liniowy
trend_zysk <- coef(trend_zysk)[2] # współczynnik kierunkowy
if (trend_zysk > 0) {
  trend_zysk_odp <- "trend rosnący zysków firmy w analizowanym przedziale"
} else if (trend_zysk < 0) {
  trend_zysk_odp <- "trend malejący zysków firmy w analizowanym przedziale"
} else {
  trend_zysk_odp <- "trend, utrzymujący się na stały poziomie"
}




# Tworzenie wykresu
ggplot(df_zysk_faktyczny, aes(x = data, y = zysk) ) +
  geom_col(fill = kol) +
  geom_smooth(method = "lm", color = "magenta2", linetype = "dashed", se = FALSE) +
  labs(title = "Zyski firmy w każdym miesiącu działalności",
       x = "Data",
       y = "Wartość [zł]") +
  scale_x_continuous(breaks=as.numeric(df_zysk_faktyczny$data), labels=format(df_zysk_faktyczny$data,"%Y %m")) +
  scale_y_continuous(labels = scales::comma) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_hline(yintercept = df_oplaty_pracownikow$miesieczne_oplaty_wynagrodzen
, color = "black", linetype = "dotted", size = 1)

ile_razy_straty <- length(df_zysk_faktyczny$zysk[df_zysk_faktyczny$zysk <df_oplaty_pracownikow$miesieczne_oplaty_wynagrodzen])
ile_razy_straty

if (ile_razy_straty==0) {
  straty_odp <- "W żadnym miesiącu firma nie poniosła strat (zyski zawsze były większe od kosztów prowadzenia działalności)"
} else {
  straty_odp <- paste("W", ile_razy_straty ,"miesiącach zyski nie wystarczyły do opłacenia pracowników.")
}
straty_odp

#Ostatecznie możemy stwierdzić, że
if (trend_zysk>0 & trend_klienci_wszyscy>0) {
  odp_zad_2 <- "firma rozrasta się. Rośnie liczba obsługowanych klientów, jaki i zyski, które firma uzyskuje w kolejnych miesiącach."
} else if (trend_zysk>0 & trend_klienci_wszyscy<0){
  odp_zad_2 <- "pomimo rosnących zysków w każdym miesiącu, firma nie przyciąga do siebie nowych klientów. W dłuższym rozrachunku firma może orgazniować zbyt mało wycieczek, aby opłacić koszta swojej działalności. Potrzebne są zmiany, które zachęcą większą liczbę klientów do brania udziału w wydarzeniach."
} else if (trend_zysk<0 & trend_klienci_wszyscy>0){
  odp_zad_2 <- "pomimo rosnącej liczby klientów w każdym miesiącu, zyski maleją. Pomimo coraz większego zainteresowania wycieczkami, firma może nie być w stanie ich organizować. Przy dłuższym utrzymaniu się obecnych trendów, firma może upaść."
} else {
  odp_zad_2 <- "firma upada. Zarówno liczba obsługiwanych klientów, jak i zyski, maleją z miesiąca na miesiąc. Potrzebne są zmiany, które zarówno przyciągną nowych klientów, jak i zwiększą zyski z organizowanych wydarzeń"
}
odp_zad_2



