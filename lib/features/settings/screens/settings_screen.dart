// lib/features/settings/screens/settings_screen.dart
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final user = ref.watch(authProvider).user;
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = settings.themeMode == ThemeMode.dark;
    final isFr = settings.locale.languageCode == 'fr';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Profile card
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                _initials(user?.userMetadata?['full_name'] as String? ??
                    user?.email ??
                    'U'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      user?.userMetadata?['full_name'] as String? ??
                          'Utilisateur',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(user?.email ?? '',
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5))),
                ])),
          ]),
        )),
        const SizedBox(height: 20),

        const _SectionLabel('Préférences'),
        Card(
            child: Column(children: [
          // Language toggle
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
            trailing: ToggleButtons(
              isSelected: [isFr, !isFr],
              onPressed: (i) => notifier.setLanguage(i == 0 ? 'fr' : 'en'),
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 36),
              children: [Text(l10n.french), Text(l10n.english)],
            ),
          ),
          const Divider(height: 1),
          // Dark mode
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.darkMode),
            value: isDark,
            onChanged: notifier.setDarkMode,
          ),
          const Divider(height: 1),
          // Currency
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: Text(l10n.currency),
            trailing: DropdownButton<String>(
              value: settings.currency,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'TND', child: Text('TND')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
              ],
              onChanged: (v) {
                if (v != null) notifier.setCurrency(v);
              },
            ),
          ),
        ])),
        const SizedBox(height: 20),

        const _SectionLabel('À propos'),
        Card(
            child: Column(children: [
          const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              trailing: Text('1.0.0', style: TextStyle(color: Colors.grey))),
          const Divider(height: 1),
          const ListTile(
              leading: Icon(Icons.storage_outlined),
              title: Text('Supabase Project'),
              subtitle:
                  Text('niubrzwazfhxwizlivai', style: TextStyle(fontSize: 11))),
          const Divider(height: 1),
          const ListTile(
              leading: Icon(Icons.code_outlined),
              title: Text('Technologies'),
              subtitle: Text('Flutter · Riverpod · Supabase · Claude AI')),
        ])),
        const SizedBox(height: 20),

        OutlinedButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(l10n.logout),
                content: const Text('Voulez-vous vous déconnecter ?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.cancel)),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.logout)),
                ],
              ),
            );
            if (confirm == true) {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            side: BorderSide(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5)),
            minimumSize: const Size(double.infinity, 52),
          ),
          icon: const Icon(Icons.logout),
          label: Text(l10n.logout),
        ),
      ]),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
      );
}
