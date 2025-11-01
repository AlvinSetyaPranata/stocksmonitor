import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
      locale: const Locale('id', 'ID'), // Set Indonesian locale
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

  // Shared stock data - Indonesian stocks (IHSG/IDX)
  List<Stock> allStocks = [
    Stock(
      issuer: 'BBRI', 
      fullName: 'PT Bank Rakyat Indonesia (Persero) Tbk',
      isUp: true, 
      changePercentage: 2.5, 
      price: 5200, 
      isBookmarked: true,
      priceHistory: [
        FlSpot(0, 5100),
        FlSpot(1, 5150),
        FlSpot(2, 5180),
        FlSpot(3, 5190),
        FlSpot(4, 5200),
        FlSpot(5, 5220),
        FlSpot(6, 5200),
      ],
    ),
    Stock(
      issuer: 'BBCA', 
      fullName: 'PT Bank Central Asia Tbk',
      isUp: false, 
      changePercentage: 1.2, 
      price: 9800,
      isBookmarked: false,
      priceHistory: [
        FlSpot(0, 9900),
        FlSpot(1, 9880),
        FlSpot(2, 9850),
        FlSpot(3, 9830),
        FlSpot(4, 9820),
        FlSpot(5, 9810),
        FlSpot(6, 9800),
      ],
    ),
    Stock(
      issuer: 'TLKM', 
      fullName: 'PT Telekomunikasi Indonesia (Persero) Tbk',
      isUp: true, 
      changePercentage: 0.8, 
      price: 4200, 
      isBookmarked: true,
      priceHistory: [
        FlSpot(0, 4150),
        FlSpot(1, 4170),
        FlSpot(2, 4180),
        FlSpot(3, 4190),
        FlSpot(4, 4200),
        FlSpot(5, 4210),
        FlSpot(6, 4200),
      ],
    ),
    Stock(
      issuer: 'UNVR', 
      fullName: 'PT Unilever Indonesia Tbk',
      isUp: false, 
      changePercentage: 3.1, 
      price: 51000,
      isBookmarked: false,
      priceHistory: [
        FlSpot(0, 52500),
        FlSpot(1, 52200),
        FlSpot(2, 52000),
        FlSpot(3, 51800),
        FlSpot(4, 51500),
        FlSpot(5, 51200),
        FlSpot(6, 51000),
      ],
    ),
    Stock(
      issuer: 'ASII', 
      fullName: 'PT Astra International Tbk',
      isUp: true, 
      changePercentage: 5.2, 
      price: 7800,
      isBookmarked: false,
      priceHistory: [
        FlSpot(0, 7600),
        FlSpot(1, 7650),
        FlSpot(2, 7700),
        FlSpot(3, 7750),
        FlSpot(4, 7780),
        FlSpot(5, 7820),
        FlSpot(6, 7800),
      ],
    ),
    Stock(
      issuer: 'BMRI', 
      fullName: 'PT Bank Mandiri (Persero) Tbk',
      isUp: false, 
      changePercentage: 2.7, 
      price: 9200,
      isBookmarked: false,
      priceHistory: [
        FlSpot(0, 9400),
        FlSpot(1, 9380),
        FlSpot(2, 9350),
        FlSpot(3, 9320),
        FlSpot(4, 9300),
        FlSpot(5, 9280),
        FlSpot(6, 9200),
      ],
    ),
  ];

  // Method to toggle bookmark status
  void _toggleBookmark(String issuer) {
    setState(() {
      for (int i = 0; i < allStocks.length; i++) {
        if (allStocks[i].issuer == issuer) {
          allStocks[i] = Stock(
            issuer: allStocks[i].issuer,
            fullName: allStocks[i].fullName,
            isUp: allStocks[i].isUp,
            changePercentage: allStocks[i].changePercentage,
            price: allStocks[i].price,
            isBookmarked: !allStocks[i].isBookmarked,
            priceHistory: allStocks[i].priceHistory,
          );
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            bookmarkedStocks: allStocks.where((stock) => stock.isBookmarked).toList(),
            onBookmarkToggle: _toggleBookmark,
          ),
          MarketsScreen(
            allStocks: allStocks,
            onBookmarkToggle: _toggleBookmark,
          ),
          SettingsScreen(
            themeMode: widget.themeMode,
            onThemeToggle: widget.onThemeToggle,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pasar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// Sample stock data model
class Stock {
  final String issuer;
  final String fullName;
  final bool isUp;
  final double changePercentage;
  final double price;
  final bool isBookmarked;
  final List<FlSpot> priceHistory;

  Stock({
    required this.issuer,
    required this.fullName,
    required this.isUp,
    required this.changePercentage,
    required this.price,
    required this.isBookmarked,
    required this.priceHistory,
  });
}

class HomeScreen extends StatelessWidget {
  final List<Stock> bookmarkedStocks;
  final Function(String) onBookmarkToggle;

  const HomeScreen({
    super.key, 
    required this.bookmarkedStocks,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
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
                              title: const Text('Akun'),
                              onTap: () {
                                Navigator.pop(context);
                                // Navigate to account screen
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('Pengaturan'),
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
          return StockCard(
            stock: bookmarkedStocks[index], 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailScreen(
                    stock: bookmarkedStocks[index],
                    onBookmarkToggle: onBookmarkToggle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MarketsScreen extends StatelessWidget {
  final List<Stock> allStocks;
  final Function(String) onBookmarkToggle;

  const MarketsScreen({
    super.key, 
    required this.allStocks,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasar'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allStocks.length,
        itemBuilder: (context, index) {
          return StockCard(
            stock: allStocks[index], 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockDetailScreen(
                    stock: allStocks[index],
                    onBookmarkToggle: onBookmarkToggle,
                  ),
                ),
              );
            },
          );
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

class StockDetailScreen extends StatefulWidget {
  final Stock stock;
  final Function(String) onBookmarkToggle;

  const StockDetailScreen({
    super.key, 
    required this.stock,
    required this.onBookmarkToggle,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.stock.isBookmarked;
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkToggle(widget.stock.issuer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stock.issuer),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.yellow : null,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
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
                    'Rp${NumberFormat('#,##0').format(widget.stock.price)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        widget.stock.isUp ? Icons.trending_up : Icons.trending_down,
                        color: widget.stock.isUp ? Colors.green : Colors.red,
                      ),
                      Text(
                        '${widget.stock.changePercentage}%',
                        style: TextStyle(
                          color: widget.stock.isUp ? Colors.green : Colors.red,
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
              const SectionTitle(title: 'Riwayat Harga'),
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
                        spots: widget.stock.priceHistory,
                        isCurved: true,
                        color: widget.stock.isUp ? Colors.green : Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: widget.stock.isUp 
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
                            const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
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
                              'Rp${value.toInt()}',
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
              const SectionTitle(title: 'Informasi Perusahaan'),
              const SizedBox(height: 16),
              Text(
                widget.stock.fullName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Visi: Menjadi perusahaan terdepan dalam bidangnya di Indonesia.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Misi: Memberikan nilai terbaik kepada para pemegang saham melalui inovasi dan pelayanan yang unggul.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CEO: [Nama CEO Perusahaan]',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              // Ownership section
              const SectionTitle(title: 'Pemegang Saham Mayoritas'),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'Pemerintah Indonesia',
                percentage: '60.0%',
              ),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'Investor Asing',
                percentage: '25.0%',
              ),
              const SizedBox(height: 16),
              const ShareholderItem(
                name: 'Investor Domestik',
                percentage: '15.0%',
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
        title: const Text('Pengaturan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferensi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Tema'),
                subtitle: const Text('Pilih tema aplikasi'),
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
                title: const Text('Notifikasi'),
                subtitle: const Text('Kelola notifikasi'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Bahasa'),
                subtitle: const Text('Indonesia'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang'),
                subtitle: const Text('Versi aplikasi 1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}