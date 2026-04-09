// lib/features/budgets/widgets/set_budget_sheet.dart
// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../models/budget.dart';
import '../providers/budget_provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/services/supabase_service.dart';

class SetBudgetSheet extends ConsumerStatefulWidget {
  final BudgetModel? existing;
  const SetBudgetSheet({super.key, this.existing});
  @override
  ConsumerState<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends ConsumerState<SetBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _selectedCategoryId = widget.existing!.categoryId;
      _amountCtrl.text = widget.existing!.limitAmount.toStringAsFixed(3);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      context.showSnackBar(
          '${l10n.category} ${l10n.errorFieldRequired.toLowerCase()}',
          isError: true);
      return;
    }
    final budget = BudgetModel(
      id: widget.existing?.id ?? const Uuid().v4(),
      userId: SupabaseService.currentUserId!,
      categoryId: _selectedCategoryId,
      month: DateFormat('yyyy-MM').format(DateTime.now()),
      limitAmount: double.parse(_amountCtrl.text.replaceAll(',', '.')),
    );
    print('Submitting budget: $budget');
    try {
      await ref.read(budgetProvider.notifier).upsert(budget);
      print('Budget upsert successful');
      if (mounted) {
        context.showSnackBar(l10n.successSaved);
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error adding budget: $e');
      if (mounted) {
        context.showSnackBar('${l10n.errorGeneric}: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final categories = ref.watch(categoriesProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(
                  widget.existing != null
                      ? l10n.editTransaction
                      : l10n.setBudget,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                    labelText: l10n.category,
                    prefixIcon: const Icon(Icons.category_outlined)),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Row(children: [
                            Text(cat.icon),
                            const SizedBox(width: 8),
                            Text(cat.localName(locale))
                          ]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: '${l10n.budgetLimit} (TND)',
                  hintText: '0.000',
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
                validator: Validators.amount,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child:
                    Text(widget.existing != null ? l10n.save : l10n.setBudget),
              ),
            ]),
      ),
    );
  }
}
