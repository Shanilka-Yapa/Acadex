import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'dashboard/dashboard.dart';
import 'profile/profile_model.dart';
import 'profile/profile_page.dart';

class AcadexApp extends StatelessWidget {
  const AcadexApp({super.key});

  // ============================================================
  // Modern Sleek Dark Palette Constants
  // ============================================================
  static const Color brandDark = Color(0xFF071422); // Deep midnight navy
  static const Color primaryAccent = Color(0xFF0088E8); // Rich Electric Blue
  static const Color lightAccent = Color(0xFF0F324D); // Deep accent container
  static const Color appBackground = Color(0xFF0A1624); // Modern Sleek Dark Background
  static const Color cardColor = Color(0xFF0F263A); // Sleek Dark Surface Cards
  static const Color elevatedCard = Color(0xFF15334D); // Elevated cards
  static const Color mainText = Color(0xFFF1F6FA); // Crisp White/Ice Text
  static const Color secondaryText = Color(0xFF8EABC0); // Muted Slate Blue-Grey
  static const Color borderDivider = Color(0xFF1B3B57); // Dark Border / Divider

  // Elegant Professional Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF16324F), // Noticeable rich steel navy top-left
      Color(0xFF0C1D2E), // Deep midnight blue middle
      Color(0xFF050B12), // Sleek pitch dark bottom-right
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Backwards compatibility aliases
  static const Color primaryBlue = primaryAccent;
  static const Color primaryDark = brandDark;
  static const Color secondaryPurple = Color(0xFF8B5CF6);
  static const Color accentCyan = primaryAccent;
  static const Color background = appBackground;
  static const Color surface = cardColor;
  static const Color elevatedSurface = elevatedCard;
  static const Color elevatedSurfaceAlt = lightAccent;
  static const Color textPrimary = mainText;
  static const Color textSecondary = secondaryText;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color divider = borderDivider;

  ThemeData _buildTheme() {
    final colorScheme = const ColorScheme.dark(
      primary: primaryAccent,
      onPrimary: brandDark,
      primaryContainer: lightAccent,
      onPrimaryContainer: primaryAccent,
      secondary: primaryAccent,
      onSecondary: brandDark,
      secondaryContainer: lightAccent,
      onSecondaryContainer: primaryAccent,
      tertiary: Color(0xFF38BDF8),
      onTertiary: brandDark,
      surface: cardColor,
      onSurface: mainText,
      error: error,
      onError: Colors.white,
      outline: borderDivider,
      shadow: Color(0x33000000),
      surfaceTint: primaryAccent,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: appBackground,
      primaryColor: primaryAccent,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: cardColor,
        hourMinuteTextColor: primaryAccent,
        hourMinuteColor: lightAccent,
        dayPeriodTextColor: primaryAccent,
        dayPeriodColor: lightAccent,
        dialHandColor: primaryAccent,
        dialBackgroundColor: lightAccent,
        dialTextColor: mainText,
        entryModeIconColor: primaryAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: mainText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryAccent),
        titleTextStyle: TextStyle(
          color: mainText,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.45,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderDivider, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderDivider),
        ),
        titleTextStyle: const TextStyle(
          color: mainText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(color: secondaryText, fontSize: 14),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: mainText,
        subtitleTextStyle: TextStyle(color: secondaryText, fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brandDark,
        labelStyle: const TextStyle(color: secondaryText),
        hintStyle: const TextStyle(color: secondaryText),
        floatingLabelStyle: const TextStyle(
          color: primaryAccent,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryAccent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            primaryAccent.withValues(alpha: 0.35),
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStatePropertyAll(
            primaryAccent.withValues(alpha: 0.15),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          side: const BorderSide(color: borderDivider),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        elevation: 3,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(
        color: borderDivider,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDivider),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightAccent,
        selectedColor: primaryAccent.withValues(alpha: 0.2),
        disabledColor: appBackground,
        labelStyle: const TextStyle(color: mainText),
        secondaryLabelStyle: const TextStyle(color: mainText),
        side: const BorderSide(color: borderDivider),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        pressElevation: 0,
        showCheckmark: false,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryAccent,
        linearTrackColor: borderDivider,
        circularTrackColor: borderDivider,
      ),
      iconTheme: const IconThemeData(color: secondaryText),
      textTheme: ThemeData(brightness: Brightness.light).textTheme.copyWith(
        displayLarge: const TextStyle(
          color: mainText,
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
        ),
        displayMedium: const TextStyle(
          color: mainText,
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.1,
        ),
        headlineLarge: const TextStyle(
          color: mainText,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.9,
        ),
        headlineMedium: const TextStyle(
          color: mainText,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        headlineSmall: const TextStyle(
          color: mainText,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.35,
        ),
        titleLarge: const TextStyle(
          color: mainText,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: const TextStyle(
          color: mainText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        bodyLarge: const TextStyle(
          color: mainText,
          fontSize: 16,
          height: 1.45,
        ),
        bodyMedium: const TextStyle(
          color: secondaryText,
          fontSize: 14,
          height: 1.45,
        ),
        labelLarge: const TextStyle(
          color: mainText,
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
      themeMode: ThemeMode.light,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AcadexApp.backgroundGradient,
          ),
          child: child,
        );
      },
      home: profileBox.isNotEmpty ? const DashboardPage() : const ProfilePage(),
    );
  }
}
