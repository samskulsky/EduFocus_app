import 'package:edufocus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'setup_6.dart';

class SetupPage5 extends StatefulWidget {
  const SetupPage5({super.key});

  @override
  State<SetupPage5> createState() => _SetupPage5State();
}

class _SetupPage5State extends State<SetupPage5> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    status = await Permission.notification.status.isGranted;
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
                    'Allow Notifications',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'In order to remind you of your assignments and study schedules, we need to send you notifications.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifications',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: status,
                            onChanged: (value) async {
                              await Permission.notification.request();
                              if (await Permission
                                  .notification.status.isGranted) {
                                setState(() {
                                  status = true;
                                });
                              }
                            },
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
                        onPressed: () {
                          Get.to(() => const SetupPage6());
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
