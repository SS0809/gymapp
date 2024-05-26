import 'package:flutter/material.dart';
import '../plans/PlanSelection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../plans/plans_edit.dart';
import '../main.dart';
import '../Login.dart';
import '../payments/payment.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../docs/docs.dart';
import '../docs/pdf_screen.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gym_app/docs/pdf_screen.dart';


class Dataitem {
  String filename;
  String resource_type;

  Dataitem({
    required this.filename,
    required this.resource_type,
  });

  factory Dataitem.fromJson(Map<String,dynamic> json) {
    return Dataitem(
      filename: json['filename'],
      resource_type: json['resource_type'],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<List<Docs>> fetchAllData() async {
  String token = await storage.read(key: "jwt") ?? "";
  var res = await http.get(
    Uri.parse('$SERVER_IP/getalldata'),
    headers: {
      'Authorization': json.decode(token)["token"],
      'Content-Type': 'application/json',
    },
  );

  if (res.statusCode == 200) {
    List<dynamic> body = json.decode(res.body);
    List<Docs> docs =
    body.map((dynamic item) => Docs.fromJson(item)).toList();
    print(docs);
    return docs;
  } else {
    throw Exception('Failed to load data');
  }
}

class Customer {
  Customer({
    required this.name,
    required this.dataitems,
    required this.imageProvider,
    List<Docs>? items,
  }) : items = items ?? [];

  final String name;
  final List<Dataitem> dataitems;
  final ImageProvider imageProvider;
  final List<Docs> items;
}

class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
  });

  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;

