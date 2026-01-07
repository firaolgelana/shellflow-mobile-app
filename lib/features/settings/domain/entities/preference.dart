import 'package:equatable/equatable.dart';

enum AppTheme { light, dark, system }

class Preference extends Equatable {
  final AppTheme theme;
  final String languageCode; // e.g., 'en', 'es'
  final bool use24HourFormat;

  const Preference({
    required this.theme,
    required this.languageCode,
    required this.use24HourFormat,
  });

  // Factory for default settings
  factory Preference.defaults() {
    return const Preference(
      theme: AppTheme.system,
      languageCode: 'en',
      use24HourFormat: true,
    );
  }

  Preference copyWith({
    AppTheme? theme,
    String? languageCode,
    bool? use24HourFormat,
  }) {
    return Preference(
      theme: theme ?? this.theme,
      languageCode: languageCode ?? this.languageCode,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    );
  }

  @override
  List<Object?> get props => [theme, languageCode, use24HourFormat];
}