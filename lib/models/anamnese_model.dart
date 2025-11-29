// lib/models/anamnese_model.dart

import 'package:flutter/foundation.dart';

class AnamneseData {
  // =============== SESSÃO 1: Responsável ===============
  String enfermeiro;
  DateTime dataAtendimento;

  // =============== SESSÃO 2: Identificação do paciente ===============
  String nomePaciente;
  DateTime dataNascimento;
  String? sexo;
  String? estadoCivil;
  String? escolaridade;
  String profissao;
  String endereco;
  String religiao;
  String responsavel;
  String telefone;

  // =============== SESSÃO 3: Condições domiciliares ===============
  String? tipoHabitacao; // 'casa' ou 'apartamento'
  bool temAnimais;
  List<String> adaptacoes; // inclui 'nenhuma'
  List<String> dispositivos; // inclui 'nenhuma'
  String outroDispositivo;
  String alimentacao;
  String ingestaoHidrica;
  bool usaAlcool;
  String sono;

  // =============== SESSÃO 4: Histórico de saúde ===============
  String queixaPrincipal;
  String periodoEvolucao;
  String doencasAtuais;
  List<String> doencasPregressasSelecionadas;
  String outrasDoencasPregressas;
  String cirurgias;
  String internacoes;
  bool temAlergia;
  String alergiaDescricao;
  String medicamentos;
  bool consegueTomarMedicamentos;

  // =============== SESSÃO 5: Aspectos psicossociais ===============
  bool temCuidador;
  String frequenciaCuidador;
  String contatoCuidador;
  String? relacaoCuidador; // 'boa' ou 'ruim'
  String? relacaoFamilia;
  String humor;
  bool sinaisPsicologicos;
  String lazer;
  bool acompanhamentoPsiquiatrico;
  bool acompanhamentoPsicologico;

  // =============== SESSÃO 6: Avaliação física ===============
  String? estadoGeral; // 'bom', 'regular', 'ruim'
  String pa;
  String fc;
  String fr;
  String temp;
  String spo2;
  String glicemia;
  String peso;
  String altura;
  String pele;
  String lesoes;

  // =============== SESSÃO 7: Avaliação cognitiva ===============
  List<String> orientado; // ['tempo', 'espaço'] — sem 'pessoa'
  bool memoriaPreservada;
  String? katzBanho; // 'independente', 'parcial', 'dependente'
  String? katzVestir;
  String? katzAlimentar;
  String? katzMover;
  bool continencia;

  // =============== SESSÃO 8: Antes da consulta ===============
  DateTime? dataPrevista;
  String local;
  String especialidade;
  String nomeMedicoAntes;
  String observacoesAntes;

  // =============== SESSÃO 9: Após a consulta ===============
  String nomeMedicoApos;
  String orientacoesMedicas;
  String examesSolicitados;
  String observacoesApos;

  // =============== Metadados ===============
  String? id; // opcional: para edição
  DateTime? dataCriacao;

