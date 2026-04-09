// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SmartSpend';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'Inscription';

  @override
  String get logout => 'Déconnexion';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get settings => 'Paramètres';

  @override
  String get totalExpenses => 'Dépenses Totales';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get lastMonth => 'Mois dernier';

  @override
  String get recentTransactions => 'Transactions Récentes';

  @override
  String get spendingByCategory => 'Dépenses par Catégorie';

  @override
  String get monthlyOverview => 'Aperçu Mensuel';

  @override
  String get anomaliesDetected => 'Anomalies détectées';

  @override
  String get addTransaction => 'Ajouter une transaction';

  @override
  String get editTransaction => 'Modifier';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'Sans description';

  @override
  String get categorySuggestedByAI => 'Catégorie suggérée par l\'IA ✨';

  @override
  String get selectCategory => 'Sélectionnez une catégorie';

  @override
  String get descriptionHintExample => 'Ex: Courses Monoprix...';

  @override
  String get amount => 'Montant';

  @override
  String get category => 'Catégorie';

  @override
  String get date => 'Date';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get anomalyWarning => 'Dépense inhabituelle détectée !';

  @override
  String get anomalyHighAmountMessage =>
      'Ce montant est significativement plus élevé que votre moyenne.';

  @override
  String get anomalySaveAnyway => 'Voulez-vous quand même l\'enregistrer ?';

  @override
  String get deleteConfirmation => 'Cette action est irréversible.';

  @override
  String get spent => 'Dépensé';

  @override
  String get aiClassifying => 'Classification IA...';

  @override
  String get setBudget => 'Définir un budget';

  @override
  String get budgetLimit => 'Limite du budget';

  @override
  String get overBudget => 'Budget dépassé';

  @override
  String get remaining => 'Restant';

  @override
  String get language => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get currency => 'Devise';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get errorNetwork => 'Pas de connexion internet';

  @override
  String get errorInvalidEmail => 'Email invalide';

  @override
  String get errorWeakPassword => 'Mot de passe trop court (min 6 caractères)';

  @override
  String get errorPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get errorFieldRequired => 'Ce champ est obligatoire';

  @override
  String get errorInvalidAmount => 'Montant invalide';

  @override
  String get successSaved => 'Enregistré avec succès';

  @override
  String get successDeleted => 'Supprimé avec succès';

  @override
  String get noTransactions => 'Aucune transaction';

  @override
  String get noTransactionsDesc => 'Ajoutez votre première transaction';

  @override
  String get noBudgets => 'Aucun budget défini';

  @override
  String get search => 'Rechercher';

  @override
  String get allCategories => 'Toutes les catégories';
}
