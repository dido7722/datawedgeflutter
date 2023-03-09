import 'dart:io';
import 'package:datawedgeflutter/core/model/barcodes.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(InvoiceBarcodes invoiceBarcodes) async {
    var ttf = pw.Font.ttf(await rootBundle.load("fonts/Mirza-Regular.ttf"));

    final pdf = pw.Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: PageOrientation.landscape,

      maxPages: 100,
      theme: ThemeData.withFont(
        base: ttf,
      ),
      build: (context) => [
        Directionality(
          textDirection: TextDirection.rtl,
          child: buildInvoice(invoiceBarcodes),
        )
      ],
    ));

    String kundNameOrder = 'barcode';

    return PdfApi.saveDocument(name: '$kundNameOrder.pdf', pdf: pdf);
  }

  static Widget buildInvoice(InvoiceBarcodes invoice) {
    return Wrap(
      children: List.generate(invoice.products.length, (index) {
        return Padding(
          padding: EdgeInsets.all(10),
          child:
          Container(
            width: PdfPageFormat.a4.width/2,
          height: PdfPageFormat.a4.height/4,
          child:Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(invoice.products[index].names[1],maxLines: 2,
                style: TextStyle(fontSize: 25,),textAlign: TextAlign.center,),
            pw.Text(
                (invoice.products[index].size[1] == 'Weight')
                    ? '-'
                    : invoice.products[index].size[1],
                style: TextStyle(fontSize: 25)),
            Container(
              height: 135,
              // color: PdfColor.fromInt(0xfff9535c),
              width: 250,
              child: BarcodeWidget(
                  // height: 200,
                  // width: 200,
                  barcode: Barcode.code128(),
                  data: invoice.products[index].idAmeen,
                  textStyle: TextStyle(fontSize: 25)),
            ),
          ]),),
        );
      }),
    );
  }
}
