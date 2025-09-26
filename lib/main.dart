import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:food_delivery_app/cart.dart';
import 'package:food_delivery_app/other_screen/food_detail.dart';
import 'package:food_delivery_app/other_screen/notification%20.dart';
import 'package:food_delivery_app/other_screen/onboarding.dart';
import 'package:food_delivery_app/profile.dart';
import 'dart:convert';
import 'package:food_delivery_app/search.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onTap(int i) => setState(() => _currentIndex = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: MyNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class MyNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const MyNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.blue,
      selectedFontSize: 15,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FoodItem>> _foodItemsFuture;
  @override
  void initState() {
    super.initState();
    _foodItemsFuture = loadFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        flexibleSpace: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white),
                    const Text(
                      "New York City",
                      style: TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),

                      icon: const Icon(
                        Icons.search_outlined,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  " Provide the best \n food for you",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Find by Category",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(color: Colors.orange.shade700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                foodIcon(
                  img: const AssetImage('assets/Burger.jpg'),
                  txt: "Burger",
                ),
                foodIcon(img: const AssetImage('assets/taco.jpg'), txt: "Taco"),
                foodIcon(
                  img: const AssetImage('assets/drink.jpg'),
                  txt: "Drink",
                ),
                foodIcon(
                  img: const AssetImage('assets/pizza.jpg'),
                  txt: "Pizza",
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<FoodItem>>(
                future: _foodItemsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
                    return const Center(child: Text('No food items found.'));
                  }
                  final items = snap.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => foodCard(
                      context,
                      items[i].img,
                      items[i].title,
                      items[i].rating,
                      items[i].distance,
                      items[i].price,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget foodIcon({required ImageProvider img, required String txt}) {
  return SizedBox(
    height: 80,
    width: 80,
    child: Card(
      color: Colors.grey[200],
      elevation: 8,
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: img, height: 45, width: 50),
          const SizedBox(height: 5),
          Text(
            txt,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget foodCard(
  BuildContext c,
  String path,
  String name,
  double rating,
  String dist,
  double price,
) {
  return GestureDetector(
    onTap: () => Navigator.push(
      c,
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(
          imagePath: path,
          name: name,
          price: price,
          rating: rating,
          distance: dist,
        ),
      ),
    ),
    child: Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.asset(
              path,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(rating.toString()),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.orange,
                      size: 16,
                    ),
                    Text(dist),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Rs. $price",
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
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

class FoodItem {
  final int id;
  final String title;
  final double price;
  final double rating;
  final String img;
  final String distance;
  FoodItem({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.img,
    required this.distance,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    img: json['img'],
    distance: json['distance'],
  );
}

Future<List<FoodItem>> loadFoodItems() async {
  final String raw = await rootBundle.loadString('assets/food_items.json');
  final List<dynamic> list = json.decode(raw);
  return list.map((e) => FoodItem.fromJson(e)).toList();
}
