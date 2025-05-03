import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Green Volt'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and app name
            Center(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.eco_outlined,
                      size: 80,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Green Volt',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // About Us section
            _buildSectionTitle('About Us'),
            _buildSectionContent(
              'Green Volt is an eco-friendly application designed to help users monitor and reduce their carbon footprint through sustainable energy practices. Our team of environmental experts and developers work together to create tools that make sustainable living easier.',
            ),
            
            const SizedBox(height: 24),
            
            // Our Mission section
            _buildSectionTitle('Our Mission'),
            _buildSectionContent(
              'To promote sustainable energy consumption and help users make environmentally conscious decisions in their daily lives. We believe that small changes can lead to significant environmental impact when adopted collectively.',
            ),
            
            const SizedBox(height: 24),
            
            // Features section
            _buildSectionTitle('Key Features'),
            const SizedBox(height: 8),
            _buildFeatureItem(Icons.analytics_outlined, 'Energy Usage Tracking'),
            _buildFeatureItem(Icons.tips_and_updates_outlined, 'Eco-friendly Tips'),
            _buildFeatureItem(Icons.notifications_active_outlined, 'Consumption Alerts'),
            _buildFeatureItem(Icons.bar_chart, 'Carbon Footprint Analysis'),
            
            const SizedBox(height: 24),
            
            // Contact section
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 8),
            _buildContactButton(
              context,
              Icons.email_outlined,
              'Email Us',
              'mailto:support@greenvolt.com',
            ),
            _buildContactButton(
              context,
              Icons.language,
              'Visit Our Website',
              'https://www.greenvolt.com',
            ),
            
            const SizedBox(height: 24),
            
            // Privacy and Terms
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to privacy policy
                  },
                  child: const Text('Privacy Policy'),
                ),
                const Text('|'),
                TextButton(
                  onPressed: () {
                    // Navigate to terms of service
                  },
                  child: const Text('Terms of Service'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Copyright
            Center(
              child: Text(
                '© ${DateTime.now().year} Green Volt. All rights reserved.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22, 
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }
  
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactButton(BuildContext context, IconData icon, String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        onPressed: () => _launchUrl(url),
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade100,
          foregroundColor: Colors.green.shade800,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
