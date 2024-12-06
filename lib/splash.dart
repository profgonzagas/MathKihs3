import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navega para a tela principal após 3 segundos
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Ajuste a cor para corresponder ao tema
      body: Center(
        child: Image.asset('lib/assets/splashNovo.jpg'), // Caminho da imagem
      ),
    );
  }
}