  // =============== Construtor ===============
  AnamneseData({
    // Sessão 1
    required this.enfermeiro,
    required this.dataAtendimento,

    // Sessão 2
    required this.nomePaciente,
    required this.dataNascimento,
    this.sexo,
    this.estadoCivil,
    this.escolaridade,
    this.profissao = '',
    this.endereco = '',
    this.religiao = '',
    this.responsavel = '',
    this.telefone = '',

    // Sessão 3
    this.tipoHabitacao,
    this.temAnimais = false,
    this.adaptacoes = const [],
    this.dispositivos = const [],
    this.outroDispositivo = '',
    this.alimentacao = '',
    this.ingestaoHidrica = '',
    this.usaAlcool = false,
    this.sono = '',

    // Sessão 4
    required this.queixaPrincipal,
    this.periodoEvolucao = '',
    this.doencasAtuais = '',
    this.doencasPregressasSelecionadas = const [],
    this.outrasDoencasPregressas = '',
    this.cirurgias = '',
    this.internacoes = '',
    this.temAlergia = false,
    this.alergiaDescricao = '',
    this.medicamentos = '',
    this.consegueTomarMedicamentos = false,

    // Sessão 5
    this.temCuidador = false,
    this.frequenciaCuidador = '',
    this.contatoCuidador = '',
    this.relacaoCuidador,
    this.relacaoFamilia,
    this.humor = '',
    this.sinaisPsicologicos = false,
    this.lazer = '',
    this.acompanhamentoPsiquiatrico = false,
    this.acompanhamentoPsicologico = false,

    // Sessão 6
    this.estadoGeral,
    this.pa = '',
    this.fc = '',
    this.fr = '',
    this.temp = '',
    this.spo2 = '',
    this.glicemia = '',
    this.peso = '',
    this.altura = '',
    this.pele = '',
    this.lesoes = '',

    // Sessão 7
    this.orientado = const [],
    this.memoriaPreservada = false,
    this.katzBanho,
    this.katzVestir,
    this.katzAlimentar,
    this.katzMover,
    this.continencia = false,

    // Sessão 8
    this.dataPrevista,
    this.local = '',
    this.especialidade = '',
    this.nomeMedicoAntes = '',
    this.observacoesAntes = '',

    // Sessão 9
    this.nomeMedicoApos = '',
    this.orientacoesMedicas = '',
    this.examesSolicitados = '',
    this.observacoesApos = '',

    // Metadados
    this.id,
    this.dataCriacao,
  });