  String get formattedTotalItemPrice =>
      '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  _ExampleDragAndDropState createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  late List<Customer> _customers = [];
  bool _isLoading = true;
  String remotePDFpath = "";
  late Future<List<Docs>> _fetchDocsFuture; // Declare the future variable

Future<void> fetchCustomers() async {
  String token = await storage.read(key: "jwt") ?? "";
  var res = await http.get(
    Uri.parse('$SERVER_IP/getusers_user'),
    headers: {
      'Authorization': json.decode(token)["token"],
      'Content-Type': 'application/json',
    },
  );

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    _customers = List<Customer>.from(data.map<Customer>((item) {
      print(item['dataitems'][0]); // [{"filename":"myname","resource_type":"image"}]//string
      List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(json.decode(item['dataitems'][0]));
      List<Dataitem> dataitems = dataList.map((dataitem) => Dataitem.fromJson(dataitem)).toList();
      // Print each Dataitem instance in the dataitems list
      for (var dataitem in dataitems) {
        print('Filename: ${dataitem.filename}, Resource Type: ${dataitem.resource_type}');
      }
      return Customer(
        name: item['username'],
        dataitems: dataitems, // Assign parsed data directly
        imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
      );
    }));
    print(_customers[0].dataitems.map((dataitem) => 'Filename: ${dataitem.filename}, Resource Type: ${dataitem.resource_type}').toList());
    setState(() {
      _isLoading = false;
    });
  } else {
    setState(() {
      _isLoading = true;
    });
    print('Failed to fetch customers');
  }
}

  void _itemDroppedOnCustomerCart({required Docs item, required Customer customer}) {
    setState(() {
      if (!_doesCustomerHaveItem(customer, item)) {
        customer.items.add(item);
      }
    });
  }

  bool _doesCustomerHaveItem(Customer customer, Docs item) {
    return customer.items.any((existingItem) => existingItem.filename == item.filename);
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

  @override
  void initState() {
    super.initState();
    _fetchDocsFuture = fetchAllData(); // Initialize the future
    fetchCustomers();
  }
  Future<void> postItemsListToServer(List<Map<String, dynamic>> customerItemsList) async {
    print(customerItemsList); // Print the data to verify it's correct before sending
    try {
      String token = await storage.read(key: "jwt") ?? "";
      var res = await http.post(
        Uri.parse('$SERVER_IP/draggeddata'),
        headers: {
          'Authorization': json.decode(token)["token"],
        },
        body: {
        'data':  jsonEncode
            (customerItemsList),
        }
      );
/*
[{customerName: tanu, items: [{filename: myname, resource_type: image}]}, {customerName: anshika, items: [{filename: myname, resource_type: image}]}, {customerName: nishant, items: []}, {customerName: tanu, items: []}, {customerName: tanu, items: []}, {customerName: anshika, items: []}, {customerName: nishant, items: []}]

 */
      if (res.statusCode == 200) {
        print('Items list posted successfully');
      } else {
        print('Failed to post items list');
      }
    } catch (e) {
      print('Error posting items list: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0D0D),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 4, child: _buildMenuList()),
            _buildCustomerList(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        },
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0B585B)),
      title: Text(
        'Content Distributor',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          color: const Color(0xFF5C28A9),
          fontWeight: FontWeight.w900,
        ),
      ),
      backgroundColor: const Color(0xFF0E0D0D),
      elevation: 0,
    );
  }

  Widget _buildMenuList() {
    return FutureBuilder<List<Docs>>(
      future: _fetchDocsFuture, // Use the initialized future here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          List<Docs> docs = snapshot.data!;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return LongPressDraggable<Docs>(
                data: docs[index],
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: Text(docs[index].filename),// Image.network(docs[index].secure_url),
                child: ListTile(
                  onTap: () {
                    createFileOfPdfUrl(docs[index].secure_url)
                        .then((f) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(path: remotePDFpath),
                        ),
                      );
                    });
                  },
                  title: Text(docs[index].filename),
                  subtitle: Text(docs[index].resource_type),
                  trailing: Image.network(docs[index].secure_url),
                ),
              );
            },
          );
        }
      },
    );
  }


  Widget _buildCustomerList() {
    return _isLoading
        ? SizedBox(
      height: 100,
      child: Center(child: CircularProgressIndicator()),
    )
        : Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: _customers.length,
            itemBuilder: (context, index) {
              return _buildPersonWithDropZone(_customers[index]);
            },
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            onPressed: () {
              List<Map<String, dynamic>> customerItemsList = _customers.map((customer) {
                return {
                  'user': customer.name,
                  'items': customer.items.map((item) {
                    return {
                      'filename': item.filename,
                      'resource_type': item.resource_type,
                    };
                  }).toList(),
                };
              }).toList();

              postItemsListToServer(customerItemsList);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
            child: Icon(Icons.cloud_upload_sharp),
          ),
        ),
      ],
    );
  }


  Widget _buildPersonWithDropZone(Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: DragTarget<Docs>(
        builder: (context, candidateItems, rejectedItems) {
          return CustomerCart(
            customer: customer,
            highlighted: candidateItems.isNotEmpty,
            hasItems: customer.items.isNotEmpty,
          );
        },
        onAcceptWithDetails: (details) {
          // Check if the dropped item already exists in both dataitems and items lists
          bool alreadyExistsInDataItems = customer.dataitems.any((dataitem) => dataitem.filename == details.data.filename);
          bool alreadyExistsInItems = customer.items.any((item) => item.filename == details.data.filename);

          // If the item doesn't already exist in both lists, add it to the items list
          if (!alreadyExistsInDataItems && !alreadyExistsInItems) {
            _itemDroppedOnCustomerCart(item: details.data, customer: customer);
          }
        },
      ),
    );
  }

}

class CustomerCart extends StatelessWidget {
  const CustomerCart({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 28 : 4,
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF121618),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Image(
                    image: customer.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: hasItems ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              if (hasItems)
                ...customer.items
                    .map((item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.filename,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ...customer.dataitems
                  .map((dataitem) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  dataitem.filename,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${customer.items.length + customer.dataitems.length} item${customer.items.length+customer.dataitems.length != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      color: const Color(0xFF171D1F),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Image(
                  image: item.imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18, color: const Color(0xFFAFAFAF)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.formattedTotalItemPrice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFFAFAFAF)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.photoProvider,
  });

  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
