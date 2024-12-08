import 'package:flutter/material.dart';

class WiFiSetupPage extends StatefulWidget {
  const WiFiSetupPage({super.key});

  @override
  _WiFiSetupPageState createState() => _WiFiSetupPageState();
}

class _WiFiSetupPageState extends State<WiFiSetupPage> {
  final _formKey = GlobalKey<FormState>();
  String _ssid = '';
  String _password = '';
  bool _isConnected = false;
  bool _showPassword = false;

  void _saveWiFiSettings() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you would typically call your WiFi connection API
      // For this example, we'll just simulate a successful connection
      setState(() {
        _isConnected = true;
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WiFi Connected'),
          content: Text('Successfully connected to $_ssid'),
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
        title: const Text('WiFi Setup'),
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
                  labelText: 'WiFi Name (SSID)',
                  prefixIcon: Icon(Icons.wifi),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WiFi name';
                  }
                  return null;
                },
                onSaved: (value) => _ssid = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveWiFiSettings,
                child: Text(_isConnected ? 'Update WiFi Settings' : 'Connect to WiFi'),
              ),
              const SizedBox(height: 20),
              if (_isConnected)
                Text(
                  'Connected to: $_ssid',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}