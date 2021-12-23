import 'dart:io';
import 'package:crystal/model/stat.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfApi {

  List months =  ["Jan", "Feb", "Mar", "Apr",
    "May", "Jun", "July", "Aug", "Sept", "Oct",
    "Nov", "Dec", "Average"];

  var iaqStatus = [
    "Good Air Quality",
    "Moderate Air Quality",
    "Unhealthy Air Quality",
    "Very Unhealthy Air Quality",
    "Hazardous Air Quality"
  ];

  var iaqStatusValue = [
    "0 - 50",
    "51 - 100",
    "101 - 200",
    "201 - 300",
    "Above 300"
  ];

  DateTime now = DateTime.now();

  Future<List<int>> _readImageData(String name) async {
    final ByteData data = await rootBundle.load('assets/images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<File> generatePDF({Stat stat}) async {
    final document = PdfDocument();
    final page = document.pages.add();
    final PdfImage image =
    PdfBitmap(await _readImageData('stat2.png'));

    drawTitle(stat,page);
    drawGrid(stat,page);
    drawImage(image,page);

    return saveFile(document);
  }
  //draw stat table
  void drawGrid(Stat stat,PdfPage page){
    final grid = PdfGrid();
    grid.columns.add(count: 3);
    final headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = "Month";
    headerRow.cells[1].value = "PPM Average";
    headerRow.cells[2].value = "Status";
    headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;

    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12)
    );
    for(int i = 0; i<months.length; i ++){
      final row =grid.rows.add();
      row.cells[0].value = months[i].toString();
      if(stat.avgPPM[i]!=0){
        row.cells[1].value = stat.avgPPM[i].toString();
      }else{
        row.cells[1].value = "n/a";
      }
      row.cells[2].value = stat.avgStatus[i].toString();
    }

    //Adding padding to the table
    for(int i = 0; i<headerRow.cells.count; i++){
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for(int i=0; i<grid.rows.count; i++){
      final row = grid.rows[i];
      for(int j=0; j<row.cells.count; j++){
        row.cells[j].style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, top: 5, right: 5);
      }
    }
    grid.draw(
      page:  page,
      bounds: Rect.fromLTWH(0, 110, 0, 0)
    );
  }

  //draw title
  void drawTitle(Stat stat, PdfPage page){
  String formattedDate = DateFormat.yMMMd('en_US').format(now);
    final pageSize = page.getClientSize();
    final title = "Report: Indoor Air Quality Statistics "+stat.currentYear ;
    final subtitle = "by CRYSTAL; $formattedDate";
    final footer = '''Generated on ${DateTime.now().toString().substring(0,10)} at ${DateTime.now().toString().substring(10,19)}
    
Source: CRYSTAL (Indoor Air Quality Monitoring System)''';
    final info = '''Info:
Table below shows Indoor Air Quality (AQI) category''';

    page.graphics.drawString(
        title,
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, 50, 0, 0)
    );
    page.graphics.drawString(
        subtitle,
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, 80, 0, 0)
    );
  page.graphics.drawString(
      info,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
      bounds: Rect.fromLTWH(0, pageSize.height-240, 0, 0)
  );
    page.graphics.drawString(
        footer,
        PdfStandardFont(PdfFontFamily.helvetica, 8),
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        bounds: Rect.fromLTWH(0, pageSize.height-50, 0, 0)
    );
}

  //draw table
  void drawImage(PdfImage image,PdfPage page){
   final pageSize = page.getClientSize();
    page.graphics.drawImage(
        image,
        Rect.fromLTWH(0, pageSize.height-200, 0, 0)
    );
  }

  //save pdf document
  Future<File> saveFile(PdfDocument document) async {

    try{
      final path = (await getExternalStorageDirectory()).path;
      String name = DateTime.now().toString().replaceAll(new RegExp(r'[:\.\-]+'), "");
      final fileName = '$path' + '/$name.pdf';
      final file = File(fileName);
      file.writeAsBytes(document.save(), flush: true);
      document.dispose();
      return file;
    } catch(e){
      print(e);
    }
  }
}