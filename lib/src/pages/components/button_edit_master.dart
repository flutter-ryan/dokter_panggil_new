import 'package:flutter/material.dart';

class ButtonEditMaster extends StatelessWidget {
  const ButtonEditMaster({
    super.key,
    this.update,
    this.delete,
    this.batal,
  });

  final VoidCallback? delete;
  final VoidCallback? update;
  final VoidCallback? batal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: delete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: update,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Update'),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: batal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
