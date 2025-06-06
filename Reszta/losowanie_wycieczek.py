import numpy as np
from math import floor
import random
import pandas as pd

#Liczba klientow i zalezna od niej wycieczek
n_klienci = 300 #tyle musi byc co najmniej
n_wycieczki = floor(n_klienci/30*1.5)

print(n_klienci, n_wycieczki)

#Losowanie odbytych wycieczek
ile_jest = 15 #liczba do zczytania z listy wszystkich planow eventow

minimum_5 = False

while True:
	jaka_wycieczka = {'id_wycieczki': [], 'id_planu': []}
	ilosc = set()
	for i in range(n_wycieczki):
		losowe = random.randint(1, ile_jest)
		jaka_wycieczka['id_wycieczki'].append(i+1)
		jaka_wycieczka['id_planu'].append(losowe)
		ilosc.add(losowe)
	if len(ilosc) >= 5: break

jaka_wycieczka = pd.DataFrame(jaka_wycieczka)

print(jaka_wycieczka) #gotowe do umieszczenia w tabeli, trzeba tylko wygenerowac plik, czego nie zrobie na telefonie



