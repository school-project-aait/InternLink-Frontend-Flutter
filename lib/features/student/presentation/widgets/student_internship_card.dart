import 'package:flutter/material.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/internship.dart';

class StudentInternshipCard extends StatelessWidget {
  final Internship internship;
  final VoidCallback onApply;

  const StudentInternshipCard({
    super.key,
    required this.internship,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = internship.status.toLowerCase() == 'active';
    final deadlineColor = _getDeadlineColor(internship.deadline);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/internship/${internship.id}',
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      internship.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      internship.status.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: isActive ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Company and Category
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.business,
                    label: internship.companyName,
                  ),
                  if (internship.categoryName.isNotEmpty)
                    _InfoChip(
                      icon: Icons.category,
                      label: internship.categoryName,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Description preview
              if (internship.description.isNotEmpty)
                Text(
                  internship.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),

              // Deadline and Apply Button
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deadline:',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          internship.deadline,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: deadlineColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isActive ? onApply : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive
                          ? theme.primaryColor
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(isActive ? 'APPLY' : 'CLOSED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDeadlineColor(String deadline) {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final difference = deadlineDate.difference(now).inDays;

      if (difference < 0) return Colors.red;
      if (difference < 7) return Colors.orange;
      return Colors.green;
    } catch (e) {
      return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Colors.grey[200],
      labelStyle: Theme.of(context).textTheme.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}