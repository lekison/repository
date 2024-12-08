import 'package:flutter/material.dart';
import 'package:package_1/helper.dart';
import 'package:package_1/history.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Payment History',
      home: PaymentHistoryPage(),
    );
  }
}

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  late Future<List<PaymentHistory>> _payments;

  @override
  void initState() {
    super.initState();
    _refreshPayments();
  }

  void _refreshPayments() {
    setState(() {
      _payments = dbHelper.getPayments();
    });
  }

  void _addPayment() async {
    await dbHelper.insertPayment(
      PaymentHistory(
        id: 0,
        customerName: 'John Doe',
        packageName: 'Premium',
        amount: 50.0,
        date: DateTime.now(),
      ),
    );
    _refreshPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: FutureBuilder<List<PaymentHistory>>(
        future: _payments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No payment history found');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final payment = snapshot.data![index];
                return ListTile(
                  title: Text('${payment.customerName} - ${payment.packageName}'),
                  subtitle: Text('\$${payment.amount} - ${payment.date}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPayment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
