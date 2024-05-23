import 'package:flutter/material.dart';
import '../main.dart';
void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const List<Item> _items = [
  Item(
    name: 'Spinach Pizza',
    totalPriceCents: 1299,
    uid: '1',
    imageProvider: NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food1.jpg'),
  ),
  Item(
    name: 'Veggie Delight',
    totalPriceCents: 799,
    uid: '2',
    imageProvider: NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food2.jpg'),
  ),
  Item(
    name: 'Chicken Parmesan',
    totalPriceCents: 1499,
    uid: '3',
    imageProvider: NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food3.jpg'),
  ),
];

class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  _ExampleDragAndDropState createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop> with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),   Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),

  ];

  void _itemDroppedOnCustomerCart({required Item item, required Customer customer}) {
    setState(() {
      customer.items.add(item);
    });
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
        'Order Food',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 36,
          color: const Color(0xFF5C28A9),
          fontWeight: FontWeight.w900,
        ),
      ),
      backgroundColor: const Color(0xFF0E0D0D),
      elevation: 0,
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildMenuItem(_items[index]),
    );
  }

  Widget _buildMenuItem(Item item) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(photoProvider: item.imageProvider),
      child: MenuListItem(item: item),
    );
  }

  Widget _buildCustomerList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _people.length,
        itemBuilder: (context, index) => _buildPersonWithDropZone(_people[index]),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: DragTarget<Item>(
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
                  fontWeight: hasItems ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              if (hasItems) ...[
                Text(
                  customer.formattedTotalItemPrice,
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18 ,color: const Color(
                        0xFFAFAFAF)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.formattedTotalItemPrice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                        color: const Color(
                            0xFFAFAFAF)
                    ),
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

@immutable
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

  String get formattedTotalItemPrice => '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents = items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
