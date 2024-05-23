import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gym_app/docs/pdf_screen.dart';

class Docs {
  String filename;
  String resource_type;
  String secure_url;

  Docs({
    required this.filename,
    required this.resource_type,
    required this.secure_url,
  });

  factory Docs.fromJson(Map<String, dynamic> json) {
    return Docs(
      filename: json['filename'],
      resource_type: json['resource_type'],
      secure_url: json['secure_url'],
    );
  }
}

class MyDocs extends StatefulWidget {
  final List<Docs> docs;

  const MyDocs({
    required this.docs,
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyDocs> {
  String pathPDF = "";
  String remotePDFpath = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/docs/ok.pdf', 'ok.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        throw Exception('Storage permission not granted');
      }
    }
  }

  Future<File> createFileOfPdfUrl(String url) async {
    await requestStoragePermission();
    Completer<File> completer = Completer();
    print("Start download file from internet!");

    try {
      // Extract the filename from the URL
      final filename = url.substring(url.lastIndexOf("/") + 1);

      // Perform the file download
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();

      // Log response status code
      print('Response status code: ${response.statusCode}');

      // Handle different status codes
      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      var bytes = await consolidateHttpClientResponseBytes(response);

      // Check if bytes are not empty
      if (bytes.isEmpty) {
        throw Exception('Downloaded file is empty');
      }

      // Get the external storage directory
      Directory? directory;
      try {
        directory = await getExternalStorageDirectory();
        if (directory == null) {
          throw Exception('Unable to get external storage directory');
        }
      } catch (e) {
        print('Unable to get external storage directory: $e');
        rethrow;
      }

      final dirPath = directory.path;
      final filePath = '$dirPath/$filename';

      // Ensure the directory exists
      await Directory(dirPath).create(recursive: true);

      print('Download files');
      print(filePath);

      // Save the file
      File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        remotePDFpath = filePath;
      });
      completer.complete(file);
    } catch (e) {
      print(e);
      completer.completeError('Error parsing asset file!');
    } finally {
      HttpClient().close(force: true);
    }

    return completer.future;
  }



  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and then access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      print("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF View',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(widget.docs[index].filename),
                        onTap: () {
                          createFileOfPdfUrl(widget.docs[index].secure_url)
                              .then((f) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFScreen(path: remotePDFpath),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  child: Text("Open PDF"),
                  onPressed: () {
                    if (pathPDF.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: pathPDF),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  child: Text("Remote PDF"),
                  onPressed: () {
                    if (remotePDFpath.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: remotePDFpath),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
