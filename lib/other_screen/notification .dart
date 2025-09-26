import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Today',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          _buildNotificationItem(
            icon: Icons.discount_outlined,
            iconColor: Colors.red,
            title: '30% Special Discount!',
            subtitle: 'Special promotion only valid today',
          ),
          const Divider(height: 24),
          _buildNotificationItem(
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            title: 'Your Order Has Been Taken by the Driver',
            subtitle: 'Recently',
          ),
          const Divider(height: 24),
          _buildNotificationItem(
            icon: Icons.cancel_outlined,
            iconColor: Colors.red,
            title: 'Your Order Has Been Canceled',
            subtitle: '19 Jun 2025',
          ),
          const Divider(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Yesterday',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          _buildNotificationItem(
            icon: Icons.discount_outlined,
            iconColor: Colors.grey,
            title: '35% Special Discount!',
            subtitle: 'Special promotion only valid today',
          ),
          const Divider(height: 24),
          _buildNotificationItem(
            icon: Icons.person_outline,
            iconColor: Colors.grey,
            title: 'Account Setup Successful!',
            subtitle: 'Special promotion only valid today',
          ),
          const Divider(height: 24),
          _buildNotificationItem(
            icon: Icons.local_offer_outlined,
            iconColor: Colors.red,
            title: 'Special Offer! 60% Off',
            subtitle: 'Special offer for new account, valid until 20 Nov 2022',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
