import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Charging Complete',
      'message': 'Your vehicle at Green Volt Station #1 has completed charging.',
      'time': '10 minutes ago',
      'isRead': false,
      'type': 'charging',
      'actionable': true,
    },
    {
      'id': '2',
      'title': 'Booking Reminder',
      'message': 'Your booking at City Center EV Hub is scheduled in 30 minutes.',
      'time': '25 minutes ago',
      'isRead': false,
      'type': 'booking',
      'actionable': true,
    },
    {
      'id': '3',
      'title': 'Special Offer',
      'message': '20% discount on all EV accessories this weekend!',
      'time': '2 hours ago',
      'isRead': true,
      'type': 'promotion',
      'actionable': false,
    },
    {
      'id': '4',
      'title': 'New Station Added',
      'message': 'A new charging station has been added near your frequent location.',
      'time': '1 day ago',
      'isRead': true,
      'type': 'info',
      'actionable': true,
    },
    {
      'id': '5',
      'title': 'Payment Successful',
      'message': 'Your payment of \$15.75 for charging session was successful.',
      'time': '2 days ago',
      'isRead': true,
      'type': 'payment',
      'actionable': false,
    },
  ];

  int get _unreadCount => _notifications.where((n) => !n['isRead']).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  for (var notification in _notifications) {
                    notification['isRead'] = true;
                  }
                });
              },
              icon: const Icon(Icons.done_all, color: Colors.white, size: 20),
              label: const Text(
                'Mark all as read',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterOptions();
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll be notified about charging status,\nbookings, and special offers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    IconData iconData;
    Color iconColor;

    // Determine icon and color based on notification type
    switch (notification['type']) {
      case 'charging':
        iconData = Icons.battery_charging_full;
        iconColor = Colors.green;
        break;
      case 'booking':
        iconData = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case 'promotion':
        iconData = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.purple;
        break;
      case 'info':
      default:
        iconData = Icons.info;
        iconColor = Colors.teal;
        break;
    }

    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification removed'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                setState(() {
                  _notifications.insert(index, notification);
                });
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: notification['isRead']
              ? BorderSide.none
              : const BorderSide(color: Colors.green, width: 1),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              notification['isRead'] = true;
            });
            _showNotificationDetails(notification);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: notification['isRead']
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification['isRead'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['time'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          if (notification['actionable'])
                            TextButton(
                              onPressed: () {
                                // Handle action based on notification type
                                _handleNotificationAction(notification);
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForType(notification['type']),
                    color: _getColorForType(notification['type']),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                notification['message'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              if (notification['actionable'])
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleNotificationAction(notification);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _getActionButtonText(notification['type']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'charging':
        return Icons.battery_charging_full;
      case 'booking':
        return Icons.calendar_today;
      case 'promotion':
        return Icons.local_offer;
      case 'payment':
        return Icons.payment;
      case 'info':
      default:
        return Icons.info;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'charging':
        return Colors.green;
      case 'booking':
        return Colors.blue;
      case 'promotion':
        return Colors.orange;
      case 'payment':
        return Colors.purple;
      case 'info':
      default:
        return Colors.teal;
    }
  }

  String _getActionButtonText(String type) {
    switch (type) {
      case 'charging':
        return 'View Charging Details';
      case 'booking':
        return 'View Booking';
      case 'promotion':
        return 'View Offer';
      case 'payment':
        return 'View Payment';
      case 'info':
      default:
        return 'View Details';
    }
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    // In a real app, you would navigate to the appropriate screen based on the notification type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action for: ${notification['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Filter Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              _buildFilterOption('All Notifications', Icons.notifications),
              _buildFilterOption('Unread', Icons.mark_email_unread),
              _buildFilterOption('Charging', Icons.battery_charging_full),
              _buildFilterOption('Bookings', Icons.calendar_today),
              _buildFilterOption('Promotions', Icons.local_offer),
              _buildFilterOption('Payments', Icons.payment),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
            title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // In a real app, you would filter the notifications based on the selected option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Filtered by: $title'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

