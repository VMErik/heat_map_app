import 'package:flutter/material.dart';
import 'package:habit_tracker_app/theme/light_mode.dart';
import 'package:habit_tracker_app/theme/dark_mode.dart';


class ThemeProvider extends ChangeNotifier{
  // Inicializamos
  ThemeData _themeData = lightMode;

  // Get tema seleccionado
  ThemeData get themeData => _themeData;

  // Validacion si es darkmode el tema seleccionado
  bool get isDarkMode => _themeData == darkMode;

  // Estabkecer el tema
  set themeData(ThemeData theme){
    _themeData = theme;
    // Notificamos a los listeners sobre el cambio
    notifyListeners();
  }

  // Hacemos el cambi del tema por el apuesto al seleccionado
  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }
}