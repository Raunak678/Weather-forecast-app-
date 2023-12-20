import 'package:flutter/material.dart';

class Additionalinformation extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;

  const Additionalinformation(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  State<Additionalinformation> createState() => _AdditionalinformationState();
}

class _AdditionalinformationState extends State<Additionalinformation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
            ),
            const SizedBox(height: 8),
            Icon(widget.icon, size: 32),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(widget.value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
