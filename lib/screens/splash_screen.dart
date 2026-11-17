import 'package:flutter/material.dart';
import 'package:gerenciador_notas/screens/home_screen.dart';

// StatefulWidget: a tela precisa executar ações no sei ciclo de vida
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //initState() roda uma vez, quando o está é criado
    super.initState(); // mantém a inicialização da classe pai.
    abrirHome(); // Inicia a espera e a troca de tela
  }

  // Future<void> : aperação assíncrona que não retorna valor
  Future<void> abrirHome() async {
    // aguarda 2 segundos sem travar a interface
    await Future.delayed(const Duration(seconds: 2));

    // mounted é false se esta tela já foi removida da arvore.
    // Não podemos user context para navegar depois disso.
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold Fornece uma estrutura visual da tela Material
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ocupar so o necessário
          children: [
            Icon(Icons.edit_note, size: 78, color: Colors.indigo),
            const SizedBox(height: 20),
            Text(
              'Gerenciador de Notas',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
