import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edufocus/main.dart';
import 'package:edufocus/utils/app_user.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../utils/note.dart';
import 'note_edit.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
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
                  FontAwesomeIcons.noteSticky,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notes',
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
                Note note = Note(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  sharedWith: [],
                  title: '',
                  content: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  id: const Uuid().v4(),
                );
                addNote(note);
                noteId = note.id;
                cNote = note;
                Get.to(() => const NotesEditor());
              },
              child: Text(
                'New',
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
        child: StreamBuilder<List<Note>>(
            stream: getNotes(FirebaseAuth.instance.currentUser!.uid),
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
              // sort notes by updated time
              snapshot.data!.sort((a, b) {
                return b.updatedAt.compareTo(a.updatedAt);
              });
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 128, 16, 8),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  Note note = snapshot.data![index];
                  return GlassContainer(
                    child: ListTile(
                      onTap: () {
                        noteId = note.id;
                        cNote = note;
                        Get.to(() => const NotesEditor());
                      },
                      title: Text(
                        note.content.isNotEmpty
                            ? jsonDecode(note.content)[0]['insert']
                                .replaceAll(RegExp(r'<[^>]*>'), '')
                                .trim()
                            : 'Untitled Note',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${DateFormat.MMMEd().format(note.updatedAt)} ${DateFormat.jm().format(note.updatedAt)}',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('notes')
                              .doc(note.id)
                              .delete();
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
