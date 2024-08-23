import 'package:edufocus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'setup_3.dart';

class SetupPage2 extends StatefulWidget {
  const SetupPage2({super.key});

  @override
  State<SetupPage2> createState() => _SetupPage2State();
}

String firstName = '';

class _SetupPage2State extends State<SetupPage2> {
  TextEditingController firstNameController = TextEditingController();

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
                    'What\'s your first name?',
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
                    child: TextField(
                      controller: firstNameController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                      ),
                      maxLength: 20,
                      autocorrect: false,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'First Name',
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
                  Center(
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (firstNameController.text.isNotEmpty) {
                            firstName =
                                firstNameController.text.capitalizeFirst!;
                            Get.to(() => const SetupPage3());
                          } else {
                            toastification.show(
                              style: ToastificationStyle.fillColored,
                              applyBlurEffect: true,
                              context: context,
                              type: ToastificationType.error,
                              title: const Text('Please enter your first name'),
                              autoCloseDuration: const Duration(seconds: 5),
                            );
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
