import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  final String consumerKey = 'your_consumer_key';
  final String consumerSecret = 'your_consumer_secret';
  final String shortCode = 'your_short_code';
  final String lipaNaMpesaOnlineUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
  final String tokenUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';

  Future<String> getAccessToken() async {
    final response = await http.get(
      Uri.parse(tokenUrl),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<void> lipaNaMpesaOnline(String phoneNumber, double amount) async {
    final accessToken = await getAccessToken();
    final timestamp = DateTime.now().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0];
    final password = base64Encode(utf8.encode('$shortCode$accessToken$timestamp'));
    final response = await http.post(
      Uri.parse(lipaNaMpesaOnlineUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount,
        'PartyA': phoneNumber,
        'PartyB': shortCode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': 'https://your_callback_url.com',
        'AccountReference': 'your_account_reference',
        'TransactionDesc': 'Subscription Payment',
      }),
    );
    if (response.statusCode == 200) {
      print('Payment initiated successfully');
    } else {
      throw Exception('Failed to initiate payment');
    }
  }

  Future<void> initiateMpesaPayment(String phoneNumber, double amount) async {
    await lipaNaMpesaOnline(phoneNumber, amount);
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _amount = '';
  String _phoneNumber = ''; // This would typically be fetched from the user's account
  bool _isProcessing = false;
  final MpesaService _mpesaService = MpesaService();

  @override
  void initState() {
    super.initState();
    _loadUserPhoneNumber();
  }

  void _loadUserPhoneNumber() {
    // In a real app, you'd fetch this from your user account system
    // For this example, we'll use a mock phone number
    setState(() {
      _phoneNumber = '254712345678'; // Example Kenyan phone number
    });
  }

  void _initiateMpesaPayment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isProcessing = true;
      });

      try {
        await _mpesaService.initiateMpesaPayment(_phoneNumber, double.parse(_amount));
        _showMpesaPromptDialog();
      } catch (e) {
        _showErrorDialog('Failed to initiate payment: ${e.toString()}');
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showMpesaPromptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('M-Pesa Payment Prompt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('An M-Pesa prompt has been sent to your phone.'),
              const SizedBox(height: 10),
              Text('Phone Number: $_phoneNumber'),
              Text('Amount: KES $_amount'),
              const SizedBox(height: 10),
              const Text('Please enter your M-Pesa PIN to complete the transaction.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Pesa Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount (KES)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _amount = value!,
              ),
              const SizedBox(height: 20),
              Text(
                'Payment will be requested from:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                _phoneNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isProcessing ? null : _initiateMpesaPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Pay with M-Pesa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}