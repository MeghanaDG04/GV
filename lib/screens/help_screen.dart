import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'FAQs'),
            Tab(text: 'Guides'),
            Tab(text: 'Support'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for help topics...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFaqTab(),
                _buildGuidesTab(),
                _buildSupportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I track my energy usage?',
        'answer': 'Navigate to the Home screen and tap on the "Track Usage" button. Follow the prompts to input your energy consumption data. You can connect smart meters or manually enter readings from your utility bills.'
      },
      {
        'question': 'How can I reduce my carbon footprint?',
        'answer': 'Check out the tips section on the Home screen for personalized recommendations based on your usage patterns. We analyze your consumption habits and suggest specific actions that will have the most impact for your situation.'
      },
      {
        'question': 'Is my data secure?',
        'answer': 'Yes, all your data is encrypted and stored securely. We use industry-standard encryption protocols and never share your personal information with third parties without your explicit consent. You can review our privacy policy for more details.'
      },
      {
        'question': 'How do I update my profile information?',
        'answer': 'Go to User Settings from the menu and tap on "Edit Profile" to update your information. You can change your name, email, password, and notification preferences from this screen.'
      },
      {
        'question': 'Can I connect smart home devices?',
        'answer': 'Yes! Green Volt supports integration with many popular smart home systems. Go to the "Integrations" section in Settings to connect your smart devices and start monitoring their energy usage in real-time.'
      },
      {
        'question': 'How accurate are the carbon footprint calculations?',
        'answer': 'Our calculations are based on regional energy mix data and industry-standard conversion factors. While they provide a good estimate, actual values may vary slightly depending on your specific utility provider and local conditions.'
      },
      {
        'question': 'Can I export my usage data?',
        'answer': 'Yes, you can export your data in CSV or PDF format from the Reports section. This is useful for record-keeping or if you want to analyze your usage patterns in external tools.'
      },
    ];

    List<Map<String, String>> filteredFaqs = faqs;
    if (_searchQuery.isNotEmpty) {
      filteredFaqs = faqs.where((faq) {
        return faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filteredFaqs.isEmpty
        ? const Center(
            child: Text(
              'No matching FAQs found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredFaqs.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: _buildFaqItem(
                  filteredFaqs[index]['question']!,
                  filteredFaqs[index]['answer']!,
                ),
              );
            },
          );
  }

  Widget _buildGuidesTab() {
    final List<Map<String, dynamic>> guides = [
      {
        'title': 'Getting Started',
        'icon': Icons.play_circle_outline,
        'description': 'Learn the basics of using Green Volt to monitor your energy usage.',
      },
      {
        'title': 'Connecting Smart Devices',
        'icon': Icons.devices,
        'description': 'Step-by-step instructions for integrating your smart home devices.',
      },
      {
        'title': 'Understanding Your Reports',
        'icon': Icons.bar_chart,
        'description': 'How to interpret the data and insights in your energy reports.',
      },
      {
        'title': 'Setting Energy Goals',
        'icon': Icons.flag,
        'description': 'Tips for creating achievable energy reduction targets.',
      },
      {
        'title': 'Troubleshooting Connection Issues',
        'icon': Icons.sync_problem,
        'description': 'Solutions for common connectivity problems with devices and services.',
      },
    ];

    List<Map<String, dynamic>> filteredGuides = guides;
    if (_searchQuery.isNotEmpty) {
      filteredGuides = guides.where((guide) {
        return guide['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               guide['description']!.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filteredGuides.isEmpty
        ? const Center(
            child: Text(
              'No matching guides found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredGuides.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(
                                        filteredGuides[index]['icon'],
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    filteredGuides[index]['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      filteredGuides[index]['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to detailed guide screen
                    // This would be implemented in a real app
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening guide: ${filteredGuides[index]['title']}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildSupportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SupportSectionTitle(title: 'Contact Support'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our support team is here to help you with any questions or issues.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/contact');
                    },
                    icon: const Icon(Icons.email),
                    label: const Text('Contact Us'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const _SupportSectionTitle(title: 'Support Hours'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SupportTimeRow(day: 'Monday - Friday', hours: '9:00 AM - 8:00 PM EST'),
                  Divider(),
                  _SupportTimeRow(day: 'Saturday', hours: '10:00 AM - 6:00 PM EST'),
                  Divider(),
                  _SupportTimeRow(day: 'Sunday', hours: 'Closed'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const _SupportSectionTitle(title: 'Emergency Support'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'For urgent issues outside of regular support hours:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        '+1 (555) 123-4567',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Note: Emergency support is for critical issues only.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const _SupportSectionTitle(title: 'Self-Help Resources'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(
              children: [
                _buildResourceItem(
                  context,
                  'Knowledge Base',
                  'Browse our extensive collection of articles',
                  Icons.menu_book,
                ),
                const Divider(height: 1),
                _buildResourceItem(
                  context,
                  'Video Tutorials',
                  'Watch step-by-step guides for common tasks',
                  Icons.video_library,
                ),
                const Divider(height: 1),
                _buildResourceItem(
                  context,
                  'Community Forum',
                  'Connect with other users and share solutions',
                  Icons.forum,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                const Text(
                  'Still need help?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Talk to a Support Agent'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(BuildContext context, String title, String description, IconData icon) {
    return InkWell(
      onTap: () {
        // Navigate to resource
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening: $title'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.all(16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        Text(
          answer,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SupportSectionTitle extends StatelessWidget {
  final String title;
  
  const _SupportSectionTitle({required this.title});
  
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

class _SupportTimeRow extends StatelessWidget {
  final String day;
  final String hours;
  
  const _SupportTimeRow({required this.day, required this.hours});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

