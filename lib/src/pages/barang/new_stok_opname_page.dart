import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewStokOpnamePage extends StatefulWidget {
  const NewStokOpnamePage({super.key});

  @override
  State<NewStokOpnamePage> createState() => _NewStokOpnamePageState();
}

class _NewStokOpnamePageState extends State<NewStokOpnamePage> {
  final _filter = TextEditingController();
  final _controller = ScrollController();
  bool _showFab = true;

  void _createStokOpname() {
    //
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(2.0, 1.0),
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 18,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Stok Opname',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SearchInputForm(
                    controller: _filter,
                    hint: 'Pencarian stok opname',
                    suffixIcon: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey[300],
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        iconSize: 18,
                        color: Colors.black38,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _showFab ? 1 : 0,
            child: FloatingActionButton(
              onPressed: _createStokOpname,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
