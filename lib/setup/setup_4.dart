import 'package:edufocus/main.dart';
import 'package:edufocus/setup/setup_6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'setup_5.dart';

class SetupPage4 extends StatefulWidget {
  const SetupPage4({super.key});

  @override
  State<SetupPage4> createState() => _SetupPage4State();
}

String schoolType = '';

class _SetupPage4State extends State<SetupPage4> {
  int v = 0;

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
                  Text(
                    'What type of school do you attend?',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Column(
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: 0,
                          groupValue: v,
                          onChanged: (value) {
                            setState(() {
                              v = value!;
                              schoolType = 'Middle School';
                            });
                          },
                          title: Text('Middle School',
                              style:
                                  GoogleFonts.ibmPlexSans(color: Colors.white)),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: 1,
                          groupValue: v,
                          onChanged: (value) {
                            setState(() {
                              v = value!;
                              schoolType = 'High School';
                            });
                          },
                          title: Text('High School',
                              style:
                                  GoogleFonts.ibmPlexSans(color: Colors.white)),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          value: 2,
                          groupValue: v,
                          onChanged: (value) {
                            setState(() {
                              v = value!;
                              schoolType = 'College';
                            });
                          },
                          title: Text('College',
                              style:
                                  GoogleFonts.ibmPlexSans(color: Colors.white)),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // if platform is mac, skip this page
                          if (GetPlatform.isMacOS) {
                            Get.to(() => const SetupPage6());
                          } else {
                            Get.to(() => const SetupPage5());
                          }
                        },
                        child: Text('Continue',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ]
                    .animate(interval: 250.ms, delay: 500.ms)
                    .fadeIn(delay: 200.ms, duration: 500.ms),
              ),
            ),
          ).animate().fadeIn(),
        ),
      ),
    );
  }
}
