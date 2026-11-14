import 'package:flutter/material.dart';

/// Recognised fuel brands for the small badge in the station field.
class StationBrand {
  const StationBrand(this.name, this.color, this.textColor);

  final String name;
  final Color color;
  final Color textColor;

  String get initial =>
      name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

  static const shell = StationBrand('Shell', Color(0xFFFFD500), Color(0xFFD71920));
  static const slovnaft = StationBrand(
    'Slovnaft',
    Color(0xFFE30613),
    Colors.white,
  );
  static const omv = StationBrand('OMV', Color(0xFF0072BC), Colors.white);
  static const mol = StationBrand('MOL', Color(0xFFD6001C), Colors.white);
  static const jurki = StationBrand('Jurki', Color(0xFFFFD100), Colors.black);
  static const tesco = StationBrand('Tesco', Color(0xFF00539F), Colors.white);
  static const orlen = StationBrand('Orlen', Color(0xFFE30613), Colors.white);
  static const benzina = StationBrand(
    'Benzina',
    Color(0xFFF58220),
    Colors.white,
  );
  static const eurooil = StationBrand(
    'EuroOil',
    Color(0xFF005CA9),
    Colors.white,
  );
  static const lukoil = StationBrand('Lukoil', Color(0xFFD6001C), Colors.white);
  static const cirrus = StationBrand('Cirrus', Color(0xFF003DA5), Colors.white);

  static const List<StationBrand> all = [
    shell,
    slovnaft,
    omv,
    mol,
    jurki,
    tesco,
    orlen,
    benzina,
    eurooil,
    lukoil,
    cirrus,
  ];

  static bool _has(String text, String keyword) {
    if (keyword.length <= 3) {
      return RegExp(
        '(^|[^a-z0-9])${RegExp.escape(keyword)}([^a-z0-9]|\$)',
      ).hasMatch(text);
    }
    return text.contains(keyword);
  }

  /// Detects a brand from any receipt text: station name, eKasa unit name or
  /// the operator company printed on the receipt.
  static StationBrand? detect(String? source) {
    if (source == null) return null;
    final text = source.toLowerCase();
    if (text.trim().isEmpty) return null;

    // HAPPE is the Shell operator in Slovakia.
    if (_has(text, 'shell') || _has(text, 'happe')) return shell;
    if (_has(text, 'slovnaft')) return slovnaft;
    if (_has(text, 'omv')) return omv;
    if (_has(text, 'mol')) return mol;
    if (_has(text, 'jurki')) return jurki;
    if (_has(text, 'tesco')) return tesco;
    if (_has(text, 'orlen') || _has(text, 'unipetrol')) return orlen;
    if (_has(text, 'benzina')) return benzina;
    if (_has(text, 'eurooil')) return eurooil;
    if (_has(text, 'lukoil')) return lukoil;
    if (_has(text, 'cirrus')) return cirrus;
    return null;
  }
}
