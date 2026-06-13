import 'dart:io';
import 'dart:typed_data';
import 'package:helper_app/core/models/inventory/position_cell_dto.dart';
import 'package:helper_app/core/models/item/item_dto.dart';
import 'package:helper_app/core/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Обязательный импорт для шрифтов
import 'package:path/path.dart' as p;

class PdfExportService {
  
  static Future<void> exportPositionLabels(List<PositionCellDto> positions) async {
    final pdf = pw.Document();

    // 1. Загружаем шрифты Roboto (они поддерживают кириллицу)
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // Заранее создаем стили с указанием шрифта, чтобы избежать ошибки Courier
    final labelStyle = pw.TextStyle(font: fontBold, fontSize: 14);
    final captionStyle = pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey700);

    // Группируем по 12 штук на страницу
    for (var i = 0; i < positions.length; i += 12) {
      final chunk = positions.skip(i).take(12).toList();
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          // 2. Устанавливаем тему со шрифтами для ВСЕЙ страницы
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: 3,
              childAspectRatio: 1,
              children: chunk.map((pos) {
                return pw.Container(
                  margin: const pw.EdgeInsets.all(10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data: pos.fullName, 
                      width: 70, // Было 100. Уменьшаем, чтобы дать место тексту!
                      height: 70, // Было 100.
                      drawText: false,
                    ),
                    pw.SizedBox(height: 8),
                    pw.FittedBox( // Масштабирует текст, чтобы он точно влез в ширину
                      child: pw.Text(
                        pos.fullName, 
                        style: labelStyle,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      pos.firstLevelStorageType, 
                      style: captionStyle,
                    ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }

    // Сохранение и открытие файла...
    try {
      final bytes = await pdf.save();
      Directory? directory;

      // Выбираем директорию в зависимости от платформы
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory(); 
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) throw Exception("Не удалось получить доступ к хранилищу");

      final fileName = "Labels_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final filePath = p.join(directory.path, fileName);
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      
      // Открываем файл
      await OpenFilex.open(filePath);
      
    } catch (e) {
      print("Ошибка сохранения: $e");
    }
  }
  
  static Future<void> exportWorkerCredentials({
    required String fullName,
    required String role,
    required String login,
    required String password,
  }) async {
    final pdf = pw.Document();

    // 1. Загружаем шрифты с поддержкой кириллицы
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // Заранее создаем стили, передавая загруженные шрифты
    final titleStyle = pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColors.purple);
    final normalStyle = pw.TextStyle(font: fontRegular, fontSize: 10);
    final headerStyle = pw.TextStyle(font: fontBold, fontSize: 11);
    final credsStyle = pw.TextStyle(font: fontRegular, fontSize: 11);
    final dateStyle = pw.TextStyle(font: fontRegular, fontSize: 7, color: PdfColors.grey);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        // 2. Применяем шрифты ко всей странице
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        ),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.purple, width: 2),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text("TASK CONTROL", style: titleStyle),
                ),
                pw.SizedBox(height: 20),
                pw.Text("Сотрудник: $fullName", style: normalStyle),
                pw.Text("Должность: $role", style: normalStyle),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 10),
                pw.Text("ДАННЫЕ ДЛЯ ВХОДА:", style: headerStyle),
                pw.SizedBox(height: 5),
                pw.Text("Логин: $login", style: credsStyle),
                pw.Text("Пароль: $password", style: credsStyle),
                pw.Spacer(),
                pw.Text(
                  "Сгенерировано: ${DateTime.now().toString().split('.')[0]}", 
                  style: dateStyle,
                ),
              ],
            ),
          );
        },
      ),
    );

    try {
      final Uint8List bytes = await pdf.save();

      final Directory? directory = Platform.isAndroid 
          ? await getExternalStorageDirectory() 
          : await getApplicationDocumentsDirectory();
      
      if (directory == null) throw Exception("Не удалось найти директорию для сохранения");

      final String fileName = "Access_${login}_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final String filePath = "${directory.path}/$fileName";

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      Logger.i("PDF сохранен по пути: $filePath");

      await OpenFilex.open(filePath);

    } catch (e) {
      Logger.e("Ошибка при сохранении PDF", e);
      rethrow;
    }
  }

  // Экспорт штрих-кодов выбранных товаров в PDF
  static Future<void> exportItemBarcodes(List<ItemDto> items) async {
    final pdf = pw.Document();
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final labelStyle = pw.TextStyle(font: fontBold, fontSize: 10);
    final codeStyle = pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey700);

    for (var i = 0; i < items.length; i += 12) {
      final chunk = items.skip(i).take(12).toList();
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
          build: (pw.Context context) {
            return pw.GridView(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              children: chunk.map((item) {
                return pw.Container(
                  margin: const pw.EdgeInsets.all(8),
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        item.name,
                        style: labelStyle,
                        maxLines: 2,
                        textAlign: pw.TextAlign.center,
                        overflow: pw.TextOverflow.clip,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Expanded(
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: item.barcode.isNotEmpty ? item.barcode : '000000000000',
                          drawText: false,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        item.barcode.isNotEmpty ? item.barcode : '000000000000',
                        style: codeStyle,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }

    try {
      final bytes = await pdf.save();
      final Directory? directory = Platform.isAndroid 
          ? await getExternalStorageDirectory() 
          : await getApplicationDocumentsDirectory();
      
      if (directory == null) throw Exception("Не удалось получить доступ к хранилищу");

      final fileName = "Barcodes_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final filePath = p.join(directory.path, fileName);
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      await OpenFilex.open(filePath);
    } catch (e) {
      Logger.e("Ошибка экспорта штрих-кодов: $e");
    }
  }
}