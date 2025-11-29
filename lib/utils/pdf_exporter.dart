// lib/utils/pdf_exporter.dart

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:clauviver_anamnese/models/anamnese_model.dart';

class PDFExporter {
  static String _formatarData(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static Future<Uint8List> gerarPDF(AnamneseData data) async {
    final pdf = pw.Document();

    pw.Widget _campo(String label, String valor) {
      if (valor.isEmpty) return pw.SizedBox();
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(valor),
          ],
        ),
      );
    }

    String _simNao(bool? valor) => valor == true ? 'Sim' : valor == false ? 'Não' : '–';
    String _lista(List<String> itens) => itens.isEmpty ? 'Nenhum' : itens.join(', ');

    // Capa
    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('ClauViver – Anamnese', style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 10),
            pw.Text('Paciente: ${data.nomePaciente}'),
            pw.Text('Idade: ${data.idade} anos'),
            pw.Text('Data: ${_formatarData(data.dataAtendimento)}'),
          ],
        ),
      ),
    ));

    // Corpo (simplificado para compilar)
    pdf.addPage(pw.MultiPage(
      build: (context) => <pw.Widget>[
        pw.Header(text: '1. Identificação'),
        _campo('Nome', data.nomePaciente),
        _campo('Data de nascimento', _formatarData(data.dataNascimento)),
        if (data.sexo != null) _campo('Sexo', data.sexo!),
        _campo('Telefone', data.telefone),

        pw.Header(text: '2. Histórico de Saúde'),
        _campo('Queixa principal', data.queixaPrincipal),
        _campo('Medicamentos', data.medicamentos),
        _campo('Alergias', data.temAlergia ? (data.alergiaDescricao.isEmpty ? 'Sim' : data.alergiaDescricao) : 'Não'),
      ],
    ));

    return pdf.save();
  }
}