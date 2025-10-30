import 'package:admin_dokter_panggil/src/source/color_style.dart';
import 'package:flutter/material.dart';

class DashboardSubFormWidget extends StatelessWidget {
  const DashboardSubFormWidget({
    super.key,
    this.title,
    this.onAdd,
    this.dataCard,
    this.errorMessage,
    this.isRacikan = false,
    this.isAdd = true,
    this.onView,
  });

  final String? title;
  final VoidCallback? onAdd;
  final Widget? dataCard;
  final String? errorMessage;
  final bool isRacikan;
  final bool isAdd;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$title',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ),
                if (onView != null)
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: IconButton(
                      onPressed: onView,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.edit_document,
                        size: 20,
                      ),
                      color: Colors.blue,
                    ),
                  ),
                if (onAdd != null)
                  const SizedBox(
                    width: 12,
                  ),
                if (onAdd != null)
                  CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: IconButton(
                      onPressed: onAdd,
                      padding: EdgeInsets.zero,
                      icon: isAdd
                          ? const Icon(Icons.add_rounded)
                          : const Icon(
                              Icons.edit_rounded,
                              size: 20,
                            ),
                      color: kGreenColor,
                    ),
                  )
              ],
            ),
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
              )
        ],
      ),
    );
  }
}
