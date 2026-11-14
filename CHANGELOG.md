# Changelog

Všetky podstatné zmeny Fuelixu. Formát vychádza z [Keep a Changelog](https://keepachangelog.com/sk/1.1.0/),
verzie sa riadia [SemVer](https://semver.org/lang/sk/).

## [0.6.0] - 2026-11-14

- Výdavky sa dajú načítať z bločku: QR alebo fotka vyplní názov (obchod/prevádzku), sumu a dátum.
- Z eKasa bločku sa do poznámky vypíšu všetky položky s množstvom, jednotkovou cenou a súčtom.
- Tachometer pri výdavku je nepovinný (v poli je vyznačené „nepovinné“).
- Dátum tankovania aj výdavku sa berie z bločku — z eKasy aj z fotky (OCR).

## [0.5.1] - 2026-11-14

- Miesto tankovania z GPS už obsahuje aj obec: z „Shell“ sa doplní „Shell Prievidza“ (reverse geocoding). Názvy, ktoré obec už majú alebo obsahujú pobočku (napr. „Shell PD“), zostanú bez zmeny.
- Geolokácia má časový limit, takže tlačidlo „moja poloha“ nikdy nezostane visieť; hláška pri neúspechu je jasnejšia.
- Widget má nové rozloženie: hore Fuelix, v strede QR ikona, dole TANKUJ.

## [0.5.0] - 2026-11-14

- Čerpačka z eKasy: keď doklad neuvádza prevádzku, appka rozpozná značku z prevádzkovateľa (HAPPE → Shell) a v poli stanice zobrazí farebnú ikonku značky (Shell, Slovnaft, OMV, MOL, Jurki, Tesco, Orlen, Benzina, EuroOil, Lukoil).
- Pri pridávaní tankovania je hore posledná cena za liter aj posledný stav tachometra; pole Stav km zostáva prázdne, aby sa omylom neuložil rovnaký nájazd.
- Spotreba sa v hornej karte zobrazí hneď po zadaní stavu km a litrov.
- Pri ukladaní appka porovná novú spotrebu s priemerom: ak je výrazne nižšia, ponúkne označiť predošlé tankovanie ako vynechané; ak je výrazne vyššia, upozorní na kontrolu litrov a tachometra.
- Kratší popis „Vynechané tankovanie“: „Vynechali ste predošlé tankovanie? Nezapočíta sa do priemeru.“
- Widget 1×1 má ikonu QR, nápis Fuelix a slovo TANKUJ.

## [0.4.1] - 2026-11-14

- Čerpačka z eKasy sa použije len vtedy, keď doklad obsahuje konkrétnu prevádzku; firma prevádzkovateľa (napr. „HAPPE s.r.o.“) sa už ako stanica nezobrazí. Inak zostane prázdna a doplní sa podľa GPS alebo z posledných troch staníc.
- Opravená chyba „MobileScannerController is already running“: dvojité ťuknutie na widget už neotvorí druhý skener.
- Po minimalizovaní a opätovnom otvorení appky sa už nespustí skener; otvorí sa normálne garáž alebo obľúbené auto.
- Widget je zmenšený na 1×1 dielik – obsahuje len ikonu QR a text „TANK“.

## [0.4.0] - 2026-11-14

- QR kód z bločku sa už nevyhodnocuje naslepo: ak obsahuje eKasa UID, Fuelix ho overí v štátnej službe Finančnej správy a načíta položky, litre, cenu za liter, sumu aj dátum.
- Z bločku sa rozpozná palivová položka (Natural, Diesel, FuelSave, LPG, CNG…) a nie bežný nákup; z obyčajného nákupného bločku sa tankovanie nevytvorí.
- Ak sa doklad v eKase nenájde alebo je bez internetu, appka ponúkne odfotenie bločku (OCR) alebo ručné zadanie.

## [0.3.1] - 2026-11-14

- Bloček sa dá načítať aj vtedy, keď QR kód neobsahuje ceny (napr. Shell): v skeneri je tlačidlo „Odfotiť bloček“ a „Z galérie“.
- Fotka bločku sa číta priamo v telefóne (Google ML Kit) – litre, cena za liter, celková suma a značka čerpačky.
- Celková suma sa vyberá inteligentne: ak OCR prehodí stĺpce a „Spolu“ je medzisúčet, použije sa suma, ktorá sedí na litre × cena za liter.
- Formulár tankovania sa z widgetu otvorí hneď; čerpačka podľa GPS sa doplní na pozadí, keď súradnice dorazia.
- Opravená chyba s časovou zónou pri načítaní pripomienok.

## [0.3.0] - 2026-11-13

- Heslo zálohy sa po prvom zadaní uloží do Android Keystore, takže ďalšie zálohy sa už na nič nepýtajú. V nastaveniach je nová položka „Heslo zálohy“ na jeho zmenu.
- Cieľ zálohy si appka zapamätá: prvý raz vyberieš OneDrive, Google Disk alebo pamäť, odvtedy sa záloha zapisuje rovno tam bez akéhokoľvek dialógu. Cieľ sa dá kedykoľvek zmeniť alebo zabudnúť.
- Widget na plochu „Fuelix – Natankovať“: jedno ťuknutie otvorí QR skener, po naskenovaní bločku sa rovno otvorí formulár tankovania s vyplnenými litrami, cenou a čerpačkou podľa GPS.
- Staršie zálohy si ponechajú heslo, ktorým boli vytvorené; nové heslo platí pre nové zálohy.

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
