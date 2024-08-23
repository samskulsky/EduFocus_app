import 'package:edufocus/main.dart';
import 'package:edufocus/screens/auth.dart';
import 'package:edufocus/screens/home.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

String lastName = '';

List<Color> midnight = [
  const Color.fromARGB(255, 24, 4, 84),
  const Color.fromARGB(255, 33, 6, 132),
  const Color.fromARGB(255, 61, 10, 70)
];

List<Color> fireside = [
  const Color.fromARGB(255, 60, 7, 13),
  const Color.fromARGB(255, 90, 5, 15),
  const Color.fromARGB(255, 129, 1, 9)
];

List<Color> ocean = [
  const Color.fromARGB(255, 13, 82, 103),
  const Color.fromARGB(255, 11, 61, 77),
  const Color.fromARGB(255, 2, 35, 45),
];

List<Color> creamsicle = [
  const Color.fromARGB(255, 151, 9, 38),
  const Color.fromARGB(255, 197, 104, 12),
  const Color.fromARGB(255, 174, 160, 1),
];

List<String> options = ['Midnight', 'Fireside', 'Ocean', 'Creamsicle'];

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController lastNameController = TextEditingController();

  late String theme;

  @override
  void initState() {
    super.initState();
    theme = prefs.getString('theme')!;
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
                      Get.off(() => const HomeScreen());
                    },
                  ),
                  Text(
                    'Settings',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Color Theme',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    // ignore: prefer_const_constructors
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString(
                                'theme', options[index].toLowerCase());

                            setState(() {
                              theme = options[index].toLowerCase();
                              gradient = options[index] == 'Midnight'
                                  ? midnight
                                  : options[index] == 'Fireside'
                                      ? fireside
                                      : options[index] == 'Ocean'
                                          ? ocean
                                          : creamsicle;
                            });
                          });
                        },
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: options[index] == 'Midnight'
                                ? midnight
                                : options[index] == 'Fireside'
                                    ? fireside
                                    : options[index] == 'Ocean'
                                        ? ocean
                                        : creamsicle,
                          ),
                          border: theme == options[index].toLowerCase()
                              ? Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2)
                              : null,
                          opacity: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              options[index],
                              style: GoogleFonts.ibmPlexSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight:
                                    theme == options[index].toLowerCase()
                                        ? FontWeight.bold
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(16),
                    child: TextButton(
                      onPressed: () {
                        Get.offAll(() => const AuthPage());
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.ibmPlexSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
}
