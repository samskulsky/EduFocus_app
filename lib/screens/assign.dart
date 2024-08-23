import 'package:edufocus/main.dart';
import 'package:edufocus/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utils/app_user.dart';

class AssignDays extends StatefulWidget {
  const AssignDays({super.key});

  @override
  State<AssignDays> createState() => _AssignDaysState();
}

AppUser? cUser;

class _AssignDaysState extends State<AssignDays> {
  DateTime selectedDate = DateTime.now();

  List<String> days = [
    'Day 1',
    'Day 2',
    'Day 3',
    'Day 4',
    'Day 5',
    'Day 6',
    'Day A',
    'Day B',
    'Day C',
    'Day D',
    'Day E',
    'Day F',
  ];

  String selectedDay = '';

  List<Day> assignedDays = [];

  @override
  void initState() {
    super.initState();
    if (cUser!.days == null) {
      cUser!.days = [];
    }

    assignedDays = cUser!.days!;
  }

  @override
  Widget build(BuildContext context) {
    // if current day is in assigned days
    bool isDayAssigned = assignedDays
        .where((element) => sameDate(element.date, selectedDate))
        .isNotEmpty;

    // if current day is in assigned days
    if (isDayAssigned) {
      // get the day
      Day day = assignedDays
          .firstWhere((element) => sameDate(element.date, selectedDate));

      // if day is not empty
      if (day.dayName != '') {
        // get the day
        selectedDay = day.dayName;
      }
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: Center(
          child: GlassContainer(
            opacity: 0.1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      FontAwesomeIcons.solidCircleLeft,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      updateUser(cUser!);
                      Get.off(() => const HomeScreen());
                    },
                  ),
                  Text(
                    'Assign Days',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedDate = selectedDate
                                      .subtract(const Duration(days: 1));
                                  selectedDay = '';
                                });
                              },
                            ),
                            Text(
                              DateFormat.yMMMMEEEEd().format(selectedDate),
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.arrowRight,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 1));
                                  selectedDay = '';
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (int i = 1; i <= 6; i++)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDay = days[i - 1];
                                      if (isDayAssigned) {
                                        assignedDays
                                            .firstWhere((element) => sameDate(
                                                element.date, selectedDate))
                                            .dayName = selectedDay;
                                      } else {
                                        cUser!.days!.add(Day(
                                          date: selectedDate,
                                          dayName: selectedDay,
                                        ));
                                      }
                                    });
                                  },
                                  child: GlassContainer(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        days[i - 1],
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 11,
                                          fontWeight: selectedDay == days[i - 1]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: selectedDay == days[i - 1]
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              for (int i = 1;
                                  i <= 6;
                                  i++) // letter (Day A, Day B, etc.)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDay = days[5 + i];
                                      if (isDayAssigned) {
                                        assignedDays
                                            .firstWhere((element) => sameDate(
                                                element.date, selectedDate))
                                            .dayName = selectedDay;
                                      } else {
                                        cUser!.days!.add(Day(
                                          date: selectedDate,
                                          dayName: selectedDay,
                                        ));
                                      }
                                    });
                                  },
                                  child: GlassContainer(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        days[5 + i],
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 11,
                                          fontWeight: selectedDay == days[5 + i]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: selectedDay == days[5 + i]
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDay = '';
                                    if (isDayAssigned) {
                                      assignedDays.removeWhere((element) =>
                                          sameDate(element.date, selectedDate));
                                    }
                                  });
                                },
                                child: GlassContainer(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      'None',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 11,
                                        fontWeight: selectedDay == ''
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: selectedDay == ''
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ].animate().fadeIn(delay: 200.ms, duration: 500.ms),
              ),
            ),
          ).animate().fadeIn(),
        ),
      ),
    );
  }

  bool sameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
