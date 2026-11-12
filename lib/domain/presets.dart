class ServicePreset {
  const ServicePreset({
    required this.labelKey,
    required this.category,
    this.repeatMonths,
    this.repeatKm,
  });

  final String labelKey;
  final String category;
  final int? repeatMonths;
  final double? repeatKm;
}

/// One-tap service templates shown in the garage.
const List<ServicePreset> servicePresets = [
  ServicePreset(
    labelKey: 'preset.oil',
    category: 'maintenance',
    repeatMonths: 12,
    repeatKm: 15000,
  ),
  ServicePreset(
    labelKey: 'preset.airfilter',
    category: 'maintenance',
    repeatMonths: 24,
    repeatKm: 30000,
  ),
  ServicePreset(
    labelKey: 'preset.brakes',
    category: 'service',
    repeatMonths: 24,
    repeatKm: 30000,
  ),
  ServicePreset(
    labelKey: 'preset.tires',
    category: 'tires',
    repeatMonths: 6,
  ),
  ServicePreset(
    labelKey: 'preset.inspection',
    category: 'inspection',
    repeatMonths: 24,
  ),
  ServicePreset(
    labelKey: 'preset.insurance',
    category: 'insurance',
    repeatMonths: 12,
  ),
  ServicePreset(
    labelKey: 'preset.battery',
    category: 'maintenance',
    repeatMonths: 48,
  ),
  ServicePreset(
    labelKey: 'preset.coolant',
    category: 'maintenance',
    repeatMonths: 48,
    repeatKm: 60000,
  ),
];
