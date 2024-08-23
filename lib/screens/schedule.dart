import 'package:edufocus/main.dart';
import 'package:edufocus/screens/course_details.dart';
import 'package:edufocus/screens/home.dart';
import 'package:edufocus/screens/sched_item.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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
                  FontAwesomeIcons.calendarDays,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Schedule',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Text(
            'Swipe left to delete events',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              color: Colors.white,
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

                Get.to(() => const SchedItem());
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
              appUser = snapshot.data; // sort schedule items by days

              // sort schedule items by start time
              appUser!.scheduleItems!.sort((a, b) {
                return a.startTime.compareTo(b.startTime);
              });
              appUser!.scheduleItems!.sort((a, b) {
                return a.days.join('').compareTo(b.days.join(''));
              });

              return ListView.separated(
                itemCount: appUser!.scheduleItems != null
                    ? appUser!.scheduleItems!.length
                    : 0,
                padding: const EdgeInsets.fromLTRB(16, 136, 16, 16),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  TimeOfDay startTime = TimeOfDay(
                    hour: appUser!.scheduleItems![index].startTime.hour,
                    minute: appUser!.scheduleItems![index].startTime.minute,
                  );
                  TimeOfDay endTime = TimeOfDay(
                    hour: appUser!.scheduleItems![index].endTime.hour,
                    minute: appUser!.scheduleItems![index].endTime.minute,
                  );
                  Course? course = appUser!.courses!.firstWhereOrNull(
                    (course) =>
                        course.id == appUser!.scheduleItems![index].courseId,
                  );
                  return Dismissible(
                    key: Key(appUser!.scheduleItems![index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      appUser!.scheduleItems!.removeAt(index);
                      updateUser(appUser!);
                    },
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appUser!.scheduleItems![index].days
                                  .join(', ')
                                  .toUpperCase(),
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              '${startTime.format(context)} - ${endTime.format(context)}',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              appUser!.scheduleItems![index].name,
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                        ),
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
