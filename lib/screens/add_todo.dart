import 'package:edufocus/main.dart';
import 'package:edufocus/screens/study_sched.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:edufocus/utils/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

Todo? editingTodo;

class _AddTodoState extends State<AddTodo> {
  TextEditingController assignmentTitleController = TextEditingController();
  TextEditingController assignmentDescriptionController =
      TextEditingController();
  bool isRevealed2 = false;
  bool isRevealed3 = false;
  String courseId = '';
  DateTime dueDate = DateTime.now().add(const Duration(days: 1));
  int v = 1;

  void toggleReveal2() {
    setState(() {
      isRevealed2 = !isRevealed2;
      isRevealed3 = false;
    });
  }

  void toggleReveal3() {
    setState(() {
      isRevealed3 = !isRevealed3;
      isRevealed2 = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (editingTodo != null) {
      assignmentTitleController.text = editingTodo!.title;
      assignmentDescriptionController.text = editingTodo!.description;
      courseId = editingTodo!.courseId;
      dueDate = editingTodo!.dueDate;
      v = editingTodo!.type == 'exam' ? 0 : 1;
    }
  }

  @override
  void dispose() {
    assignmentTitleController.dispose();
    assignmentDescriptionController.dispose();
    super.dispose();
    editingTodo = null;
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
                    editingTodo == null ? 'Add Todo' : 'Edit Todo',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 0,
                    groupValue: v,
                    onChanged: (value) {
                      setState(() {
                        v = value!;
                      });
                    },
                    title: Text('Exam',
                        style: GoogleFonts.ibmPlexSans(color: Colors.white)),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    activeColor: Colors.white,
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: 1,
                    groupValue: v,
                    onChanged: (value) {
                      setState(() {
                        v = value!;
                      });
                    },
                    title: Text('Assignment',
                        style: GoogleFonts.ibmPlexSans(color: Colors.white)),
                    visualDensity:
                        const VisualDensity(vertical: -4, horizontal: -4),
                    activeColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    borderRadius: BorderRadius.circular(16),
                    width: double.infinity,
                    child: TextField(
                      controller: assignmentTitleController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 40,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Title',
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
                    child: TextField(
                      controller: assignmentDescriptionController,
                      cursorColor: Colors.white,
                      style: GoogleFonts.ibmPlexSans(
                        color: Colors.white,
                      ),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 200,
                      maxLines: 5,
                      decoration: InputDecoration(
                        isDense: false,
                        hintText: 'Description',
                        hintStyle: GoogleFonts.ibmPlexSans(
                          color: Colors.white,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    courseId != ''
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.xmark,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                if (courseId != '')
                                  Expanded(
                                    child: Text(
                                      appUser!.courses!
                                          .firstWhere((element) =>
                                              element.id == courseId)
                                          .name,
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if (courseId == '')
                                  Text(
                                    'No course selected',
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
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children: [
                                const SizedBox(height: 8),
                                for (Course course in appUser!.courses ?? [])
                                  RadioListTile(
                                    dense: true,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    value: course.id,
                                    groupValue: courseId,
                                    onChanged: (value) {
                                      setState(() {
                                        courseId = value.toString();
                                      });
                                    },
                                    title: Text(
                                      course.name,
                                      style: GoogleFonts.ibmPlexSans(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
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
                            onTap: toggleReveal3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    FontAwesomeIcons.calendarDay,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Due ${DateFormat.MMMMEEEEd().format(dueDate)}',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              height: 70,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 365,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: GlassContainer(
                                      borderRadius: BorderRadius.circular(16),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            dueDate = DateTime.now()
                                                .add(Duration(days: index));
                                          });
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateFormat('E')
                                                  .format(DateTime.now().add(
                                                      Duration(days: index)))
                                                  .toUpperCase(),
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 12,
                                                color: dueDate.day ==
                                                        DateTime.now()
                                                            .add(Duration(
                                                                days: index))
                                                            .day
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                                fontWeight: dueDate.day ==
                                                        DateTime.now()
                                                            .add(Duration(
                                                                days: index))
                                                            .day
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              DateFormat.yMMMMd().format(
                                                  DateTime.now().add(
                                                      Duration(days: index))),
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 14,
                                                color: dueDate.day ==
                                                        DateTime.now()
                                                            .add(Duration(
                                                                days: index))
                                                            .day
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                                fontWeight: dueDate.day ==
                                                        DateTime.now()
                                                            .add(Duration(
                                                                days: index))
                                                            .day
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ],
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
                          if (assignmentTitleController.text.isEmpty) return;
                          if (courseId.isEmpty) return;

                          Todo todo = Todo(
                            userId: appUser!.uid,
                            id: editingTodo == null
                                ? const Uuid().v4()
                                : editingTodo!.id,
                            type: v == 0 ? 'exam' : 'assignment',
                            status: 'pending',
                            title: assignmentTitleController.text,
                            description: assignmentDescriptionController.text,
                            dueDate: DateTime(
                              dueDate.year,
                              dueDate.month,
                              dueDate.day - 1,
                              23,
                              59,
                            ),
                            createdAt: DateTime.now(),
                            reminder: DateTime.now(),
                            courseId: courseId,
                            attachments: [],
                            studyPlan: editingTodo != null
                                ? editingTodo!.studyPlan ?? []
                                : [],
                          );

                          if (editingTodo != null) {
                            updateTodo(todo);
                          } else {
                            addTodo(todo);
                          }

                          if (todo.type == 'exam') {
                            Get.off(() => const StudySchedulePage());
                            curTodo = todo;
                          } else {
                            Get.back();
                          }
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
