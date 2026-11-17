import 'package:flutter/material.dart';
import 'package:gerenciador_notas/services/nota_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller permite ler o conteudo digitado no Textfield
  final TextEditingController _controller = TextEditingController();

  // Instancia do serviço: a tela não acessa o pacote diretamente
  final NotaStorageService _storage = NotaStorageService();
  //  Guarda o texto que a interface mostra abaixo dos botões
  String _notaSalva = '';

  @override
  void initState() {
    super.initState();
    carregarNota(); // recuperar o valor ao abrir a home
  }

  // Busca o texto salvo, espera a leitura e atualiza a interface
  Future<void> carregarNota() async {
    final String texto = await _storage.buscarNota();
    if (!mounted) return; // verifica se a tela ainda esta disponivel

    setState(() {
      _notaSalva = texto; // Atualiza o texto marcado na tela
      _controller.text = texto; // Preenche o campo com o valor salvo.
    });
  }

  // Função chamada pelo onPressed do botão de salvar
  Future<void> salvarNota() async {
    // variavel para armazenar a nota digitada pelo usuario
    final String texto = _controller.text.trim();

    // verificamos se a nota esta vazia
    if (texto.isEmpty) return; // Não salva nota vazia

    await _storage.salvarNota(texto); // Grava no dispositivo
    if (!mounted) return; // Evita atualizar um tela descartada

    setState(() {
      _notaSalva = texto; // Mostra a versão recem-salva
    });

    // Informamos ao usuario que a ação finalizou.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Nota Salva no dispositivo')));
  }

  // Função para apagar um nota
  Future<void> apagarNota() async {
    await _storage.apagarNota(); // remove o valor persistido.
    if (!mounted) return;

    setState(() {
      _notaSalva = ''; // Limpa o texto exibido
      _controller.clear(); // Limpa o campo de entrada
    });
  }

  @override
  void dispose() {
    //Libera o controller quando o flutter descarta essa tela.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Notas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Minha primeira anotação.'),

            const SizedBox(height: 12),

            TextField(
              controller: _controller, // Conecta o campo ao controller
              maxLines: 3, // Permitir escrever até três linhas.
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva uma anotação...',
              ),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: salvarNota,
              child: const Text('Salvar no dispositivo'),
            ),
            OutlinedButton(
              onPressed: apagarNota,
              child: const Text('Apagar nota Salva'),
            ),

            const SizedBox(height: 24),

            const Text('Nota Recuperada do armazenamento:'),
            const SizedBox(height: 8),
            Text(_notaSalva.isEmpty ? ' Nenhuma nota salva. ' : _notaSalva),
          ],
        ),
      ),
    );
  }
}
