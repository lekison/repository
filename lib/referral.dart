import 'package:flutter/material.dart';

class ReferralPage extends StatelessWidget {
  final TextEditingController _referralCodeController = TextEditingController();

  ReferralPage({super.key});

  void _shareReferralCode() {
    // Implement sharing functionality here
    print('Sharing referral code: ${_referralCodeController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer a Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Refer a friend and get 10% off your next subscription!',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _referralCodeController,
              decoration: const InputDecoration(
                labelText: 'Your Referral Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareReferralCode,
              child: const Text('Share Referral Code'),
            ),
            const SizedBox(height: 20),
            Text(
              'When your friend signs up using your referral code, you\'ll both receive a 10% discount on your next subscription!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}