import 'package:edufocus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import 'setup_2.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
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
                  Text(
                    'Welcome!',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Let\'s setup your account',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
                          Get.to(() => const SetupPage2());
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
