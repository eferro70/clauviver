# Análise da Arquitetura e Instruções de Execução do Projeto Flutter

**Projeto:** `clauviver_anamnese`

## 1. Visão Geral da Arquitetura do Projeto

O projeto `clauviver_anamnese` apresenta uma estrutura de aplicação Flutter bem organizada, seguindo o padrão de projetos da plataforma. A análise da estrutura de arquivos sugere uma arquitetura focada na separação de responsabilidades em três camadas principais, com forte indicação do uso de **Firebase** como serviço de _backend_.

### Arquitetura Sugerida (Baseada na Estrutura de Arquivos)

| Camada                      | Diretórios/Arquivos Chave                                                                   | Responsabilidade                                                                                                                         |
| :-------------------------- | :------------------------------------------------------------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------- |
| **Apresentação (UI/UX)**    | `lib/tela_anamnese.dart`, `lib/tela_lista_anamneses.dart`                                   | Contém os _widgets_ e as telas (páginas) da aplicação, responsáveis pela interface do usuário e pela interação com o usuário.            |
| **Lógica de Negócio**       | (Implícita nos arquivos de tela e em futuras pastas como `lib/models` ou `lib/controllers`) | Gerencia o estado da aplicação e as regras de negócio, como a validação de dados da anamnese.                                            |
| **Serviços/Infraestrutura** | `lib/utils/exportar_csv.dart`, `android/app/google-services.json`                           | Lida com a comunicação com serviços externos (como Firebase Firestore) e utilitários de sistema (como exportação de dados e permissões). |

A presença de `android/app/google-services.json` e referências a plugins como `firebase_core` e `firebase_firestore` (vistos nos arquivos de _build_ truncados) confirma que o aplicativo utiliza o **Firebase Firestore** para persistência de dados, o que é crucial para o armazenamento das informações de anamnese.

## 2. Estrutura de Diretórios e Arquivos Chave

A tabela a seguir detalha os arquivos e diretórios mais relevantes para a compreensão da arquitetura e do fluxo do aplicativo:

| Caminho                                          | Descrição                                                                                                                                                       |
| :----------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lib/main.dart`                                  | **Ponto de entrada** da aplicação. Contém a função `main()` e, tipicamente, o _widget_ raiz que define o tema e as rotas.                                       |
| `lib/tela_anamnese.dart`                         | **Tela de Anamnese**. Provavelmente contém o formulário para coleta de dados do paciente.                                                                       |
| `lib/tela_lista_anamneses.dart`                  | **Tela de Lista**. Exibe a lista de anamneses salvas, interagindo com o Firestore para buscar os dados.                                                         |
| `lib/utils/exportar_csv.dart`                    | **Utilitário de Exportação**. Lógica para converter os dados da anamnese (provavelmente do Firestore) para o formato CSV.                                       |
| `assets/icon/logo.png`, `assets/icon/splash.png` | **Recursos Visuais**. Imagens utilizadas no aplicativo, como ícones e tela de _splash_.                                                                         |
| `android/app/google-services.json`               | **Configuração do Firebase**. Arquivo essencial para conectar o aplicativo Android aos serviços do Firebase.                                                    |
| `pubspec.yaml`                                   | **Gerenciamento de Dependências**. Lista as bibliotecas Flutter e Dart utilizadas (ex: `firebase_core`, `cloud_firestore`, `permission_handler`, `share_plus`). |

## 3. Instruções para Execução Local do Aplicativo

Para executar o aplicativo `clauviver_anamnese` localmente, siga os passos abaixo.

### Pré-requisitos

1.  **Instalação do Flutter:** Certifique-se de que o Flutter SDK esteja instalado e configurado corretamente.
2.  **Dispositivo/Emulador:** Tenha um dispositivo físico conectado ou um emulador/simulador em execução (Android, iOS, Web, ou Desktop).
3.  **Dependências do Firebase:** O arquivo `google-services.json` já está presente, mas é necessário garantir que as dependências do Dart estejam instaladas.

### Passos de Execução

1.  **Navegar para o Diretório do Projeto:**

    ```bash
    cd clauviver_anamnese
    ```

2.  **Instalar as Dependências do Dart/Flutter:**
    Este comando lê o arquivo `pubspec.yaml` e baixa todos os pacotes necessários.

    ```bash
    flutter pub get
    ```

3.  **Verificar a Configuração:**
    É recomendável executar o comando de diagnóstico para garantir que todas as ferramentas necessárias estejam disponíveis.

    ```bash
    flutter doctor
    ```

4.  **Executar o Aplicativo:**
    Com um dispositivo ou emulador ativo, execute o aplicativo. O Flutter fará o _build_ e o _deploy_ para o dispositivo selecionado.
    ```bash
    flutter run
    ```
    _Dica: Se houver múltiplos dispositivos ativos, você pode especificar um usando a flag `-d <device_id>` (ex: `flutter run -d chrome` para web ou `flutter run -d emulator-5554` para um emulador Android)._

### Observações Importantes

- **Firebase:** Como o projeto utiliza Firebase, a execução em um ambiente que não seja o configurado (por exemplo, um novo ambiente de desenvolvimento) pode exigir a reconfiguração do Firebase, incluindo a obtenção de um novo `google-services.json` e, para iOS, a configuração do `GoogleService-Info.plist`.
- **Permissões:** O uso de plugins como `permission_handler` e `share_plus` indica que o aplicativo pode solicitar permissões de sistema (como acesso a arquivos ou armazenamento) e utilizar funcionalidades nativas de compartilhamento. Certifique-se de que as permissões necessárias estejam configuradas nos arquivos `AndroidManifest.xml` (Android) e `Info.plist` (iOS).

### Usando o Android Virtual Device (AVD)

1. **Para abrir o AVD:**

```bash
studio.sh
```

2. **Liste seus AVDs disponíveis:**

```bash
~/Android/Sdk/emulator/emulator -list-avds
```

3. **Inicie o AVD (substitua Seu_AVD_Nome pelo nome listado acima):**

```bash
~/Android/Sdk/emulator/emulator -avd Tablet_ClauViver
```
