import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'dashboard/dashboard.dart';
import 'profile/profile_model.dart';
import 'profile/profile_page.dart';

class AcadexApp extends StatelessWidget {
  const AcadexApp({super.key});

  static const Color primaryBlue = Color(0xFF2B6CFF);
  static const Color primaryDark = Color(0xFF1E4FD6);
  static const Color secondaryPurple = Color(0xFF6E7DFF);
  static const Color accentCyan = Color(0xFF36D1DC);
  static const Color background = Color(0xFF060B16);
  static const Color surface = Color(0xFF0D1626);
  static const Color elevatedSurface = Color(0xFF142033);
  static const Color elevatedSurfaceAlt = Color(0xFF18263B);
  static const Color textPrimary = Color(0xFFE6EEF8);
  static const Color textSecondary = Color(0xFF92A3BA);
  static const Color success = Color(0xFF1BCB91);
  static const Color warning = Color(0xFFF4B942);
  static const Color error = Color(0xFFF05A6B);
  static const Color divider = Color(0xFF22324A);

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primaryBlue,
      onPrimary: Colors.white,
      primaryContainer: primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: secondaryPurple,
      onSecondary: Colors.white,
      secondaryContainer: secondaryPurple.withValues(alpha: 0.18),
      onSecondaryContainer: const Color(0xFFE9D5FF),
      tertiary: accentCyan,
      onTertiary: Colors.white,
      tertiaryContainer: accentCyan.withValues(alpha: 0.18),
      onTertiaryContainer: const Color(0xFFCFFAFE),
      surface: surface,
      onSurface: textPrimary,
      error: error,
      onError: Colors.white,
      outline: divider,
      shadow: Colors.black.withValues(alpha: 0.35),
      surfaceTint: primaryBlue,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      splashFactory: InkSparkle.splashFactory,
      primaryColor: primaryBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.45,
        ),
      ),
      cardTheme: CardThemeData(
        color: elevatedSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.28),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: elevatedSurfaceAlt,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(color: textSecondary, fontSize: 14),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: textPrimary,
        subtitleTextStyle: TextStyle(color: textSecondary, fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        floatingLabelStyle: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(primaryBlue),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(
            Colors.white.withValues(alpha: 0.08),
          ),
          shadowColor: const WidgetStatePropertyAll(primaryBlue),
          elevation: const WidgetStatePropertyAll(3),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: DividerThemeData(
        color: divider.withValues(alpha: 0.92),
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: elevatedSurfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: elevatedSurfaceAlt,
        selectedColor: primaryBlue.withValues(alpha: 0.18),
        disabledColor: elevatedSurface,
        labelStyle: const TextStyle(color: textPrimary),
        secondaryLabelStyle: const TextStyle(color: textPrimary),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: divider,
        circularTrackColor: divider,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.copyWith(
        displayLarge: const TextStyle(
          color: textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
        ),
        displayMedium: const TextStyle(
          color: textPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.1,
        ),
        headlineLarge: const TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.9,
        ),
        headlineMedium: const TextStyle(
          color: textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        headlineSmall: const TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.35,
        ),
        titleLarge: const TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: const TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        bodyLarge: const TextStyle(
          color: textPrimary,
          fontSize: 16,
          height: 1.45,
        ),
        bodyMedium: const TextStyle(
          color: textSecondary,
          fontSize: 14,
          height: 1.45,
        ),
        labelLarge: const TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileBox = Hive.box<Profile>('profile');

    return MaterialApp(
      title: 'Acadex',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      darkTheme: _buildTheme(),
      themeMode: ThemeMode.dark,
      home: profileBox.isNotEmpty ? const DashboardPage() : const ProfilePage(),
    );
  }
}
