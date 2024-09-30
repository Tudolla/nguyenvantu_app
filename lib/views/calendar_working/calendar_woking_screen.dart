import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/gen/assets.gen.dart';
import 'dart:ui';
import 'package:table_calendar/table_calendar.dart';

import '../../components/core/app_textstyle.dart';
import '../../providers/time_tracking_provider.dart';

class CalendarWokingScreen extends ConsumerStatefulWidget {
  const CalendarWokingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarWokingScreenState();
}

class _CalendarWokingScreenState extends ConsumerState<CalendarWokingScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    final currentMonth = _focusedDay.month;
    final currentYear = _focusedDay.year;
    ref.read(attendanceViewModelProvider.notifier).loadAttendanceData(
          currentMonth,
          currentYear,
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeTrackingState = ref.watch(attendanceViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "calendar working day",
          style: TextStyle(
            fontFamily: AppTextStyle.drawerFontStyle,
            fontSize: 25,
            color: const Color.fromARGB(255, 109, 105, 105),
          ),
        ),
        centerTitle: true,
      ),
      body: timeTrackingState.when(
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text("Sorry, have some error"),
        ),
        data: (data) {
          Map<DateTime?, double?> workingDay = {};

          for (var attendace in data) {
            DateTime? date =
                attendace.date != null ? DateTime.parse(attendace.date!) : null;
            workingDay[date] = attendace.workHoursRes ?? null;
          }

          return Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              left: 20,
              right: 20,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: 150,
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          Assets.images.calendar.path,
                          // fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Độ mờ
                          child: Container(
                            color: Colors.black
                                .withOpacity(0), // Giữ trong suốt cho hiệu ứng
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TableCalendar(
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    final selectedMonth = focusedDay.month;
                    final selectedYear = focusedDay.year;

                    ref
                        .read(attendanceViewModelProvider.notifier)
                        .loadAttendanceData(selectedMonth, selectedYear);
                  },
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2024, 01, 01),
                  lastDay: DateTime.utc(2025, 01, 01),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronMargin: EdgeInsets.only(left: 0.0),
                    rightChevronMargin: EdgeInsets.only(right: 0.0),
                    leftChevronPadding: EdgeInsets.all(0),
                    rightChevronPadding: EdgeInsets.all(0),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      size: 28,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      size: 28,
                    ),
                  ),
                  calendarFormat: _calendarFormat,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      DateTime cleanDay =
                          DateTime(day.year, day.month, day.day);
                      double? workHours = workingDay[cleanDay];
                      if (workHours == 1.0) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (workHours == 0.5) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 164, 241, 175),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
