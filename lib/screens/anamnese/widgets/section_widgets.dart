// lib/screens/anamnese/widgets/section_widgets.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clauviver_anamnese/models/anamnese_model.dart';

// =============== SESSÃO 1: Responsável ===============
class Section1Responsavel extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section1Responsavel({super.key, required this.formKey, required this.data});

  @override
  State<Section1Responsavel> createState() => _Section1ResponsavelState();
}

class _Section1ResponsavelState extends State<Section1Responsavel> {
  final _enfermeiroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _enfermeiroController.text = widget.data.enfermeiro;
    if (widget.data.dataAtendimento == DateTime(1990)) {
      widget.data.dataAtendimento = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _enfermeiroController,
              decoration: const InputDecoration(labelText: 'Enfermeiro(a) *'),
              onChanged: (v) => widget.data.enfermeiro = v,
              validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
            _buildDatePickerRow(
              context, // ✅ Context adicionado
              'Data do atendimento *',
              widget.data.dataAtendimento,
              (date) => widget.data.dataAtendimento = date!,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 2: Identificação do paciente ===============
class Section2Identificacao extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section2Identificacao({super.key, required this.formKey, required this.data});

  @override
  State<Section2Identificacao> createState() => _Section2IdentificacaoState();
}

class _Section2IdentificacaoState extends State<Section2Identificacao> {
  final _nomeController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _religiaoController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _telefoneController = TextEditingController();

  static const List<String> _sexos = ['masculino', 'feminino', 'outro', 'prefiro não informar'];
  static const List<String> _estadosCivis = ['solteiro(a)', 'casado(a)', 'divorciado(a)', 'viúvo(a)', 'união estável'];
  static const List<String> _escolaridades = [
    'nenhuma',
    'fundamental incompleto',
    'fundamental completo',
    'médio incompleto',
    'médio completo',
    'superior incompleto',
    'superior completo',
    'pós-graduação',
    'mestrado',
    'doutorado'
  ];

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.data.nomePaciente;
    _profissaoController.text = widget.data.profissao;
    _enderecoController.text = widget.data.endereco;
    _religiaoController.text = widget.data.religiao;
    _responsavelController.text = widget.data.responsavel;
    _telefoneController.text = widget.data.telefone;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome completo *'),
              onChanged: (v) => widget.data.nomePaciente = v,
              validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
            _buildDatePickerRow(
              context, // ✅ Context adicionado
              'Data de nascimento *',
              widget.data.dataNascimento,
              (date) => widget.data.dataNascimento = date!,
            ),
            const SizedBox(height: 12),
            Text('Idade: ${widget.data.idade} anos', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDropdown(
              'Sexo *',
              _sexos,
              widget.data.sexo,
              (v) => widget.data.sexo = v,
            ),
            const SizedBox(height: 12),
            _buildDropdown('Estado civil', _estadosCivis, widget.data.estadoCivil, (v) => widget.data.estadoCivil = v),
            const SizedBox(height: 12),
            _buildDropdown('Escolaridade', _escolaridades, widget.data.escolaridade, (v) => widget.data.escolaridade = v),
            const SizedBox(height: 12),
            TextFormField(controller: _profissaoController, decoration: const InputDecoration(labelText: 'Profissão'), onChanged: (v) => widget.data.profissao = v),
            TextFormField(controller: _enderecoController, decoration: const InputDecoration(labelText: 'Endereço'), onChanged: (v) => widget.data.endereco = v),
            TextFormField(controller: _religiaoController, decoration: const InputDecoration(labelText: 'Religião (opcional)'), onChanged: (v) => widget.data.religiao = v),
            TextFormField(controller: _responsavelController, decoration: const InputDecoration(labelText: 'Responsável'), onChanged: (v) => widget.data.responsavel = v),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
              onChanged: (v) => widget.data.telefone = v,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 3: Condições domiciliares ===============
class Section3CondicoesDomiciliares extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section3CondicoesDomiciliares({super.key, required this.formKey, required this.data});

  @override
  State<Section3CondicoesDomiciliares> createState() => _Section3CondicoesDomiciliaresState();
}

class _Section3CondicoesDomiciliaresState extends State<Section3CondicoesDomiciliares> {
  final _alimentacaoController = TextEditingController();
  final _ingestaoHidricaController = TextEditingController();
  final _sonoController = TextEditingController();
  final _outroDispositivoController = TextEditingController();

  static const List<String> _habitacoes = ['casa', 'apartamento'];
  static const List<String> _adaptacoes = ['nenhuma', 'acesso', 'banheiro'];
  static const List<String> _dispositivos = ['nenhuma', 'bengala', 'andador', 'cadeira de rodas', 'outro'];

  @override
  void initState() {
    super.initState();
    _alimentacaoController.text = widget.data.alimentacao;
    _ingestaoHidricaController.text = widget.data.ingestaoHidrica;
    _sonoController.text = widget.data.sono;
    _outroDispositivoController.text = widget.data.outroDispositivo;
  }

  void _toggleAdaptacao(String item) {
    setState(() {
      if (item == 'nenhuma') {
        if (widget.data.adaptacoes.contains('nenhuma')) {
          widget.data.adaptacoes = [];
        } else {
          widget.data.adaptacoes = ['nenhuma'];
        }
      } else {
        final newSet = List<String>.from(widget.data.adaptacoes)..remove('nenhuma');
        if (newSet.contains(item)) {
          newSet.remove(item);
        } else {
          newSet.add(item);
        }
        widget.data.adaptacoes = newSet;
      }
    });
  }

  void _toggleDispositivo(String item) {
    setState(() {
      if (item == 'nenhuma') {
        if (widget.data.dispositivos.contains('nenhuma')) {
          widget.data.dispositivos = [];
        } else {
          widget.data.dispositivos = ['nenhuma'];
        }
      } else {
        final newSet = List<String>.from(widget.data.dispositivos)..remove('nenhuma');
        if (newSet.contains(item)) {
          newSet.remove(item);
        } else {
          newSet.add(item);
        }
        widget.data.dispositivos = newSet;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown('Habitação', _habitacoes, widget.data.tipoHabitacao, (v) => widget.data.tipoHabitacao = v),
            const SizedBox(height: 12),
            _buildYesNoRow('Animais no ambiente?', widget.data.temAnimais, (v) => widget.data.temAnimais = v),
            const SizedBox(height: 12),
            const Text('Adaptações:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._adaptacoes.map((item) => CheckboxListTile(
                title: Text(item),
                value: widget.data.adaptacoes.contains(item),
                onChanged: (v) => _toggleAdaptacao(item),
            )),
            const SizedBox(height: 12),
            const Text('Dispositivos:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._dispositivos.map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.data.dispositivos.contains(item),
                  onChanged: (v) => _toggleDispositivo(item),
                )),
            if (widget.data.dispositivos.contains('outro')) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _outroDispositivoController,
                decoration: const InputDecoration(labelText: 'Especifique'),
                onChanged: (v) => widget.data.outroDispositivo = v,
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(controller: _alimentacaoController, decoration: const InputDecoration(labelText: 'Alimentação'), onChanged: (v) => widget.data.alimentacao = v),
            TextFormField(controller: _ingestaoHidricaController, decoration: const InputDecoration(labelText: 'Ingestão hídrica'), onChanged: (v) => widget.data.ingestaoHidrica = v),
            _buildYesNoRow('Faz uso de álcool?', widget.data.usaAlcool, (v) => widget.data.usaAlcool = v),
            TextFormField(controller: _sonoController, decoration: const InputDecoration(labelText: 'Qualidade do sono'), onChanged: (v) => widget.data.sono = v),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 4: Histórico de saúde ===============
class Section4HistoricoSaude extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section4HistoricoSaude({super.key, required this.formKey, required this.data});

  @override
  State<Section4HistoricoSaude> createState() => _Section4HistoricoSaudeState();
}

class _Section4HistoricoSaudeState extends State<Section4HistoricoSaude> {
  final _queixaController = TextEditingController();
  final _periodoController = TextEditingController();
  final _doencasAtuaisController = TextEditingController();
  final _outrasDoencasController = TextEditingController();
  final _cirurgiasController = TextEditingController();
  final _internacoesController = TextEditingController();
  final _alergiaDescricaoController = TextEditingController();
  final _medicamentosController = TextEditingController();

  static const List<String> _doencasComuns = [
    'Hipertensão',
    'Diabetes',
    'Asma',
    'Doença cardíaca',
    'Doença renal',
    'Câncer',
    'Doença pulmonar',
    'AVC',
    'Depressão',
    'Ansiedade',
  ];

  @override
  void initState() {
    super.initState();
    _queixaController.text = widget.data.queixaPrincipal;
    _periodoController.text = widget.data.periodoEvolucao;
    _doencasAtuaisController.text = widget.data.doencasAtuais;
    _outrasDoencasController.text = widget.data.outrasDoencasPregressas;
    _cirurgiasController.text = widget.data.cirurgias;
    _internacoesController.text = widget.data.internacoes;
    _alergiaDescricaoController.text = widget.data.alergiaDescricao;
    _medicamentosController.text = widget.data.medicamentos;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _queixaController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Queixa principal *'),
              onChanged: (v) => widget.data.queixaPrincipal = v,
              validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
            ),
            TextFormField(controller: _periodoController, decoration: const InputDecoration(labelText: 'Período de evolução'), onChanged: (v) => widget.data.periodoEvolucao = v),
            TextFormField(controller: _doencasAtuaisController, decoration: const InputDecoration(labelText: 'Doenças atuais'), onChanged: (v) => widget.data.doencasAtuais = v),
            const SizedBox(height: 12),
            const Text('Doenças pregressas comuns:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._doencasComuns.map((doenca) => CheckboxListTile(
                  title: Text(doenca),
                  value: widget.data.doencasPregressasSelecionadas.contains(doenca),
                  onChanged: (v) {
                    setState(() {
                      if (v!) {
                        widget.data.doencasPregressasSelecionadas.add(doenca);
                      } else {
                        widget.data.doencasPregressasSelecionadas.remove(doenca);
                      }
                    });
                  },
                )),
            const SizedBox(height: 12),
            TextFormField(
              controller: _outrasDoencasController,
              decoration: const InputDecoration(labelText: 'Outras doenças pregressas'),
              onChanged: (v) => widget.data.outrasDoencasPregressas = v,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _cirurgiasController, decoration: const InputDecoration(labelText: 'Cirurgias anteriores'), onChanged: (v) => widget.data.cirurgias = v),
            TextFormField(controller: _internacoesController, decoration: const InputDecoration(labelText: 'Internações prévias'), onChanged: (v) => widget.data.internacoes = v),
            _buildYesNoRow('Tem alergias?', widget.data.temAlergia, (v) {
              widget.data.temAlergia = v;
              if (!v) widget.data.alergiaDescricao = '';
            }),
            if (widget.data.temAlergia) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _alergiaDescricaoController,
                decoration: const InputDecoration(labelText: 'Descreva as alergias *'),
                onChanged: (v) => widget.data.alergiaDescricao = v,
                validator: (v) => widget.data.temAlergia && v!.trim().isEmpty ? 'Descreva' : null,
              ),
            ],
            TextFormField(
              controller: _medicamentosController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Medicamentos em uso'),
              onChanged: (v) => widget.data.medicamentos = v,
            ),
            _buildYesNoRow(
              'Consegue lembrar/tomar os medicamentos?',
              widget.data.consegueTomarMedicamentos,
              (v) => widget.data.consegueTomarMedicamentos = v,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 5: Aspectos psicossociais ===============
class Section5AspectosPsicossociais extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section5AspectosPsicossociais({super.key, required this.formKey, required this.data});

  @override
  State<Section5AspectosPsicossociais> createState() => _Section5AspectosPsicossociaisState();
}

class _Section5AspectosPsicossociaisState extends State<Section5AspectosPsicossociais> {
  final _frequenciaController = TextEditingController();
  final _contatoController = TextEditingController();
  final _humorController = TextEditingController();
  final _lazerController = TextEditingController();

  static const List<String> _relacoes = ['boa', 'ruim'];

  @override
  void initState() {
    super.initState();
    _frequenciaController.text = widget.data.frequenciaCuidador;
    _contatoController.text = widget.data.contatoCuidador;
    _humorController.text = widget.data.humor;
    _lazerController.text = widget.data.lazer;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYesNoRow('Acompanhado por cuidador?', widget.data.temCuidador, (v) {
              widget.data.temCuidador = v;
              if (!v) {
                widget.data.frequenciaCuidador = '';
                widget.data.contatoCuidador = '';
                widget.data.relacaoCuidador = null;
              }
            }),
            if (widget.data.temCuidador) ...[
              TextFormField(controller: _frequenciaController, decoration: const InputDecoration(labelText: 'Frequência'), onChanged: (v) => widget.data.frequenciaCuidador = v),
              TextFormField(controller: _contatoController, decoration: const InputDecoration(labelText: 'Contato do cuidador'), onChanged: (v) => widget.data.contatoCuidador = v),
              _buildDropdown('Relação com cuidador', _relacoes, widget.data.relacaoCuidador, (v) => widget.data.relacaoCuidador = v),
            ],
            const SizedBox(height: 12),
            _buildDropdown('Relação com família', _relacoes, widget.data.relacaoFamilia, (v) => widget.data.relacaoFamilia = v),
            TextFormField(controller: _humorController, decoration: const InputDecoration(labelText: 'Humor'), onChanged: (v) => widget.data.humor = v),
            _buildYesNoRow(
              'Sinais de isolamento/tristeza/agressividade?',
              widget.data.sinaisPsicologicos,
              (v) => widget.data.sinaisPsicologicos = v,
            ),
            TextFormField(controller: _lazerController, decoration: const InputDecoration(labelText: 'Lazer/socialização'), onChanged: (v) => widget.data.lazer = v),
            _buildYesNoRow('Acompanhamento psiquiátrico?', widget.data.acompanhamentoPsiquiatrico, (v) => widget.data.acompanhamentoPsiquiatrico = v),
            _buildYesNoRow('Acompanhamento psicológico?', widget.data.acompanhamentoPsicologico, (v) => widget.data.acompanhamentoPsicologico = v),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 6: Avaliação física ===============
class Section6AvaliacaoFisica extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section6AvaliacaoFisica({super.key, required this.formKey, required this.data});

  @override
  State<Section6AvaliacaoFisica> createState() => _Section6AvaliacaoFisicaState();
}

class _Section6AvaliacaoFisicaState extends State<Section6AvaliacaoFisica> {
  final _paController = TextEditingController();
  final _fcController = TextEditingController();
  final _frController = TextEditingController();
  final _tempController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _glicemiaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _peleController = TextEditingController();
  final _lesoesController = TextEditingController();

  static const List<String> _estados = ['bom', 'regular', 'ruim'];

  @override
  void initState() {
    super.initState();
    _paController.text = widget.data.pa;
    _fcController.text = widget.data.fc;
    _frController.text = widget.data.fr;
    _tempController.text = widget.data.temp;
    _spo2Controller.text = widget.data.spo2;
    _glicemiaController.text = widget.data.glicemia;
    _pesoController.text = widget.data.peso;
    _alturaController.text = widget.data.altura;
    _peleController.text = widget.data.pele;
    _lesoesController.text = widget.data.lesoes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown('Estado geral', _estados, widget.data.estadoGeral, (v) => widget.data.estadoGeral = v),
            const SizedBox(height: 12),
            const Text('Sinais vitais:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              Expanded(child: TextFormField(controller: _paController, decoration: const InputDecoration(labelText: 'PA'), onChanged: (v) => widget.data.pa = v)),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _fcController, decoration: const InputDecoration(labelText: 'FC'), onChanged: (v) => widget.data.fc = v)),
            ]),
            Row(children: [
              Expanded(child: TextFormField(controller: _frController, decoration: const InputDecoration(labelText: 'FR'), onChanged: (v) => widget.data.fr = v)),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _tempController, decoration: const InputDecoration(labelText: 'Temp'), onChanged: (v) => widget.data.temp = v)),
            ]),
            Row(children: [
              Expanded(child: TextFormField(controller: _spo2Controller, decoration: const InputDecoration(labelText: 'SpO₂'), onChanged: (v) => widget.data.spo2 = v)),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _glicemiaController, decoration: const InputDecoration(labelText: 'Glicemia'), onChanged: (v) => widget.data.glicemia = v)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextFormField(controller: _pesoController, decoration: const InputDecoration(labelText: 'Peso (kg)'), onChanged: (v) => widget.data.peso = v)),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _alturaController, decoration: const InputDecoration(labelText: 'Altura (cm)'), onChanged: (v) => widget.data.altura = v)),
            ]),
            if (widget.data.peso.isNotEmpty && widget.data.altura.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('IMC: ${widget.data.imc?.toStringAsFixed(1) ?? '–'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
            const SizedBox(height: 12),
            TextFormField(controller: _peleController, decoration: const InputDecoration(labelText: 'Pele'), onChanged: (v) => widget.data.pele = v),
            TextFormField(controller: _lesoesController, decoration: const InputDecoration(labelText: 'Lesões/curativos'), onChanged: (v) => widget.data.lesoes = v),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 7: Avaliação cognitiva ===============
class Section7AvaliacaoCognitiva extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section7AvaliacaoCognitiva({super.key, required this.formKey, required this.data});

  @override
  State<Section7AvaliacaoCognitiva> createState() => _Section7AvaliacaoCognitivaState();
}

class _Section7AvaliacaoCognitivaState extends State<Section7AvaliacaoCognitiva> {
  static const List<String> _orientacoes = ['tempo', 'espaço']; // REMOVIDO "pessoa"
  static const List<String> _katzOpcoes = ['independente', 'parcial', 'dependente'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Orientado em:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._orientacoes.map((item) => CheckboxListTile(
                  title: Text(item),
                  value: widget.data.orientado.contains(item),
                  onChanged: (v) {
                    setState(() {
                      if (v!) {
                        widget.data.orientado.add(item);
                      } else {
                        widget.data.orientado.remove(item);
                      }
                    });
                  },
                )),
            _buildYesNoRow('Memória preservada?', widget.data.memoriaPreservada, (v) => widget.data.memoriaPreservada = v),
            const SizedBox(height: 12),
            const Text('Escala de Katz (AVDs):', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDropdown('Banhar-se', _katzOpcoes, widget.data.katzBanho, (v) => widget.data.katzBanho = v),
            _buildDropdown('Vestir-se', _katzOpcoes, widget.data.katzVestir, (v) => widget.data.katzVestir = v),
            _buildDropdown('Alimentar-se', _katzOpcoes, widget.data.katzAlimentar, (v) => widget.data.katzAlimentar = v),
            _buildDropdown('Mover-se', _katzOpcoes, widget.data.katzMover, (v) => widget.data.katzMover = v),
            _buildYesNoRow('Continência?', widget.data.continencia, (v) => widget.data.continencia = v),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 8: Antes da consulta ===============
class Section8AntesConsulta extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section8AntesConsulta({super.key, required this.formKey, required this.data});

  @override
  State<Section8AntesConsulta> createState() => _Section8AntesConsultaState();
}

class _Section8AntesConsultaState extends State<Section8AntesConsulta> {
  final _localController = TextEditingController();
  final _especialidadeController = TextEditingController();
  final _medicoController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localController.text = widget.data.local;
    _especialidadeController.text = widget.data.especialidade;
    _medicoController.text = widget.data.nomeMedicoAntes;
    _observacoesController.text = widget.data.observacoesAntes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePickerRow(
              context, // ✅ Context adicionado
              'Data prevista',
              widget.data.dataPrevista,
              (date) => widget.data.dataPrevista = date,
            ),
            TextFormField(controller: _localController, decoration: const InputDecoration(labelText: 'Local'), onChanged: (v) => widget.data.local = v),
            TextFormField(controller: _especialidadeController, decoration: const InputDecoration(labelText: 'Especialidade'), onChanged: (v) => widget.data.especialidade = v),
            TextFormField(controller: _medicoController, decoration: const InputDecoration(labelText: 'Nome do médico'), onChanged: (v) => widget.data.nomeMedicoAntes = v),
            TextFormField(
              controller: _observacoesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Observações'),
              onChanged: (v) => widget.data.observacoesAntes = v,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== SESSÃO 9: Após a consulta ===============
class Section9AposConsulta extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final AnamneseData data;

  const Section9AposConsulta({super.key, required this.formKey, required this.data});

  @override
  State<Section9AposConsulta> createState() => _Section9AposConsultaState();
}

class _Section9AposConsultaState extends State<Section9AposConsulta> {
  final _medicoController = TextEditingController();
  final _orientacoesController = TextEditingController();
  final _examesController = TextEditingController();
  final _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicoController.text = widget.data.nomeMedicoApos;
    _orientacoesController.text = widget.data.orientacoesMedicas;
    _examesController.text = widget.data.examesSolicitados;
    _observacoesController.text = widget.data.observacoesApos;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(controller: _medicoController, decoration: const InputDecoration(labelText: 'Nome do médico'), onChanged: (v) => widget.data.nomeMedicoApos = v),
            TextFormField(
              controller: _orientacoesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Orientações do médico'),
              onChanged: (v) => widget.data.orientacoesMedicas = v,
            ),
            TextFormField(
              controller: _examesController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Exames solicitados'),
              onChanged: (v) => widget.data.examesSolicitados = v,
            ),
            TextFormField(
              controller: _observacoesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Observações'),
              onChanged: (v) => widget.data.observacoesApos = v,
            ),
          ],
        ),
      ),
    );
  }
}

// =============== WIDGETS AUXILIARES ===============
Widget _buildDatePickerRow(BuildContext context, String label, DateTime? date, void Function(DateTime?) onChanged) {
  return InputDecorator(
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    child: InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
        );
        if (picked != null) onChanged(picked);
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 18),
          const SizedBox(width: 8),
          Text(
            date == null ? 'Selecione' : DateFormat('dd/MM/yyyy').format(date),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

Widget _buildDropdown(
  String label,
  List<String> items,
  String? value,
  void Function(String?) onChanged,
) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(labelText: label),
    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
  );
}

Widget _buildYesNoRow(String label, bool value, void Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label),
      Row(
        children: [
          TextButton.icon(
            onPressed: () => onChanged(true),
            icon: Icon(Icons.check_circle, color: value ? Colors.green : Colors.grey),
            label: const Text('Sim'),
          ),
          TextButton.icon(
            onPressed: () => onChanged(false),
            icon: Icon(Icons.cancel, color: !value ? Colors.red : Colors.grey),
            label: const Text('Não'),
          ),
        ],
      ),
    ],
  );
}