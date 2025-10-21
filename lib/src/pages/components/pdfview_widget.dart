import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfviewWidget extends StatefulWidget {
  const PdfviewWidget({
    super.key,
    this.url,
  });

  final String? url;

  @override
  State<PdfviewWidget> createState() => _PdfviewWidgetState();
}

class _PdfviewWidgetState extends State<PdfviewWidget> {
  bool _isLoading = true;
  PDFDocument? _doc;

  @override
  void initState() {
    super.initState();
    _getDocument();
  }

  void _getDocument() async {
    PDFDocument doc = await PDFDocument.fromURL(widget.url!);
    setState(() {
      _doc = doc;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: _isLoading
              ? _loadingWidget(context)
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: PDFViewer(
                        document: _doc!,
                        showNavigation: false,
                        showPicker: false,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 22,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _loadingWidget(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: LoadingKit(
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
