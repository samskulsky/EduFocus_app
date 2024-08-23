import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:edufocus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latext/latext.dart';

class MathSolver extends StatefulWidget {
  const MathSolver({super.key});

  @override
  State<MathSolver> createState() => _MathSolverState();
}

class _MathSolverState extends State<MathSolver> {
  XFile? image;
  final gemini = Gemini.instance;
  String text = '';
  bool loading = false;

  Future<void> getImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ImageCropper cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          IOSUiSettings(
            title: 'Crop Image',
          )
        ],
      );
      setState(() {
        this.image = croppedImage != null ? XFile(croppedImage.path) : null;
      });
      sendImage(XFile(croppedImage!.path));
    }
  }

  String ex =
      '{"input": "\$\\int {\frac{\\ln^2 x}{x}}dx\$","steps": {"1": "Use integration by parts with \$u=\\ln^2 x, \\quad dv = \frac{1}{x}dx\$"...},"answer": "\$\frac{1}{3}\\ln^3 x (3\\ln x-2)+C\$"}';

  Future<void> sendImage(XFile? imageFile) async {
    if (image == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    Uint8List base64Image = File(imageFile!.path).readAsBytesSync();
    gemini.textAndImage(
      text:
          "Solve the math problem shown. Surround ALL LaTeX with one dollar sign (\$) on each side. (all variables/numbers/expressions/etc should be latex inline with a dollar sign on each side) Respond in JSON format EXACTLY like example. No ``` json indicators. If there are multiple Qs, only choose the first or most prominent. Everything you do should be at least 1 step (at least 3 steps overall). Use textual explanations alongside numbers. NO Unrecognized string escape Example: ${jsonEncode(ex)}",
      images: [base64Image],
    ).then((value) {
      log(value?.content?.parts?.last.text ?? '');
      setState(() {
        loading = false;
        text = value?.content?.parts?.last.text ?? '';
      });
    }).catchError((e) => log('textAndImageInput', error: e));
  }

  @override
  Widget build(BuildContext context) {
    // if text is not empty, turn it from json to a map
    Map<String, dynamic> json = text.isNotEmpty
        ? jsonDecode(text
            .replaceAll('```', '')
            .replaceAll('json', '')
            .replaceAll('\$\$', '\$'))
        : {};

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
                  FontAwesomeIcons.hashtag,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Math Solver',
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
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 8,
              ),
            ],
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
            child: IconButton(
              onPressed: () {
                getImageFromCamera();
              },
              icon: const Icon(FontAwesomeIcons.camera, color: Colors.white),
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 128, 16, 8),
          children: [
            if (image == null)
              GlassContainer(
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.fileCircleExclamation,
                    color: Colors.white,
                  ),
                  title: Text(
                    'No image has been uploaded yet',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (image == null) const SizedBox(height: 16),

            // If image is not null, show the image
            if (image != null)
              GlassContainer(
                height: 100,
                borderRadius: BorderRadius.circular(16),
                blur: 8,
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.fitHeight,
                ),
              ),

            if (loading)
              const Padding(
                padding: EdgeInsets.all(64),
                child: Center(
                  child: SpinKitPulse(
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),

            if (json.length > 1)
              ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                itemCount: (json.length + json['steps'].length - 1).toInt(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Input:',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Builder(
                          builder: (context) => LaTexT(
                            laTeXCode: Text(
                              json['input'],
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  // null check for json['steps']
                  if (index == json.length + json['steps'].length - 2) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Answer:',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GlassContainer(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Builder(
                              builder: (context) => LaTexT(
                                laTeXCode: Text(
                                  json['answer'],
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                equationStyle: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GlassContainer(
                        // circular
                        borderRadius: BorderRadius.circular(22),
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            (index).toString(),
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Builder(
                          builder: (context) => LaTexT(
                            equationStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            laTeXCode: Text(
                              json['steps'][index.toString()],
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
