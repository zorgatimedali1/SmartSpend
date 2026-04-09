// lib/core/services/ai_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  String get _apiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';
  Map<String, String> get _headers => {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      };

  /// Returns category id 1-10. Falls back to 10 (Other) on error.
  Future<int> categorize(String description) async {
    if (description.trim().isEmpty) return AppConstants.catOther;
    try {
      final res = await http
          .post(
            Uri.parse(AppConstants.claudeApiUrl),
            headers: _headers,
            body: jsonEncode({
              'model': AppConstants.claudeModel,
              'max_tokens': AppConstants.claudeMaxTokens,
              'temperature':
                  0.1, // Lower temperature for more consistent categorization
              'messages': [
                {
                  'role': 'user',
                  'content':
                      'Classify this transaction into one of these categories. Reply with ONLY the number (1-10).\n\n'
                          'Categories:\n'
                          '1=Food (groceries, restaurants, meals)\n'
                          '2=Transport (bus, taxi, fuel, public transport)\n'
                          '3=Housing (rent, utilities, maintenance)\n'
                          '4=Health (medical, pharmacy, insurance)\n'
                          '5=Entertainment (movies, games, hobbies)\n'
                          '6=Shopping (clothes, electronics, general purchases)\n'
                          '7=Dining (restaurants, cafes, takeout)\n'
                          '8=Education (courses, books, training)\n'
                          '9=Savings (investments, deposits)\n'
                          '10=Other (anything that doesn\'t fit above)\n\n'
                          'Transaction description: "$description"\n\n'
                          'Category number:'
                }
              ],
            }),
          )
          .timeout(AppConstants.apiTimeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = (data['content'][0]['text'] as String).trim();
        final categoryId = int.tryParse(text);
        if (categoryId != null && categoryId >= 1 && categoryId <= 10) {
          return categoryId;
        }
      }
    } catch (e) {
      print('AI categorization error: $e');
    }
    return AppConstants.catOther;
  }

  /// Returns {is_anomaly: bool, score: double, reason: String}
  Future<Map<String, dynamic>> detectAnomaly({
    required double amount,
    required String categoryName,
    required List<double> recentAmounts,
  }) async {
    const safe = {'is_anomaly': false, 'score': 0.0, 'reason': ''};
    if (recentAmounts.isEmpty) return safe;
    try {
      final avg = recentAmounts.reduce((a, b) => a + b) / recentAmounts.length;
      final res = await http
          .post(
            Uri.parse(AppConstants.claudeApiUrl),
            headers: _headers,
            body: jsonEncode({
              'model': AppConstants.claudeModel,
              'max_tokens': AppConstants.claudeMaxTokens,
              'messages': [
                {
                  'role': 'user',
                  'content': 'Is this transaction an anomaly? Reply with ONLY valid JSON.\n'
                      'Format: {"is_anomaly":bool,"score":0.0-1.0,"reason":"max 10 words"}\n'
                      'Category: $categoryName\n'
                      'This amount: ${amount.toStringAsFixed(3)} TND\n'
                      'Average: ${avg.toStringAsFixed(3)} TND\n'
                      'Recent: ${recentAmounts.map((e) => e.toStringAsFixed(3)).join(", ")}'
                }
              ],
            }),
          )
          .timeout(AppConstants.apiTimeout);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = (data['content'][0]['text'] as String)
            .replaceAll(RegExp(r'```json|```'), '')
            .trim();
        final result = jsonDecode(text) as Map<String, dynamic>;
        return {
          'is_anomaly': result['is_anomaly'] as bool? ?? false,
          'score': (result['score'] as num?)?.toDouble() ?? 0.0,
          'reason': result['reason'] as String? ?? '',
        };
      }
    } catch (_) {}
    return safe;
  }
}
