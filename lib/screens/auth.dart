import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:edufocus/main.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:toastification/toastification.dart';

import '../utils/app_user.dart';
import 'auth_2.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

bool valid = false;

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(FocusNode());
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
                  Text(
                    'EduFocus',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Streamline your studies.',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // if mac
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.phone,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'To continue, please enter your phone number.',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    const SizedBox(height: 16),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    GlassContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: IntlPhoneField(
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(FontAwesomeIcons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          dropdownTextStyle: GoogleFonts.ibmPlexSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          dropdownIcon: Icon(
                            FontAwesomeIcons.caretDown,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          showDropdownIcon: false,
                          pickerDialogStyle: PickerDialogStyle(
                            searchFieldPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            backgroundColor: Colors.white,
                            searchFieldInputDecoration: InputDecoration(
                              hintText: 'Search...',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              hintStyle: GoogleFonts.ibmPlexSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            listTileDivider: const SizedBox(height: 0),
                            countryNameStyle: GoogleFonts.ibmPlexSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            countryCodeStyle: GoogleFonts.ibmPlexSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onChanged: (phone) {
                            if (phone.number.length >= 10 &&
                                phone.isValidNumber()) {
                              valid = true;
                            } else {
                              valid = false;
                            }
                            phoneNumber = phone.completeNumber;
                          },
                        ),
                      ),
                    ),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    const SizedBox(height: 16),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    Center(
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(16),
                        height: 40,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (!valid &&
                                defaultTargetPlatform == TargetPlatform.iOS) {
                              toastification.show(
                                style: ToastificationStyle.fillColored,
                                applyBlurEffect: true,
                                context: context,
                                type: ToastificationType.error,
                                title: const Text(
                                    'Please enter a valid phone number'),
                                autoCloseDuration: const Duration(seconds: 5),
                              );
                              return;
                            }

                            FocusScope.of(context).requestFocus(FocusNode());
                            Get.to(() => const AuthPage2());
                          },
                          child: Text('Continue',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    const SizedBox(height: 16),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'OR',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    const SizedBox(height: 16),

                  Center(
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          UserCredential user = await signInWithApple();
                          setupFlow(FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: Text('Sign In with Apple',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ].animate(delay: 500.ms).fadeIn(
                      duration: 1000.ms,
                    ),
              ),
            ),
          ).animate().scale().fadeIn(),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
