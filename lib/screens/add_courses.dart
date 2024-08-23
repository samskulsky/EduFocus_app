import 'package:edufocus/main.dart';
import 'package:edufocus/screens/course_details.dart';
import 'package:edufocus/screens/home.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddCourses extends StatefulWidget {
  const AddCourses({super.key});

  @override
  State<AddCourses> createState() => _AddCoursesState();
}

class _AddCoursesState extends State<AddCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        title: GlassContainer(
          borderRadius: BorderRadius.circular(16),
          blur: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.graduationCap,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Courses',
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          icon: const Icon(
            FontAwesomeIcons.solidCircleLeft,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          GlassContainer(
            borderRadius: BorderRadius.circular(16),
            height: 40,
            width: 60,
            blur: 8,
            child: TextButton(
              onPressed: () {
                editing = false;

                Get.to(() => const AddCourse());
              },
              child: Text(
                'Add',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: StreamBuilder<AppUser>(
            stream: userStream(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(
                  child: SpinKitPulse(
                    color: Colors.white,
                    size: 50,
                  ),
                );
              }
              appUser = snapshot.data;
              return ListView.separated(
                itemCount: appUser!.courses!.length,
                padding: const EdgeInsets.fromLTRB(16, 128, 16, 16),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return GlassContainer(
                    shadowColor: colors[appUser!.courses![index].color]!,
                    shadowStrength: 1,
                    blur: 2,
                    border: Border.all(
                      color: colors[appUser!.courses![index].color]!,
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors[appUser!.courses![index].color]!
                            .withOpacity(0.5),
                        colors[appUser!.courses![index].color]!
                            .withOpacity(0.2),
                      ],
                    ),
                    opacity: 1,
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      leading: Container(
                        alignment: Alignment.centerLeft,
                        width: 58,
                        child: Icon(
                          icons[appUser!.courses![index].icon],
                          color: Colors.white.withOpacity(0.7),
                          size: 40,
                        ),
                      ),
                      title: Text(
                        appUser!.courses![index].name,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${DateFormat.yMMMd().format(appUser!.courses![index].startDate)} – ${DateFormat.yMMMd().format(appUser!.courses![index].endDate)}',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          editing = true;
                          editingCourse = appUser!.courses![index];

                          Get.to(() => const AddCourse());
                        },
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
