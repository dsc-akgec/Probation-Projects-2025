import 'package:flutter/material.dart';

class Product {
  final String id, title;
  final double price;
  final String? subtitle;
  Product({
    required this.id,
    required this.title,
    required this.price,
    this.subtitle,
  });
}

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
  double get total => product.price * qty;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final products = [
    Product(
      id: 'p1',
      title: 'Veg Burger',
      price: 120,
      subtitle: 'Tasty & healthy',
    ),
    Product(
      id: 'p2',
      title: 'Cheese Burger',
      price: 150,
      subtitle: 'Extra cheese',
    ),
    Product(
      id: 'p3',
      title: 'Paneer Burger',
      price: 140,
      subtitle: 'Paneer patty',
    ),
    Product(id: 'p4', title: 'Crispy Taco', price: 90, subtitle: 'Crunchy'),
    Product(id: 'p5', title: 'Shakes', price: 60, subtitle: 'Cool and creamy'),
    Product(id: 'p6', title: 'Veg Pizza', price: 350, subtitle: 'Family size'),
  ];

  final List<CartItem> _cart = [];
  final Map<String, bool> _selected = {};

  @override
  void initState() {
    super.initState();
    for (var p in products) _selected[p.id] = false;
  }

  void _addToCart(Product product) {
    final idx = _cart.indexWhere((c) => c.product.id == product.id);
    setState(() {
      idx >= 0 ? _cart[idx].qty++ : _cart.add(CartItem(product: product));
      _selected[product.id] = true;
    });
  }

  void _removeFromCart(Product product) {
    final idx = _cart.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0)
      setState(() {
        _cart.removeAt(idx);
        _selected[product.id] = false;
      });
  }

  void _changeQty(Product product, int delta) {
    final idx = _cart.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0)
      setState(() {
        _cart[idx].qty += delta;
        if (_cart[idx].qty <= 0) _cart.removeAt(idx);
      });
  }

  double get _totalPrice => _cart.fold(0.0, (s, c) => s + c.total);
  int get _totalItems => _cart.fold(0, (s, c) => s + c.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Cart', style: TextStyle(color: Colors.black87)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Delivery Location',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          side: BorderSide(color: Colors.orange.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Change Location'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Menu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      final inCart = _cart.any((c) => c.product.id == p.id);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.fastfood_outlined,
                                    size: 36,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                p.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${p.price.toInt()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _addToCart(p),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: inCart
                                          ? Colors.orange.shade100
                                          : Colors.orange.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      inCart ? 'Add +' : 'Add',
                                      style: TextStyle(
                                        color: inCart
                                            ? Colors.orange.shade700
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cart Items',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Total Items ($_totalItems)',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_cart.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Your cart is empty. Add items from the menu above.',
                      ),
                    )
                  else
                    ..._cart.map(
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Checkbox(
                                value: _selected[item.product.id] ?? true,
                                onChanged: (v) => setState(
                                  () => _selected[item.product.id] = v ?? false,
                                ),
                              ),
                            ),
                            Container(
                              width: 72,
                              height: 72,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade100,
                              ),
                              child: const Icon(
                                Icons.bento,
                                size: 36,
                                color: Colors.black26,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '₹${item.product.price.toInt()}',
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      _qtyButton(
                                        Icons.remove,
                                        () => _changeQty(item.product, -1),
                                        Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${item.qty}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _qtyButton(
                                        Icons.add,
                                        () => _changeQty(item.product, 1),
                                        Colors.orange.shade700,
                                        true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  IconButton(
                                    onPressed: () =>
                                        _removeFromCart(item.product),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _summaryRow('Total Items', '$_totalItems'),
                        const SizedBox(height: 8),
                        _summaryRow('Delivery Fee', 'Free', true),
                        const Divider(height: 20, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${_totalPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _cart.isEmpty ? null : _showCheckout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.orange.shade700,
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_totalItems items',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '₹ ${_totalPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(
    IconData icon,
    VoidCallback onTap,
    Color color, [
    bool isAdd = false,
  ]) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isAdd ? color : null,
          borderRadius: BorderRadius.circular(6),
          border: isAdd ? null : Border.all(color: color),
        ),
        child: Icon(icon, size: 18, color: isAdd ? Colors.white : null),
      ),
    );
  }

  Widget _summaryRow(String label, String value, [bool isBold = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
      ],
    );
  }

  void _showCheckout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Text('Pay ₹${_totalPrice.toInt()} - demo only'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cart.clear();
                _selected.updateAll((key, value) => false);
              });
              Navigator.pop(context);
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }
}
