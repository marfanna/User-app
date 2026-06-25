import 'package:flutter/material.dart';

/// Guesses an icon for a free-text medicine category name by keyword.
///
/// Admin lets shop owners type arbitrary `itemCategory` values, so there's no
/// fixed taxonomy to map against — we match on substrings and fall back to a
/// generic pill icon. First match in the list wins (order = priority).
IconData medicineCategoryIcon(String category) {
  final c = category.toLowerCase();

  bool has(List<String> keys) => keys.any(c.contains);

  if (has(['antibiotic', 'antiviral', 'antifungal', 'infection'])) {
    return Icons.shield_outlined;
  }
  if (has(['analgesic', 'pain', 'inflammat'])) return Icons.healing_outlined;
  if (has(['antacid', 'gastric', 'stomach', 'digest'])) {
    return Icons.local_fire_department_outlined;
  }
  if (has(['diabet', 'insulin', 'sugar'])) return Icons.bloodtype_outlined;
  if (has(['vitamin', 'supplement', 'nutrition', 'health drink'])) {
    return Icons.medication_outlined;
  }
  if (has(['baby', 'child', 'pediatric', 'infant'])) {
    return Icons.child_friendly_outlined;
  }
  if (has(['heart', 'cardio', 'hypertens', 'pressure', 'vascular'])) {
    return Icons.favorite_outline;
  }
  if (has(['derma', 'skin', 'cosmetic'])) return Icons.face_outlined;
  if (has(['eye', 'ear', 'optic', 'vision'])) {
    return Icons.remove_red_eye_outlined;
  }
  if (has(['dental', 'tooth', 'teeth', 'oral'])) {
    return Icons.medical_services_outlined;
  }
  if (has(['respiratory', 'asthma', 'cough', 'cold', 'lung'])) {
    return Icons.masks_outlined;
  }
  if (has(['depress', 'psych', 'anxiety', 'mental'])) {
    return Icons.psychology_alt_outlined;
  }
  if (has(['neuro', 'brain', 'nerve'])) return Icons.psychology_outlined;
  if (has(['contracept', 'sexual', 'wellness', 'reproduct'])) {
    return Icons.volunteer_activism_outlined;
  }
  if (has(['herbal', 'ayurved', 'natural'])) return Icons.spa_outlined;
  if (has(['surgical', 'first aid', 'bandage', 'wound'])) {
    return Icons.medical_information_outlined;
  }
  if (has(['diagnostic', 'equipment', 'device', 'monitor', 'test'])) {
    return Icons.biotech_outlined;
  }
  if (has(['ortho', 'bone', 'joint', 'muscle'])) {
    return Icons.accessible_outlined;
  }
  if (has(['oncology', 'cancer', 'tumor'])) {
    return Icons.local_hospital_outlined;
  }
  if (has(['allergy', 'antihistamine'])) return Icons.air_outlined;
  if (has(['personal care', 'hygiene', 'soap', 'wash'])) {
    return Icons.clean_hands_outlined;
  }
  if (has(['drink', 'syrup', 'liquid'])) return Icons.local_drink_outlined;

  return Icons.medication_outlined;
}
