import 'dart:io';
import 'dart:typed_data';
import 'package:helper_app/core/models/boss_panel/boss_panel_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Обязательный импорт для шрифтов
import '../utils/logger.dart';

class PdfExportService {
  // В файл lib/core/services/pdf_export_service.dart добавь:
static Future<void> exportPositionLabels(List<PositionCellDto> positions) async {
  final pdf = pw.Document();
  final font = await PdfGoogleFonts.robotoRegular();

  // Группируем по 12 штук на страницу (сетка 3x4)
  for (var i = 0; i < positions.length; i += 12) {
    final chunk = positions.skip(i).take(12).toList();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
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
                      data: pos.  , // В QR зашиваем полное имя
                      width: 100,
                      height: 100,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(pos.fullName, 
                      style: pw.TextStyle(font: font, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(pos.firstLevelStorageType, 
                      style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  final bytes = await pdf.save();
  final directory = await getExternalStorageDirectory();
  final file = File("${directory!.path}/Labels_${DateTime.now().millisecondsSinceEpoch}.pdf");
  await file.writeAsBytes(bytes);
  await OpenFilex.open(file.path);
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
                  child: pw.Text("TASK CONTROL", 
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.purple)),
                ),
                pw.SizedBox(height: 20),
                pw.Text("Сотрудник: $fullName", style: const pw.TextStyle(fontSize: 10)),
                pw.Text("Должность: $role", style: const pw.TextStyle(fontSize: 10)),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 10),
                pw.Text("ДАННЫЕ ДЛЯ ВХОДА:", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text("Логин: $login", style: const pw.TextStyle(fontSize: 11)),
                pw.Text("Пароль: $password", style: const pw.TextStyle(fontSize: 11)),
                pw.Spacer(),
                pw.Text("Сгенерировано: ${DateTime.now().toString().split('.')[0]}", 
                  style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey)),
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
}