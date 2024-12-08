import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  final List<Map<String, String>> supportInfo = [
    {
      'title': 'FAQ',
      
      'description': 'Find answers to commonly asked questions about our services, subscription plans, and payment processes. Our comprehensive FAQ section covers a wide range of topics to help you quickly resolve any issues or concerns you may have.',
    },
    {
      'title': 'Contact Us',
      
      'description': 'Need personalized assistance? Our dedicated support team is here to help. Reach out to us via email, phone, or live chat. We strive to respond to all inquiries within 24 hours, ensuring you get the help you need as quickly as possible.',
    },
    {
      'title': 'Troubleshooting',
      
      'description': 'Experiencing technical difficulties? Our troubleshooting guide provides step-by-step solutions to common technical issues. From account access problems to payment concerns, weve got you covered with easy-to-follow instructions.',
    },
  ];

   SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: supportInfo.length,
          itemBuilder: (context, index) {
            final info = supportInfo[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(info['icon'] as IconData, size: 30, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 16),
                        Text(
                          info['title']!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      info['description']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add navigation or action for each card
                          print('Tapped on ${info['title']}');
                        },
                        child: const Text('Learn More'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}