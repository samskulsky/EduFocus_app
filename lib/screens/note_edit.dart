import 'dart:convert';

import 'package:edufocus/main.dart';
import 'package:edufocus/utils/note.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesEditor extends StatefulWidget {
  const NotesEditor({super.key});

  @override
  State<NotesEditor> createState() => _NotesEditorState();
}

String noteId = '';
Note? cNote;

class _NotesEditorState extends State<NotesEditor> {
  final FocusNode _focusNode = FocusNode();
  FleatherController? _controller;
  DateTime lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) BrowserContextMenu.disableContextMenu();
    _initController();
  }

  @override
  void dispose() {
    super.dispose();
    if (kIsWeb) BrowserContextMenu.enableContextMenu();
  }

  Future<void> _initController() async {
    if (noteId == '') {
      startFromScratch();
      return;
    }
    try {
      Note note = await getNoteById(noteId);
      if (note.content.isEmpty) {
        startFromScratch();
        return;
      }
      final doc = ParchmentDocument.fromJson(jsonDecode(note.content));
      _controller = FleatherController(document: doc);
    } catch (err, st) {
      print('Cannot read json: $err\n$st');
      _controller = FleatherController();
    }
    setState(() {});
  }

  Future<void> startFromScratch() async {
    final doc = ParchmentDocument();
    _controller = FleatherController(document: doc);
    setState(() {});
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _focusNode.requestFocus();
      }
    }
  }

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
                  'Edit Note',
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
            // save
            cNote!.updatedAt = DateTime.now();
            cNote!.content = jsonEncode(_controller!.document);
            updateNote(cNote!);
            Get.back();
          },
        ),
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
        padding: const EdgeInsets.only(top: 124),
        child: Container(
          color: Colors.white,
          child: _controller == null
              ? const Center(
                  child: SpinKitPulse(
                    color: Colors.white,
                    size: 50,
                  ),
                )
              : Column(
                  children: [
                    FleatherToolbar.basic(controller: _controller!),
                    Divider(
                        height: 1, thickness: 1, color: Colors.grey.shade200),
                    Expanded(
                      child: FleatherEditor(
                        controller: _controller!,
                        focusNode: _focusNode,
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).padding.bottom,
                          top: 8,
                        ),
                        maxContentWidth: 800,
                        spellCheckConfiguration: SpellCheckConfiguration(
                            spellCheckService: DefaultSpellCheckService(),
                            misspelledSelectionColor: Colors.red,
                            misspelledTextStyle:
                                DefaultTextStyle.of(context).style),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
