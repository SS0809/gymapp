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
import 'dart:math';

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
    required this.imageProvider,
    List<Docs>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Docs> items;
/*
  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }*/
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
  Future<void> fetchCustomers() async {
    String token = await storage.read(key: "jwt") ?? "";
    var res = await http.get(
      Uri.parse('$SERVER_IP/getusers_user'),
      headers: {
        'Authorization': json.decode(token)["token"],
        'Content-Type': 'application/json',
      },
    );
    print('Response status code: ${res.statusCode}${json.decode(token)["token"]}'); // Add this line
    print('Response reason phrase: ${res.reasonPhrase}'); // Add this line

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      print(data);
      _customers = List<Customer>.from(data.map<Customer>((item) {
        return Customer(
          name: item['username'],
          imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
        );
      }));
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
  late Future<List<Docs>> _fetchDocsFuture; // Declare the future variable
  void _itemDroppedOnCustomerCart({required Docs item, required Customer customer}) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchDocsFuture = fetchAllData(); // Initialize the future
    fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0D0D),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 5, child: _buildMenuList()),
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
                feedback: Image.network(docs[index].secure_url),
                child: ListTile(
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
        : SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          return _buildPersonWithDropZone(_customers[index]);
        },
      ),
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
          _itemDroppedOnCustomerCart(item: details.data, customer: customer);
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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 38,
                  height: 38,
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
                      fontWeight:
                          hasItems ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              if (hasItems) ...[
                Text(
                  customer.name,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: textColor,
                        fontSize: 12,
                      ),
                ),
              ],
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
