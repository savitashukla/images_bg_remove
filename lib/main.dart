import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remove_bg/remove_bg.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double linearProgress = 0.0;
  File? file;
  File? fileBg;
  String? fileName;

  Future pickImage() async {
    var status = await Permission.storage.status;

    if (await Permission.storage.request().isGranted) {
      // Permission granted, perform file picking
    } else {
      // Permission denied, show a message or request permission again
    }

/*    try {*/
    final ImagePicker _picker = ImagePicker();

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    /* } catch (e) {
      print('Error picking image: $e');
    }*/

    /*try {


        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

        if (result == null) return;
        // final Uint8List imageTemp = result.files.first.bytes!;
        setState(() {
          fileName = result.files.first.name;
          file = File(result.files.single.path!);
        });
      } on PlatformException catch (e) {
        debugPrint(e.toString());
      }*/
  }

  Future pickImageBg() async {
    final ImagePicker _picker = ImagePicker();

    final pickedFile11 = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile11 != null) {
        fileBg = File(pickedFile11.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Uint8List? bytes;

  /// please use File Picker or Image Picker
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remove.bg"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (bytes != null)
                  Stack(
                    children: [
                      Image.file(
                        fileBg!,
                        height: 200,
                        width: double.infinity,
                      ),
                      Center(
                          child: Image.memory(
                        bytes!,
                        height: 100,
                      ))
                    ],
                  ),
                if (file != null)
                  SizedBox(
                    height: 240,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Card(
                                    child: Image.file(
                                      file!,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                              Text("FileName: $fileName"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: linearProgress),
                const SizedBox(height: 10),
                const Text(
                  'Remove.bg Upload Progress',
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text("Select Image"),
                ),

                ElevatedButton(
                  onPressed: () {
                    pickImageBg();
                  },
                  child: const Text("Select bg Image"),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Remove().bg(
            file!,
            privateKey: "TCyesCituQwvcYEVTNvaJdyM", // (Keep Confidential)
            onUploadProgressCallback: (progressValue) {
              setState(() {
                linearProgress = progressValue;
              });
            },
          ).then((data) async {
            // bytes = await File("filename.png").writeAsString(data);
            // Directory appDocumentsDirectory =
            //     await getApplicationDocumentsDirectory(); // 1
            // String appDocumentsPath = appDocumentsDirectory.path; // 2
            // String filePath = '$appDocumentsPath/demoTextFile.png'; // 3
            // File file = File(filePath); // 1
            // file.writeAsString(data); // 2
            // String fileContent = await file.readAsString(); // 2

            // print('File Content: $fileContent');
            bytes = data;
            setState(() {});
          });
        },
        tooltip: 'Submit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
