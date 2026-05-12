import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfExportService {
  static Future<void> exportWorkerCredentials({
    required String fullName,
    required String role,
    required String login,
    required String password,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6, // Маленький формат, удобно печатать как бейдж
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
                pw.Text("Сотрудник: $fullName", style: const pw.TextStyle(fontSize: 12)),
                pw.Text("Должность: $role", style: const pw.TextStyle(fontSize: 12)),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text("ДАННЫЕ ДЛЯ ВХОДА:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text("Логин: $login"),
                pw.Text("Пароль: $password"),
                pw.Spacer(),
                pw.Text("Сгенерировано автоматически системой управления складом", 
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    // Сразу открываем предпросмотр и печать
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}