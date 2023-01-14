import 'package:flutter/material.dart';

import 'package:filmme/src/pages/home_page.dart';
import 'package:filmme/src/pages/pelicula_detalle.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Film Me',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => const PeliculaDetalle(),
      },
    );
  }
}
