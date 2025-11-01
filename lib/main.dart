import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
      const HomeScreen(), // Bookmarked emitents
      const MarketsScreen(), // All markets
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
        const HomeScreen(), // Bookmarked emitents
        const MarketsScreen(), // All markets
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
            icon: Icon(Icons.list),
            label: 'Markets',
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
  final bool isBookmarked;
  final List<FlSpot> priceHistory;

  Stock({
    required this.issuer,
    required this.isUp,
    required this.changePercentage,
    required this.price,
    this.isBookmarked = false,
    required this.priceHistory,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample stock data - only bookmarked emitents
    final List<Stock> bookmarkedStocks = [
      Stock(
        issuer: 'Apple Inc.', 
        isUp: true, 
        changePercentage: 2.5, 
        price: 150.00, 
        isBookmarked: true,
        priceHistory: [
          FlSpot(0, 145),
          FlSpot(1, 147),
          FlSpot(2, 149),
          FlSpot(3, 148),
          FlSpot(4, 150),
          FlSpot(5, 152),
          FlSpot(6, 150),
        ],
      ),
      Stock(
        issuer: 'Microsoft Corp.', 
        isUp: true, 
        changePercentage: 0.8, 
        price: 300.00, 
        isBookmarked: true,
        priceHistory: [
          FlSpot(0, 295),
          FlSpot(1, 297),
          FlSpot(2, 299),
          FlSpot(3, 301),
          FlSpot(4, 300),
          FlSpot(5, 302),
          FlSpot(6, 300),
        ],
      ),
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
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : Colors.black,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.black 
                      : Colors.white,
                ),
                onPressed: () {
                  // Show account options
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.account_circle),
                              title: const Text('Account'),
                              onTap: () {
                                Navigator.pop(context);
                                // Navigate to account screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Settings'),
                              onTap: () {
                                Navigator.pop(context);
                                // Navigate to settings
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(
                                      themeMode: Theme.of(context).brightness == Brightness.dark 
                                          ? ThemeMode.dark 
                                          : ThemeMode.light,
                                      onThemeToggle: (bool value) {},
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookmarkedStocks.length,
        itemBuilder: (context, index) {
          return StockCard(stock: bookmarkedStocks[index], onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StockDetailScreen(stock: bookmarkedStocks[index]),
              ),
            );
          });
        },
      ),
    );
  }
}

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample stock data - all markets
    final List<Stock> allStocks = [
      Stock(
        issuer: 'Apple Inc.', 
        isUp: true, 
        changePercentage: 2.5, 
        price: 150.00, 
        isBookmarked: true,
        priceHistory: [
          FlSpot(0, 145),
          FlSpot(1, 147),
          FlSpot(2, 149),
          FlSpot(3, 148),
          FlSpot(4, 150),
          FlSpot(5, 152),
          FlSpot(6, 150),
        ],
      ),
      Stock(
        issuer: 'Google LLC', 
        isUp: false, 
        changePercentage: 1.2, 
        price: 2750.00,
        priceHistory: [
          FlSpot(0, 2760),
          FlSpot(1, 2755),
          FlSpot(2, 2752),
          FlSpot(3, 2750),
          FlSpot(4, 2748),
          FlSpot(5, 2745),
          FlSpot(6, 2750),
        ],
      ),
      Stock(
        issuer: 'Microsoft Corp.', 
        isUp: true, 
        changePercentage: 0.8, 
        price: 300.00, 
        isBookmarked: true,
        priceHistory: [
          FlSpot(0, 295),
          FlSpot(1, 297),
          FlSpot(2, 299),
          FlSpot(3, 301),
          FlSpot(4, 300),
          FlSpot(5, 302),
          FlSpot(6, 300),
        ],
      ),
      Stock(
        issuer: 'Amazon.com Inc.', 
        isUp: false, 
        changePercentage: 3.1, 
        price: 3200.00,
        priceHistory: [
          FlSpot(0, 3220),
          FlSpot(1, 3215),
          FlSpot(2, 3210),
          FlSpot(3, 3205),
          FlSpot(4, 3200),
          FlSpot(5, 3195),
          FlSpot(6, 3200),
        ],
      ),
      Stock(
        issuer: 'Tesla Inc.', 
        isUp: true, 
        changePercentage: 5.2, 
        price: 800.00,
        priceHistory: [
          FlSpot(0, 780),
          FlSpot(1, 785),
          FlSpot(2, 790),
          FlSpot(3, 795),
          FlSpot(4, 800),
          FlSpot(5, 810),
          FlSpot(6, 800),
        ],
      ),
      Stock(
        issuer: 'Netflix Inc.', 
        isUp: false, 
        changePercentage: 2.7, 
        price: 450.00,
        priceHistory: [
          FlSpot(0, 460),
          FlSpot(1, 458),
          FlSpot(2, 455),
          FlSpot(3, 452),
          FlSpot(4, 450),
          FlSpot(5, 448),
          FlSpot(6, 450),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allStocks.length,
        itemBuilder: (context, index) {
          return StockCard(stock: allStocks[index], onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StockDetailScreen(stock: allStocks[index]),
              ),
            );
          });
        },
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  const StockCard({super.key, required this.stock, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Issuer name with reduced font size
              Text(
                stock.issuer,
                style: const TextStyle(
                  fontSize: 16, // Reduced from 18 to 16
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Market direction icon and percentage
              Row(
                children: [
                  Icon(
                    stock.isUp ? Icons.trending_up : Icons.trending_down,
                    color: stock.isUp ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${stock.changePercentage}%',
                    style: TextStyle(
                      fontSize: 14, // Reduced from default
                      color: stock.isUp ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StockDetailScreen extends StatelessWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stock.issuer),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stock price and change
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${stock.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        stock.isUp ? Icons.trending_up : Icons.trending_down,
                        color: stock.isUp ? Colors.green : Colors.red,
                      ),
                      Text(
                        '${stock.changePercentage}%',
                        style: TextStyle(
                          color: stock.isUp ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Statistics section
              const SectionTitle(title: 'Price History'),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: stock.priceHistory,
                        isCurved: true,
                        color: stock.isUp ? Colors.green : Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: stock.isUp 
                              ? Colors.green.withOpacity(0.3) 
                              : Colors.red.withOpacity(0.3),
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Text(
                              weekdays[value.toInt()],
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '\$${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 5,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor,
                          strokeWidth: 0.5,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Theme.of(context).dividerColor,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Company information section
              const SectionTitle(title: 'Company Information'),
              const SizedBox(height: 16),
              const Text(
                'Apple Inc. is an American multinational technology company that specializes in consumer electronics, computer software, and online services. The company was founded in 1976 by Steve Jobs, Steve Wozniak, and Ronald Wayne to develop, sell, and support personal computers.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vision: To make the best products on earth and to leave the world better than we found it.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Mission: To bring the best user experience to its customers through its innovative hardware, software, and services.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CEO: Tim Cook',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              // Ownership section
              const SectionTitle(title: 'Major Shareholders'),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'The Vanguard Group, Inc.',
                percentage: '8.0%',
              ),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'BlackRock, Inc.',
                percentage: '5.5%',
              ),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'Berkshire Hathaway Inc.',
                percentage: '5.2%',
              ),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'Tim Cook (CEO)',
                percentage: '0.02%',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ShareholderItem extends StatelessWidget {
  final String name;
  final String percentage;

  const ShareholderItem({super.key, required this.name, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
              'Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: const Text('Select app theme'),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    onThemeToggle(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                subtitle: const Text('Manage notifications'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                subtitle: const Text('App version 1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}