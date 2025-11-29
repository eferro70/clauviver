import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaAnamnese extends StatefulWidget {
  const TelaAnamnese({super.key});

  @override
  State<TelaAnamnese> createState() => _TelaAnamneseState();
}

class _TelaAnamneseState extends State<TelaAnamnese> {
  final _formKey = GlobalKey<FormState>();

  // Sessão 1: Responsável
  final _enfermeiroController = TextEditingController();
  DateTime? _dataAtendimento;

  // Sessão 2: Identificação do paciente
  final _nomePacienteController = TextEditingController();
  DateTime? _dataNascimento;
  String? _sexo;
  String? _estadoCivil;
  String? _escolaridade;
  final _profissaoController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _religiaoController = TextEditingController();
  final _responsavelPacienteController = TextEditingController();
  final _telefonePacienteController = TextEditingController();

  // Sessão 3: Condições domiciliares
  String? _tipoHabitacao;
  bool? _temAnimais;
  List<String> _adaptacoesSelecionadas = [];
  List<String> _dispositivosSelecionados = [];
  final _outroDispositivoController = TextEditingController();
  final _alimentacaoController = TextEditingController();
  final _ingestaHidricaController = TextEditingController();
  bool? _usaAlcool;
  final _sonoController = TextEditingController();

  // Sessão 4: Histórico de saúde
  final _queixaPrincipalController = TextEditingController();
  final _periodoEvolucaoController = TextEditingController();
  final _doencasAtuaisController = TextEditingController();
  final _doencasPregressasController = TextEditingController();
  final _cirurgiasController = TextEditingController();
  final _internacoesController = TextEditingController();
  bool? _temAlergia;
  final _alergiaDescricaoController = TextEditingController();
  final _medicamentosController = TextEditingController();
  bool? _consegueTomarMedicamentos;

  // Sessão 5: Aspectos psicossociais
  bool? _temCuidador;
  final _frequenciaCuidadorController = TextEditingController();
  final _contatoCuidadorController = TextEditingController();
  String? _relacaoCuidador;
  String? _relacaoFamilia;
  final _humorController = TextEditingController();
  bool? _sinaisPsicologicos;
  final _lazerController = TextEditingController();
  bool? _acompanhamentoPsiquiatrico;
  bool? _acompanhamentoPsicologico;

  // Sessão 6: Avaliação física
  String? _estadoGeral;
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

  // Sessão 7: Avaliação cognitiva
  List<String> _orientadoSelecionados = [];
  bool? _memoriaPreservada;
  String? _katzBanho;
  String? _katzVestir;
  String? _katzAlimentar;
  String? _katzMover;
  bool? _continencia;

  // Sessão 8: Cuidados e orientações
  bool? _consultaEspecialista;
  final _especialidadeController = TextEditingController();
  final _informadoPorController = TextEditingController();
  final _orientacoesMedicasController = TextEditingController();
  final _solicitacoesExamesController = TextEditingController();
  final _encaminhamentosController = TextEditingController();
  DateTime? _dataRetorno;

  // Opções fixas
  final List<String> _sexos = ['masculino', 'feminino', 'outro', 'prefiro não informar'];
  final List<String> _estadosCivis = ['solteiro(a)', 'casado(a)', 'divorciado(a)', 'viúvo(a)', 'união estável'];
  final List<String> _escolaridades = [
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
  final List<String> _habitacoes = ['casa', 'apartamento'];
  final List<String> _adaptacoes = ['nenhuma', 'acesso', 'banheiro'];
  final List<String> _dispositivos = ['bengala', 'andador', 'cadeira de rodas', 'outro'];
  final List<String> _orientacoes = ['tempo', 'espaço', 'pessoa'];
  final List<String> _katzOpcoes = ['independente', 'parcial', 'dependente'];
  final List<String> _relacoes = ['boa', 'ruim'];

  bool _salvando = false;

  // Funções auxiliares
  int? calcularIdade(DateTime? dataNasc) {
    if (dataNasc == null) return null;
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month || (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }
    return idade;
  }

  double? calcularIMC(String? pesoStr, String? alturaStr) {
    if (pesoStr == null || alturaStr == null) return null;
    final peso = double.tryParse(pesoStr);
    final alturaCm = double.tryParse(alturaStr);
    if (peso == null || alturaCm == null || alturaCm <= 0) return null;
    final alturaM = alturaCm / 100;
    return peso / (alturaM * alturaM);
  }

  // Seletores de data
  Future<void> _selecionarDataAtendimento() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (data != null) setState(() => _dataAtendimento = data);
  }

