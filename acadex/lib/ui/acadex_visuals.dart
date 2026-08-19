import 'package:flutter/material.dart';

import '../app.dart';

/// Reusable elegant background container with sleek gradient for pages
class AcadexScaffoldBackground extends StatelessWidget {
  final Widget child;

  const AcadexScaffoldBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AcadexApp.backgroundGradient,
      ),
      child: child,
    );
  }
}

/// Glassmorphic Floating Action Button
class AcadexGlassFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;

  const AcadexGlassFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AcadexApp.primaryAccent.withValues(alpha: 0.45),
            AcadexApp.primaryAccent.withValues(alpha: 0.20),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AcadexApp.primaryAccent.withValues(alpha: 0.25),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: Tooltip(
          message: tooltip ?? '',
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphic Action Button with label and icon
class AcadexGlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const AcadexGlassButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.28),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AcadexIconChip extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final BorderRadius borderRadius;

  const AcadexIconChip({
    super.key,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.size = 44,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.12),
        borderRadius: borderRadius,
        border: Border.all(color: backgroundColor.withValues(alpha: 0.20)),
      ),
      child: Icon(icon, color: iconColor == Colors.white ? backgroundColor : iconColor, size: size * 0.5),
    );
  }
}

class AcadexAppLogo extends StatelessWidget {
  final double size;
  final double radius;

  const AcadexAppLogo({super.key, this.size = 48, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 18,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset('assets/images/acadex_logo.jpeg', fit: BoxFit.cover),
    );
  }
}

class AcadexEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const AcadexEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AcadexIconChip(
              icon: icon,
              backgroundColor: AcadexApp.primaryBlue,
              size: 60,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (action case final actionWidget?) ...[
              const SizedBox(height: 18),
              actionWidget,
            ],
          ],
        ),
      ),
    );
  }
}

class AcadexSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const AcadexSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(letterSpacing: 0.1),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        action ?? const SizedBox.shrink(),
      ],
    );
  }
}

/// A smooth, error-free time picker dialog supporting both scrollable looping wheels and direct typing
Future<TimeOfDay?> showAcadexTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
}) async {
  final init = initialTime ?? TimeOfDay.now();
  int selectedHour = init.hourOfPeriod == 0 ? 12 : init.hourOfPeriod;
  int selectedMinute = init.minute;
  DayPeriod selectedPeriod = init.period;
  bool isKeyboardMode = false;

  final initialHourIndex = selectedHour - 1;
  final initialMinuteIndex = selectedMinute;
  final initialPeriodIndex = selectedPeriod == DayPeriod.am ? 0 : 1;

  final hourController =
      FixedExtentScrollController(initialItem: initialHourIndex);
  final minuteController =
      FixedExtentScrollController(initialItem: initialMinuteIndex);
  final periodController =
      FixedExtentScrollController(initialItem: initialPeriodIndex);

  final hourTextController = TextEditingController(
    text: selectedHour.toString().padLeft(2, '0'),
  );
  final minuteTextController = TextEditingController(
    text: selectedMinute.toString().padLeft(2, '0'),
  );

  return showDialog<TimeOfDay>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0F2636),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFF1B3B52), width: 1),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isKeyboardMode
                        ? Icons.view_day_rounded
                        : Icons.keyboard_alt_rounded,
                    color: AcadexApp.primaryAccent,
                  ),
                  tooltip: isKeyboardMode
                      ? 'Switch to Wheel'
                      : 'Type Time (Keyboard)',
                  onPressed: () {
                    setDialogState(() {
                      isKeyboardMode = !isKeyboardMode;
                      if (isKeyboardMode) {
                        hourTextController.text =
                            selectedHour.toString().padLeft(2, '0');
                        minuteTextController.text =
                            selectedMinute.toString().padLeft(2, '0');
                      } else {
                        final h = int.tryParse(hourTextController.text);
                        final m = int.tryParse(minuteTextController.text);
                        if (h != null && h >= 1 && h <= 12) {
                          selectedHour = h;
                          hourController.jumpToItem(selectedHour - 1);
                        }
                        if (m != null && m >= 0 && m <= 59) {
                          selectedMinute = m;
                          minuteController.jumpToItem(selectedMinute);
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              height: 180,
              width: 290,
              child: isKeyboardMode
                  // Typeable numeric input mode
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Hours input field
                          SizedBox(
                            width: 68,
                            child: TextField(
                              controller: hourTextController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFF132D42),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AcadexApp.primaryAccent
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AcadexApp.primaryAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                final h = int.tryParse(val);
                                if (h != null && h >= 1 && h <= 12) {
                                  selectedHour = h;
                                }
                              },
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              ':',
                              style: TextStyle(
                                color: AcadexApp.primaryAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Minutes input field
                          SizedBox(
                            width: 68,
                            child: TextField(
                              controller: minuteTextController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFF132D42),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AcadexApp.primaryAccent
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: AcadexApp.primaryAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                final m = int.tryParse(val);
                                if (m != null && m >= 0 && m <= 59) {
                                  selectedMinute = m;
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          // AM / PM Segment toggle
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setDialogState(
                                  () => selectedPeriod = DayPeriod.am,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedPeriod == DayPeriod.am
                                        ? AcadexApp.primaryAccent
                                        : const Color(0xFF132D42),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'AM',
                                    style: TextStyle(
                                      color: selectedPeriod == DayPeriod.am
                                          ? Colors.white
                                          : const Color(0xFF8A99A8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () => setDialogState(
                                  () => selectedPeriod = DayPeriod.pm,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedPeriod == DayPeriod.pm
                                        ? AcadexApp.primaryAccent
                                        : const Color(0xFF132D42),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PM',
                                    style: TextStyle(
                                      color: selectedPeriod == DayPeriod.pm
                                          ? Colors.white
                                          : const Color(0xFF8A99A8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  // Scrollable wheel mode
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hours Wheel (Infinite Loop 1-12)
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: hourController,
                            itemExtent: 44,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              selectedHour = (index % 12) + 1;
                            },
                            childDelegate: ListWheelChildLoopingListDelegate(
                              children: List.generate(12, (index) {
                                final hour = index + 1;
                                return Center(
                                  child: Text(
                                    hour.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        const Text(
                          ':',
                          style: TextStyle(
                            color: AcadexApp.primaryAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Minutes Wheel (Infinite Loop 00-59)
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: minuteController,
                            itemExtent: 44,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              selectedMinute = index % 60;
                            },
                            childDelegate: ListWheelChildLoopingListDelegate(
                              children: List.generate(60, (index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // AM/PM Wheel
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: periodController,
                            itemExtent: 44,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              selectedPeriod =
                                  index == 0 ? DayPeriod.am : DayPeriod.pm;
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 2,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index == 0 ? 'AM' : 'PM',
                                    style: const TextStyle(
                                      color: AcadexApp.primaryAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, null),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF8A99A8)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (isKeyboardMode) {
                    final h = int.tryParse(hourTextController.text);
                    final m = int.tryParse(minuteTextController.text);
                    if (h != null && h >= 1 && h <= 12) selectedHour = h;
                    if (m != null && m >= 0 && m <= 59) selectedMinute = m;
                  }

                  int finalHour = selectedHour;
                  if (selectedPeriod == DayPeriod.am) {
                    if (finalHour == 12) finalHour = 0;
                  } else {
                    if (finalHour != 12) finalHour += 12;
                  }
                  Navigator.pop(
                    dialogContext,
                    TimeOfDay(hour: finalHour, minute: selectedMinute),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}

