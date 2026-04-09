// lib/features/auth/providers/auth_provider.dart
// ignore_for_file: curly_braces_in_flow_control_structures, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import '../../../core/services/supabase_service.dart';

class AuthState {
  final supa.User? user;
  final bool isLoading;
  final String? error;
  const AuthState({this.user, this.isLoading = false, this.error});
  AuthState copyWith({supa.User? user, bool? isLoading, String? error}) =>
      AuthState(
          user: user ?? this.user,
          isLoading: isLoading ?? this.isLoading,
          error: error);
  bool get isAuthenticated => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(user: SupabaseService.currentUser)) {
    SupabaseService.authStateChanges.listen((event) {
      state = state.copyWith(user: event.session?.user, isLoading: false);
    });
  }

  final _client = SupabaseService.client;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _client.auth
          .signInWithPassword(email: email.trim(), password: password);
      state = state.copyWith(user: res.user, isLoading: false);
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _map(e.message));
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Erreur de connexion');
    }
  }

  Future<void> signup(
      {required String email,
      required String password,
      required String fullName}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {'full_name': fullName.trim()});
      state = state.copyWith(user: res.user, isLoading: false);
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _map(e.message));
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Erreur lors de l\'inscription');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      const webClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID';
      final googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null) throw Exception('No access token');
      final res = await _client.auth.signInWithIdToken(
        provider: supa.OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );
      state = state.copyWith(user: res.user, isLoading: false);
    } catch (_) {
      state =
          state.copyWith(isLoading: false, error: 'Connexion Google échouée');
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    // Don't manually set state - let the auth state change listener handle it
  }

  String _map(String msg) {
    if (msg.contains('Invalid login')) return 'Email ou mot de passe incorrect';
    if (msg.contains('Email not confirmed'))
      return 'Confirmez votre email d\'abord';
    if (msg.contains('already registered')) return 'Cet email est déjà utilisé';
    return msg;
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((_) => AuthNotifier());
