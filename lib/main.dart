import 'package:flutter/material.dart';
import 'character.dart';
import 'comic.dart';
import 'api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late Future<List<Character>> characters;
  

  @override
  void initState() {
    super.initState();
    characters = ApiService().fetchCharacters();
  }

  void _showComics(BuildContext context, int characterID) async {
    late List<Comic> comics;
    var api = ApiService();
    final theme = Theme.of(context);
    comics = await api.fetchComics(characterID);
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appearance comics', style: TextStyle(color: Colors.white),),
        backgroundColor: theme.colorScheme.onSecondaryFixed,
        content: comics.isEmpty
            ? const Text('No comics found for this hero.')
            : SizedBox(
                height: 400,
                width: 400,
                child: ListView.builder(
                  itemCount: comics.length,
                  itemBuilder: (context, index) => Card(
                    color: theme.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(comics[index].title),
                          Row(children: [const Text('Issue Number: '),Text(comics[index].issueNumber.toString())]),
                          Row(children: [const Text('Pages Number: '),Text(comics[index].pageCount.toString())])
                        ],
                      ),
                    )    
                  ),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  
  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters Marvel Studio'),
        backgroundColor: theme.colorScheme.secondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Acerca de',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Acerca de'),
                    content: const Text(
                      'Descripcion: La aplicacion consume la API de marver studio'
                      'lista los personajes y te muestras los comics en los que aparece.\n'
                      'Con: Flutter\n'
                      'Desarrollado por: Juan Daniel Vallejos'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: const Text('Cerrar'))
                    ],
                  );
                }
              );
            },
          )
        ],
        
        ),
      body: FutureBuilder<List<Character>>(
        future: characters,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else if (!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('Characters not found'));
          }

          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                elevation: 10,
                color: theme.colorScheme.onPrimaryContainer,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showComics(context, character.id),
                      child: Image.network(
                        character.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        character.name,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
    );
  }
}

 