import 'dart:io';

import 'package:datawedgeflutter/core/model/barcodes.dart';
import 'package:datawedgeflutter/core/view_model/products_view_model.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

import 'pdf_invoice_api.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class makePdf{
  ProductsViewModel productsViewModel=Get.find();
  makePdfWithInvoice(productsList) async {


    final invoiceBarcodes = InvoiceBarcodes(
      products: productsList,
    );

    final pdfFile =
        await PdfInvoiceApi.generate(invoiceBarcodes);

    PdfApi.openFile(pdfFile);

  }
}