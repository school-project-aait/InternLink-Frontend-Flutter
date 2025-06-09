import 'package:flutter/material.dart';

import '../../domain/entities/internship.dart';


class InternshipCard extends StatelessWidget {
  final Internship internship;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;
  final bool isAdmin;

  const InternshipCard({
    super.key,
    required this.internship,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
    this.isAdmin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      internship.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (isAdmin) ...[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                    ),
                    isDeleting
                        ? const CircularProgressIndicator()
                        : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(internship.categoryName),
                backgroundColor: Colors.blue[50],
              ),
              const SizedBox(height: 8),
              Text(
                'Company: ${internship.companyName}',
                style: Theme.of(context).textTheme.bodyLarge,
                // style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              if (internship.description != null && internship.description!.isNotEmpty)
                Text(
                  'Requirements: ${internship.description!}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[800],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Deadline: ${internship.deadline}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      internship.status.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Text(
                  //   internship.createdAt,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}