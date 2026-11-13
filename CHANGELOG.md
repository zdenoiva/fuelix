# Changelog

Všetky podstatné zmeny Fuelixu. Formát vychádza z [Keep a Changelog](https://keepachangelog.com/sk/1.1.0/),
verzie sa riadia [SemVer](https://semver.org/lang/sk/).

## [0.2.1] - 2026-11-13

- Cena za liter a celková suma sa prepočítavajú obojsmerne pri každej zmene: úprava sumy prepíše cenu za liter, úprava ceny prepíše sumu a zmena litrov prepočíta cenu za liter.
- Po zadaní litrov a ceny za liter sa celková suma doplní okamžite a už sa „nezasekne“ na prvej číslici.
- Po vytvorení šifrovanej zálohy si vyberieš cieľ: uloženie do súboru (výber ponúkne OneDrive, Google Disk aj pamäť) alebo zdieľanie priamo do OneDrive či inej aplikácie.

## [0.2.0] - 2026-11-13

- Glass dizajn: jemný gradientový podklad, priehľadné karty s obrysom a nový vzhľad v svetlom aj tmavom režime.
- Obľúbené auto: hviezdičkou v detaile vozidla ho pripneš do hlavného menu a appka sa pri štarte otvorí rovno na ňom.
- Štatistiky: prepínanie áut, filter na rok alebo celé obdobie a nový graf prejdených kilometrov po mesiacoch.
- Cena za kilometer už zobrazuje menu (napr. „0,27 € / km“).
- Pri tankovaní sa pod poľom čerpačky ponúknu posledné tri použité stanice.
- Záloha sa šifruje heslom (AES-GCM s kľúčom z PBKDF2), takže ju možno obnoviť na akomkoľvek telefóne; bez hesla sa nedá otvoriť.
- Nastavenia reagujú okamžite – po zmene meny či témy sa hodnota v riadku zmení bez opätovného otvorenia obrazovky.
- Voľba „Systém“ vo vzhľade je vycentrovaná a na jednom riadku.
- Webová stránka už neobsahuje tabuľku ani údaje konkrétneho auta.

## [0.1.1] - 2026-11-12

- Prehľad vozidla a dlaždice v garáži sa po pridaní tankovania alebo výdavku hneď prepočítajú.
- Cena za liter a celková suma sa už navzájom neprepisujú počas písania; klepnutie na číselné pole hodnotu vyberie na prepísanie.
- Karta „Servis“ má kratší názov, aby sa zmestila na displeji telefóna.
- Pri štarte sa raz denne vytvorí lokálna záloha a drží sa posledných päť.
- Štatistiky skrývajú prázdny rozpad kategórií a nezobrazujú menu dvakrát.

## [0.1.0] - 2026-11-12

- Prvé vydanie Fuelixu: garáž s viacerými vozidlami, tankovania, výpočet spotreby medzi plnými nádržami a prehľad nákladov.
- Výdavky s kategóriami, mesačný súhrn a štatistiky (spotreba v čase, mesačné náklady, cena za kilometer).
- Servisné pripomienky podľa dátumu aj kilometrov s opakovaním a rýchlymi šablónami (olej, brzdy, pneumatiky, STK/EK, poistenie).
- Import kompletného exportu z Fuelia: vozidlo, tankovania s GPS a stanicou, výdavky, pripomienky, kategórie a obľúbené čerpačky.
- Skenovanie QR kódu z bločku, ktoré predvyplní litre, cenu za liter a celkovú sumu.
- Rozpoznanie čerpacej stanice podľa GPS a uloženie súradníc k tankovaniu.
- Slovenčina, čeština a angličtina, svetlý a tmavý režim, meny EUR/CZK/USD/PLN/HUF.
- Manuálna záloha do jedného JSON súboru, obnova zálohy a export tankovaní do CSV.
- Automatická kontrola aktualizácií z GitHubu s overením SHA-256 a inštaláciou APK.
