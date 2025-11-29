// lib/tela_lista_anamneses.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clauviver_anamnese/models/anamnese_model.dart';
import 'package:clauviver_anamnese/utils/pdf_exporter.dart';
import 'package:printing/printing.dart';
import 'screens/anamnese/anamnese_stepper_screen.dart';

class TelaListaAnamneses extends StatelessWidget {
  const TelaListaAnamneses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamneses Salvas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('anamneses')
            .orderBy('data_criacao', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma anamnese registrada.'));
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final paciente = (doc['paciente'] as Map?) ?? {};
              final nome = paciente['nome'] ?? 'Sem nome';
              final data = (doc['data_criacao'] as Timestamp?)?.toDate();
              final dataStr = data != null
                  ? '${data.day}/${data.month}/${data.year}'
                  : 'Data inválida';

              return ListTile(
                title: Text(nome),
                subtitle: Text('Registrado em: $dataStr'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnamneseStepperScreen(editingDoc: doc),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      onPressed: () async {
                        try {
                          final dataModel = AnamneseData.fromJson(doc.data() as Map<String, dynamic>);
                          final bytes = await PDFExporter.gerarPDF(dataModel);
                          await Printing.sharePdf(
                            bytes: bytes,
                            filename: 'anamnese_${dataModel.nomePaciente.replaceAll(RegExp(r'\s+'), '_')}.pdf',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao gerar PDF: $e')),
                          );
                        }
                      },
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}