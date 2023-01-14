import 'package:flutter/material.dart';

import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import 'package:filmme/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  const CardSwiper({super.key, required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: screenSize.width * 0.7,
        itemHeight: screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                    child: FadeInImage(
                      image: NetworkImage(peliculas[index].getPosterImg()),
                      placeholder: const AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'detalle',
                          arguments: peliculas[index]);
                    })),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
