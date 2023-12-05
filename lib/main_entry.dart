import 'dart:convert';
import 'dart:io';
import 'package:board/hasher/file_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:board/models/question_models.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as pt;
import 'dart:html' as html;
import 'package:collection/collection.dart';

class MainEntry extends StatefulWidget {
  const MainEntry({super.key});

  @override
  State<MainEntry> createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry>
    with SingleTickerProviderStateMixin {
  List<PlatformFile> pickedFiles = [];
  List<PlatformFile> encrptedFiles = [];
  List<String> headers = [
    'Raw Dataset',
    "Encrpted Datasets",
  ];

  int currentScreen = 0;

  String jsonPreview = '';
  late TabController controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                controller: controller,
                indicatorWeight: 1,
                onTap: (index) {
                  setState(() {
                    currentScreen = index;
                  });
                },
                padding: const EdgeInsets.all(16),
                splashBorderRadius: BorderRadius.circular(7),
                labelColor: Theme.of(context).colorScheme.surface,
                unselectedLabelColor: Colors.green,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: kElevationToShadow[1],
                ),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                tabs: headers.mapIndexed((index, title) {
                  return Container(
                      alignment: Alignment.center,
                      // width: 25.w,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    // color: currentSubjectIndex == index ? Colors.white : null,
                                  ),
                        ),
                      ));
                }).toList(),
              ),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text("Encrpting  Question With Id $jsonPreview"),
                          Expanded(
                            child: ListView(
                              children: pickedFiles
                                  .map((file) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.blueAccent,
                                          title: Text(file.name),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text("Encrypted Question With Id $jsonPreview"),
                          Expanded(
                            child: ListView(
                              children: encrptedFiles
                                  .map((file) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.blueAccent,
                                          title: Text(file.name),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: currentScreen == 0
              ? (pickedFiles.isEmpty ? _pickFiles : _encrptDataset)
              : _decrptDataset,
          label: currentScreen == 0
              ? Text(
                  pickedFiles.isEmpty ? 'Load Datasets' : 'Encrpt',
                )
              : Text('Decrypt Test'),
        ),
      ),
    );
  }

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        pickedFiles = result.files;
      });
    } else {
      print('User Canceled');
      // User canceled the picker
    }
  }

  _encrptDataset() {
    print("pressed");
    String content;
    try {
      pickedFiles.forEach((file) async {
        if (kIsWeb) {
          content = utf8.decode(file.bytes as List<int>);
        } else {
          content = await File(file.path!).readAsString();
        }

        List<QuestionModel> questions =
            List<QuestionModel>.from((jsonDecode(content)).map(
          (json) => QuestionModel.fromJson(json),
        ));
        // setState(() {
        //   questions.forEach((question) {
        //     jsonPreview = question.uniqueId;
        //   });
        // });
        _saveDatasetFile(file: file, questions: questions);
      });
    } catch (e, stack) {
      print("Error [$e] Stack Trace [$stack]");
    }
  }

  void _saveDatasetFile(
      {required PlatformFile file,
      required List<QuestionModel> questions}) async {
    try {
      List<Map<String, dynamic>> dataset = List<Map<String, dynamic>>.from(
          questions.map((question) => question.toMap()));
      String jsonString = jsonEncode(dataset);
      final blob = html.Blob([jsonString]);

      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', file.name)
        ..click();

      html.Url.revokeObjectUrl(url);
      setState(() {
        encrptedFiles.add(file);
        // pickedFiles.remove(file);
      });
    } catch (e, stack) {
      print("Error [$e] Stack Trace [$stack]");
    }
  }

  _decrptDataset() {}
}
