
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';

class PreferenceModel extends Preference {
  const PreferenceModel({
    required super.theme,
    required super.languageCode,
    required super.use24HourFormat,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      theme: _mapStringToTheme(json['theme']),
      languageCode: json['language_code'] ?? 'en',
      use24HourFormat: json['use_24_hour_format'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.name, // 'light', 'dark', 'system'
      'language_code': languageCode,
      'use_24_hour_format': use24HourFormat,
    };
  }

  factory PreferenceModel.fromEntity(Preference entity) {
    return PreferenceModel(
      theme: entity.theme,
      languageCode: entity.languageCode,
      use24HourFormat: entity.use24HourFormat,
    );
  }

  static AppTheme _mapStringToTheme(String? theme) {
    return AppTheme.values.firstWhere(
      (e) => e.name == theme,
      orElse: () => AppTheme.system,
    );
  }
}