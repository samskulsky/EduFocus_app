import 'dart:async';

import 'package:edufocus/main.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  String status =
      ''; // Work1, Break1, Work2, Break2, Work3, Break3, Work4, Break4

  // timer functions and variables
  int workTime = 25 * 60 + 1;
  int breakTime = 5 * 60 + 1;
  int longBreakTime = 25 * 60 + 1;
  int currentInterval = 1;
  int currentIntervalTime = 25 * 60;
  int currentIntervalMaxTime = 25 * 60;
  bool isPaused = false;

  Timer? timer;

  // start timer
  void startTimer() {
    WakelockPlus.enable();
    // play sound
    HapticFeedback.vibrate();
    currentIntervalTime = workTime;
    currentIntervalMaxTime = workTime;
    currentInterval = 1;
    status = 'Work1';
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIntervalTime == 0) {
        if (status == 'Work1') {
          if (currentInterval == 4) {
            currentInterval = 1;
            currentIntervalTime = longBreakTime;
            currentIntervalMaxTime = longBreakTime;
            HapticFeedback.vibrate();

            status = 'Break4';
          } else {
            currentInterval++;
            currentIntervalTime = breakTime;
            currentIntervalMaxTime = breakTime;
            HapticFeedback.vibrate();

            status = 'Break$currentInterval';
          }
        } else {
          currentIntervalTime = workTime;
          currentIntervalMaxTime = workTime;
          HapticFeedback.vibrate();

          status = 'Work$currentInterval';
        }
      } else {
        currentIntervalTime--;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                          if (timer != null) {
                            timer!.cancel();
                          }
                          Get.back();
                        },
                      ),
                      Text(
                        'Pomodoro Timer',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (status == '')
                        GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Work in 25 minute intervals. After each interval, take a 5 minute break. After four intervals, take a 25 minute break.',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (status.startsWith('Break'))
                        GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Break Period',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (status.startsWith('Work'))
                        GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Work Period',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          // timer
                          '${(currentIntervalTime ~/ 60).toString().padLeft(2, '0')}:${(currentIntervalTime % 60).toString().padLeft(2, '0')}',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // slider representing the progress of the timer
                      if (status != '')
                        GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          height: 10,
                          child: LinearProgressIndicator(
                            value: 1 -
                                currentIntervalTime / currentIntervalMaxTime,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      if (status == '') const SizedBox(height: 16),
                      if (status == '')
                        Center(
                          child: GlassContainer(
                            borderRadius: BorderRadius.circular(16),
                            height: 40,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                startTimer();
                              },
                              child: Text('Start',
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
          if (status != '')
            Positioned.fill(
              child: TransparentPointer(
                child: FloatingBubbles.alwaysRepeating(
                  noOfBubbles: 10,
                  colorsOfBubbles: const [Colors.white],
                  speed: BubbleSpeed.slow,
                  sizeFactor: 0.16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
