import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:filmme/src/models/pelicula_model.dart';
import 'package:filmme/src/models/actores_model.dart';

class PeliculasProvider {
  String apikey = '9fa97a1e058b3ce00c4e8d809a3bc0a7';
  String apiURL = 'api.themoviedb.org';
  String language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> populares = [];

  final _popularesStreamControler =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamControler.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamControler.stream;

  void disposeStreams() {
    _popularesStreamControler.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(apiURL, '3/movie/now_playing',
        {'api_key': apikey, 'language': language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(apiURL, '3/movie/popular', {
      'api_key': apikey,
      'language': language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    populares.addAll(resp);
    popularesSink(populares);

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(apiURL, '3/movie/$peliId/credits',
        {'api_key': apikey, 'language': language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(apiURL, '3/search/movie',
        {'api_key': apikey, 'language': language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
