// lib/components/status_dropdown.dart

import 'package:flutter/material.dart';

class StatusDropdown extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChange;

  static const List<String> statuses = ['Pending', 'Accepted', 'Rejected'];

  const StatusDropdown({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedStatus,
      isExpanded: true,
      items: statuses
          .map((status) => DropdownMenuItem(
        value: status,
        child: Text(status,style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),),
      ))
          .toList(),
      onChanged: (value) {
        if (value != null) onStatusChange(value);
      },
    );
  }
}
