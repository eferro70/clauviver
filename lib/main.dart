import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Teste Firebase Offline')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance.collection('testes').add({
                  'timestamp': FieldValue.serverTimestamp(),
                  'device': 'emulador',
                });
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Salvo com sucesso!')),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Erro: $e')),
                );
              }
            },
            child: const Text('Salvar no Firestore'),
          ),
        ),
      ),
    );
  }
}