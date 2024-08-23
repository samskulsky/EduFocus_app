import 'package:edufocus/main.dart';
import 'package:edufocus/screens/home.dart';
import 'package:edufocus/setup/setup_2.dart';
import 'package:edufocus/setup/setup_4.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'setup_3.dart';

class SetupPage6 extends StatefulWidget {
  const SetupPage6({super.key});

  @override
  State<SetupPage6> createState() => _SetupPage6State();
}

class _SetupPage6State extends State<SetupPage6> {
  bool status = false;

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
                    'All set!',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Thanks for setting up your account. You can now start using the app.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 16,
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
                        onPressed: () async {
                          AppUser appUser = AppUser(
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            phoneNumber: FirebaseAuth
                                    .instance.currentUser!.phoneNumber ??
                                '',
                            email:
                                FirebaseAuth.instance.currentUser!.email ?? '',
                            firstName: firstName,
                            lastName: lastName,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            schoolType: schoolType,
                            role: 'student',
                            fcmToken: GetPlatform.isIOS
                                ? await FirebaseMessaging.instance.getToken() ??
                                    ''
                                : '',
                          );
                          createUser(appUser).whenComplete(() {
                            Get.offAll(() => const HomeScreen());
                          });
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
