import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/domain/station_brand.dart';

void main() {
  test('detects Slovak and Czech brands', () {
    expect(StationBrand.detect('Shell Prievidza')!.name, 'Shell');
    expect(StationBrand.detect('HAPPE s.r.o.')!.name, 'Shell');
    expect(StationBrand.detect('SLOVNAFT, a.s.')!.name, 'Slovnaft');
    expect(StationBrand.detect('OMV Slovensko')!.name, 'OMV');
    expect(StationBrand.detect('MOL ČR')!.name, 'MOL');
    expect(StationBrand.detect('Jurki SK')!.name, 'Jurki');
    expect(StationBrand.detect('Tesco Prievidza')!.name, 'Tesco');
    expect(StationBrand.detect('ORLEN Benzina')!.name, 'Orlen');
    expect(StationBrand.detect('EUROOIL')!.name, 'EuroOil');
    expect(StationBrand.detect('LUKOIL')!.name, 'Lukoil');
  });

  test('does not match short names inside other words', () {
    expect(StationBrand.detect('Moldavsko'), isNull);
    expect(StationBrand.detect('Tomášova pumpa'), isNull);
  });

  test('returns null for an unknown station', () {
    expect(StationBrand.detect(''), isNull);
    expect(StationBrand.detect('Prievidza - neznáma pumpa'), isNull);
  });

  test('brands have a usable badge letter', () {
    expect(StationBrand.shell.initial, 'S');
    expect(StationBrand.omv.initial, 'O');
  });
}
