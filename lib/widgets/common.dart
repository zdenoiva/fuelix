import 'package:flutter/material.dart';

import '../data/database.dart';
import '../l10n/strings.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    final card = Card(child: content);
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: card,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 34, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

class StatBlock extends StatelessWidget {
  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.icon,
    this.accent,
  });

  final String label;
  final String value;
  final String? sub;
  final IconData? icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: accent ?? scheme.onSurfaceVariant),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: accent,
          ),
        ),
        if (sub != null)
          Text(
            sub!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class CategoryDot extends StatelessWidget {
  const CategoryDot({super.key, required this.color, this.size = 10});

  final int color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle),
  );
}

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? confirmLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.t('common.cancel')),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel ?? context.t('common.delete')),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String categoryLabel(BuildContext context, String key) =>
    context.t('category.$key');

String categoryName(BuildContext context, ExpenseCategory category) {
  if (!category.isBuiltin) return category.label;
  final translated = context.t('category.${category.key}');
  return translated.startsWith('category.') ? category.label : translated;
}

int categoryColor(List<ExpenseCategory> categories, String key) {
  for (final category in categories) {
    if (category.key == key) return category.color;
  }
  return 0xFF607D8B;
}
