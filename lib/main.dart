import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ← necessário para offline persistence
import 'package:flutter/material.dart';
// Substitua os imports antigos:
// import 'tela_anamnese.dart';
// import 'tela_lista_anamneses.dart';
import 'screens/anamnese/anamnese_stepper_screen.dart'; // ← novo formulário
import 'tela_lista_anamneses.dart'; // ← mantém (precisará ser atualizada depois para suportar edição)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Ativa persistência offline do Firestore (essencial para seu app offline)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClauViver',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClauViver – Anamnese')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnamneseStepperScreen(), // ← usa a nova tela
                ),
              ),
              child: const Text('🔍 Nova Anamnese'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TelaListaAnamneses(),
                ),
              ),
              child: const Text('📋 Ver Anamneses Salvas'),
            ),
          ],
        ),
      ),
    );
  }
}