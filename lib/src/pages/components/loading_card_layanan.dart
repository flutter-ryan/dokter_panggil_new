import 'package:admin_dokter_panggil/src/pages/components/loading_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingCardLayanan extends StatelessWidget {
  const LoadingCardLayanan({
    super.key,
    this.itemCount = 3,
    this.padding = EdgeInsets.zero,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: LoadingShimmer(
                width: 120,
                height: 12,
              ),
              subtitle: LoadingShimmer(
                width: 180,
                height: 10,
              ),
            ),
            Divider(
              height: 0.0,
              color: Colors.grey[400],
            ),
            const SizedBox(
              height: 12.0,
            ),
            const LoadingShimmer(width: 100, height: 10),
            const SizedBox(
              height: 4.0,
            ),
            const LoadingShimmer(width: double.infinity, height: 12),
            const SizedBox(
              height: 12.0,
            ),
            const LoadingShimmer(width: 100, height: 10),
            const SizedBox(
              height: 4.0,
            ),
            const LoadingShimmer(width: double.infinity, height: 12),
            const SizedBox(
              height: 18.0,
            )
          ],
        ),
      ),
      separatorBuilder: (context, i) => const SizedBox(
        height: 15.0,
      ),
      itemCount: itemCount,
    );
  }
}
