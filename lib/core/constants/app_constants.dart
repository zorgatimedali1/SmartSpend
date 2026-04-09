// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';
  static const String claudeModel = 'claude-3-5-haiku-20241022';
  static const int claudeMaxTokens = 150;
  static const Duration apiTimeout = Duration(seconds: 15);

  static const String transactionsBox = 'transactions_box';
  static const String settingsBox = 'settings_box';

  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyCurrency = 'currency';

  static const String tableProfiles = 'profiles';
  static const String tableTransactions = 'transactions';
  static const String tableCategories = 'categories';
  static const String tableBudgets = 'budgets';

  static const int catOther = 10;
  static const int anomalyContextCount = 10;
  static const double anomalyScoreThreshold = 0.6;
}
