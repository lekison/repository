import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:package_1/packages.dart';
import 'package:package_1/password.dart';
import 'package:package_1/paymenthistory.dart';
import 'package:package_1/paymentpage.dart';
import 'package:package_1/referral.dart';
import 'package:package_1/support.dart';

// Import your existing pages here

  

// New page for advertisements
class AdvertisementPage extends StatelessWidget {
  final String title;
  final String description;

  const AdvertisementPage({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement action for the advertisement
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Action taken on $title advertisement')),
                );
              },
              child: const Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyAppy extends StatelessWidget {
  const MyAppy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentCarouselIndex = 0;
  double _sliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          _buildBody(context),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(Icons.message, 'Messages'),
          _buildDrawerItem(Icons.account_circle, 'Profile'),
          _buildDrawerItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Implement navigation
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          _buildWelcomeCard(),
          _buildGridCard(context),
          _buildInteractiveCarousel(context),
          _buildColorGridCard(),
          _buildInteractiveSection(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _showNotification(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Text('Welcome, User!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            const Text('Location: Your Location', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Update Location'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildGridItem(Icons.payment, 'Payment', () => _navigateToPayment(context)),
            _buildGridItem(Icons.change_circle, 'Change Plan', () => _navigateToChangePlan(context)),
            _buildGridItem(Icons.change_circle, 'Change password', () => _navigateToChangePassword(context)),
            _buildGridItem(Icons.help, 'Help', () => _navigateToHelp(context)),
            _buildGridItem(Icons.person_add, 'Referrals', () => _navigateToReferrals(context)),
            _buildGridItem(Icons.history, 'History', () => _navigateToHistory(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 50),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildInteractiveCarousel(BuildContext context) {
    final List<Map<String, String>> carouselItems = [
      {'image': 'assets/Bronze.jpg', 'title': 'Bronze Package', 'description': 'Great value for new users'},
      {'image': 'assets/diamond.jpg', 'title': 'Diamond Package', 'description': 'Premium features for power users'},
      {'image': 'assets/silver.png', 'title': 'Silver Package', 'description': 'Perfect balance of features and price'},
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          items: carouselItems.map((item) => _buildCarouselItem(context, item)).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: carouselItems.asMap().entries.map((entry) {
            return Container(
              width: 12.0,
              height: 12.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(_currentCarouselIndex == entry.key ? 0.9 : 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, Map<String, String> item) {
    return InkWell(
      onTap: () => _navigateToAdvertisement(context, item['title']!, item['description']!),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Image.asset(item['image']!, fit: BoxFit.cover, width: 1000.0),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGridCard() {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildColorGridItem('Gold', Colors.yellow, 300),
            _buildColorGridItem('Silver', Colors.grey, 400),
            _buildColorGridItem('Bronze', Colors.brown, 500),
            _buildColorGridItem('Diamond', Colors.blueAccent, 900),
            _buildColorGridItem('Platinum', Colors.white, 100),
            _buildColorGridItem('Green', Colors.green, 600),
            _buildColorGridItem('Blue', Colors.blue, 700),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGridItem(String label, Color color, int amount) {
    return GestureDetector(
      onTap: () => _navigateToAdvertisement(context, label, 'Explore our $label package for only \$$amount'),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveSection() {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Customize Your Experience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 5,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text('Selected Value: ${_sliderValue.round()}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToAdvertisement(context, 'Custom Package', 'Your personalized package based on your preferences'),
              child: const Text('Get Custom Offer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No new notifications')),
    );
  }

  void _navigateToAdvertisement(BuildContext context, String title, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdvertisementPage(title: title, description: description)),
    );
  }

  void _navigateToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentPage(
        
        ),
      ),
    );
  }

  void _navigateToChangePlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WifiPackagesApp()),
    );
  }
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WiFiSetupPage()),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupportPage()),
    );
  }

  void _navigateToReferrals(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReferralPage()),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentHistoryPage()),
    );
  }
}