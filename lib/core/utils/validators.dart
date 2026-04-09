// lib/core/utils/validators.dart
class Validators {
  Validators._();

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ce champ est obligatoire';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) return 'Email invalide';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Ce champ est obligatoire';
    if (v.length < 6) return 'Mot de passe trop court (min 6 caractères)';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'Ce champ est obligatoire';
    if (v != original) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ce champ est obligatoire';
    return null;
  }

  static String? amount(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ce champ est obligatoire';
    final parsed = double.tryParse(v.replaceAll(',', '.'));
    if (parsed == null) return 'Montant invalide';
    if (parsed <= 0) return 'Le montant doit être positif';
    return null;
  }
}
