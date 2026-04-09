// lib/features/transactions/models/category.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CategoryModel {
  final int id;
  final String nameFr;
  final String nameEn;
  final String icon;
  final Color color;

  const CategoryModel({required this.id, required this.nameFr, required this.nameEn, required this.icon, required this.color});

  factory CategoryModel.fromJson(Map<String, dynamic> j) {
    final id = j['id'] as int;
    return CategoryModel(
      id: id, nameFr: j['name_fr'] as String, nameEn: j['name_en'] as String,
      icon: j['icon'] as String? ?? '📌',
      color: (id >= 1 && id <= AppTheme.categoryColors.length)
          ? AppTheme.categoryColors[id - 1]
          : const Color(0xFF6B7280),
    );
  }

  String localName(String locale) => locale == 'fr' ? nameFr : nameEn;

  static List<CategoryModel> get defaults => [
    CategoryModel(id:1,nameFr:'Alimentation',nameEn:'Food',icon:'🛒',color:AppTheme.categoryColors[0]),
    CategoryModel(id:2,nameFr:'Transport',nameEn:'Transport',icon:'🚗',color:AppTheme.categoryColors[1]),
    CategoryModel(id:3,nameFr:'Logement',nameEn:'Housing',icon:'🏠',color:AppTheme.categoryColors[2]),
    CategoryModel(id:4,nameFr:'Santé',nameEn:'Health',icon:'💊',color:AppTheme.categoryColors[3]),
    CategoryModel(id:5,nameFr:'Loisirs',nameEn:'Entertainment',icon:'🎮',color:AppTheme.categoryColors[4]),
    CategoryModel(id:6,nameFr:'Shopping',nameEn:'Shopping',icon:'👗',color:AppTheme.categoryColors[5]),
    CategoryModel(id:7,nameFr:'Restaurants',nameEn:'Dining',icon:'🍽️',color:AppTheme.categoryColors[6]),
    CategoryModel(id:8,nameFr:'Éducation',nameEn:'Education',icon:'📚',color:AppTheme.categoryColors[7]),
    CategoryModel(id:9,nameFr:'Épargne',nameEn:'Savings',icon:'💰',color:AppTheme.categoryColors[8]),
    CategoryModel(id:10,nameFr:'Autre',nameEn:'Other',icon:'📌',color:AppTheme.categoryColors[9]),
  ];
}
