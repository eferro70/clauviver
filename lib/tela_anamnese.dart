import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaAnamnese extends StatefulWidget {
  const TelaAnamnese({super.key});

  @override
  State<TelaAnamnese> createState() => _TelaAnamneseState();
}

class _TelaAnamneseState extends State<TelaAnamnese> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _queixaController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _cirurgiasController = TextEditingController();
  final _historicoFamiliarController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime? _dataNascimento;
  String? _sexo;
  bool _temAlergia = false;
  final _alergiaController = TextEditingController();
  List<String> _doencasSelecionadas = [];
  bool _gestante = false;

  final List<String> _sexos = ['masculino', 'feminino', 'outro', 'prefiro não informar'];
  final List<String> _doencasCronicas = [
    'Hipertensão',
    'Diabetes',
    'Asma',
    'Doença cardíaca',
    'Doença renal',
    'Câncer',
    'Outra'
  ];

  bool _salvando = false;

  Future<void> _selecionarDataNascimento() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) {
      setState(() => _dataNascimento = data);
    }
  }

  Future<void> _salvarAnamnese() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de nascimento')),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final data = {
        'paciente_nome': _nomeController.text.trim(),
        'data_nascimento': _dataNascimento!.toIso8601String().split('T')[0],
        'sexo': _sexo,
        'telefone': _telefoneController.text.trim(),
        'queixa_principal': _queixaController.text.trim(),
        'historico_medicamentos': _medicamentosController.text.trim(),
        'alergias': {
          'tem_alergia': _temAlergia,
          'descricao': _temAlergia ? _alergiaController.text.trim() : '',
        },
        'doencas_cronicas': _doencasSelecionadas,
        'cirurgias_anteriores': _cirurgiasController.text.trim(),
        'historico_familiar': _historicoFamiliarController.text.trim(),
        'gestante': _gestante,
        'observacoes': _observacoesController.text.trim(),
        'data_criacao': FieldValue.serverTimestamp(),
        'origem': 'tablet_clauviver',
      };

      await FirebaseFirestore.instance.collection('anamneses').add(data);

      // Limpar campos
      _nomeController.clear();
      _telefoneController.clear();
      _queixaController.clear();
      _medicamentosController.clear();
      _alergiaController.clear();
      _cirurgiasController.clear();
      _historicoFamiliarController.clear();
      _observacoesController.clear();
      _dataNascimento = null;
      _sexo = null;
      _temAlergia = false;
      _doencasSelecionadas.clear();
      _gestante = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Anamnese salva com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Anamnese')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome completo *'),
                validator: (v) => v!.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              // Data de nascimento
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento *',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _selecionarDataNascimento,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        _dataNascimento == null
                            ? 'Selecione'
                            : '${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sexo
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo *'),
                items: _sexos.map((sexo) {
                  return DropdownMenuItem(value: sexo, child: Text(sexo));
                }).toList(),
                onChanged: (value) => setState(() => _sexo = value),
                validator: (v) => v == null ? 'Selecione o sexo' : null,
              ),
              const SizedBox(height: 12),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone (opcional)'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),

              // Queixa principal
              TextFormField(
                controller: _queixaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Queixa principal *',
                  hintText: 'Ex: Dor de cabeça há 3 dias',
                ),
                validator: (v) => v!.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 12),

              // Alergias
              CheckboxListTile(
                title: const Text('Tem alergia?'),
                value: _temAlergia,
                onChanged: (value) => setState(() => _temAlergia = value!),
              ),
              if (_temAlergia)
                TextFormField(
                  controller: _alergiaController,
                  decoration: const InputDecoration(
                    labelText: 'Descreva as alergias *',
                    hintText: 'Ex: Penicilina, amendoim',
                  ),
                  validator: (v) =>
                      _temAlergia && v!.trim().isEmpty ? 'Descreva a alergia' : null,
                ),
              const SizedBox(height: 12),

              // Doenças crônicas
              const Text('Doenças crônicas conhecidas:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._doencasCronicas.map((doenca) {
                return CheckboxListTile(
                  title: Text(doenca),
                  value: _doencasSelecionadas.contains(doenca),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        _doencasSelecionadas.add(doenca);
                      } else {
                        _doencasSelecionadas.remove(doenca);
                      }
                    });
                  },
                );
              }),
              const SizedBox(height: 12),

              // Gestante (só se sexo == feminino)
              if (_sexo == 'feminino')
                CheckboxListTile(
                  title: const Text('Gestante?'),
                  value: _gestante,
                  onChanged: (value) => setState(() => _gestante = value!),
                ),

              // Histórico médico
              TextFormField(
                controller: _medicamentosController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Medicamentos em uso',
                  hintText: 'Ex: Losartana 50mg, 1x/dia',
                ),
              ),
              TextFormField(
                controller: _cirurgiasController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Cirurgias anteriores',
                ),
              ),
              TextFormField(
                controller: _historicoFamiliarController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Histórico familiar relevante',
                ),
              ),
              TextFormField(
                controller: _observacoesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                ),
              ),
              const SizedBox(height: 24),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvarAnamnese,
                  icon: _salvando
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: _salvando
                      ? const Text('Salvando...')
                      : const Text('Salvar Anamnese'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}