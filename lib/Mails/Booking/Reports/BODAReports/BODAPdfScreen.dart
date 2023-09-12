
import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:share/share.dart';

class BODAPdfScreen extends StatefulWidget {
  final String path;

  const BODAPdfScreen({Key? key, required this.path}) : super(key: key);

  @override
  _BODAPdfScreenState createState() => _BODAPdfScreenState();
}

class _BODAPdfScreenState extends State<BODAPdfScreen> {
  late PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.kPrimaryColor,
        onPressed: () {
          Share.shareFiles([widget.path]);
        },
        child: const Icon(Icons.share),
      ),
      body: PdfView(
        documentLoader: const Center(child: CircularProgressIndicator()),
        pageLoader: const Center(child: CircularProgressIndicator()),
        controller: _pdfController,
      ),
    );
  }
}
