import 'dart:developer';

import 'package:edufocus/main.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class AuthPage2 extends StatefulWidget {
  const AuthPage2({super.key});

  @override
  State<AuthPage2> createState() => _AuthPage2State();
}

String phoneNumber = '';

class _AuthPage2State extends State<AuthPage2> {
  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthHandler(
      phoneNumber: phoneNumber,
      onCodeSent: () {
        log('Code sent');
      },
      onLoginSuccess: (userCredential, autoVerified) {
        log(
          autoVerified
              ? 'OTP was fetched automatically!'
              : 'OTP was verified manually!',
        );
        toastification.show(
          style: ToastificationStyle.fillColored,
          applyBlurEffect: true,
          context: context,
          type: ToastificationType.success,
          title: const Text('Phone number verified!'),
          autoCloseDuration: const Duration(seconds: 5),
        );
        log('Login success UID: ${userCredential.user!.uid}');
        setupFlow(FirebaseAuth.instance.currentUser!.uid);
      },
      onLoginFailed: (authException, stackTrace) {
        log(authException.message ?? 'Login failed');

        switch (authException.code) {
          case 'invalid-phone-number':
            toastification.show(
              style: ToastificationStyle.fillColored,
              applyBlurEffect: true,
              context: context,
              type: ToastificationType.error,
              title: const Text('Invalid phone number, please try again'),
              autoCloseDuration: const Duration(seconds: 5),
            );
            break;
          case 'invalid-verification-code':
            toastification.show(
              style: ToastificationStyle.fillColored,
              applyBlurEffect: true,
              context: context,
              type: ToastificationType.error,
              title: const Text('The code you entered is invalid'),
              autoCloseDuration: const Duration(seconds: 5),
            );
            break;
          default:
            toastification.show(
              style: ToastificationStyle.fillColored,
              applyBlurEffect: true,
              context: context,
              type: ToastificationType.error,
              title: const Text('An error occurred, please try again'),
              autoCloseDuration: const Duration(seconds: 5),
            );
        }
      },
      onError: (error, stackTrace) {
        log(stackTrace.toString());
        toastification.show(
          style: ToastificationStyle.fillColored,
          applyBlurEffect: true,
          context: context,
          type: ToastificationType.error,
          title: const Text('An error occurred, please try again'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      },
      builder: (context, controller) {
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
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.solidCircleLeft,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          if (controller.codeSent)
                            TextButton(
                              onPressed: controller.isOtpExpired
                                  ? () async {
                                      log('Resend OTP');
                                      await controller.sendOTP();
                                    }
                                  : null,
                              child: Text(
                                controller.isOtpExpired
                                    ? 'Resend'
                                    : '${controller.otpExpirationTimeLeft.inSeconds}s',
                                style: GoogleFonts.ibmPlexSans(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                        ],
                      ),
                      controller.isSendingCode
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Sending Verification Code...',
                                style: GoogleFonts.ibmPlexSans(
                                    fontSize: 18, color: Colors.white),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "We've sent a text with a verification code to $phoneNumber",
                                    style: GoogleFonts.ibmPlexSans(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Enter Code',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Pinput(
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    length: 6,
                                    defaultPinTheme: PinTheme(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                234, 239, 243, 1)),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      textStyle: GoogleFonts.ibmPlexSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      width: 50,
                                      height: 50,
                                    ),
                                    onCompleted: (pin) async {
                                      await controller.verifyOtp(pin);
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
