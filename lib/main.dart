import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'screens/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (GetPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 600),
      minimumSize: Size(450, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'EduFocus',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Gemini.init(apiKey: 'INSERT_API_KEY');

  prefs = await SharedPreferences.getInstance();
  if (prefs.getString('theme') != null) {
    if (prefs.getString('theme') == 'midnight') {
      gradient = midnight;
    } else if (prefs.getString('theme') == 'fireside') {
      gradient = fireside;
    } else if (prefs.getString('theme') == 'ocean') {
      gradient = ocean;
    } else if (prefs.getString('theme') == 'creamsicle') {
      gradient = creamsicle;
    }
  } else {
    gradient = midnight;
    prefs.setString('theme', 'midnight');
  }

  runApp(const MyApp());
}

late SharedPreferences prefs;

List<Color> gradient = [
  const Color.fromARGB(255, 24, 4, 84),
  const Color.fromARGB(255, 33, 6, 132),
  const Color.fromARGB(255, 61, 10, 70)
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: GetPlatform.isDesktop
          ? MacosApp(
              title: 'EduFocus',
              theme: MacosThemeData.light(),
              darkTheme: MacosThemeData.dark(),
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              home: FirebaseAuth.instance.currentUser == null
                  ? const AuthPage()
                  : const HomeScreen(),
            )
          : GetMaterialApp(
              defaultTransition: Transition.fade,
              title: 'EduFocus',
              themeMode: ThemeMode.light,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textTheme: GoogleFonts.ibmPlexSansTextTheme(),
                buttonTheme: ButtonThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                dropdownMenuTheme: DropdownMenuThemeData(
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  textStyle: GoogleFonts.ibmPlexSans(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  centerTitle: true,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  titleTextStyle: GoogleFonts.ibmPlexSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.white),
                  trackColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.4)),
                ),
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.all(Colors.white),
                ),
                timePickerTheme: TimePickerThemeData(
                  confirmButtonStyle: TextButton.styleFrom(
                    textStyle: GoogleFonts.ibmPlexSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  cancelButtonStyle: TextButton.styleFrom(
                    textStyle: GoogleFonts.ibmPlexSans(
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  dialHandColor: Colors.grey,
                  dialBackgroundColor: Colors.white,
                  hourMinuteColor: Colors.white,
                  hourMinuteTextColor: Colors.black,
                  dialTextColor: Colors.black,
                  dialTextStyle: GoogleFonts.ibmPlexSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  helpTextStyle: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                  ),
                  dayPeriodTextStyle: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.transparent,
                  iconColor: Colors.white,
                  isDense: true,
                  counterStyle: GoogleFonts.ibmPlexSans(
                    color: Colors.white,
                  ),
                  labelStyle: GoogleFonts.ibmPlexSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: GoogleFonts.ibmPlexSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              debugShowCheckedModeBanner: false,
              home: FirebaseAuth.instance.currentUser == null
                  ? const AuthPage()
                  : const HomeScreen(),
            ),
    );
  }
}
