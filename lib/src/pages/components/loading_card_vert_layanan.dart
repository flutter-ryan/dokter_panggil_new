import 'package:dokter_panggil/src/pages/components/loading_shimmer.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class LoadingCardVertLayanan extends StatelessWidget {
  const LoadingCardVertLayanan({
    super.key,
    this.itemCount = 3,
    this.padding = EdgeInsets.zero,
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        shrinkWrap: true,
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => Container(
          width: SizeConfig.blockSizeHorizontal * 42,
          padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 28.0,
                ),
                title: const Align(
                  alignment: Alignment.centerRight,
                  child: LoadingShimmer(width: 80, height: 10),
                ),
                subtitle: const Align(
                  alignment: Alignment.centerRight,
                  child: LoadingShimmer(width: 30, height: 8),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingShimmer(width: 80, height: 10),
                  SizedBox(
                    height: 8.0,
                  ),
                  LoadingShimmer(width: 150, height: 10),
                ],
              ),
              const LoadingShimmer(width: double.infinity, height: 42)
            ],
          ),
        ),
        separatorBuilder: (context, i) => const SizedBox(
          width: 12.0,
        ),
        itemCount: itemCount,
      ),
    );
  }
}
