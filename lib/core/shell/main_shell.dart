// lib/core/shell/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/transactions/providers/transaction_provider.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _Tab(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard', path: '/'),
    _Tab(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Transactions', path: '/transactions'),
    _Tab(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet, label: 'Budgets', path: '/budgets'),
    _Tab(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Paramètres', path: '/settings'),
  ];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/transactions')) return 1;
    if (loc.startsWith('/budgets')) return 2;
    if (loc.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomalyCount = ref.watch(anomalyCountProvider);
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      floatingActionButton: idx == 1
          ? FloatingActionButton(
              onPressed: () => context.go('/transactions/add'),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => context.go(_tabs[i].path),
        items: _tabs.asMap().entries.map((e) {
          final i = e.key;
          final tab = e.value;
          return BottomNavigationBarItem(
            icon: i == 1 && anomalyCount > 0
                ? Badge(label: Text('$anomalyCount'), child: Icon(tab.icon))
                : Icon(tab.icon),
            activeIcon: Icon(tab.activeIcon),
            label: tab.label,
          );
        }).toList(),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  const _Tab({required this.icon, required this.activeIcon, required this.label, required this.path});
}
