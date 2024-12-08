import 'package:flutter/material.dart';
import 'package:package_1/paymentpage.dart';



void main() {
  runApp( const WifiPackagesApp());
}
class WifiPackagesApp extends StatefulWidget {
  const WifiPackagesApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WifiPackagesAppState createState() => _WifiPackagesAppState();
}
class _WifiPackagesAppState extends State<WifiPackagesApp> {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Packages',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
      ),
      home: WifiPackagesScreen(),
    );
  }
}

class WifiPackagesScreen extends StatelessWidget {
  final List<WifiPackage> packages = [
    WifiPackage('OLD 5 Mbps - Lite', 1999.00, 5),
    WifiPackage('TSAVO HQ_70Mbps', 0.00, 70),
    WifiPackage('3 Mbps - Students 4500', 4500.00, 3),
    WifiPackage('OLD 3 Mbps Lite', 1500.00, 3),
    WifiPackage('Installation - 2Mbps', 0.00, 2),
    WifiPackage('10 Mbps Bronze', 2499.00, 10),
    WifiPackage('15 Mbps Silver', 2999.00, 15),
    WifiPackage('20 Mbps Gold', 3499.00, 20),
    WifiPackage('30 Mbps Diamond', 4499.00, 30),
    WifiPackage('40 Mbps Platinum', 6499.00, 40),
    // Add your remaining packages here
  ];

  WifiPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, List<WifiPackage>> groupedPackages = {
      'Bronze': [],
      'Silver': [],
      'Gold': [],
      'Diamond': [],
      'Platinum': [],
    };

    for (var package in packages) {
      if (package.speed == 10) {
        groupedPackages['Bronze']!.add(package);
      } else if (package.speed == 15) {
        groupedPackages['Silver']!.add(package);
      } else if (package.speed == 20) {
        groupedPackages['Gold']!.add(package);
      } else if (package.speed == 30) {
        groupedPackages['Diamond']!.add(package);
      } else if (package.speed == 40) {
        groupedPackages['Platinum']!.add(package);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Packages'),
        backgroundColor: const Color.fromARGB(255, 238, 231, 231),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: groupedPackages.entries.map((entry) {
          String title = entry.key;
          List<WifiPackage> packages = entry.value;

          return ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(color: Colors.orange),
            ),
            backgroundColor: Colors.black,
            children: packages.map((package) {
              return WifiPackageButton(package: package);
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class WifiPackageButton extends StatelessWidget {
  final WifiPackage package;

  const WifiPackageButton({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentPage(
                
            ),
          ));
        },
        child: Text(
          package.name,
          style: const TextStyle(color: Color.fromARGB(255, 231, 215, 215), fontSize: 18),
        ),
      ),
    );
  }
}

class WifiPackage {
  final String name;
  final double price;
  final int speed;

  WifiPackage(this.name, this.price, this.speed);
}
