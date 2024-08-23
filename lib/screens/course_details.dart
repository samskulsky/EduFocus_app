import 'package:edufocus/main.dart';
import 'package:edufocus/screens/home.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

DateTime? startDate;
DateTime? endDate;
bool editing = false;
Course? editingCourse;

class _AddCourseState extends State<AddCourse> {
  TextEditingController courseNameController = TextEditingController();
  String color = '';
  String icon = '';

  bool isRevealed = false;
  bool isRevealed2 = false;
  bool isRevealed3 = false;

  @override
  void initState() {
    super.initState();
    if (editing && editingCourse != null) {
      courseNameController.text = editingCourse!.name;
      startDate = editingCourse!.startDate;
      endDate = editingCourse!.endDate;
      color = editingCourse!.color;
      icon = editingCourse!.icon;
    }
  }

  @override
  void dispose() {
    courseNameController.dispose();
    super.dispose();
    editingCourse = null;
  }

  void toggleReveal() {
    setState(() {
      isRevealed = !isRevealed;
      isRevealed2 = false;
      isRevealed3 = false;
    });
  }

  void toggleReveal2() {
    setState(() {
      isRevealed2 = !isRevealed2;
      isRevealed = false;
      isRevealed3 = false;
    });
  }

  void toggleReveal3() {
    setState(() {
      isRevealed3 = !isRevealed3;
      isRevealed = false;
      isRevealed2 = false;
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
            color: color.isNotEmpty ? Colors.white : Colors.transparent,
            gradient: color.isNotEmpty
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors[color]!.withOpacity(0.4),
                      colors[color]!.withOpacity(0.7),
                      colors[color]!.withOpacity(0.9),
                      colors[color]!.withOpacity(0.7),
                    ],
                  )
                : null,
            opacity: color.isNotEmpty ? 0.4 : 0.1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (editing)
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(
                            FontAwesomeIcons.trash,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            deleteCourse(FirebaseAuth.instance.currentUser!.uid,
                                editingCourse!);
                            Get.back();
                          },
                        ),
                    ],
                  ),
                  Text(
                    'Details',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: TextField(
                      controller: courseNameController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 40,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Course Name',
                        hintStyle: GoogleFonts.ibmPlexSans(
                          color: Colors.white,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: toggleReveal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  startDate != null && endDate != null
                                      ? FontAwesomeIcons.calendarCheck
                                      : FontAwesomeIcons.calendarXmark,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                if (startDate != null && endDate != null)
                                  Text(
                                    '${DateFormat.yMMMMd().format(startDate!)} – ${DateFormat.yMMMMd().format(endDate!)}',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                if (startDate == null || endDate == null)
                                  Text(
                                    'No term selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                Icon(
                                  isRevealed
                                      ? FontAwesomeIcons.caretUp
                                      : FontAwesomeIcons.caretDown,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isRevealed,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Select the start and end date of this course.',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 8),
                                GlassContainer(
                                  borderRadius: BorderRadius.circular(16),
                                  width: double.infinity,
                                  height: 200,
                                  child: SfDateRangePicker(
                                    onSelectionChanged: (args) {
                                      final dynamic value = args.value;
                                      if (value is PickerDateRange) {
                                        startDate = value.startDate;
                                        endDate = value.endDate;
                                      }
                                      setState(() {});
                                    },
                                    view: DateRangePickerView.month,
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    navigationMode:
                                        DateRangePickerNavigationMode.snap,
                                    selectionShape:
                                        DateRangePickerSelectionShape.rectangle,
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                      viewHeaderStyle:
                                          DateRangePickerViewHeaderStyle(
                                        textStyle: GoogleFonts.ibmPlexSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    headerStyle: DateRangePickerHeaderStyle(
                                      backgroundColor: Colors.transparent,
                                      textStyle: GoogleFonts.ibmPlexSans(
                                        color: Colors.white,
                                      ),
                                    ),
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                      textStyle: GoogleFonts.ibmPlexSans(
                                        color: Colors.white,
                                      ),
                                    ),
                                    yearCellStyle: DateRangePickerYearCellStyle(
                                      textStyle: GoogleFonts.ibmPlexSans(
                                        color: Colors.white,
                                      ),
                                    ),
                                    rangeTextStyle: GoogleFonts.ibmPlexSans(
                                      color: Colors.white,
                                    ),
                                    rangeSelectionColor:
                                        Colors.white.withOpacity(0.2),
                                    startRangeSelectionColor:
                                        Colors.white.withOpacity(0.5),
                                    endRangeSelectionColor:
                                        Colors.white.withOpacity(0.5),
                                    todayHighlightColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: toggleReveal2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.palette,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                if (color.isNotEmpty)
                                  Text(
                                    'Color: ${color.capitalizeFirst}',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                if (color == '')
                                  Text(
                                    'No color selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                Icon(
                                  isRevealed2
                                      ? FontAwesomeIcons.caretUp
                                      : FontAwesomeIcons.caretDown,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isRevealed2,
                            child: SizedBox(
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: colors.length,
                                itemBuilder: (context, index) {
                                  final key = colors.keys.elementAt(index);
                                  final value = colors[key];
                                  return GestureDetector(
                                    onTap: () {
                                      color = key;
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: color == key
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        color: value,
                                      ),
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          key,
                                          style: GoogleFonts.ibmPlexSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              const Shadow(
                                                color: Colors.black,
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: toggleReveal3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  icon.isEmpty
                                      ? FontAwesomeIcons.icons
                                      : icons[icon],
                                  color: Colors.white,
                                  size: 18,
                                ),
                                if (icon.isNotEmpty)
                                  Text(
                                    'Icon Selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                if (icon == '')
                                  Text(
                                    'No icon selected',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                Icon(
                                  isRevealed3
                                      ? FontAwesomeIcons.caretUp
                                      : FontAwesomeIcons.caretDown,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isRevealed3,
                            child: SizedBox(
                              height: 200,
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: icons.length,
                                itemBuilder: (context, index) {
                                  final key = icons.keys.elementAt(index);
                                  final value = icons[key];
                                  return GestureDetector(
                                    onTap: () {
                                      icon = key;
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: icon == key
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      height: 40,
                                      child: Center(
                                        child: FaIcon(
                                          value,
                                          color: icon == key
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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
                        onPressed: () async {
                          if (courseNameController.text.isEmpty) {
                            return;
                          }
                          if (startDate == null || endDate == null) {
                            return;
                          }
                          if (color.isEmpty) {
                            return;
                          }
                          if (icon.isEmpty) {
                            return;
                          }

                          Course course = Course(
                            id: editingCourse != null
                                ? editingCourse!.id
                                : const Uuid().v4(),
                            name: courseNameController.text,
                            color: color,
                            icon: icon,
                            startDate: startDate!,
                            endDate: endDate!,
                            attributes: [],
                          );
                          if (editing) {
                            updateCourse(appUser!, course);
                          } else {
                            addCourse(
                                FirebaseAuth.instance.currentUser!.uid, course);
                          }
                          Get.back();
                        },
                        child: Text('Save',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 15,
                              color: Colors.white,
                            )),
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

final colors = {
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow[700],
  'purple': Colors.purple,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'cyan': Colors.cyan,
};

final icons = {
  'music': FontAwesomeIcons.music,
  'theater': FontAwesomeIcons.masksTheater,
  'microscope': FontAwesomeIcons.microscope,
  'book': FontAwesomeIcons.book,
  'graduation': FontAwesomeIcons.graduationCap,
  'code': FontAwesomeIcons.laptopCode,
  'calculator': FontAwesomeIcons.calculator,
  'squareroot': FontAwesomeIcons.squareRootVariable,
  'flask': FontAwesomeIcons.flask,
  'dna': FontAwesomeIcons.dna,
  'atom': FontAwesomeIcons.atom,
  'landmark': FontAwesomeIcons.landmark,
  'globe': FontAwesomeIcons.globe,
  'bookmarks': FontAwesomeIcons.bookmark,
  'earth-americas': FontAwesomeIcons.earthAmericas,
  'earth-europe': FontAwesomeIcons.earthEurope,
  'earth-asia': FontAwesomeIcons.earthAsia,
  'earth-africa': FontAwesomeIcons.earthAfrica,
  'earth-australia': FontAwesomeIcons.earthOceania,
  'hands-asl': FontAwesomeIcons.handsAslInterpreting,
  'football': FontAwesomeIcons.football,
};
