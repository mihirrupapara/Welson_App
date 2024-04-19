import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class BrochurePage extends StatefulWidget {
  const BrochurePage({Key? key}) : super(key: key);

  @override
  State<BrochurePage> createState() => _BrochurePageState();
}

class _BrochurePageState extends State<BrochurePage> {
  PdfControllerPinch? pdfControllerPinch;
  int totalPageCount = 0, currentPage = 1;
  bool loadingError = false;

  @override
  void initState() {
    super.initState();
    _loadPdfDocument();
  }

  Future<void> _loadPdfDocument() async {
    try {
      var pdfDocument = await PdfDocument.openAsset('assets/brochure.pdf');
      pdfControllerPinch =
          PdfControllerPinch(document: Future.value(pdfDocument));
      setState(() {
        loadingError = false;
        totalPageCount = pdfDocument.pagesCount;
      });
    } catch (e) {
      print("Error loading PDF: $e");
      setState(() {
        loadingError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingError ? _buildErrorUI() : _buildUI(),
    );
  }

  Widget _buildUI() {
    return pdfControllerPinch != null
        ? SingleChildScrollView(
            child: Column(
              children: [
                _pdfView(),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Text(
        'Error loading PDF',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _pdfView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: PdfViewPinch(
        controller: pdfControllerPinch!,
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BrochurePage(),
  ));
}
