import 'package:edufocus/main.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'course_details.dart';
import 'home.dart';

class SchedItem extends StatefulWidget {
  const SchedItem({super.key});

  @override
  State<SchedItem> createState() => _SchedItemState();
}

RecurringScheduleItem? editingItem;

class _SchedItemState extends State<SchedItem> {
  TextEditingController eventNameController = TextEditingController();
  bool isRevealed = false;
  bool isRevealed2 = false;
  bool isRevealed3 = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int v = 0;
  String courseId = '';
  List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  List<String> days = [];

  void toggleReveal() {
    setState(() {
      isRevealed = !isRevealed;
      isRevealed2 = false;
      isRevealed3 = false;
    });
  }

  void toggleReveal2() {
    setState(() {
      isRevealed2 = !isRevealed2;
      isRevealed = false;
      isRevealed3 = false;
    });
  }

  void toggleReveal3() {
    setState(() {
      isRevealed3 = !isRevealed3;
      isRevealed = false;
      isRevealed2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Get.back();
                        },
                      ),
                      if (editing)
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(
                            FontAwesomeIcons.trash,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                    ],
                  ),
                  Text(
                    'Recurring Event',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 0,
                    groupValue: v,
                    onChanged: (value) {
                      setState(() {
                        v = value!;
                        eventNameController.text = '';
                      });
                    },
                    title: Text('Course',
                        style: GoogleFonts.ibmPlexSans(color: Colors.white)),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    activeColor: Colors.white,
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 1,
                    groupValue: v,
                    onChanged: (value) {
                      setState(() {
                        v = value!;
                        eventNameController.text = '';
                      });
                    },
                    title: Text('Other event',
                        style: GoogleFonts.ibmPlexSans(color: Colors.white)),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    activeColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: toggleReveal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.repeat,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                if (startTime != null && endTime != null)
                                  Text(
                                    '${startTime!.format(context)} – ${endTime!.format(context)}',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                if (startTime == null || endTime == null)
                                  Text(
                                    'No time selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                Icon(
                                  isRevealed
                                      ? FontAwesomeIcons.caretUp
                                      : FontAwesomeIcons.caretDown,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isRevealed,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Select the start and end time of this event.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 8),
                                GlassContainer(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start Time',
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              helpText: 'Select Start Time',
                                              initialTime: const TimeOfDay(
                                                  hour: 8, minute: 0),
                                              builder: (context, child) {
                                                return child!;
                                              },
                                            ).then((value) {
                                              if (value != null) {
                                                if (endTime != null &&
                                                    value.hour * 60 +
                                                            value.minute >=
                                                        endTime!.hour * 60 +
                                                            endTime!.minute) {
                                                  return;
                                                }
                                                setState(() {
                                                  startTime = value;
                                                });
                                                showTimePicker(
                                                  helpText: 'Select End Time',
                                                  context: context,
                                                  initialTime: startTime != null
                                                      ? TimeOfDay(
                                                          hour:
                                                              startTime!.hour +
                                                                  1,
                                                          minute:
                                                              startTime!.minute)
                                                      : const TimeOfDay(
                                                          hour: 8, minute: 0),
                                                  builder: (context, child) {
                                                    return child!;
                                                  },
                                                ).then((value) {
                                                  if (value != null) {
                                                    if (startTime != null &&
                                                        value.hour * 60 +
                                                                value.minute <=
                                                            startTime!.hour *
                                                                    60 +
                                                                startTime!
                                                                    .minute) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      endTime = value;
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          },
                                          child: GlassContainer(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                startTime != null
                                                    ? startTime!.format(context)
                                                    : 'Select',
                                                style: GoogleFonts.ibmPlexSans(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GlassContainer(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'End Time',
                                          style: GoogleFonts.ibmPlexSans(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showTimePicker(
                                              helpText: 'Select End Time',
                                              context: context,
                                              initialTime: startTime != null
                                                  ? TimeOfDay(
                                                      hour: startTime!.hour + 1,
                                                      minute: startTime!.minute)
                                                  : const TimeOfDay(
                                                      hour: 8, minute: 0),
                                              builder: (context, child) {
                                                return child!;
                                              },
                                            ).then((value) {
                                              if (value != null) {
                                                if (startTime != null &&
                                                    value.hour * 60 +
                                                            value.minute <=
                                                        startTime!.hour * 60 +
                                                            startTime!.minute) {
                                                  return;
                                                }
                                                setState(() {
                                                  endTime = value;
                                                });
                                              }
                                            });
                                          },
                                          child: GlassContainer(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                endTime != null
                                                    ? endTime!.format(context)
                                                    : 'Select',
                                                style: GoogleFonts.ibmPlexSans(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (v == 0) const SizedBox(height: 16),
                  if (v == 0)
                    GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: toggleReveal2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      courseId != ''
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.xmark,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  if (courseId != '')
                                    Expanded(
                                      child: Text(
                                        appUser!.courses!
                                            .firstWhere((element) =>
                                                element.id == courseId)
                                            .name,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  if (courseId == '')
                                    Text(
                                      'No course selected',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  Icon(
                                    isRevealed2
                                        ? FontAwesomeIcons.caretUp
                                        : FontAwesomeIcons.caretDown,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isRevealed2,
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  for (Course course in appUser!.courses ?? [])
                                    RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                      value: course.id,
                                      groupValue: courseId,
                                      onChanged: (value) {
                                        setState(() {
                                          courseId = value!;
                                        });
                                        eventNameController.text = course.name;
                                      },
                                      title: Text(
                                        course.name,
                                        style: GoogleFonts.ibmPlexSans(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      secondary: GlassContainer(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: FaIcon(icons[course.icon],
                                              size: 22, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: TextField(
                      controller: eventNameController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 40,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Event Name',
                        hintStyle: GoogleFonts.ibmPlexSans(
                          color: Colors.white,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: toggleReveal3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                if (days.isNotEmpty)
                                  Expanded(
                                    child: Text(
                                      days.join(', '),
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (days.isEmpty)
                                  Text(
                                    'No day selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                Icon(
                                  isRevealed3
                                      ? FontAwesomeIcons.caretUp
                                      : FontAwesomeIcons.caretDown,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isRevealed3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Weekly events:',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'Select the days of the week this event will occur.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (String weekday in weekdays)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            days.removeWhere((element) =>
                                                element.startsWith('Day '));
                                            // add in order
                                            if (days.contains(weekday)) {
                                              days.remove(weekday);
                                            } else {
                                              days.add(weekday);
                                            }

                                            // sort
                                            days.sort((a, b) {
                                              return weekdays
                                                  .indexOf(a)
                                                  .compareTo(
                                                      weekdays.indexOf(b));
                                            });
                                          });
                                        },
                                        child: GlassContainer(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              weekday,
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 11,
                                                fontWeight:
                                                    days.contains(weekday)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: days.contains(weekday)
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Block/cycle schedules:',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  'Select the days of the block/cycle this event will occur.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (int i = 1; i <= 6; i++)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // remove all letter days
                                            days.removeWhere((element) =>
                                                element.startsWith('Day ') &&
                                                    element.endsWith('A') ||
                                                element.endsWith('B') ||
                                                element.endsWith('C') ||
                                                element.endsWith('D') ||
                                                element.endsWith('E') ||
                                                element.endsWith('F'));

                                            // remove all week days
                                            days.removeWhere((element) =>
                                                element.startsWith('Mon') ||
                                                element.startsWith('Tue') ||
                                                element.startsWith('Wed') ||
                                                element.startsWith('Thu') ||
                                                element.startsWith('Fri') ||
                                                element.startsWith('Sat') ||
                                                element.startsWith('Sun'));

                                            // add in order
                                            if (days.contains('Day $i')) {
                                              days.remove('Day $i');
                                            } else {
                                              days.add('Day $i');
                                            }

                                            // sort
                                            days.sort((a, b) {
                                              return int.parse(a.split(' ')[1])
                                                  .compareTo(int.parse(
                                                      b.split(' ')[1]));
                                            });
                                          });
                                        },
                                        child: GlassContainer(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              'Day $i',
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 11,
                                                fontWeight:
                                                    days.contains('Day $i')
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                color: days.contains('Day $i')
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
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
                                            // remove all number days
                                            days.removeWhere((element) =>
                                                element.startsWith('Day ') &&
                                                element.split(' ')[1].isNum);

                                            days.removeWhere((element) =>
                                                element.startsWith('Mon') ||
                                                element.startsWith('Tue') ||
                                                element.startsWith('Wed') ||
                                                element.startsWith('Thu') ||
                                                element.startsWith('Fri') ||
                                                element.startsWith('Sat') ||
                                                element.startsWith('Sun'));

                                            // add in order
                                            if (days.contains(
                                                'Day ${String.fromCharCode(64 + i)}')) {
                                              days.remove(
                                                  'Day ${String.fromCharCode(64 + i)}');
                                            } else {
                                              days.add(
                                                  'Day ${String.fromCharCode(64 + i)}');
                                            }

                                            // sort
                                            days.sort((a, b) {
                                              return a
                                                  .split(' ')[1]
                                                  .compareTo(b.split(' ')[1]);
                                            });
                                          });
                                        },
                                        child: GlassContainer(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              'Day ${String.fromCharCode(64 + i)}',
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 11,
                                                fontWeight: days.contains(
                                                        'Day ${String.fromCharCode(64 + i)}')
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: days.contains(
                                                        'Day ${String.fromCharCode(64 + i)}')
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          if (eventNameController.text.isEmpty) {
                            return;
                          }
                          if (startTime == null || endTime == null) {
                            return;
                          }
                          if (v == 0 && courseId == '') {
                            return;
                          }
                          if (days.isEmpty) {
                            return;
                          }

                          if (appUser!.scheduleItems == null) {
                            appUser!.scheduleItems = [];
                          }

                          appUser!.scheduleItems!.add(RecurringScheduleItem(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: eventNameController.text,
                            courseId: v == 0 ? courseId : null,
                            startTime: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              startTime!.hour,
                              startTime!.minute,
                            ),
                            endTime: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              endTime!.hour,
                              endTime!.minute,
                            ),
                            days: days,
                          ));

                          updateUser(appUser!);
                          Get.back();
                        },
                        child: Text('Save',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
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
}
