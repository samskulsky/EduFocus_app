import 'package:edufocus/main.dart';
import 'package:edufocus/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'course_details.dart';

class StudySchedulePage extends StatefulWidget {
  const StudySchedulePage({super.key});

  @override
  State<StudySchedulePage> createState() => _StudySchedulePageState();
}

Todo? curTodo;

class _StudySchedulePageState extends State<StudySchedulePage> {
  int v = 1;
  int k = 15;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    curTodo = null;
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
                    'Study Schedule',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'To prepare for your exam, choose when you plan to study and for how long.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          onPressed: () {
                            setState(() {
                              v++;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.circlePlus,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                        ),
                        if (v >= 2)
                          IconButton(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            onPressed: () {
                              setState(() {
                                v--;
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.circleMinus,
                              color: Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Study period: ',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Once every ',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      GlassContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '$v',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' days.',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          onPressed: () {
                            setState(() {
                              k += 5;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.circlePlus,
                            color: Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                        ),
                        if (k >= 10)
                          IconButton(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            onPressed: () {
                              setState(() {
                                k -= 5;
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.circleMinus,
                              color: Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Study duration: ',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'For ',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      GlassContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '$k',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' minutes.',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          createStudySchedule();

                          updateTodo(curTodo!);

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

  void createStudySchedule() {
    // from now until the exam date, create a study schedule
    // based on the study period and study duration

    // for each day, create a study plan item
    int daysUntilExam = curTodo!.dueDate.difference(DateTime.now()).inDays;

    List<StudyPlanItem> studySchedule = [];

    for (int i = 0; i < daysUntilExam; i++) {
      if (i % v == 0) {
        studySchedule.add(StudyPlanItem(
          dueDate: curTodo!.dueDate.subtract(Duration(days: i)),
          length: k,
        ));
      }
    }

    curTodo!.studyPlan = studySchedule;
  }
}
