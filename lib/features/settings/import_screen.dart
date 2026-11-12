import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../l10n/strings.dart';
import '../../services/fuelio_import.dart';
import '../../widgets/common.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  FuelioPreview? _preview;
  FuelioImportResult? _result;
  bool _busy = false;
  String? _error;

  Future<void> _pickFile() async {
    setState(() => _error = null);
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'txt'],
    );
    if (picked.isEmpty) return;
    final bytes = await picked.first.readAsBytes();
    _parse(bytes);
  }

  void _parse(Uint8List bytes) {
    try {
      final text = utf8.decode(bytes, allowMalformed: true);
      final preview = FuelioImporter.parse(text);
      setState(() {
        _preview = preview;
        _result = null;
        _error = null;
      });
    } on FormatException {
      setState(() => _error = context.t('import.error'));
    } catch (_) {
      setState(() => _error = context.t('import.error'));
    }
  }

  Future<void> _import() async {
    final preview = _preview;
    if (preview == null) return;
    setState(() => _busy = true);
    try {
      final result = await FuelioImporter.apply(preview);
      if (!mounted) return;
      setState(() {
        _result = result;
        _preview = null;
        _busy = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t('import.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (_error != null)
            SectionCard(
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_error!)),
                ],
              ),
            ),
          if (_result != null)
            _ResultCard(result: _result!)
          else if (_preview != null)
            _PreviewCard(preview: _preview!)
          else
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('import.step1'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.t('import.pickFile'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: Text(context.t('import.pickFile')),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (_preview != null) ...[
            FilledButton.icon(
              onPressed: _busy ? null : _import,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_outlined),
              label: Text(
                _busy ? context.t('import.importing') : context.t('import.confirm'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pickFile,
              child: Text(context.t('common.back')),
            ),
          ],
          if (_result != null)
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.t('common.done')),
            ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.preview});

  final FuelioPreview preview;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('import.step2'),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            preview.vehicle.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            [
              if (preview.vehicle.plate.isNotEmpty) preview.vehicle.plate,
              if (preview.vehicle.make.isNotEmpty) preview.vehicle.make,
              if (preview.vehicle.model.isNotEmpty) preview.vehicle.model,
            ].join(' · '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _row(
            context,
            Icons.local_gas_station_outlined,
            context.t('fillup.title'),
            '${preview.fillUps.length}',
          ),
          _row(
            context,
            Icons.receipt_long_outlined,
            context.t('expense.title'),
            '${preview.expenses.length}',
          ),
          _row(
            context,
            Icons.notifications_active_outlined,
            context.t('import.reminders'),
            '${preview.reminders.length}',
          ),
          _row(
            context,
            Icons.category_outlined,
            context.t('expense.category'),
            '${preview.categories.length}',
          ),
          if (preview.stations.isNotEmpty)
            _row(
              context,
              Icons.local_gas_station,
              context.t('fillup.station'),
              '${preview.stations.length}',
            ),
          if (preview.tripsSkipped > 0) ...[
            const Divider(height: 20),
            Text(
              context.t('import.tripsSkipped', {
                'n': preview.tripsSkipped,
              }),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final FuelioImportResult result;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF0E9F6E)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.t('import.done', {'n': result.total}),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (result.duplicates > 0) ...[
            const SizedBox(height: 8),
            Text(
              context.t('import.duplicates', {'n': result.duplicates}),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
