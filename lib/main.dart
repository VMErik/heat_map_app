import 'package:flutter/material.dart';
import 'package:habit_tracker_app/database/habit_datatabse.dart';
import 'package:habit_tracker_app/pages/home_page.dart';
import 'package:habit_tracker_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding();
  // Inicializamos nuestra base dedatos, por eso haemos nuestro main asyncrono
  await HabitDatabase.initialize(); //
  // Hacemos el regitro de la fecha de inicio
  await HabitDatabase().saveFirstLaunchDate();
  // Corremos nuestra app
  runApp(
      // Usamos multiprovider, para inicializar mas de un provider en la app
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    // Mandamos nuestr app como hijo
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      // Nnuestro tema sera lo que esta en el provider
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
