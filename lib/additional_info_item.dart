import "package:flutter/material.dart";

class AdditionalInfoPage extends StatelessWidget {
  final IconData icon;
  final String info;
  final String value;
  const AdditionalInfoPage({
    super.key,
    required this.icon,
    required this.info,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          info,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        )
      ],
    );
  }
}
