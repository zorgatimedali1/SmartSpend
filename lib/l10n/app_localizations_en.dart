// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartSpend';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get noAccount => 'No account? Sign Up';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get settings => 'Settings';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get monthlyOverview => 'Monthly Overview';

  @override
  String get anomaliesDetected => 'Anomalies detected';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description';

  @override
  String get categorySuggestedByAI => 'Category suggested by AI ✨';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get descriptionHintExample => 'Ex: Groceries at Monoprix...';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get anomalyWarning => 'Unusual spending detected!';

  @override
  String get anomalyHighAmountMessage =>
      'This amount is significantly higher than your average.';

  @override
  String get anomalySaveAnyway => 'Do you still want to record it?';

  @override
  String get deleteConfirmation => 'This action is irreversible.';

  @override
  String get spent => 'Spent';

  @override
  String get aiClassifying => 'AI classifying...';

  @override
  String get setBudget => 'Set Budget';

  @override
  String get budgetLimit => 'Budget Limit';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get remaining => 'Remaining';

  @override
  String get language => 'Language';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get currency => 'Currency';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorNetwork => 'No internet connection';

  @override
  String get errorInvalidEmail => 'Invalid email';

  @override
  String get errorWeakPassword => 'Password too short (min 6 characters)';

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get errorFieldRequired => 'This field is required';

  @override
  String get errorInvalidAmount => 'Invalid amount';

  @override
  String get successSaved => 'Saved successfully';

  @override
  String get successDeleted => 'Deleted successfully';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get noTransactionsDesc => 'Add your first transaction';

  @override
  String get noBudgets => 'No budgets set';

  @override
  String get search => 'Search';

  @override
  String get allCategories => 'All Categories';
}
