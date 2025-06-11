import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/application.dart';

class ApplicationCard extends ConsumerWidget {
  final Application application;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Internship title and company
            Text(
              application.internshipTitle ?? 'Internship',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              application.companyName ?? 'Company',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            // Status row
            Row(
              children: [
                _buildStatusIndicator(application.status),
                const SizedBox(width: 8),
                Text(
                  application.status.toUpperCase(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _getStatusColor(application.status),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Application details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'University',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      application.university,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Graduation Year',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      application.graduationYear.toString(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                if (application.status == 'pending')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // white background
                        side: const BorderSide(color: Color(0xFF1B2A80), width: 2), // blue border stroke
                        elevation: 0,
                      ),
                      child: const Text('WITHDRAW',style: TextStyle(
                        color: Colors.red, // blue text
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                if (application.status == 'pending')
                  const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // white background
                        side: const BorderSide(color: Color(0xFF1B2A80), width: 2), // blue border stroke
                        elevation: 0,
                    ),
                    child: const Text('UPDATE',
                      style: TextStyle(
                      color: Color(0xFF1B2A80), // blue text
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA000); // Orange
      case 'accepted':
        return const Color(0xFF4CAF50); // Green
      case 'rejected':
        return const Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }
}