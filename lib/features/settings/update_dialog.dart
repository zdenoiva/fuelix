import 'package:flutter/material.dart';

import '../../l10n/strings.dart';
import '../../services/update_service.dart';
import '../../util/format.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key, required this.info});

  final UpdateInfo info;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double _progress = 0;
  bool _downloading = false;
  String? _error;

  Future<void> _download() async {
    setState(() {
      _downloading = true;
      _error = null;
      _progress = 0;
    });
    try {
      final file = await UpdateService.instance.download(
        widget.info,
        onProgress: (progress, _, _) {
          if (mounted) setState(() => _progress = progress);
        },
      );
      if (!mounted) return;
      await UpdateService.instance.install(file);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _error = context.t('update.shaFailed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(context.t('update.available', {'v': widget.info.version})),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.info.changelog.isNotEmpty) ...[
            Text(
              context.t('update.changelog'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in widget.info.changelog)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('•  $line'),
                      ),
                  ],
                ),
              ),
            ),
          ],
          if (widget.info.size > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                formatFileSize(widget.info.size),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          if (_downloading) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 6),
            Text(
              context.t('update.downloading', {
                'p': (_progress * 100).round(),
              }),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: scheme.error)),
          ],
          const SizedBox(height: 12),
          Text(
            context.t('update.installHint'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _downloading ? null : () => Navigator.of(context).pop(),
          child: Text(context.t('update.later')),
        ),
        FilledButton.icon(
          onPressed: _downloading ? null : _download,
          icon: const Icon(Icons.system_update_alt),
          label: Text(
            _downloading
                ? context.t('update.downloading', {
                    'p': (_progress * 100).round(),
                  })
                : context.t('update.download', {
                    'size': formatFileSize(widget.info.size),
                  }),
          ),
        ),
      ],
    );
  }
}
