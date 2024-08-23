import 'package:confetti/confetti.dart';
import 'package:edufocus/main.dart';
import 'package:edufocus/screens/add_courses.dart';
import 'package:edufocus/screens/add_todo.dart';
import 'package:edufocus/screens/assign.dart';
import 'package:edufocus/screens/calc.dart';
import 'package:edufocus/screens/notes.dart';
import 'package:edufocus/screens/pomodoro.dart';
import 'package:edufocus/screens/schedule.dart';
import 'package:edufocus/screens/settings.dart';
import 'package:edufocus/screens/solver.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:edufocus/utils/event.dart';
import 'package:edufocus/utils/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:relative_time/relative_time.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';

import 'course_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

AppUser? appUser;

int page = 0;
CalendarView calendarView = CalendarView.day;

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController scrollController = ScrollController();

  late ConfettiController _controllerBottomLeft;
  late ConfettiController _controllerBottomRight;

  @override
  void initState() {
    super.initState();

    _controllerBottomLeft =
        ConfettiController(duration: const Duration(milliseconds: 500));

    _controllerBottomRight =
        ConfettiController(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controllerBottomLeft.dispose();
    _controllerBottomRight.dispose();
    super.dispose();
  }

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isDesktop) {
      return MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: pageIndex,
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              onChanged: (i) {
                setState(() => pageIndex = i);
              },
              items: const [
                SidebarItem(
                  label: Text('Page One'),
                ),
                SidebarItem(
                  label: Text('Page Two'),
                ),
              ],
            );
          },
        ),
        titleBar: TitleBar(
          title: const Text('EduFocus'),
        ),
        child: MacosScaffold(
          toolBar: ToolBar(
            title: Text('EduFocus'),
          ),
        ),
      );
    }

    return Stack(
      children: [
        if (GetPlatform.isIOS)
          Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            bottomNavigationBar: GlassContainer(
              blur: 50,
              child: BottomNavigationBar(
                currentIndex: page,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                items: const [
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.house),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.listUl),
                    label: 'Assignments',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.solidCalendarDays),
                    label: 'Schedule',
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    page = index;
                  });
                },
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
              title: GlassContainer(
                borderRadius: BorderRadius.circular(16),
                blur: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: page == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.house,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Home',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : page == 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.listUl,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Assignments',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Text(
                                    'Day',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 20,
                                      color: calendarView == CalendarView.day
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                      fontWeight:
                                          calendarView == CalendarView.day
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      calendarView = CalendarView.day;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Week',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 20,
                                      color: calendarView == CalendarView.week
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                      fontWeight:
                                          calendarView == CalendarView.week
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      calendarView = CalendarView.week;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Text(
                                    'List',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 20,
                                      color:
                                          calendarView == CalendarView.schedule
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                      fontWeight:
                                          calendarView == CalendarView.schedule
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      calendarView = CalendarView.schedule;
                                    });
                                  },
                                ),
                              ],
                            ),
                ),
              ),
              actions: [
                if (page == 0)
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    height: 40,
                    width: 60,
                    blur: 8,
                    child: IconButton(
                      onPressed: () {
                        Get.off(() => const SettingsPage());
                      },
                      icon: const Icon(
                        FontAwesomeIcons.gear,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (page == 1)
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    height: 40,
                    width: 60,
                    blur: 8,
                    child: IconButton(
                      onPressed: () {
                        Get.to(() => const AddTodo());
                      },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (page != 2) const SizedBox(width: 16),
              ],
            ),
            body: Container(
              height: double.infinity,
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
                  if (appUser!.courses == null) {
                    appUser!.courses = [];
                  }
                  if (page == 0) {
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 128, bottom: 128),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GlassContainer(
                            opacity: 0.1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Your Weekly Progress',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (streak() > 1)
                                        GlassContainer(
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Text(
                                              '${streak()} day${streak() > 1 ? 's' : ''} in a row!',
                                              style: GoogleFonts.ibmPlexSans(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: SfCartesianChart(
                                      borderWidth: 0,
                                      plotAreaBorderWidth: 0,
                                      primaryXAxis: const CategoryAxis(
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        majorGridLines:
                                            MajorGridLines(width: 0),
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        isVisible: false,
                                      ),
                                      series: <CartesianSeries>[
                                        getWeeklyProgress(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.15 < 180
                                  ? 180
                                  : MediaQuery.of(context).size.height * 0.15,
                          child: Center(
                            child: ListView(
                              controller: scrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(16),
                              children: [
                                scrollWidget(
                                  'Add/Edit Courses',
                                  appUser!.courses!.isEmpty
                                      ? 'You have no courses added yet. Add your courses to get started.'
                                      : 'You currently have ${appUser!.courses!.length} course${appUser!.courses!.length > 1 ? 's' : ''} added.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.graduationCap,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'My Courses',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const AddCourses());
                                  },
                                ),
                                const SizedBox(width: 16),
                                scrollWidget(
                                  'Edit Schedule',
                                  'Stay updated with classes and timely assignments.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.calendarDays,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Schedule',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const Schedule());
                                  },
                                ),
                                const SizedBox(width: 16),
                                // scrollWidget(
                                //   'Notification Settings',
                                //   'Manage your notification preferences.',
                                //   Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       const FaIcon(
                                //         FontAwesomeIcons.solidBell,
                                //         color: Colors.white,
                                //         size: 16,
                                //       ),
                                //       const SizedBox(width: 8),
                                //       Text(
                                //         'Notifications',
                                //         style: GoogleFonts.ibmPlexSans(
                                //           color: Colors.white,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                //   () {
                                //     Get.to(() => const Schedule());
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 0.15 < 180
                                  ? 180
                                  : MediaQuery.of(context).size.height * 0.15,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              children: [
                                scrollWidget(
                                  'Notes',
                                  'Keep track of content and important information.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.noteSticky,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Notes',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const Notes());
                                  },
                                ),
                                const SizedBox(width: 16),
                                scrollWidget(
                                  'Math Solver',
                                  'Take a photo of a math problem and get the solution.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.hashtag,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Math Solver',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const MathSolver());
                                  },
                                ),
                                const SizedBox(width: 16),
                                scrollWidget(
                                  'Calculator',
                                  'Convienent tool for all your calculations.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.calculator,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Calculator',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const Calculator());
                                  },
                                ),
                                const SizedBox(width: 16),
                                scrollWidget(
                                  'Pomodoro Timer',
                                  'Stay focused and productive using the Pomodoro technique.',
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.solidClock,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Pomodoro Timer',
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  () {
                                    Get.to(() => const Pomodoro());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                          .animate(
                            interval: 300.ms,
                          )
                          .scaleXY(duration: 350.ms)
                          .fadeIn(
                            delay: 150.ms,
                            duration: 350.ms,
                          ),
                    );
                  } else if (page == 1) {
                    return StreamBuilder(
                        stream:
                            getTodos(FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return const Center(
                              child: SpinKitPulse(
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          }
                          List<Todo> todos = snapshot.data!;

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(0, 128, 0, 0),
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(todos[index].id),
                                onDismissed: (direction) {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    completeTodo(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        todos[index].id);
                                    addUsage(1);
                                    _controllerBottomRight.play();
                                  } else {
                                    deleteTodo(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        todos[index].id);
                                  }
                                },
                                background: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.red,
                                        Colors.red.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: GlassContainer(
                                      borderRadius: BorderRadius.circular(90),
                                      height: 40,
                                      width: 40,
                                      child: const Icon(
                                        FontAwesomeIcons.circleXmark,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.green,
                                        Colors.green.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: GlassContainer(
                                      borderRadius: BorderRadius.circular(90),
                                      height: 40,
                                      width: 40,
                                      child: const Icon(
                                        FontAwesomeIcons.circleCheck,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // show bottom sheet
                                    // glass

                                    showBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GlassContainer(
                                            height: 300,
                                            shadowStrength: 8,
                                            blur: 50,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Center(
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 70, 16, 0),
                                                    child: FaIcon(
                                                      icons[appUser!.courses!
                                                          .firstWhere(
                                                              (course) =>
                                                                  course.id ==
                                                                  todos[index]
                                                                      .courseId)
                                                          .icon],
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      size: 55,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            GlassContainer(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  todos[index].type ==
                                                                          'assignment'
                                                                      ? 'Assignment'
                                                                      : 'Exam',
                                                                  style: GoogleFonts
                                                                      .ibmPlexSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ).animate().moveX(),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                    const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .xmark,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          appUser!.courses!
                                                              .firstWhere((course) =>
                                                                  course.id ==
                                                                  todos[index]
                                                                      .courseId)
                                                              .name
                                                              .toUpperCase(),
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ).animate().fadeIn(),
                                                        Text(
                                                          todos[index].title,
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ).animate().fadeIn(),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          todos[index]
                                                              .description,
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .solidClock,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  todos[index].type ==
                                                                          'exam'
                                                                      ? '${RelativeTime.locale(const Locale('en')).format(todos[index].dueDate).capitalizeFirst}'
                                                                      : 'Due ${RelativeTime.locale(const Locale('en')).format(todos[index].dueDate)}',
                                                                  style: GoogleFonts
                                                                      .ibmPlexSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ).animate().flipH(
                                                                delay: 500.ms,
                                                                duration:
                                                                    500.ms),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          'MMM d, y')
                                                                      .format(todos[
                                                                              index]
                                                                          .dueDate),
                                                                  style: GoogleFonts
                                                                      .ibmPlexSans(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GlassContainer(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                height: 40,
                                                                color: Colors
                                                                    .green
                                                                    .withOpacity(
                                                                        0.5),
                                                                child:
                                                                    TextButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () async {
                                                                    completeTodo(
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid,
                                                                        todos[index]
                                                                            .id);
                                                                    Navigator.pop(
                                                                        context);

                                                                    addUsage(1);

                                                                    // confetti
                                                                    _controllerBottomRight
                                                                        .play();
                                                                  },
                                                                  label: Text(
                                                                    'Complete',
                                                                    style: GoogleFonts
                                                                        .ibmPlexSans(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  icon:
                                                                      const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .solidCircleCheck,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child:
                                                                  GlassContainer(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                height: 40,
                                                                color: Colors
                                                                    .red
                                                                    .withOpacity(
                                                                        0.5),
                                                                child:
                                                                    TextButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () async {
                                                                    await deleteTodo(
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid,
                                                                        todos[index]
                                                                            .id);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  label: Text(
                                                                    'Delete',
                                                                    style: GoogleFonts
                                                                        .ibmPlexSans(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  icon:
                                                                      const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .trash,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child:
                                                                  GlassContainer(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                                height: 40,
                                                                child:
                                                                    TextButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () {
                                                                    editingTodo =
                                                                        todos[
                                                                            index];

                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.to(() =>
                                                                        const AddTodo());
                                                                  },
                                                                  label: Text(
                                                                    'Edit',
                                                                    style: GoogleFonts
                                                                        .ibmPlexSans(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  icon:
                                                                      const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .penToSquare,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]
                                                              .animate(
                                                                delay: 1000.ms,
                                                              )
                                                              .fadeIn(),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: GlassContainer(
                                    opacity: 0.8,
                                    borderRadius: BorderRadius.circular(0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        colors[appUser!.courses!
                                            .firstWhere((course) =>
                                                course.id ==
                                                todos[index].courseId)
                                            .color]!,
                                        colors[appUser!.courses!
                                                .firstWhere((course) =>
                                                    course.id ==
                                                    todos[index].courseId)
                                                .color]!
                                            .withOpacity(0.8),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 16, 16, 0),
                                            child: FaIcon(
                                              icons[appUser!.courses!
                                                  .firstWhere((course) =>
                                                      course.id ==
                                                      todos[index].courseId)
                                                  .icon],
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              size: 55,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                appUser!.courses!
                                                    .firstWhere((course) =>
                                                        course.id ==
                                                        todos[index].courseId)
                                                    .name
                                                    .toUpperCase(),
                                                style: GoogleFonts.ibmPlexSans(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                todos[index].title,
                                                style: GoogleFonts.ibmPlexSans(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                todos[index].description,
                                                style: GoogleFonts.ibmPlexSans(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const FaIcon(
                                                        FontAwesomeIcons
                                                            .solidClock,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        todos[index].type ==
                                                                'exam'
                                                            ? '${RelativeTime.locale(const Locale('en')).format(todos[index].dueDate).capitalizeFirst}'
                                                            : 'Due ${RelativeTime.locale(const Locale('en')).format(todos[index].dueDate)}',
                                                        style: GoogleFonts
                                                            .ibmPlexSans(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        DateFormat('MMM d, y')
                                                            .format(todos[index]
                                                                .dueDate),
                                                        style: GoogleFonts
                                                            .ibmPlexSans(
                                                          color: Colors.white
                                                              .withOpacity(0.5),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if (todos[index].studyPlan !=
                                                      null &&
                                                  todos[index]
                                                      .studyPlan!
                                                      .isNotEmpty)
                                                const SizedBox(height: 8),
                                              if (todos[index].studyPlan !=
                                                      null &&
                                                  todos[index]
                                                      .studyPlan!
                                                      .isNotEmpty)
                                                Divider(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  thickness: 2,
                                                ),
                                              if (todos[index].studyPlan !=
                                                      null &&
                                                  todos[index]
                                                      .studyPlan!
                                                      .isNotEmpty)
                                                const SizedBox(height: 8),
                                              if (todos[index].studyPlan !=
                                                      null &&
                                                  todos[index]
                                                      .studyPlan!
                                                      .isNotEmpty)
                                                Row(
                                                  children: [
                                                    GlassContainer(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      blur: 8,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        child: Text(
                                                          'STUDY PLAN',
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Study for ${todos[index].studyPlan!.last.length} minutes',
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Due ${RelativeTime.locale(const Locale('en')).format(todos[index].studyPlan!.last.dueDate)}',
                                                          style: GoogleFonts
                                                              .ibmPlexSans(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        // remove this item
                                                        setState(() {
                                                          todos[index]
                                                              .studyPlan!
                                                              .removeLast();
                                                        });

                                                        // show confetti
                                                        _controllerBottomRight
                                                            .play();

                                                        addUsage(1);

                                                        updateTodo(
                                                            todos[index]);
                                                      },
                                                      child: GlassContainer(
                                                        color: Colors.green
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        blur: 8,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          child: Row(
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .circleCheck,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                'Complete',
                                                                style: GoogleFonts
                                                                    .ibmPlexSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  .animate(delay: (100 * index).ms)
                                  .fadeIn(duration: 900.ms, delay: 200.ms)
                                  .shimmer(
                                      blendMode: BlendMode.srcOver,
                                      color: Colors.white12)
                                  .move(
                                      begin: const Offset(-16, 0),
                                      curve: Curves.easeOutQuad);
                            },
                          );
                        });
                  } else if (page == 2) {
                    List<EduEvent> events = []; // Days of week
                    if (appUser!.scheduleItems == null) {
                      appUser!.scheduleItems = [];
                    }
                    for (var schedItem in appUser!.scheduleItems!) {
                      DateTime now = DateTime.now();
                      DateTime? courseStart = schedItem.courseId != null
                          ? appUser!.courses!
                              .firstWhere(
                                  (course) => course.id == schedItem.courseId)
                              .startDate
                          : null;
                      DateTime? courseEnd = schedItem.courseId != null
                          ? appUser!.courses!
                              .firstWhere(
                                  (course) => course.id == schedItem.courseId)
                              .endDate
                          : null;

                      DateTime start = DateTime(now.year, now.month, now.day,
                          schedItem.startTime.hour, schedItem.startTime.minute);
                      DateTime end = DateTime(now.year, now.month, now.day,
                          schedItem.endTime.hour, schedItem.endTime.minute);

                      String recRule = '';

                      if (schedItem.days.isNotEmpty) {
                        List<WeekDays> wDays = [];
                        for (var day in schedItem.days) {
                          switch (day) {
                            case 'Mon':
                              wDays.add(WeekDays.monday);
                              break;
                            case 'Tue':
                              wDays.add(WeekDays.tuesday);
                              break;
                            case 'Wed':
                              wDays.add(WeekDays.wednesday);
                              break;
                            case 'Thu':
                              wDays.add(WeekDays.thursday);
                              break;
                            case 'Fri':
                              wDays.add(WeekDays.friday);
                              break;
                            case 'Sat':
                              wDays.add(WeekDays.saturday);
                              break;
                            case 'Sun':
                              wDays.add(WeekDays.sunday);
                              break;
                          }
                        }
                        if (wDays.isNotEmpty) {
                          recRule = SfCalendar.generateRRule(
                            RecurrenceProperties(
                              startDate: courseStart ?? start,
                              endDate: courseEnd ?? end,
                              recurrenceRange: courseEnd != null
                                  ? RecurrenceRange.endDate
                                  : RecurrenceRange.noEndDate,
                              weekDays: wDays,
                              recurrenceType: RecurrenceType.weekly,
                            ),
                            start,
                            end,
                          );
                          events.add(
                            EduEvent(
                              id: schedItem.id,
                              title: schedItem.name,
                              startTime: start,
                              endTime: end,
                              courseId: schedItem.courseId ?? '',
                              isAllDay: false,
                              color: schedItem.courseId != null
                                  ? appUser!.courses!
                                      .firstWhere((course) =>
                                          course.id == schedItem.courseId)
                                      .color
                                  : null,
                              reccurenceRule: recRule,
                            ),
                          );
                        }
                      }
                    }

                    if (appUser!.days == null) {
                      appUser!.days = [];
                    }

                    for (var day in appUser!.days!) {
                      events.add(
                        EduEvent(
                          id: const Uuid().v4(),
                          title: day.dayName,
                          startTime: day.date,
                          endTime: day.date,
                          courseId: '',
                          isAllDay: true,
                          reccurenceRule: '',
                        ),
                      );

                      for (var schedItem in appUser!.scheduleItems!) {
                        DateTime now = day.date;
                        DateTime start = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            schedItem.startTime.hour,
                            schedItem.startTime.minute);
                        DateTime end = DateTime(now.year, now.month, now.day,
                            schedItem.endTime.hour, schedItem.endTime.minute);

                        if (schedItem.days.contains(day.dayName) &&
                            day.dayName.isNotEmpty) {
                          events.add(
                            EduEvent(
                              id: schedItem.id,
                              title: schedItem.name,
                              startTime: start,
                              endTime: end,
                              courseId: schedItem.courseId ?? '',
                              isAllDay: false,
                              color: schedItem.courseId != null
                                  ? appUser!.courses!
                                      .firstWhere((course) =>
                                          course.id == schedItem.courseId)
                                      .color
                                  : null,
                              reccurenceRule: '',
                            ),
                          );
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 128, 24, 0),
                      child: Column(
                        children: [
                          GlassContainer(
                            child: ListTile(
                              title: Text(
                                'Assign Days',
                                style: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'In order to view events that occur on block/cycle days, you must assign each day.',
                                style: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: const FaIcon(
                                FontAwesomeIcons.angleRight,
                                color: Colors.white,
                              ),
                              onTap: () {
                                cUser = appUser;
                                Get.off(() => const AssignDays());
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SfCalendar(
                              allowViewNavigation: true,
                              showDatePickerButton: true,
                              selectionDecoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              view: calendarView,
                              viewNavigationMode: ViewNavigationMode.none,
                              dataSource: EventDataSource(events),
                              monthViewSettings: const MonthViewSettings(
                                showAgenda: true,
                              ),
                              headerStyle: CalendarHeaderStyle(
                                backgroundColor: Colors.transparent,
                                textStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              viewHeaderHeight: 80,
                              todayHighlightColor: Colors.red,
                              showTodayButton: true,
                              viewHeaderStyle: ViewHeaderStyle(
                                backgroundColor: Colors.transparent,
                                dayTextStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                dateTextStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              scheduleViewSettings: ScheduleViewSettings(
                                hideEmptyScheduleWeek: true,
                                appointmentTextStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                placeholderTextStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                weekHeaderSettings: WeekHeaderSettings(
                                  weekTextStyle: GoogleFonts.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                dayHeaderSettings: DayHeaderSettings(
                                  dayFormat: 'EEE',
                                  dayTextStyle: GoogleFonts.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  dateTextStyle: GoogleFonts.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                monthHeaderSettings: MonthHeaderSettings(
                                  monthFormat: 'MMM yyyy',
                                  height: 50,
                                  monthTextStyle: GoogleFonts.ibmPlexSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              todayTextStyle: GoogleFonts.ibmPlexSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              appointmentTextStyle: GoogleFonts.ibmPlexSans(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              appointmentBuilder: // ignore: missing_return
                                  (BuildContext context,
                                      CalendarAppointmentDetails details) {
                                try {
                                  final EduEvent event =
                                      details.appointments.first;
                                  return GlassContainer(
                                    gradient: event.color != null &&
                                            event.color!.isNotEmpty
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              colors[event.color]!
                                                  .withOpacity(0.8),
                                              colors[event.color]!
                                                  .withOpacity(0.4),
                                            ],
                                          )
                                        : null,
                                    opacity: event.color != null &&
                                            event.color!.isNotEmpty
                                        ? 0.6
                                        : 0.1,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Center(
                                      child: Text(
                                        event.title,
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  final Appointment app =
                                      details.appointments.first;
                                  return GlassContainer(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        app.color.withOpacity(0.8),
                                        app.color.withOpacity(0.4),
                                      ],
                                    ),
                                    opacity: 0.6,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Center(
                                      child: Text(
                                        app.subject,
                                        style: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              timeSlotViewSettings: TimeSlotViewSettings(
                                dayFormat: 'E',
                                // numberOfDaysInView: 2,
                                timeIntervalHeight: 50,
                                startHour: 6,
                                timeRulerSize: 50,
                                timeTextStyle: GoogleFonts.ibmPlexSans(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              scheduleViewMonthHeaderBuilder: // ignore: missing_return
                                  (BuildContext buildContext,
                                      ScheduleViewMonthHeaderDetails details) {
                                return GlassContainer(
                                  height: 50,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${DateFormat('MMMM').format(DateTime(0, details.date.month))} ${details.date.year}',
                                      style: GoogleFonts.ibmPlexSans(
                                        color: Colors.white,
                                        fontSize: 26,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center();
                },
              ),
            ),
          ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerBottomRight,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: 80,
            emissionFrequency: 1,
            numberOfParticles: 50,
            colors: [
              Colors.green.withOpacity(0.8),
              Colors.pink.withOpacity(0.8),
              Colors.orange.withOpacity(0.8),
              Colors.purple.withOpacity(0.8),
              Colors.yellow.withOpacity(0.8),
            ],
          ),
        ),
      ],
    );
  }

  void addUsage(int i) {
    if (appUser!.dailyUsage == null) {
      appUser!.dailyUsage = [];
    }

    DateTime currentDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    bool todayAlreadyAdded = false;

    for (var usage in appUser!.dailyUsage!) {
      if (usage.date == currentDay) {
        usage.points += i;
        todayAlreadyAdded = true;
        break;
      }
    }

    if (!todayAlreadyAdded) {
      appUser!.dailyUsage!.add(DailyUsageItem(date: currentDay, points: i));
    }

    updateUser(appUser!);
  }

  bool sameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int streak() {
    // get streak since today
    int streak = 0;
    DateTime currentDay =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (appUser!.dailyUsage == null) {
      appUser!.dailyUsage = [];
    }

    // sort usage data
    appUser!.dailyUsage!.sort((a, b) => b.date.compareTo(a.date));

    for (var usage in appUser!.dailyUsage!) {
      if (sameDate(usage.date, currentDay)) {
        streak++;
        currentDay = currentDay.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  ColumnSeries getWeeklyProgress() {
    // use usage data to get weekly progress
    DateTime lastMonday =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    lastMonday = DateTime(lastMonday.year, lastMonday.month, lastMonday.day);

    DateTime lastTuesday = lastMonday.add(const Duration(days: 1));
    DateTime lastWednesday = lastMonday.add(const Duration(days: 2));
    DateTime lastThursday = lastMonday.add(const Duration(days: 3));
    DateTime lastFriday = lastMonday.add(const Duration(days: 4));
    DateTime lastSaturday = lastMonday.add(const Duration(days: 5));
    DateTime lastSunday = lastMonday.add(const Duration(days: 6));

    int monPoints = 0;
    int tuePoints = 0;
    int wedPoints = 0;
    int thuPoints = 0;
    int friPoints = 0;
    int satPoints = 0;
    int sunPoints = 0;

    if (appUser!.dailyUsage != null) {
      for (var usage in appUser!.dailyUsage!) {
        if (sameDate(usage.date, lastMonday)) {
          monPoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastTuesday)) {
          tuePoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastWednesday)) {
          wedPoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastThursday)) {
          thuPoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastFriday)) {
          friPoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastSaturday)) {
          satPoints += usage.points.toInt();
        } else if (sameDate(usage.date, lastSunday)) {
          sunPoints += usage.points.toInt();
        }
      }
    }

    return ColumnSeries<WeekData, String>(
      color: Colors.white,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.white.withOpacity(0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      dataSource: <WeekData>[
        WeekData('Mon', monPoints),
        WeekData('Tue', tuePoints),
        WeekData('Wed', wedPoints),
        WeekData('Thu', thuPoints),
        WeekData('Fri', friPoints),
        WeekData('Sat', satPoints),
        WeekData('Sun', sunPoints),
      ],
      xValueMapper: (WeekData week, _) => week.day,
      yValueMapper: (WeekData week, _) => week.hours,
      dataLabelSettings: const DataLabelSettings(isVisible: false),
    );
  }
}

class WeekData {
  WeekData(this.day, this.hours);
  final String day;
  final int hours;
}

Widget scrollWidget(String title, String description, Widget buttonLabel,
    void Function() onPressed) {
  return GlassContainer(
    width: MediaQuery.of(Get.context!).size.width * 0.5,
    opacity: 0.1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.ibmPlexSans(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GlassContainer(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                ),
                onPressed: onPressed,
                child: buttonLabel,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