  Future<void> _selecionarDataNascimento() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(1980),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (data != null) setState(() => _dataNascimento = data);
  }

  Future<void> _selecionarDataRetorno() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (data != null) setState(() => _dataRetorno = data);
  }

  // Salvar
  Future<void> _salvarAnamnese() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dataAtendimento == null) {
      _mostrarErro('Selecione a data do atendimento');
      return;
    }
    if (_nomePacienteController.text.trim().isEmpty) {
      _mostrarErro('Informe o nome do paciente');
      return;
    }
    if (_dataNascimento == null) {
      _mostrarErro('Selecione a data de nascimento do paciente');
      return;
    }

    setState(() => _salvando = true);

    try {
      final data = {
        // Sessão 1
        'responsavel': {
          'enfermeiro': _enfermeiroController.text.trim(),
          'data_atendimento': _dataAtendimento!.toIso8601String().split('T')[0],
        },

        // Sessão 2
        'paciente': {
          'nome': _nomePacienteController.text.trim(),
          'data_nascimento': _dataNascimento!.toIso8601String().split('T')[0],
          'idade': calcularIdade(_dataNascimento),
          'sexo': _sexo,
          'estado_civil': _estadoCivil,
          'escolaridade': _escolaridade,
          'profissao': _profissaoController.text.trim(),
          'endereco': _enderecoController.text.trim(),
          'religiao': _religiaoController.text.trim(),
          'responsavel_nome': _responsavelPacienteController.text.trim(),
          'telefone': _telefonePacienteController.text.trim(),
        },

        // Sessão 3
        'condicoes_domiciliares': {
          'habitacao': _tipoHabitacao,
          'animais': _temAnimais,
          'adaptacoes': _adaptacoesSelecionadas,
          'dispositivos': _dispositivosSelecionados,
          'outro_dispositivo': _dispositivosSelecionados.contains('outro')
              ? _outroDispositivoController.text.trim()
              : '',
          'alimentacao': _alimentacaoController.text.trim(),
          'ingesta_hidrica': _ingestaHidricaController.text.trim(),
          'alcool': _usaAlcool,
          'sono': _sonoController.text.trim(),
        },

        // Sessão 4
        'historico_saude': {
          'queixa_principal': _queixaPrincipalController.text.trim(),
          'periodo_evolucao': _periodoEvolucaoController.text.trim(),
          'doencas_atuais': _doencasAtuaisController.text.trim(),
          'doencas_pregressas': _doencasPregressasController.text.trim(),
          'cirurgias': _cirurgiasController.text.trim(),
          'internacoes': _internacoesController.text.trim(),
          'alergias': {
            'tem': _temAlergia,
            'descricao': _temAlergia == true ? _alergiaDescricaoController.text.trim() : '',
          },
          'medicamentos': _medicamentosController.text.trim(),
          'consegue_tomar': _consegueTomarMedicamentos,
        },

        // Sessão 5
        'aspectos_psicossociais': {
          'tem_cuidador': _temCuidador,
          'frequencia_cuidador': _temCuidador == true ? _frequenciaCuidadorController.text.trim() : '',
          'contato_cuidador': _temCuidador == true ? _contatoCuidadorController.text.trim() : '',
          'relacao_cuidador': _temCuidador == true ? _relacaoCuidador : null,
          'relacao_familia': _relacaoFamilia,
          'humor': _humorController.text.trim(),
          'sinais_psicologicos': _sinaisPsicologicos,
          'lazer': _lazerController.text.trim(),
          'acompanhamento_psiquiatrico': _acompanhamentoPsiquiatrico,
          'acompanhamento_psicologico': _acompanhamentoPsicologico,
        },

        // Sessão 6
        'avaliacao_fisica': {
          'estado_geral': _estadoGeral,
          'sinais_vitais': {
            'pa': _paController.text.trim(),
            'fc': _fcController.text.trim(),
            'fr': _frController.text.trim(),
            'temp': _tempController.text.trim(),
            'spo2': _spo2Controller.text.trim(),
            'glicemia': _glicemiaController.text.trim(),
          },
          'peso': _pesoController.text.trim(),
          'altura': _alturaController.text.trim(),
          'imc': calcularIMC(_pesoController.text.trim(), _alturaController.text.trim()),
          'pele': _peleController.text.trim(),
          'lesoes_curativos': _lesoesController.text.trim(),
        },

        // Sessão 7
        'avaliacao_cognitiva': {
          'orientado': _orientadoSelecionados,
          'memoria_preservada': _memoriaPreservada,
          'katz': {
            'banhar': _katzBanho,
            'vestir': _katzVestir,
            'alimentar': _katzAlimentar,
            'mover': _katzMover,
            'continencia': _continencia,
          },
        },

        // Sessão 8
        'cuidados_orientacoes': {
          'consulta_especialista': _consultaEspecialista,
          'especialidade': _consultaEspecialista == true ? _especialidadeController.text.trim() : '',
          'informado_por': _informadoPorController.text.trim(),
          'orientacoes_medicas': _orientacoesMedicasController.text.trim(),
          'solicitacoes_exames': _solicitacoesExamesController.text.trim(),
          'encaminhamentos': _encaminhamentosController.text.trim(),
          'data_retorno': _dataRetorno?.toIso8601String().split('T')[0],
        },

        // Metadados
        'data_criacao': FieldValue.serverTimestamp(),
        'origem': 'tablet_clauviver',
        'versao_formulario': '2.0',
      };

      await FirebaseFirestore.instance.collection('anamneses').add(data);

      _limparCampos();
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

  void _mostrarErro(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _limparCampos() {
    // Sessão 1
    _enfermeiroController.clear();
    _dataAtendimento = null;

    // Sessão 2
    _nomePacienteController.clear();
    _dataNascimento = null;
    _sexo = null;
    _estadoCivil = null;
    _escolaridade = null;
    _profissaoController.clear();
    _enderecoController.clear();
    _religiaoController.clear();
    _responsavelPacienteController.clear();
    _telefonePacienteController.clear();

    // Sessão 3
    _tipoHabitacao = null;
    _temAnimais = null;
    _adaptacoesSelecionadas.clear();
    _dispositivosSelecionados.clear();
    _outroDispositivoController.clear();
    _alimentacaoController.clear();
    _ingestaHidricaController.clear();
    _usaAlcool = null;
    _sonoController.clear();

    // Sessão 4
    _queixaPrincipalController.clear();
    _periodoEvolucaoController.clear();
    _doencasAtuaisController.clear();
    _doencasPregressasController.clear();
    _cirurgiasController.clear();
    _internacoesController.clear();
    _temAlergia = null;
    _alergiaDescricaoController.clear();
    _medicamentosController.clear();
    _consegueTomarMedicamentos = null;

    // Sessão 5
    _temCuidador = null;
    _frequenciaCuidadorController.clear();
    _contatoCuidadorController.clear();
    _relacaoCuidador = null;
    _relacaoFamilia = null;
    _humorController.clear();
    _sinaisPsicologicos = null;
    _lazerController.clear();
    _acompanhamentoPsiquiatrico = null;
    _acompanhamentoPsicologico = null;

    // Sessão 6
    _estadoGeral = null;
    _paController.clear();
    _fcController.clear();
    _frController.clear();
    _tempController.clear();
    _spo2Controller.clear();
    _glicemiaController.clear();
    _pesoController.clear();
    _alturaController.clear();
    _peleController.clear();
    _lesoesController.clear();

    // Sessão 7
    _orientadoSelecionados.clear();
    _memoriaPreservada = null;
    _katzBanho = null;
    _katzVestir = null;
    _katzAlimentar = null;
    _katzMover = null;
    _continencia = null;

    // Sessão 8
    _consultaEspecialista = null;
    _especialidadeController.clear();
    _informadoPorController.clear();
    _orientacoesMedicasController.clear();
    _solicitacoesExamesController.clear();
    _encaminhamentosController.clear();
    _dataRetorno = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Anamnese - ClauViver')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SESSÃO 1: Responsável ---
              _buildSectionTitle('1. Responsável'),
              TextFormField(
                controller: _enfermeiroController,
                decoration: const InputDecoration(labelText: 'Enfermeiro(a) *'),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data do atendimento *',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _selecionarDataAtendimento,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _dataAtendimento == null
                            ? 'Selecione'
                            : '${_dataAtendimento!.day}/${_dataAtendimento!.month}/${_dataAtendimento!.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 32),

              // --- SESSÃO 2: Identificação do paciente ---
              _buildSectionTitle('2. Identificação do paciente'),
              TextFormField(
                controller: _nomePacienteController,
                decoration: const InputDecoration(labelText: 'Nome completo *'),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento *',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _selecionarDataNascimento,
                  child: Row(
                    children: [
                      const Icon(Icons.cake, size: 18),
                      const SizedBox(width: 8),
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
              if (_dataNascimento != null) ...[
                const SizedBox(height: 8),
                Text('Idade: ${calcularIdade(_dataNascimento)} anos',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo *'),
                items: _sexos.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _sexo = v),
                validator: (v) => v == null ? 'Selecione' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _estadoCivil,
                decoration: const InputDecoration(labelText: 'Estado civil'),
                items: _estadosCivis.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _estadoCivil = v),
              ),
              const SizedBox(height: 8),
              DropdownRow(
                label: 'Escolaridade',
                value: _escolaridade,
                items: _escolaridades,
                onChanged: (v) => setState(() => _escolaridade = v),
              ),
              const SizedBox(height: 8),
              TextFormField(controller: _profissaoController, decoration: const InputDecoration(labelText: 'Profissão')),
              TextFormField(controller: _enderecoController, decoration: const InputDecoration(labelText: 'Endereço')),
              TextFormField(controller: _religiaoController, decoration: const InputDecoration(labelText: 'Religião (opcional)')),
              TextFormField(controller: _responsavelPacienteController, decoration: const InputDecoration(labelText: 'Responsável')),
              TextFormField(
                controller: _telefonePacienteController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              const Divider(height: 32),

              // --- SESSÃO 3: Condições domiciliares ---
              _buildSectionTitle('3. Condições domiciliares e hábitos de vida'),
              DropdownRow(
                label: 'Habitação',
                value: _tipoHabitacao,
                items: _habitacoes,
                onChanged: (v) => setState(() => _tipoHabitacao = v),
              ),
              const SizedBox(height: 8),
              _buildYesNoQuestion('Animais no ambiente?', _temAnimais, (v) => setState(() => _temAnimais = v)),
              const SizedBox(height: 12),
              const Text('Adaptações:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._adaptacoes.map((item) => CheckboxListTile(
                    title: Text(item),
                    value: _adaptacoesSelecionadas.contains(item),
                    onChanged: (v) => setState(() {
                      if (v!) {
                        _adaptacoesSelecionadas.add(item);
                      } else {
                        _adaptacoesSelecionadas.remove(item);
                      }
                    }),
                  )),
              const SizedBox(height: 12),
              const Text('Dispositivos:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._dispositivos.map((item) => CheckboxListTile(
                    title: Text(item),
                    value: _dispositivosSelecionados.contains(item),
                    onChanged: (v) => setState(() {
                      if (v!) {
                        _dispositivosSelecionados.add(item);
                      } else {
                        _dispositivosSelecionados.remove(item);
                      }
                    }),
                  )),
              if (_dispositivosSelecionados.contains('outro')) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _outroDispositivoController,
                  decoration: const InputDecoration(labelText: 'Especifique outro dispositivo'),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(controller: _alimentacaoController, decoration: const InputDecoration(labelText: 'Alimentação')),
              TextFormField(controller: _ingestaHidricaController, decoration: const InputDecoration(labelText: 'Ingesta hídrica')),
              _buildYesNoQuestion('Faz uso de álcool?', _usaAlcool, (v) => setState(() => _usaAlcool = v)),
              TextFormField(controller: _sonoController, decoration: const InputDecoration(labelText: 'Qualidade do sono')),

              const Divider(height: 32),

              // --- SESSÃO 4: Histórico de saúde ---
              _buildSectionTitle('4. Histórico de saúde'),
              TextFormField(
                controller: _queixaPrincipalController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Queixa principal *'),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(controller: _periodoEvolucaoController, decoration: const InputDecoration(labelText: 'Período de evolução')),
              TextFormField(controller: _doencasAtuaisController, decoration: const InputDecoration(labelText: 'Doenças atuais')),
              TextFormField(controller: _doencasPregressasController, decoration: const InputDecoration(labelText: 'Doenças pregressas')),
              TextFormField(controller: _cirurgiasController, decoration: const InputDecoration(labelText: 'Cirurgias')),
              TextFormField(controller: _internacoesController, decoration: const InputDecoration(labelText: 'Internações prévias')),
              _buildYesNoQuestion('Tem alergias?', _temAlergia, (v) {
                setState(() => _temAlergia = v);
                if (v == false) _alergiaDescricaoController.clear();
              }),
              if (_temAlergia == true) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _alergiaDescricaoController,
                  decoration: const InputDecoration(labelText: 'Descreva as alergias *'),
                  validator: (v) => _temAlergia == true && v!.trim().isEmpty ? 'Descreva' : null,
                ),
              ],
              TextFormField(
                controller: _medicamentosController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Medicamentos em uso'),
              ),
              _buildYesNoQuestion(
                'Consegue lembrar/tomar os medicamentos?',
                _consegueTomarMedicamentos,
                (v) => setState(() => _consegueTomarMedicamentos = v),
              ),

              const Divider(height: 32),

              // --- SESSÃO 5: Aspectos psicossociais ---
              _buildSectionTitle('5. Aspectos psicossociais'),
              _buildYesNoQuestion('Acompanhado por cuidador?', _temCuidador, (v) {
                setState(() => _temCuidador = v);
                if (v == false) {
                  _frequenciaCuidadorController.clear();
                  _contatoCuidadorController.clear();
                  _relacaoCuidador = null;
                }
              }),
              if (_temCuidador == true) ...[
                TextFormField(
                  controller: _frequenciaCuidadorController,
                  decoration: const InputDecoration(labelText: 'Frequência do cuidador'),
                ),
                TextFormField(
                  controller: _contatoCuidadorController,
                  decoration: const InputDecoration(labelText: 'Contato do cuidador'),
                ),
                DropdownRow(
                  label: 'Relação com cuidador',
                  value: _relacaoCuidador,
                  items: _relacoes,
                  onChanged: (v) => setState(() => _relacaoCuidador = v),
                ),
              ],
              DropdownRow(
                label: 'Relação com família',
                value: _relacaoFamilia,
                items: _relacoes,
                onChanged: (v) => setState(() => _relacaoFamilia = v),
              ),
              TextFormField(controller: _humorController, decoration: const InputDecoration(labelText: 'Humor')),
              _buildYesNoQuestion(
                'Sinais de isolamento/tristeza/agressividade?',
                _sinaisPsicologicos,
                (v) => setState(() => _sinaisPsicologicos = v),
              ),
              TextFormField(controller: _lazerController, decoration: const InputDecoration(labelText: 'Lazer/socialização')),
              _buildYesNoQuestion(
                'Acompanhamento psiquiátrico?',
                _acompanhamentoPsiquiatrico,
                (v) => setState(() => _acompanhamentoPsiquiatrico = v),
              ),
              _buildYesNoQuestion(
                'Acompanhamento psicológico?',
                _acompanhamentoPsicologico,
                (v) => setState(() => _acompanhamentoPsicologico = v),
              ),

              const Divider(height: 32),

              // --- SESSÃO 6: Avaliação física ---
              _buildSectionTitle('6. Avaliação física'),
              DropdownRow(
                label: 'Estado geral',
                value: _estadoGeral,
                items: ['bom', 'regular', 'ruim'],
                onChanged: (v) => setState(() => _estadoGeral = v),
              ),
              const SizedBox(height: 12),
              const Text('Sinais vitais:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _paController, decoration: const InputDecoration(labelText: 'PA'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _fcController, decoration: const InputDecoration(labelText: 'FC'))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _frController, decoration: const InputDecoration(labelText: 'FR'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _tempController, decoration: const InputDecoration(labelText: 'Temp'))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _spo2Controller, decoration: const InputDecoration(labelText: 'SpO₂'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _glicemiaController, decoration: const InputDecoration(labelText: 'Glicemia'))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _pesoController, decoration: const InputDecoration(labelText: 'Peso (kg)'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _alturaController, decoration: const InputDecoration(labelText: 'Altura (cm)'))),
                ],
              ),
              if (_pesoController.text.isNotEmpty && _alturaController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('IMC: ${calcularIMC(_pesoController.text, _alturaController.text)?.toStringAsFixed(1) ?? '–'}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
              TextFormField(controller: _peleController, decoration: const InputDecoration(labelText: 'Pele')),
              TextFormField(controller: _lesoesController, decoration: const InputDecoration(labelText: 'Lesões/curativos')),

              const Divider(height: 32),

              // --- SESSÃO 7: Avaliação cognitiva ---
              _buildSectionTitle('7. Avaliação cognitiva e funcional'),
              const Text('Orientado em:', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._orientacoes.map((item) => CheckboxListTile(
                    title: Text(item),
                    value: _orientadoSelecionados.contains(item),
                    onChanged: (v) => setState(() {
                      if (v!) {
                        _orientadoSelecionados.add(item);
                      } else {
                        _orientadoSelecionados.remove(item);
                      }
                    }),
                  )),
              _buildYesNoQuestion('Memória preservada?', _memoriaPreservada, (v) => setState(() => _memoriaPreservada = v)),
              const SizedBox(height: 12),
              const Text('Escala de Katz (AVDs):', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildKatzRow('Banhar-se', _katzBanho, (v) => setState(() => _katzBanho = v)),
              _buildKatzRow('Vestir-se', _katzVestir, (v) => setState(() => _katzVestir = v)),
              _buildKatzRow('Alimentar-se', _katzAlimentar, (v) => setState(() => _katzAlimentar = v)),
              _buildKatzRow('Mover-se', _katzMover, (v) => setState(() => _katzMover = v)),
              _buildYesNoQuestion('Continência?', _continencia, (v) => setState(() => _continencia = v)),

              const Divider(height: 32),

              // --- SESSÃO 8: Cuidados e orientações ---
              _buildSectionTitle('8. Cuidados e orientações para a consulta'),
              _buildYesNoQuestion('Consulta com especialista?', _consultaEspecialista, (v) {
                setState(() => _consultaEspecialista = v);
                if (v == false) _especialidadeController.clear();
              }),
              if (_consultaEspecialista == true) ...[
                TextFormField(
                  controller: _especialidadeController,
                  decoration: const InputDecoration(labelText: 'Especialidade'),
                ),
              ],
              TextFormField(
                controller: _informadoPorController,
                decoration: const InputDecoration(labelText: 'Informações fornecidas por'),
              ),
              TextFormField(
                controller: _orientacoesMedicasController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Orientações do médico'),
              ),
              TextFormField(
                controller: _solicitacoesExamesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Solicitações de exames'),
              ),
              TextFormField(
                controller: _encaminhamentosController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Encaminhamentos necessários'),
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de retorno',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _selecionarDataRetorno,
                  child: Row(
                    children: [
                      const Icon(Icons.date_range, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _dataRetorno == null ? 'Opcional' : '${_dataRetorno!.day}/${_dataRetorno!.month}/${_dataRetorno!.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvando ? null : _salvarAnamnese,
                  icon: _salvando
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: _salvando
                      ? const Text('Salvando...')
                      : const Text('Salvar Anamnese Completa'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildYesNoQuestion(String label, bool? value, Function(bool?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => onChanged(true),
              icon: Icon(Icons.check_circle, color: value == true ? Colors.green : Colors.grey),
              label: const Text('Sim'),
            ),
            TextButton.icon(
              onPressed: () => onChanged(false),
              icon: Icon(Icons.cancel, color: value == false ? Colors.red : Colors.grey),
              label: const Text('Não'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKatzRow(String label, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: _katzOpcoes.map((op) => DropdownMenuItem(value: op, child: Text(op))).toList(),
      onChanged: onChanged,
    );
  }
}

// Widget auxiliar para dropdowns em linha
class DropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const DropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }
}