// lib/screens/anamnese/anamnese_stepper_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clauviver_anamnese/models/anamnese_model.dart';
import 'widgets/section_widgets.dart';

class AnamneseStepperScreen extends StatefulWidget {
  final DocumentSnapshot? editingDoc; // null = novo registro

  const AnamneseStepperScreen({super.key, this.editingDoc});

  @override
  State<AnamneseStepperScreen> createState() => _AnamneseStepperScreenState();
}

class _AnamneseStepperScreenState extends State<AnamneseStepperScreen> {
  late AnamneseData _data;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKeys = List<GlobalKey<FormState>>.generate(9, (_) => GlobalKey());

  final List<String> _sectionTitles = [
    '1. Responsável',
    '2. Identificação do paciente',
    '3. Condições domiciliares',
    '4. Histórico de saúde',
    '5. Aspectos psicossociais',
    '6. Avaliação física',
    '7. Avaliação cognitiva',
    '8. Antes da consulta',
    '9. Após a consulta',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingDoc != null) {
      _data = AnamneseData.fromJson(widget.editingDoc!.data() as Map<String, dynamic>);
      _data.id = widget.editingDoc!.id;
    } else {
      _data = AnamneseData(
        enfermeiro: '',
        dataAtendimento: DateTime.now(),
        nomePaciente: '',
        dataNascimento: DateTime(1990),
        queixaPrincipal: '',
      );
    }
  }

  void _goToPage(int page) {
    if (page >= 0 && page < 9) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    final formKey = _formKeys[_currentPage];
    if (formKey.currentState?.validate() ?? true) {
      if (_currentPage < 8) {
        _goToPage(_currentPage + 1);
      } else {
        _salvar();
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    }
  }

  Future<void> _salvar() async {
    // Validação final de todos os formulários
    for (var key in _formKeys) {
      if (!(key.currentState?.validate() ?? true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
        );
        return;
      }
    }

    try {
      final json = _data.toJson();
      if (_data.id != null) {
        await FirebaseFirestore.instance.collection('anamneses').doc(_data.id).set(json);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Anamnese atualizada!')));
        }
      } else {
        await FirebaseFirestore.instance.collection('anamneses').add(json);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Anamnese salva com sucesso!')));
        }
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Sair sem salvar?'),
                content: const Text('Tem certeza que deseja sair? As alterações não salvas serão perdidas.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sair')),
                ],
              ),
            ) ?? false;
        return confirm;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_sectionTitles[_currentPage]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
          itemBuilder: (context, index) {
            return _buildPage(index);
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Voltar
                if (_currentPage > 0)
                  FilledButton.tonal(
                    onPressed: _prevPage,
                    child: const Text('Anterior'),
                  ),
                if (_currentPage == 0) const Spacer(),

                // Botão Próximo ou Salvar
                FilledButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage == 8 ? 'Salvar' : 'Próximo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0: return Section1Responsavel(formKey: _formKeys[0], data: _data);
      case 1: return Section2Identificacao(formKey: _formKeys[1], data: _data);
      case 2: return Section3CondicoesDomiciliares(formKey: _formKeys[2], data: _data);
      case 3: return Section4HistoricoSaude(formKey: _formKeys[3], data: _data);
      case 4: return Section5AspectosPsicossociais(formKey: _formKeys[4], data: _data);
      case 5: return Section6AvaliacaoFisica(formKey: _formKeys[5], data: _data);
      case 6: return Section7AvaliacaoCognitiva(formKey: _formKeys[6], data: _data);
      case 7: return Section8AntesConsulta(formKey: _formKeys[7], data: _data);
      case 8: return Section9AposConsulta(formKey: _formKeys[8], data: _data);
      default: return const SizedBox();
    }
  }
}