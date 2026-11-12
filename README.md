# Fuelix

Jednoduchá Android appka na evidenciu tankovania, spotreby, výdavkov a servisu. Offline-first, bez reklám,
v slovenčine, češtine a angličtine.

- Web: <https://zdenoiva.github.io/fuelix/>
- Releases: <https://github.com/zdenoiva/fuelix/releases>
- Balík: `sk.zdenoiva.fuelix`

## Čo vie

| Oblasť | Funkcie |
|---|---|
| Garáž | viac vozidiel, palivo, objem nádrže, EČV, počiatočný stav km, archivácia |
| Tankovanie | dátum, km, litre, cena za liter, celková suma, plná nádrž, vynechané tankovanie, stanica, GPS, poznámka |
| Výpočty | spotreba medzi plnými nádržami (aj s čiastočnými), priemerná spotreba, cena za km, celkové náklady |
| Výdavky | kategórie s farbami, príjmy, foto bločku, mesačný súhrn |
| Servis a pripomienky | termín podľa dátumu aj km, opakovanie v mesiacoch/kilometroch, šablóny, notifikácie |
| Štatistiky | spotreba v čase, mesačné náklady, rozpad podľa kategórií |
| Dáta | import z Fuelia, export CSV, JSON záloha a obnova |
| Blok | QR kód z bločku predvyplní litre a ceny, GPS rozpozná čerpačku |

## Vývoj

```powershell
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter run
```

Drift schéma je v `lib/data/database.dart`; po jej zmene treba znovu spustiť `build_runner`.

### Štruktúra

```
lib/
  data/        Drift databáza a repozitár
  domain/      výpočet spotreby, servisné šablóny
  features/    obrazovky (garáž, vozidlo, tankovanie, výdavky, servis, štatistiky, nastavenia)
  l10n/        preklady SK / CZ / EN
  services/    import z Fuelia, aktualizácie, záloha, notifikácie, QR, poloha
  widgets/     spoločné UI prvky
test/          unit testy výpočtov a Fuelio importu
```

## Release

Rovnaký postup ako pri Raritio:

1. `flutter analyze` a `flutter test` bez chýb.
2. Zvýš `version: X.Y.Z+N` v `pubspec.yaml` (N = `versionCode`).
3. Pridaj sekciu `## [X.Y.Z] - YYYY-MM-DD` do `CHANGELOG.md`.
4. `git commit -m "release: X.Y.Z"`, `git tag vX.Y.Z`, `git push origin main --tags`.
5. GitHub Actions **Release APK** podpíše APK, vytvorí release a prepíše `latest.json`.

Lokálny podpis: `android/key.properties` + `android/fuelix-release.jks` (mimo gitu).
Záloha keystoru: `H:\Android-apka\fuelix-keystore\`.

## Import z Fuelia

Nastavenia → Import z Fuelia → vyber CSV export. Podporované sekcie: `## Vehicle`, `## Log`,
`## CostCategories`, `## Costs`, `## FavStations`, `## Category`. Služby s `RemindDate`/`RepeatMonths`
sa premenia na pripomienky, `guid` záznamy sa ukladajú ako `externalId`, takže opakovaný import
nevytvára duplikáty. `## TripLog` sa v tejto verzii neimportuje (počíta sa len počet preskočených jázd).