  // =============== Getters úteis ===============
  int get idade {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  double? get imc {
    final pesoNum = double.tryParse(peso);
    final alturaCm = double.tryParse(altura);
    if (pesoNum == null || alturaCm == null || alturaCm <= 0) return null;
    final alturaM = alturaCm / 100;
    return pesoNum / (alturaM * alturaM);
  }

  // =============== Conversão para JSON ===============
  Map<String, dynamic> toJson() {
    return {
      // Sessão 1
      'responsavel': {
        'enfermeiro': enfermeiro.trim(),
        'data_atendimento': dataAtendimento.toIso8601String().split('T')[0],
      },

      // Sessão 2
      'paciente': {
        'nome': nomePaciente.trim(),
        'data_nascimento': dataNascimento.toIso8601String().split('T')[0],
        'idade': idade,
        'sexo': sexo,
        'estado_civil': estadoCivil,
        'escolaridade': escolaridade,
        'profissao': profissao.trim(),
        'endereco': endereco.trim(),
        'religiao': religiao.trim(),
        'responsavel_nome': responsavel.trim(),
        'telefone': telefone.trim(),
      },

      // Sessão 3
      'condicoes_domiciliares': {
        'habitacao': tipoHabitacao,
        'animais': temAnimais,
        'adaptacoes': adaptacoes,
        'dispositivos': dispositivos,
        'outro_dispositivo': dispositivos.contains('outro') ? outroDispositivo.trim() : '',
        'alimentacao': alimentacao.trim(),
        'ingesta_hidrica': ingestaoHidrica.trim(),
        'alcool': usaAlcool,
        'sono': sono.trim(),
      },

      // Sessão 4
      'historico_saude': {
        'queixa_principal': queixaPrincipal.trim(),
        'periodo_evolucao': periodoEvolucao.trim(),
        'doencas_atuais': doencasAtuais.trim(),
        'doencas_pregressas_selecionadas': doencasPregressasSelecionadas,
        'outras_doencas_pregressas': outrasDoencasPregressas.trim(),
        'cirurgias': cirurgias.trim(),
        'internacoes': internacoes.trim(),
        'alergias': {
          'tem': temAlergia,
          'descricao': temAlergia ? alergiaDescricao.trim() : '',
        },
        'medicamentos': medicamentos.trim(),
        'consegue_tomar': consegueTomarMedicamentos,
      },

      // Sessão 5
      'aspectos_psicossociais': {
        'tem_cuidador': temCuidador,
        'frequencia_cuidador': temCuidador ? frequenciaCuidador.trim() : '',
        'contato_cuidador': temCuidador ? contatoCuidador.trim() : '',
        'relacao_cuidador': temCuidador ? relacaoCuidador : null,
        'relacao_familia': relacaoFamilia,
        'humor': humor.trim(),
        'sinais_psicologicos': sinaisPsicologicos,
        'lazer': lazer.trim(),
        'acompanhamento_psiquiatrico': acompanhamentoPsiquiatrico,
        'acompanhamento_psicologico': acompanhamentoPsicologico,
      },

      // Sessão 6
      'avaliacao_fisica': {
        'estado_geral': estadoGeral,
        'sinais_vitais': {
          'pa': pa.trim(),
          'fc': fc.trim(),
          'fr': fr.trim(),
          'temp': temp.trim(),
          'spo2': spo2.trim(),
          'glicemia': glicemia.trim(),
        },
        'peso': peso.trim(),
        'altura': altura.trim(),
        'imc': imc != null ? imc!.toStringAsFixed(1) : null,
        'pele': pele.trim(),
        'lesoes_curativos': lesoes.trim(),
      },

      // Sessão 7
      'avaliacao_cognitiva': {
        'orientado': orientado,
        'memoria_preservada': memoriaPreservada,
        'katz': {
          'banhar': katzBanho,
          'vestir': katzVestir,
          'alimentar': katzAlimentar,
          'mover': katzMover,
          'continencia': continencia,
        },
      },

      // Sessão 8
      'antes_consulta': {
        'data_prevista': dataPrevista?.toIso8601String().split('T')[0],
        'local': local.trim(),
        'especialidade': especialidade.trim(),
        'nome_medico': nomeMedicoAntes.trim(),
        'observacoes': observacoesAntes.trim(),
      },

      // Sessão 9
      'apos_consulta': {
        'nome_medico': nomeMedicoApos.trim(),
        'orientacoes_medicas': orientacoesMedicas.trim(),
        'exames_solicitados': examesSolicitados.trim(),
        'observacoes': observacoesApos.trim(),
      },

      // Metadados
      'data_criacao': dataCriacao?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'origem': 'tablet_clauviver',
      'versao_formulario': '2.1',
    };
  }

  // =============== Criar a partir de JSON (Firestore) ===============
  factory AnamneseData.fromJson(Map<String, dynamic> json) {
    final responsavel = json['responsavel'] as Map<String, dynamic>?;
    final paciente = json['paciente'] as Map<String, dynamic>?;
    final domiciliar = json['condicoes_domiciliares'] as Map<String, dynamic>?;
    final saude = json['historico_saude'] as Map<String, dynamic>?;
    final psico = json['aspectos_psicossociais'] as Map<String, dynamic>?;
    final fisica = json['avaliacao_fisica'] as Map<String, dynamic>?;
    final cognitiva = json['avaliacao_cognitiva'] as Map<String, dynamic>?;
    final antes = json['antes_consulta'] as Map<String, dynamic>?;
    final apos = json['apos_consulta'] as Map<String, dynamic>?;

    final alergias = saude?['alergias'] as Map<String, dynamic>?;
    final sinaisVitais = fisica?['sinais_vitais'] as Map<String, dynamic>?;
    final katz = cognitiva?['katz'] as Map<String, dynamic>?;

    return AnamneseData(
      // Metadados
      id: json['id'] as String?,
      dataCriacao: json['data_criacao'] != null
          ? DateTime.tryParse(json['data_criacao'].toString())
          : null,

      // Sessão 1
      enfermeiro: responsavel?['enfermeiro'] ?? '',
      dataAtendimento: responsavel != null && responsavel['data_atendimento'] != null
          ? DateTime.parse('${responsavel['data_atendimento']}T00:00:00')
          : DateTime.now(),

      // Sessão 2
      nomePaciente: paciente?['nome'] ?? '',
      dataNascimento: paciente != null && paciente['data_nascimento'] != null
          ? DateTime.parse('${paciente['data_nascimento']}T00:00:00')
          : DateTime(1990),
      sexo: paciente?['sexo'],
      estadoCivil: paciente?['estado_civil'],
      escolaridade: paciente?['escolaridade'],
      profissao: paciente?['profissao'] ?? '',
      endereco: paciente?['endereco'] ?? '',
      religiao: paciente?['religiao'] ?? '',
      responsavel: paciente?['responsavel_nome'] ?? '',
      telefone: paciente?['telefone'] ?? '',

      // Sessão 3
      tipoHabitacao: domiciliar?['habitacao'],
      temAnimais: domiciliar?['animais'] ?? false,
      adaptacoes: List<String>.from(domiciliar?['adaptacoes'] ?? []),
      dispositivos: List<String>.from(domiciliar?['dispositivos'] ?? []),
      outroDispositivo: domiciliar?['outro_dispositivo'] ?? '',
      alimentacao: domiciliar?['alimentacao'] ?? '',
      ingestaoHidrica: domiciliar?['ingesta_hidrica'] ?? '',
      usaAlcool: domiciliar?['alcool'] ?? false,
      sono: domiciliar?['sono'] ?? '',

      // Sessão 4
      queixaPrincipal: saude?['queixa_principal'] ?? '',
      periodoEvolucao: saude?['periodo_evolucao'] ?? '',
      doencasAtuais: saude?['doencas_atuais'] ?? '',
      doencasPregressasSelecionadas: List<String>.from(saude?['doencas_pregressas_selecionadas'] ?? []),
      outrasDoencasPregressas: saude?['outras_doencas_pregressas'] ?? '',
      cirurgias: saude?['cirurgias'] ?? '',
      internacoes: saude?['internacoes'] ?? '',
      temAlergia: alergias?['tem'] ?? false,
      alergiaDescricao: alergias?['descricao'] ?? '',
      medicamentos: saude?['medicamentos'] ?? '',
      consegueTomarMedicamentos: saude?['consegue_tomar'] ?? false,

      // Sessão 5
      temCuidador: psico?['tem_cuidador'] ?? false,
      frequenciaCuidador: psico?['frequencia_cuidador'] ?? '',
      contatoCuidador: psico?['contato_cuidador'] ?? '',
      relacaoCuidador: psico?['relacao_cuidador'],
      relacaoFamilia: psico?['relacao_familia'],
      humor: psico?['humor'] ?? '',
      sinaisPsicologicos: psico?['sinais_psicologicos'] ?? false,
      lazer: psico?['lazer'] ?? '',
      acompanhamentoPsiquiatrico: psico?['acompanhamento_psiquiatrico'] ?? false,
      acompanhamentoPsicologico: psico?['acompanhamento_psicologico'] ?? false,

      // Sessão 6
      estadoGeral: fisica?['estado_geral'],
      pa: sinaisVitais?['pa'] ?? '',
      fc: sinaisVitais?['fc'] ?? '',
      fr: sinaisVitais?['fr'] ?? '',
      temp: sinaisVitais?['temp'] ?? '',
      spo2: sinaisVitais?['spo2'] ?? '',
      glicemia: sinaisVitais?['glicemia'] ?? '',
      peso: fisica?['peso'] ?? '',
      altura: fisica?['altura'] ?? '',
      pele: fisica?['pele'] ?? '',
      lesoes: fisica?['lesoes_curativos'] ?? '',

      // Sessão 7
      orientado: List<String>.from(cognitiva?['orientado'] ?? []),
      memoriaPreservada: cognitiva?['memoria_preservada'] ?? false,
      katzBanho: katz?['banhar'],
      katzVestir: katz?['vestir'],
      katzAlimentar: katz?['alimentar'],
      katzMover: katz?['mover'],
      continencia: katz?['continencia'] ?? false,

      // Sessão 8
      dataPrevista: antes != null && antes['data_prevista'] != null
          ? DateTime.parse('${antes['data_prevista']}T00:00:00')
          : null,
      local: antes?['local'] ?? '',
      especialidade: antes?['especialidade'] ?? '',
      nomeMedicoAntes: antes?['nome_medico'] ?? '',
      observacoesAntes: antes?['observacoes'] ?? '',

      // Sessão 9
      nomeMedicoApos: apos?['nome_medico'] ?? '',
      orientacoesMedicas: apos?['orientacoes_medicas'] ?? '',
      examesSolicitados: apos?['exames_solicitados'] ?? '',
      observacoesApos: apos?['observacoes'] ?? '',
    );
  }
}