import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'SmartSpend'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Se connecter'**
  String get alreadyHaveAccount;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte ? S\'inscrire'**
  String get noAccount;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @transactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @budgets.
  ///
  /// In fr, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @totalExpenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses Totales'**
  String get totalExpenses;

  /// No description provided for @thisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois dernier'**
  String get lastMonth;

  /// No description provided for @recentTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions Récentes'**
  String get recentTransactions;

  /// No description provided for @spendingByCategory.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses par Catégorie'**
  String get spendingByCategory;

  /// No description provided for @monthlyOverview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu Mensuel'**
  String get monthlyOverview;

  /// No description provided for @anomaliesDetected.
  ///
  /// In fr, this message translates to:
  /// **'Anomalies détectées'**
  String get anomaliesDetected;

  /// No description provided for @addTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editTransaction;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In fr, this message translates to:
  /// **'Sans description'**
  String get noDescription;

  /// No description provided for @categorySuggestedByAI.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie suggérée par l\'IA ✨'**
  String get categorySuggestedByAI;

  /// No description provided for @selectCategory.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une catégorie'**
  String get selectCategory;

  /// No description provided for @descriptionHintExample.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Courses Monoprix...'**
  String get descriptionHintExample;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @anomalyWarning.
  ///
  /// In fr, this message translates to:
  /// **'Dépense inhabituelle détectée !'**
  String get anomalyWarning;

  /// No description provided for @anomalyHighAmountMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce montant est significativement plus élevé que votre moyenne.'**
  String get anomalyHighAmountMessage;

  /// No description provided for @anomalySaveAnyway.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous quand même l\'enregistrer ?'**
  String get anomalySaveAnyway;

  /// No description provided for @deleteConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get deleteConfirmation;

  /// No description provided for @spent.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé'**
  String get spent;

  /// No description provided for @aiClassifying.
  ///
  /// In fr, this message translates to:
  /// **'Classification IA...'**
  String get aiClassifying;

  /// No description provided for @setBudget.
  ///
  /// In fr, this message translates to:
  /// **'Définir un budget'**
  String get setBudget;

  /// No description provided for @budgetLimit.
  ///
  /// In fr, this message translates to:
  /// **'Limite du budget'**
  String get budgetLimit;

  /// No description provided for @overBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget dépassé'**
  String get overBudget;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Restant'**
  String get remaining;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get english;

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get currency;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet'**
  String get errorNetwork;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get errorInvalidEmail;

  /// No description provided for @errorWeakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop court (min 6 caractères)'**
  String get errorWeakPassword;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get errorPasswordMismatch;

  /// No description provided for @errorFieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get errorFieldRequired;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant invalide'**
  String get errorInvalidAmount;

  /// No description provided for @successSaved.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré avec succès'**
  String get successSaved;

  /// No description provided for @successDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Supprimé avec succès'**
  String get successDeleted;

  /// No description provided for @noTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get noTransactions;

  /// No description provided for @noTransactionsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première transaction'**
  String get noTransactionsDesc;

  /// No description provided for @noBudgets.
  ///
  /// In fr, this message translates to:
  /// **'Aucun budget défini'**
  String get noBudgets;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @allCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get allCategories;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
