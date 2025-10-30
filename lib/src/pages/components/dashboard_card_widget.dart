import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class DashboardCardWidget extends StatelessWidget {
  const DashboardCardWidget({
    super.key,
    this.title,
    this.onAdd,
    this.dataCard,
    this.errorMessage,
    this.isRacikan = false,
    this.isBhp = false,
  });

  final String? title;
  final VoidCallback? onAdd;
  final Widget? dataCard;
  final String? errorMessage;
  final bool isRacikan;
  final bool isBhp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$title',
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              onAdd != null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: IconButton(
                        onPressed: onAdd,
                        padding: EdgeInsets.zero,
                        icon: dataCard == null || isRacikan || isBhp
                            ? const Icon(Icons.add_rounded)
                            : const Icon(
                                Icons.edit_rounded,
                                size: 20,
                              ),
                        color: kGreenColor,
                      ),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                    ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          color: Colors.grey,
        ),
        dataCard ??
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Text(
                  '$errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
