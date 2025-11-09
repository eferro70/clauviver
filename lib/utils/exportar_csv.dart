// lib/utils/exportar_csv.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';

Future<void> exportarParaDownloads(BuildContext context) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('anamneses').get();
    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma anamnese para exportar.')),
      );
      return;
    }

    final cabecalhos = [
      'Nome', 'Data Nascimento', 'Sexo', 'Telefone', 'Queixa Principal',
      'Tem Alergia', 'Alergias', 'Doenças Crônicas', 'Cirurgias',
      'Histórico Familiar', 'Gestante', 'Observações', 'Data Registro (UTC)'
    ];

    final linhas = <List<dynamic>>[];
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final alergiasMap = data['alergias'] as Map<dynamic, dynamic>?;
      final doencasList = (data['doencas_cronicas'] as List?) ?? [];

      linhas.add([
        data['paciente_nome'] ?? '',
        data['data_nascimento'] ?? '',
        data['sexo'] ?? '',
        data['telefone'] ?? '',
        data['queixa_principal'] ?? '',
        alergiasMap?['tem_alergia'] == true ? 'Sim' : 'Não',
        alergiasMap?['descricao'] ?? '',
        doencasList.join('; '),
        data['cirurgias_anteriores'] ?? '',
        data['historico_familiar'] ?? '',
        data['gestante'] == true ? 'Sim' : 'Não',
        data['observacoes'] ?? '',
        (data['data_criacao'] as Timestamp?)?.toDate().toUtc().toIso8601String() ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert([cabecalhos, ...linhas]);
    final bytes = Uint8List.fromList(utf8.encode(csvString));

    // ✅ CORREÇÃO: Usar MimeType.csv em vez de string
    await FileSaver.instance.saveFile(
      name: 'anamneses_${DateTime.now().millisecondsSinceEpoch}.csv',
      bytes: bytes,
      mimeType: MimeType.csv, // ✅ CORRIGIDO
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ CSV salvo em Downloads!')),
    );

  } catch (e) {
    print('Erro ao salvar CSV: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar: $e')),
    );
  }
}