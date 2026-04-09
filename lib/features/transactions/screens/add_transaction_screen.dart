// lib/features/transactions/screens/add_transaction_screen.dart
// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartspend/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/services/supabase_service.dart';
import '../widgets/ai_category_chip.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;
  const AddTransactionScreen({super.key, this.transactionId});
  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isEdit = false;
  String? _editId;
  bool _aiSuggestedShown = false;
  bool _isAiSuggested = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _isEdit = true;
      _editId = widget.transactionId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final txs = ref.read(transactionProvider).transactions;
    try {
      final tx = txs.firstWhere((t) => t.id == _editId);
      _descCtrl.text = tx.description ?? '';
      _amountCtrl.text = tx.amount.toStringAsFixed(3);
      _selectedCategoryId = tx.categoryId;
      _selectedDate = tx.date;
      _aiSuggestedShown =
          true; // Don't show AI suggestions for existing transactions
      _isAiSuggested = false;
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _onDescriptionChanged(String value) {
    if (value.length >= 4 && !_aiSuggestedShown) {
      _aiSuggestedShown = true;
      _suggestCategory(value);
    }
  }

  Future<void> _suggestCategory(String desc) async {
    final suggested =
        await ref.read(transactionProvider.notifier).suggestCategory(desc);
    if (suggested != null && mounted) {
      setState(() {
        _selectedCategoryId = suggested;
        _isAiSuggested = true;
      });
      final l10n = AppLocalizations.of(context)!;
      context.showSnackBar(l10n.categorySuggestedByAI);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text.trim().replaceAll(',', '.'));
    final userId = SupabaseService.currentUserId!;

    print(
        'Submitting transaction: amount=$amount, userId=$userId, categoryId=$_selectedCategoryId');

    try {
      if (_isEdit && _editId != null) {
        final existing = ref
            .read(transactionProvider)
            .transactions
            .firstWhere((t) => t.id == _editId!);
        await ref
            .read(transactionProvider.notifier)
            .updateTransaction(existing.copyWith(
              amount: amount,
              description: _descCtrl.text.trim(),
              categoryId: _selectedCategoryId,
              date: _selectedDate,
            ));
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          context.showSnackBar(l10n.successSaved);
          context.pop();
        }
      } else {
        final tx = TransactionModel(
          id: const Uuid().v4(),
          userId: userId,
          amount: amount,
          description: _descCtrl.text.trim(),
          categoryId: _selectedCategoryId,
          date: _selectedDate,
          createdAt: DateTime.now(),
        );
        print('Created transaction model: $tx');
        final anomaly =
            await ref.read(transactionProvider.notifier).addTransaction(tx);
        print('Add transaction result: anomaly=$anomaly');
        if (mounted) {
          if (anomaly != null && anomaly['is_anomaly'] == true) {
            _showAnomalyDialog(anomaly['reason'] as String? ?? '');
          } else {
            final l10n = AppLocalizations.of(context)!;
            context.showSnackBar(l10n.successSaved);
            context.pop();
          }
        }
      }
    } catch (e) {
      print('Error adding transaction: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        context.showSnackBar('${l10n.errorGeneric}: $e', isError: true);
      }
    }
  }

  void _showAnomalyDialog(String reason) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(children: [const Text('⚠️ '), Text(l10n.anomalyWarning)]),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.anomalyHighAmountMessage),
              if (reason.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(reason,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 13)),
              ],
              const SizedBox(height: 8),
              Text(l10n.anomalySaveAnyway),
            ]),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              child: Text(l10n.save)),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.editTransaction)),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteConfirmation),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(transactionProvider.notifier).deleteTransaction(_editId!);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        context.showSnackBar(l10n.successDeleted);
        context.go('/transactions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(transactionProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final isLoading = state.isLoading || state.isAiLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editTransaction : l10n.addTransaction),
        actions: [
          if (_isEdit)
            IconButton(
              icon: Icon(Icons.delete_outlined,
                  color: Theme.of(context).colorScheme.error),
              onPressed: _delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _descCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.description,
                hintText: l10n.descriptionHintExample,
                prefixIcon: const Icon(Icons.edit_note_outlined),
              ),
              validator: Validators.required,
              onChanged: _onDescriptionChanged,
            ),
            if (state.isAiLoading)
              const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: AiCategoryChip(loading: true))
            else if (_isAiSuggested && _selectedCategoryId != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AiCategoryChip(
                  label: state.categories
                      .firstWhere((c) => c.id == _selectedCategoryId,
                          orElse: () => state.categories.last)
                      .localName(locale),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l10n.amount} (TND)',
                hintText: '0.000',
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
              validator: Validators.amount,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                  labelText: l10n.category,
                  prefixIcon: const Icon(Icons.category_outlined)),
              items: state.categories
                  .map((cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Row(children: [
                          Text(cat.icon),
                          const SizedBox(width: 8),
                          Text(cat.localName(locale))
                        ]),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedCategoryId = v;
                _isAiSuggested =
                    false; // Reset AI suggestion when user manually changes
              }),
              validator: (v) => v == null ? l10n.selectCategory : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                    labelText: l10n.date,
                    prefixIcon: const Icon(Icons.calendar_today_outlined)),
                child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(_isEdit ? l10n.save : l10n.addTransaction),
            ),
          ]),
        ),
      ),
    );
  }
}
