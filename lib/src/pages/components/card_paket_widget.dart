import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class CardPaketWidget extends StatelessWidget {
  const CardPaketWidget({
    super.key,
    required this.title,
    this.onTap,
    this.data,
    this.isButton = true,
  });

  final String title;
  final VoidCallback? onTap;
  final Widget? data;
  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0,
          offset: Offset(2.0, 2.0),
        )
      ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isButton)
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    radius: 18.0,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onTap,
                        icon: const Icon(
                          Icons.add_rounded,
                          color: kPrimaryColor,
                        )),
                  )
                else
                  const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    radius: 18.0,
                  )
              ],
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Divider(
            height: 0.0,
            color: Colors.grey[400],
          ),
          if (data == null) _errorDataWidget(context),
          data ?? const SizedBox(),
        ],
      ),
    );
  }

  Widget _errorDataWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        'Data tidak tersedia',
        style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16.0,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}
