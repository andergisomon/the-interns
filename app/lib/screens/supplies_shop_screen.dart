import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartItem {
  final String name;
  final String image;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;
}

class Cart {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => _items;

  static void addItem(CartItem item) {
    // if same product exists, bump quantity
    final existing = _items.where((i) => i.name == item.name).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  static double get total {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  static void clear() => _items.clear();
}

class SuppliesShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [ // Bad code: app will crash if it can't find the image, easy fix but I my patience is running out
      {'name': 'Rusap Noingkat', 'price': 'RM15.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription1 , 'img': 'assets/images/supplies_shop/rusap_noingkat.jpeg'},
      {'name': 'RAGANG Baby Bath', 'price': 'RM10.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription2, 'img': 'assets/images/supplies_shop/ragang.jpeg'},
      {'name': 'Rusap Rombisan', 'price': 'RM7.50', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription3, 'img': 'assets/images/supplies_shop/rusap_rombisan.jpeg'},
      {'name': 'Rusap Poponsu', 'price': 'RM25.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription4, 'img': 'assets/images/supplies_shop/rusap_poponsu.jpg'},
      {'name': 'Paracetamol', 'price': 'RM20.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription5, 'img': 'assets/images/supplies_shop/pills.png'},
      {'name': 'Piriton', 'price': 'RM20.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription6, 'img': 'assets/images/supplies_shop/pills.png'},
      {'name': 'Loratadine', 'price': 'RM20.00', 'description': AppLocalizations.of(context)!.suppliesShopItemDescription7 , 'img': 'assets/images/supplies_shop/pills.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.suppliesShopTitle),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckoutCartScreen(),
              ),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 0, 0, 0)),
            label: Text(AppLocalizations.of(context)!.suppliesShopCheckout, style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      name: product['name']!,
                      price: product['price']!,
                      description: product['description']!,
                      image: product['img']!,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                        color: Colors.grey[300],
                        height: 160,
                        child: Image(
                                image: AssetImage(product['img']!),
                                fit: BoxFit.cover,
                              )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        product['name']!,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        product['price']!,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatefulWidget {
  final String name;
  final String price;
  final String description;
  final String image;

  const ProductDetailScreen({required this.name, required this.price, required this.description, required this.image});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 250,
                color: Colors.grey[300],
                child: Image(image: AssetImage(widget.image), fit: BoxFit.contain,),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.price,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
                        MarkdownBody(
              data: widget.description,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)), //(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart logic here
                  Cart.addItem(CartItem(name: widget.name,
                                        image: widget.image,
                                        unitPrice: double.parse(widget.price.substring(2)),
                                        quantity: quantity)
                                      );
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.suppliesShopAddToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutCartScreen extends StatefulWidget {
  @override
  _CheckoutCartScreenState createState() => _CheckoutCartScreenState();
}

class _CheckoutCartScreenState extends State<CheckoutCartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = Cart.items;
    int? current_radio = 1;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.suppliesShopYourCart)),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.suppliesShopEmptyCart))
              : ListView.separated(
                  padding: EdgeInsets.all(12),
                  itemCount: items.length + 1, // extra for total row
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      final item = items[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(child: Text(item.name)),
                          SizedBox(width: 12),
                          Text('x${item.quantity}'),
                          SizedBox(width: 12),
                          Text('RM${item.unitPrice.toStringAsFixed(2)}'),
                          SizedBox(width: 12),
                          Text('RM${item.totalPrice.toStringAsFixed(2)}'),
                        ],
                      );
                    } else {
                      // total row
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Spacer(flex: 4),
                            Text(
                              AppLocalizations.of(context)!.suppliesShopTotal,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'RM${Cart.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Column(
                  children: [
                    RadioListTile<int>(
                      value: 1,
                      groupValue: current_radio, // Replace with a variable if you want to manage state
                      onChanged: (value) {
                        setState(() {
                            current_radio = value!;
                          });
                        },
                      title: Text('LaLaMove delivery'),
                      subtitle: Text(
                        'Get it as quick as within 1-2 days',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    RadioListTile<int>(
                      value: 2,
                      groupValue: current_radio, // Replace with a variable if you want to manage state
                      onChanged: (value) {
                        setState(() {
                            current_radio = value!;
                          });
                        },
                      title: Text('KEX delivery'),
                      subtitle: Text(
                        'Express delivery (1-2 business days)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    RadioListTile<int>(
                      value: 3,
                      groupValue: current_radio, // Replace with a variable if you want to manage state
                      onChanged: (value) {
                        setState(() {
                            current_radio = value!;
                          });
                        },
                      title: Text('BnL Delivery'),
                      subtitle: Text(
                        'Same-day delivery (if ordered before 12 PM)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: items.isEmpty
                    ? null
                    : () {
                        // TODO: trigger your checkout flow
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.suppliesShopThankYou),
                            content:
                                Text(AppLocalizations.of(context)!.suppliesShopOrderPlaced + 'RM ${Cart.total.toStringAsFixed(2)}.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Cart.clear();
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop(); // go back out of cart
                                },
                                child: Text(AppLocalizations.of(context)!.buttonOk),
                              ),
                            ],
                          ),
                        );
                      },
                child: Text(AppLocalizations.of(context)!.suppliesShopAddToCart),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
