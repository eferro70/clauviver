import '../utils/exportar_csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaListaAnamneses extends StatelessWidget {
  const TelaListaAnamneses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamneses Salvas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () async {
              await exportarParaDownloads(context);
            },
          ),
        ],
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
              final nome = doc['paciente_nome'] ?? 'Sem nome';
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
                      builder: (context) => TelaDetalhesAnamnese(document: doc),
                    ),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await exportarParaDownloads(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaDetalhesAnamnese extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> document;

  const TelaDetalhesAnamnese({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>;

    String boolParaTexto(bool? valor) => valor == true ? 'Sim' : 'Não';

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Anamnese')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _campo('Nome', data['paciente_nome']),
            _campo('Data de nascimento', data['data_nascimento']),
            _campo('Sexo', data['sexo']),
            _campo('Telefone', data['telefone'] ?? 'Não informado'),
            _campo('Queixa principal', data['queixa_principal']),
            _campo('Medicamentos em uso', data['historico_medicamentos'] ?? 'Nenhum'),
            if ((data['alergias'] as Map?)?['tem_alergia'] == true)
              _campo('Alergias', (data['alergias'] as Map?)?['descricao'] ?? 'Não especificado'),
            _campo('Doenças crônicas', (data['doencas_cronicas'] as List?)?.join(', ') ?? 'Nenhuma'),
            _campo('Cirurgias anteriores', data['cirurgias_anteriores'] ?? 'Nenhuma'),
            _campo('Histórico familiar', data['historico_familiar'] ?? 'Não informado'),
            if (data['sexo'] == 'feminino')
              _campo('Gestante', boolParaTexto(data['gestante'])),
            _campo('Observações', data['observacoes'] ?? 'Nenhuma'),
          ],
        ),
      ),
    );
  }

  Widget _campo(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valor ?? '—'),
        ],
      ),
    );
  }
}