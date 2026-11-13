import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_state.dart';
import '../../l10n/strings.dart';
import '../../services/backup_service.dart';
import '../../services/notifications.dart';
import '../../services/update_service.dart';
import '../../widgets/common.dart';
import 'import_screen.dart';
import 'update_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';
  bool _checkingUpdate = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = '${info.version}+${info.buildNumber}');
  }

  Future<void> _pickLanguage() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.t('settings.language')),
        children: [
          for (final entry in Strings.languageNames.entries)
            ListTile(
              title: Text(entry.value),
              trailing: AppState.instance.locale.languageCode == entry.key
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.of(context).pop(entry.key),
            ),
        ],
      ),
    );
    if (selected != null) await AppState.instance.setLocale(selected);
  }

  Future<void> _pickCurrency() async {
    const currencies = ['EUR', 'CZK', 'USD', 'PLN', 'HUF', 'GBP', 'CHF'];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.t('settings.currency')),
        children: [
          for (final code in currencies)
            ListTile(
              title: Text(code),
              trailing: AppState.instance.currency == code
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => Navigator.of(context).pop(code),
            ),
        ],
      ),
    );
    if (selected != null) await AppState.instance.setCurrency(selected);
  }

  Future<void> _checkUpdate() async {
    setState(() => _checkingUpdate = true);
    final info = await UpdateService.instance.check();
    final package = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _checkingUpdate = false);
    final current = int.tryParse(package.buildNumber) ?? 0;
    if (info != null && info.versionCode > current) {
      await showDialog<void>(
        context: context,
        builder: (_) => UpdateDialog(info: info),
      );
    } else {
      showSnack(context, context.t('settings.upToDate'));
    }
  }

  Future<void> _createBackup() async {
    final password = await showDialog<String>(
      context: context,
      builder: (_) => _PasswordDialog(
        title: context.t('backup.setPassword'),
        note: context.t('backup.encryptedNote'),
        confirm: true,
      ),
    );
    if (password == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final file = await BackupService.createEncryptedBackup(password);
      if (!mounted) return;

      final destination = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    sheetContext.t('backup.where'),
                    style: Theme.of(sheetContext).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: Text(sheetContext.t('backup.saveToFile')),
                subtitle: Text(sheetContext.t('backup.saveToFileHint')),
                onTap: () => Navigator.of(sheetContext).pop('file'),
              ),
              ListTile(
                leading: const Icon(Icons.ios_share),
                title: Text(sheetContext.t('backup.shareTo')),
                subtitle: Text(sheetContext.t('backup.shareToHint')),
                onTap: () => Navigator.of(sheetContext).pop('share'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

      if (destination == 'file') {
        final saved = await BackupService.saveFile(
          file,
          mimeType: 'application/octet-stream',
        );
        if (saved && mounted) showSnack(context, context.t('backup.created'));
      } else if (destination == 'share') {
        await BackupService.shareFile(
          file,
          mimeType: 'application/octet-stream',
        );
        if (mounted) showSnack(context, context.t('backup.created'));
      }
    } catch (_) {
      if (mounted) showSnack(context, context.t('backup.error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreBackup() async {
    final picked = await FilePicker.pickFile(type: FileType.any);
    if (picked == null) return;
    final bytes = Uint8List.fromList(await picked.readAsBytes());
    if (!mounted) return;

    final encrypted = BackupService.isEncrypted(bytes);
    String? password;
    if (encrypted) {
      password = await showDialog<String>(
        context: context,
        builder: (_) => _PasswordDialog(
          title: context.t('backup.enterPassword'),
          note: context.t('backup.encryptedNote'),
        ),
      );
      if (password == null || !mounted) return;
    } else {
      final ok = await confirmDialog(
        context,
        title: context.t('backup.restore'),
        message: context.t('backup.restoreConfirm'),
        confirmLabel: context.t('common.yes'),
      );
      if (!ok || !mounted) return;
    }

    setState(() => _busy = true);
    try {
      if (encrypted) {
        await BackupService.restoreEncrypted(bytes, password!);
      } else {
        await BackupService.restore(bytes);
      }
      if (mounted) showSnack(context, context.t('backup.restored'));
    } catch (_) {
      if (mounted) {
        showSnack(
          context,
          encrypted
              ? context.t('backup.wrongPassword')
              : context.t('backup.error'),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _busy = true);
    try {
      final file = await BackupService.exportCsv();
      await BackupService.saveFile(file, mimeType: 'text/csv');
    } catch (_) {
      if (mounted) showSnack(context, context.t('common.error'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _rescheduleNotifications() async {
    await NotificationService.instance.init();
    final reminders = await AppState.instance.repo.allReminders();
    await NotificationService.instance.rescheduleAll(
      reminders.where((r) => r.isActive).toList(),
    );
    if (mounted) showSnack(context, context.t('common.done'));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
    final state = AppState.instance;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.t('settings.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (_busy) const LinearProgressIndicator(),
          _group(context.t('settings.language')),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(context.t('settings.language')),
                  subtitle: Text(
                    Strings.languageNames[state.locale.languageCode] ?? '',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickLanguage,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: Text(context.t('settings.currency')),
                  subtitle: Text(state.currency),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickCurrency,
                ),
              ],
            ),
          ),
          _group(context.t('settings.appearance')),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(context.t('settings.theme.system')),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(context.t('settings.theme.light')),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(context.t('settings.theme.dark')),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (selection) =>
                    state.setThemeMode(selection.first),
              ),
            ),
          ),
          _group(context.t('settings.data')),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: Text(context.t('settings.import')),
                  subtitle: Text(context.t('import.title')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ImportScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_view_outlined),
                  title: Text(context.t('settings.export')),
                  onTap: _busy ? null : _exportCsv,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: Text(context.t('backup.create')),
                  onTap: _busy ? null : _createBackup,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined),
                  title: Text(context.t('backup.restore')),
                  onTap: _busy ? null : _restoreBackup,
                ),
              ],
            ),
          ),
          _group(context.t('settings.update')),
          SectionCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.system_update_outlined),
              title: Text(context.t('settings.checkUpdate')),
              subtitle: Text('${context.t('common.version')} $_version'),
              trailing: _checkingUpdate
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _checkingUpdate ? null : _checkUpdate,
            ),
          ),
          _group(context.t('settings.about')),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.local_gas_station,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fuelix',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            context.t('app.tagline'),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${context.t('common.version')} $_version',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse('https://zdenoiva.github.io/fuelix/'),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.public),
                  label: const Text('zdenoiva.github.io/fuelix'),
                ),
                TextButton.icon(
                  onPressed: _rescheduleNotifications,
                  icon: const Icon(Icons.notifications_outlined),
                  label: Text(context.t('settings.notifications')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _group(String label) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 8, left: 4),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}


class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({
    required this.title,
    this.note,
    this.confirm = false,
  });

  final String title;
  final String? note;
  final bool confirm;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _first.text;
    if (password.length < 6) {
      setState(() => _error = context.t('backup.passwordMin'));
      return;
    }
    if (widget.confirm && password != _second.text) {
      setState(() => _error = context.t('backup.passwordMismatch'));
      return;
    }
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _first,
            autofocus: true,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: context.t('backup.password'),
              hintText: context.t('backup.passwordHint'),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          if (widget.confirm) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _second,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: context.t('backup.passwordConfirm'),
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (widget.note != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.note!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.t('common.cancel')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(context.t('common.ok')),
        ),
      ],
    );
  }
}
