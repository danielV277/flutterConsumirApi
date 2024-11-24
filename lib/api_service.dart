import 'dart:convert';
import 'package:http/http.dart' as http;
import "character.dart";
import 'comic.dart';

class ApiService {
  final String baseUrl = "http://gateway.marvel.com/v1/public";
  final String key = "";

  Future<List<Character>> fetchCharacters() async {
    final url =  '$baseUrl/characters?$key';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      final results = data['data']['results'] as List;
      return results.map((character) => Character.fromJson(character)).toList();
    } else {
      throw Exception('Failed to load characters');
    }  
  } 

  
  Future<List<Comic>> fetchComics(int characterID) async {
    final url= '$baseUrl/characters/$characterID/comics?$key';
      try {
        final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List;
        return results.map((comic) => Comic.fromJson(comic)).toList();
      } else {
        throw Exception('Failed to load comics');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow; // Vuelve a lanzar la excepción
    }
  }

}