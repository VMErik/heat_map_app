// Nos da una lista de los dias completados

// Nos indica si el habito se completo hoy
import 'package:habit_tracker_app/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  // Busca si en la lsita, esta el dia de hoy
  return completedDays.any((element) =>
  element.year == today.year 
  && element.month == today.month 
  && element.day == today.day);
}


// Preparamos el dataset del heatmap
Map<DateTime, int> prepareHeatMapDataSet(List<Habit> habits){
  Map<DateTime, int> dataset = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      final normaizedDate = DateTime(date.year, date.month,date.day);
      if(dataset.containsKey(normaizedDate)){
        // Si ya existe, lo agregamos un contador
        dataset[normaizedDate] = dataset[normaizedDate]! + 1;
      }else{
        // Inicializamos el dia
        dataset[normaizedDate]  = 1;
      }
    }
  }
  return dataset;
}