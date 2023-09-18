import "package:flutter/material.dart";

class HourlyForcastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const HourlyForcastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 8,
            right: 20,
            bottom: 8,
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
