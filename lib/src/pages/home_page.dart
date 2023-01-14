import 'package:filmme/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

import 'package:filmme/src/widgets/card_swiper_widget.dart';

import 'package:filmme/src/providers/peliculas_provider.dart';
import 'package:filmme/src/widgets/movie_horizontal.dart';

import 'package:filmme/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = PeliculasProvider();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          title: const Text(
            'Film Me',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
                color: Colors.black87,
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DataSearch(),
                    // query: 'Hola'
                  );
                })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperTarjetas(), _footer(context)],
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    // return
  }

  Widget _footer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          const SizedBox(height: 5.0),
          StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pelicula>> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    peliculas: snapshot.data!,
                    siguientePagina: peliculasProvider.getPopulares,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}
