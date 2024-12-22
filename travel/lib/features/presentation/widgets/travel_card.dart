import 'package:flutter/material.dart';

class TravelCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onMorePressed;
  final VoidCallback? onDeletePressed;

  const TravelCard({super.key, 
    required this.title,
    required this.date,
    required this.onMorePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(date),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onMorePressed,
                child: const Text('Детальніше'),
              ),
              if (onDeletePressed != null)
                TextButton(
                  onPressed: onDeletePressed,
                  child: const Text('Видалити'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
