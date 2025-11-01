import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  // Method to toggle theme
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StocksLite',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      home: MainScreen(themeMode: _themeMode, onThemeToggle: _toggleTheme),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(bool) onThemeToggle;

  const MainScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Screens
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(themeMode: widget.themeMode),
      SettingsScreen(
        themeMode: widget.themeMode,
        onThemeToggle: widget.onThemeToggle,
      ),
    ];
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update screens when theme changes
    if (oldWidget.themeMode != widget.themeMode) {
      _screens = [
        HomeScreen(themeMode: widget.themeMode),
        SettingsScreen(
          themeMode: widget.themeMode,
          onThemeToggle: widget.onThemeToggle,
        ),
      ];
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Sample stock data model
class Stock {
  final String issuer;
  final bool isUp;
  final double changePercentage;
  final double price;

  Stock({
    required this.issuer,
    required this.isUp,
    required this.changePercentage,
    required this.price,
  });
}

class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;

  const HomeScreen({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    // Sample stock data
    final List<Stock> stocks = [
      Stock(issuer: 'Apple Inc.', isUp: true, changePercentage: 2.5, price: 150.00),
      Stock(issuer: 'Google LLC', isUp: false, changePercentage: 1.2, price: 2750.00),
      Stock(issuer: 'Microsoft Corp.', isUp: true, changePercentage: 0.8, price: 300.00),
      Stock(issuer: 'Amazon.com Inc.', isUp: false, changePercentage: 3.1, price: 3200.00),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'stockslite',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeMode == ThemeMode.dark 
                    ? Colors.white 
                    : Colors.black,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: themeMode == ThemeMode.dark 
                      ? Colors.black 
                      : Colors.white,
                ),
                onPressed: () {
                  // Profile button action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile button pressed'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return StockCard(stock: stocks[index], themeMode: themeMode);
        },
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Stock stock;
  final ThemeMode themeMode;

  const StockCard({super.key, required this.stock, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Issuer name
            Text(
              stock.issuer,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Market direction icon and percentage
            Row(
              children: [
                Icon(
                  stock.isUp ? Icons.trending_up : Icons.trending_down,
                  color: stock.isUp ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '${stock.changePercentage}%',
                  style: TextStyle(
                    color: stock.isUp ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(bool) onThemeToggle;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Portfolio Value'),
                subtitle: const Text('\$25,430.50'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Portfolio details')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Price Alerts'),
                subtitle: const Text('3 active alerts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manage alerts')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Market Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.show_chart),
                title: const Text('Market Data'),
                subtitle: const Text('Real-time updates'),
                trailing: Switch(
                  value: true,
                  onChanged: (bool value) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                onThemeToggle(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}